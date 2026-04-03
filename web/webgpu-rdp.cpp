// web/webgpu-rdp.cpp
//
// WebGPU host code for paraLLEl-RDP.
//
// Architecture overview
// ---------------------
// This file mirrors the responsibilities of ares/n64/vulkan/vulkan.cpp but
// targets the browser WebGPU API via Emscripten's C bindings.
//
// Phase 2 status:
//   • GPU device / buffer / pipeline infrastructure: complete
//   • Utility compute shaders (clear_*, masked_rdram_resolve): functional
//   • Complex rendering shaders (ubershader, rasterizer, …): stub (no-op)
//     — substitute Naga-transpiled WGSL from tools/transpile-shaders.sh
//   • Scanout: CPU-direct RDRAM read (correct output without GPU rendering)
//   • Once the complex shaders are filled in, switch scanoutAsync() to the
//     GPU-side readback path already wired up below.
//
// Emscripten notes:
//   • Build requires -s USE_WEBGPU=1 -s ASYNCIFY
//   • JS must set Module.preinitializedWebGPUDevice before calling ares_init()
//   • emscripten_sleep(0) yields to the event loop (ASYNCIFY-safe)

#include <emscripten/emscripten.h>
#include <emscripten/html5_webgpu.h>
#include <webgpu/webgpu.h>

#include <string.h>
#include <stdlib.h>
#include <vector>
#include <string>

#include "platform-web.hpp"   // for rdram / region helpers via extern
#include <n64/n64.hpp>

namespace ares::Nintendo64 {

WebGpuRdp webgpurdp;

// ---------------------------------------------------------------------------
// Helper: load an embedded WGSL shader (linked via CMake incbin or char array)
// ---------------------------------------------------------------------------

// Each WGSL file is embedded as a null-terminated string via CMake's
// target_compile_definitions + file(READ ...) step.  Fallback: empty string.
// The actual content is provided by WGSL source arrays generated at build
// time into web/generated/shader_sources.h.

#if __has_include("generated/shader_sources.h")
#  include "generated/shader_sources.h"
#else
// Stubs so the translation unit compiles even without the generated header.
static const char* wgsl_clear_write_mask              = "";
static const char* wgsl_clear_indirect_buffer         = "";
static const char* wgsl_clear_super_sampled_write_mask= "";
static const char* wgsl_masked_rdram_resolve          = "";
static const char* wgsl_extract_vram                  = "";
static const char* wgsl_ubershader                    = "";
static const char* wgsl_rasterizer                    = "";
static const char* wgsl_span_setup                    = "";
static const char* wgsl_tile_binning                  = "";
static const char* wgsl_depth_blend                   = "";
static const char* wgsl_tmem_update                   = "";
#endif

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

static constexpr u32 RDRAM_SIZE        = 8 * 1024 * 1024;  // 8 MiB
static constexpr u32 RDRAM_WORDS       = RDRAM_SIZE / 4;
static constexpr u32 MAX_CMD_WORDS     = 0x10000;           // command ring
static constexpr u32 VI_REG_STATUS     = 0;
static constexpr u32 VI_REG_ORIGIN     = 1;
static constexpr u32 VI_REG_WIDTH      = 2;
static constexpr u32 VI_REG_V_SYNC     = 6;
static constexpr u32 VI_REG_H_VIDEO    = 9;
static constexpr u32 VI_REG_V_VIDEO    = 10;
static constexpr u32 VI_REG_X_SCALE    = 12;
static constexpr u32 VI_REG_Y_SCALE    = 13;

// ---------------------------------------------------------------------------
// GPU resource helpers
// ---------------------------------------------------------------------------

static WGPUShaderModule createShaderModule(WGPUDevice dev, const char* wgsl) {
    if (!wgsl || wgsl[0] == '\0') return nullptr;
    WGPUShaderModuleWGSLDescriptor wgslDesc = {};
    wgslDesc.chain.sType = WGPUSType_ShaderModuleWGSLDescriptor;
    wgslDesc.code = wgsl;
    WGPUShaderModuleDescriptor desc = {};
    desc.nextInChain = &wgslDesc.chain;
    return wgpuDeviceCreateShaderModule(dev, &desc);
}

static WGPUBuffer createBuffer(WGPUDevice dev, const char* label,
                               u64 size, WGPUBufferUsageFlags usage) {
    WGPUBufferDescriptor desc = {};
    desc.label              = label;
    desc.size               = size;
    desc.usage              = usage;
    desc.mappedAtCreation   = false;
    return wgpuDeviceCreateBuffer(dev, &desc);
}

static WGPUComputePipeline createComputePipeline(WGPUDevice dev,
                                                  WGPUShaderModule mod,
                                                  const char* entry,
                                                  WGPUPipelineLayout layout) {
    if (!mod) return nullptr;
    WGPUComputePipelineDescriptor desc = {};
    desc.layout             = layout;
    desc.compute.module     = mod;
    desc.compute.entryPoint = entry;
    return wgpuDeviceCreateComputePipeline(dev, &desc);
}

// ---------------------------------------------------------------------------
// Implementation struct
// ---------------------------------------------------------------------------

struct WebGpuRdp::Implementation {
    // --- WebGPU handles ---
    WGPUDevice  device  = nullptr;
    WGPUQueue   queue   = nullptr;

    // --- GPU buffers ---
    // RDRAM mirror on GPU (STORAGE | COPY_DST | COPY_SRC)
    WGPUBuffer rdramBuf    = nullptr;
    // Staging upload (MAP_WRITE | COPY_SRC) — for CPU→GPU upload
    WGPUBuffer uploadBuf   = nullptr;
    // Staging readback (MAP_READ | COPY_DST) — for GPU→CPU copy
    WGPUBuffer readbackBuf = nullptr;
    // Write-mask buffer for masked_rdram_resolve
    WGPUBuffer writeMaskBuf = nullptr;
    // Staging RDRAM buffer (what the GPU renders into before resolve)
    WGPUBuffer stagingRdramBuf = nullptr;
    // Offset UBO for clear/resolve passes (4096 bytes max = 1024 uvec4)
    WGPUBuffer offsetUBO    = nullptr;
    // Registers UBO used by multiple pipelines
    WGPUBuffer regsUBO      = nullptr;

    // --- Shader modules ---
    WGPUShaderModule sm_clearWriteMask    = nullptr;
    WGPUShaderModule sm_clearIndirect     = nullptr;
    WGPUShaderModule sm_clearSSSWM        = nullptr;
    WGPUShaderModule sm_maskedResolve     = nullptr;
    WGPUShaderModule sm_extractVram       = nullptr;
    WGPUShaderModule sm_ubershader        = nullptr;
    WGPUShaderModule sm_rasterizer        = nullptr;
    WGPUShaderModule sm_spanSetup         = nullptr;
    WGPUShaderModule sm_tileBinning       = nullptr;
    WGPUShaderModule sm_depthBlend        = nullptr;
    WGPUShaderModule sm_tmemUpdate        = nullptr;

    // --- Pipelines (created lazily from shader modules) ---
    WGPUComputePipeline pl_clearWriteMask = nullptr;
    WGPUComputePipeline pl_clearIndirect  = nullptr;
    WGPUComputePipeline pl_clearSSSWM     = nullptr;
    WGPUComputePipeline pl_maskedResolve  = nullptr;
    WGPUComputePipeline pl_extractVram    = nullptr;
    WGPUComputePipeline pl_ubershader     = nullptr;
    WGPUComputePipeline pl_rasterizer     = nullptr;
    WGPUComputePipeline pl_spanSetup      = nullptr;
    WGPUComputePipeline pl_tileBinning    = nullptr;
    WGPUComputePipeline pl_depthBlend     = nullptr;
    WGPUComputePipeline pl_tmemUpdate     = nullptr;

    // --- RDP command queue (u32 pairs = u64 commands, mirroring vulkan.cpp) ---
    u32  cmdBuffer[MAX_CMD_WORDS * 2] = {};
    u32  queueSize   = 0;
    u32  queueOffset = 0;

    // --- VI register shadow ---
    u32 viStatus = 0;   // colorDepth in bits [1:0]
    u32 viOrigin = 0;   // framebuffer DRAM address
    u32 viWidth  = 0;   // scanline width (pixels)
    u32 viHStart = 0;   // H_VIDEO register
    u32 viVStart = 0;   // V_VIDEO register
    u32 viXScale = 0;
    u32 viYScale = 0;

    // --- Scanout state ---
    // CPU-side RGBA8888 framebuffer (filled by mapScanoutRead).
    std::vector<u8> scanoutBuf;
    u32 scanoutWidth  = 0;
    u32 scanoutHeight = 0;

    // Async readback state (used when GPU rendering is active).
    bool   readbackPending = false;
    bool   readbackReady   = false;

    // Error string (set on unrecoverable GPU error).
    const char* crashError = nullptr;

    // Whether complex GPU shaders are compiled and usable.
    bool gpuRenderingActive = false;

    // Per-frame dirty flag: RDRAM was written by CPU since last upload.
    bool rdramDirty = true;
};

// ---------------------------------------------------------------------------
// load / unload
// ---------------------------------------------------------------------------

auto WebGpuRdp::load(Node::Object) -> bool {
    if (!enable) return true;

    delete implementation;
    implementation = new Implementation();
    auto& I = *implementation;

    // Obtain the pre-initialised WebGPU device from JS.
    I.device = emscripten_webgpu_get_device();
    if (!I.device) {
        // WebGPU not available — fall back to software-only mode.
        platform->status("WebGPU unavailable: using software RDP fallback");
        enable = false;
        delete implementation;
        implementation = nullptr;
        return true;  // non-fatal: vi.cpp software path handles scanout
    }

    I.queue = wgpuDeviceGetQueue(I.device);

    // --- Create persistent GPU buffers ---
    using BU = WGPUBufferUsage;
    I.rdramBuf = createBuffer(I.device, "RDRAM",
        RDRAM_SIZE,
        BU_Storage | BU_CopyDst | BU_CopySrc);

    I.uploadBuf = createBuffer(I.device, "RDRAM-upload",
        RDRAM_SIZE,
        BU_MapWrite | BU_CopySrc);

    I.readbackBuf = createBuffer(I.device, "RDRAM-readback",
        RDRAM_SIZE,
        BU_MapRead | BU_CopyDst);

    I.writeMaskBuf = createBuffer(I.device, "WriteMask",
        RDRAM_SIZE / 4,   // one u32 mask per RDRAM u32 word
        BU_Storage | BU_CopyDst);

    I.stagingRdramBuf = createBuffer(I.device, "StagingRDRAM",
        RDRAM_SIZE,
        BU_Storage | BU_CopyDst);

    I.offsetUBO = createBuffer(I.device, "OffsetUBO",
        4096,   // 1024 * sizeof(uvec4)
        BU_Uniform | BU_CopyDst);

    I.regsUBO = createBuffer(I.device, "RegsUBO",
        256,
        BU_Uniform | BU_CopyDst);

    // --- Compile shader modules ---
    // Utility shaders: always compiled (their WGSL source is fully implemented).
    I.sm_clearWriteMask = createShaderModule(I.device, wgsl_clear_write_mask);
    I.sm_clearIndirect  = createShaderModule(I.device, wgsl_clear_indirect_buffer);
    I.sm_clearSSSWM     = createShaderModule(I.device, wgsl_clear_super_sampled_write_mask);
    I.sm_maskedResolve  = createShaderModule(I.device, wgsl_masked_rdram_resolve);
    I.sm_extractVram    = createShaderModule(I.device, wgsl_extract_vram);

    // Complex rendering shaders: compiled when source is non-empty.
    // Phase 2: these contain stub main() bodies until Naga-transpiled
    // WGSL is injected via tools/transpile-shaders.sh.
    I.sm_ubershader  = createShaderModule(I.device, wgsl_ubershader);
    I.sm_rasterizer  = createShaderModule(I.device, wgsl_rasterizer);
    I.sm_spanSetup   = createShaderModule(I.device, wgsl_span_setup);
    I.sm_tileBinning = createShaderModule(I.device, wgsl_tile_binning);
    I.sm_depthBlend  = createShaderModule(I.device, wgsl_depth_blend);
    I.sm_tmemUpdate  = createShaderModule(I.device, wgsl_tmem_update);

    // --- Create compute pipelines (auto-layout) ---
    // For Phase 2, use nullptr pipeline layout → let WebGPU infer from shader.
    I.pl_clearWriteMask = createComputePipeline(I.device, I.sm_clearWriteMask, "main", nullptr);
    I.pl_clearIndirect  = createComputePipeline(I.device, I.sm_clearIndirect,  "main", nullptr);
    I.pl_clearSSSWM     = createComputePipeline(I.device, I.sm_clearSSSWM,     "main", nullptr);
    I.pl_maskedResolve  = createComputePipeline(I.device, I.sm_maskedResolve,  "main", nullptr);
    I.pl_extractVram    = createComputePipeline(I.device, I.sm_extractVram,    "main", nullptr);
    I.pl_ubershader     = createComputePipeline(I.device, I.sm_ubershader,     "main", nullptr);
    I.pl_rasterizer     = createComputePipeline(I.device, I.sm_rasterizer,     "main", nullptr);
    I.pl_spanSetup      = createComputePipeline(I.device, I.sm_spanSetup,      "main", nullptr);
    I.pl_tileBinning    = createComputePipeline(I.device, I.sm_tileBinning,    "main", nullptr);
    I.pl_depthBlend     = createComputePipeline(I.device, I.sm_depthBlend,     "main", nullptr);
    I.pl_tmemUpdate     = createComputePipeline(I.device, I.sm_tmemUpdate,     "main", nullptr);

    // Complex GPU rendering is active only when all required pipelines exist.
    // Phase 2: ubershader etc. have stub bodies → mark inactive until replaced.
    I.gpuRenderingActive = false;

    platform->status("WebGPU enabled: paraLLEl-RDP infrastructure ready (stub shaders)");
    return true;
}

auto WebGpuRdp::unload() -> void {
    if (!implementation) return;
    auto& I = *implementation;

    // Release buffers.
    auto releaseBuffer = [](WGPUBuffer& b){ if(b){ wgpuBufferRelease(b); b=nullptr; } };
    releaseBuffer(I.rdramBuf);
    releaseBuffer(I.uploadBuf);
    releaseBuffer(I.readbackBuf);
    releaseBuffer(I.writeMaskBuf);
    releaseBuffer(I.stagingRdramBuf);
    releaseBuffer(I.offsetUBO);
    releaseBuffer(I.regsUBO);

    // Release shader modules.
    auto releaseSM = [](WGPUShaderModule& m){ if(m){ wgpuShaderModuleRelease(m); m=nullptr; } };
    releaseSM(I.sm_clearWriteMask);
    releaseSM(I.sm_clearIndirect);
    releaseSM(I.sm_clearSSSWM);
    releaseSM(I.sm_maskedResolve);
    releaseSM(I.sm_extractVram);
    releaseSM(I.sm_ubershader);
    releaseSM(I.sm_rasterizer);
    releaseSM(I.sm_spanSetup);
    releaseSM(I.sm_tileBinning);
    releaseSM(I.sm_depthBlend);
    releaseSM(I.sm_tmemUpdate);

    // Release pipelines.
    auto releasePL = [](WGPUComputePipeline& p){ if(p){ wgpuComputePipelineRelease(p); p=nullptr; } };
    releasePL(I.pl_clearWriteMask);
    releasePL(I.pl_clearIndirect);
    releasePL(I.pl_clearSSSWM);
    releasePL(I.pl_maskedResolve);
    releasePL(I.pl_extractVram);
    releasePL(I.pl_ubershader);
    releasePL(I.pl_rasterizer);
    releasePL(I.pl_spanSetup);
    releasePL(I.pl_tileBinning);
    releasePL(I.pl_depthBlend);
    releasePL(I.pl_tmemUpdate);

    delete implementation;
    implementation = nullptr;
}

// ---------------------------------------------------------------------------
// frame
// ---------------------------------------------------------------------------

auto WebGpuRdp::frame() -> void {
    if (!implementation) return;
    implementation->queueSize   = 0;
    implementation->queueOffset = 0;
    implementation->rdramDirty  = true;
}

// ---------------------------------------------------------------------------
// writeWord  (VI register shadow)
// ---------------------------------------------------------------------------

auto WebGpuRdp::writeWord(u32 address, u32 data) -> void {
    if (!implementation) return;
    auto& I = *implementation;
    switch (address) {
    case VI_REG_STATUS: I.viStatus = data; break;
    case VI_REG_ORIGIN: I.viOrigin = data & 0xFFFFFF; break;
    case VI_REG_WIDTH:  I.viWidth  = data & 0xFFF;    break;
    case VI_REG_H_VIDEO: I.viHStart = data;            break;
    case VI_REG_V_VIDEO: I.viVStart = data;            break;
    case VI_REG_X_SCALE: I.viXScale = data;            break;
    case VI_REG_Y_SCALE: I.viYScale = data;            break;
    default: break;
    }
}

// ---------------------------------------------------------------------------
// render  (RDP command processing)
// ---------------------------------------------------------------------------

// Command lengths table: number of 64-bit words per opcode (same as vulkan.cpp).
static constexpr u32 kCommandLength[64] = {
    1, 1, 1, 1, 1, 1, 1, 1, 4, 6,12,14,12,14,20,22,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
};

// RDP opcode for SyncFull
static constexpr u32 OP_SYNC_FULL = 0x29;

// Flush all pending GPU work when SyncFull is encountered.
static void flushGpuCommands(WebGpuRdp::Implementation& I) {
    if (!I.device) return;

    // --- Upload CPU RDRAM to GPU if dirty ---
    if (I.rdramDirty) {
        wgpuQueueWriteBuffer(I.queue, I.rdramBuf, 0,
            rdram.ram.data, RDRAM_SIZE);
        I.rdramDirty = false;
    }

    // Phase 2: Complex rendering shaders are stubs.
    // Utility passes (clear write mask, masked resolve) can run, but
    // they need proper page-offset UBOs set up per-draw — left for the
    // full paraLLEl-RDP integration.
    // For now we submit a no-op command buffer to keep the queue alive.

    WGPUCommandEncoderDescriptor encDesc = {};
    WGPUCommandEncoder enc = wgpuDeviceCreateCommandEncoder(I.device, &encDesc);
    WGPUCommandBuffer cmd  = wgpuCommandEncoderFinish(enc, nullptr);
    wgpuQueueSubmit(I.queue, 1, &cmd);
    wgpuCommandBufferRelease(cmd);
    wgpuCommandEncoderRelease(enc);
}

auto WebGpuRdp::render() -> bool {
    if (!implementation) return false;
    auto& I = *implementation;

    // Identical queue-reading logic to vulkan.cpp::Vulkan::render().
    auto& command = rdp.command;
    u32 current = command.current & ~7u;
    u32 end     = command.end    & ~7u;
    u32 length  = (end - current) / 8;
    if (current >= end) return true;
    if (I.queueSize + length >= 0x8000) return true;

    if (!command.source) {
        do {
            I.cmdBuffer[I.queueSize * 2 + 0] = rdram.ram.read<Word>(current, RBusDevice::DP_DMA); current += 4;
            I.cmdBuffer[I.queueSize * 2 + 1] = rdram.ram.read<Word>(current, RBusDevice::DP_DMA); current += 4;
            I.queueSize++;
        } while (--length);
    } else {
        do {
            I.cmdBuffer[I.queueSize * 2 + 0] = rsp.dmem.read<Word>(current); current += 4;
            I.cmdBuffer[I.queueSize * 2 + 1] = rsp.dmem.read<Word>(current); current += 4;
            I.queueSize++;
        } while (--length);
    }

    while (I.queueOffset < I.queueSize) {
        u32 op   = I.cmdBuffer[I.queueOffset * 2];
        u32 code = (op >> 24) & 63;
        u32 len  = kCommandLength[code];

        if (I.queueOffset + len > I.queueSize) {
            // Partial command — wait for more data.
            command.start = command.current = command.end;
            return true;
        }

        if (code == OP_SYNC_FULL) {
            // Flush GPU work and raise the DP interrupt.
            flushGpuCommands(I);
            rdp.syncFull();
        }

        I.queueOffset += len;
    }

    I.queueOffset = 0;
    I.queueSize   = 0;
    command.current = command.end;
    return true;
}

// ---------------------------------------------------------------------------
// scanoutAsync
// ---------------------------------------------------------------------------

auto WebGpuRdp::scanoutAsync(bool /*field*/) -> bool {
    if (!implementation) return false;
    // Mark that a new frame is ready for scanout.
    // CPU-side scanout reads RDRAM directly (see mapScanoutRead).
    return (implementation->viOrigin != 0 && implementation->viWidth != 0);
}

// ---------------------------------------------------------------------------
// mapScanoutRead / unmapScanoutRead / endScanout
//
// Phase 2 implementation: read the VI framebuffer directly from CPU-side RDRAM,
// converting to RGBA8888 — identical to vi.cpp's software path but driven
// through the WebGpuRdp interface so vi.cpp can stay in the WEBGPU branch.
// When the full GPU rendering pipeline is active (gpuRenderingActive == true),
// swap this for the GPU readback path.
// ---------------------------------------------------------------------------

auto WebGpuRdp::mapScanoutRead(const u8*& rgba, u32& width, u32& height) -> void {
    rgba = nullptr; width = 0; height = 0;
    if (!implementation) return;
    auto& I = *implementation;

    u32 colorDepth = I.viStatus & 3;
    u32 origin     = I.viOrigin;
    u32 scanWidth  = I.viWidth;

    if (colorDepth == 0 || scanWidth == 0 || origin == 0) return;

    // Derive active display height from V_VIDEO register.
    u32 vstart = (I.viVStart >> 16) & 0x3FF;
    u32 vend   = (I.viVStart)       & 0x3FF;
    u32 yscale = (I.viYScale)       & 0xFFF;  // 2.10 fixed point

    u32 dispHeight = 0;
    if (yscale > 0 && vend > vstart) {
        dispHeight = ((vend - vstart) >> 1) * 1024 / yscale;
    }
    if (dispHeight == 0) {
        dispHeight = Region::NTSC() ? 480 : 576;
    }
    dispHeight = (dispHeight < 16) ? 16 : (dispHeight > 576 ? 576 : dispHeight);

    I.scanoutBuf.resize(scanWidth * dispHeight * 4);
    u8* dst = I.scanoutBuf.data();

    if (colorDepth == 3) {
        // RGBA8888 (32 bpp) — one 32-bit word per pixel, big-endian.
        for (u32 y = 0; y < dispHeight; y++) {
            for (u32 x = 0; x < scanWidth; x++) {
                u32 addr = origin + (y * scanWidth + x) * 4;
                if (addr + 3 >= RDRAM_SIZE) { dst[0]=dst[1]=dst[2]=dst[3]=0; dst+=4; continue; }
                u32 word = rdram.ram.read<Word>(addr, RBusDevice::VI_DMA);
                dst[0] = (word >> 24) & 0xFF;  // R
                dst[1] = (word >> 16) & 0xFF;  // G
                dst[2] = (word >>  8) & 0xFF;  // B
                dst[3] = 0xFF;                 // A
                dst += 4;
            }
        }
    } else if (colorDepth == 2) {
        // RGBA5551 (16 bpp) — two pixels per 32-bit word, big-endian.
        for (u32 y = 0; y < dispHeight; y++) {
            for (u32 x = 0; x < scanWidth; x++) {
                u32 addr16 = origin / 2 + y * scanWidth + x;
                u32 wordAddr = (addr16 & ~1u) * 2;
                if (wordAddr + 3 >= RDRAM_SIZE) { dst[0]=dst[1]=dst[2]=dst[3]=0; dst+=4; continue; }
                u32 word16 = rdram.ram.read<Half>(addr16 ^ 1, RBusDevice::VI_DMA);
                dst[0] = (u8)(((word16 >> 11) & 0x1F) << 3);
                dst[1] = (u8)(((word16 >>  6) & 0x1F) << 3);
                dst[2] = (u8)(((word16 >>  1) & 0x1F) << 3);
                dst[3] = 0xFF;
                dst += 4;
            }
        }
    }

    I.scanoutWidth  = scanWidth;
    I.scanoutHeight = dispHeight;
    rgba   = I.scanoutBuf.data();
    width  = scanWidth;
    height = dispHeight;
}

auto WebGpuRdp::unmapScanoutRead() -> void {
    // CPU-side buffer — no unmap needed.
}

auto WebGpuRdp::endScanout() -> void {
    // Nothing to signal in Phase 2.
}

// ---------------------------------------------------------------------------
// crashed
// ---------------------------------------------------------------------------

auto WebGpuRdp::crashed() -> const char* {
    if (implementation) return implementation->crashError;
    return nullptr;
}

}  // namespace ares::Nintendo64
