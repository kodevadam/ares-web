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
//   • GPU dispatch wired up: span_setup → tile_binning → ubershader (3-pass)
//   • Command parsing: SET_COLOR_IMAGE / SET_MASK_IMAGE / SET_SCISSOR extracted
//   • Stream buffers (triangle/attribute/derived setup): zeroed until triangle
//     parsing is added (separate task)
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

// paraLLEl-RDP data structures and LUTs
#include "ares/n64/vulkan/parallel-rdp/parallel-rdp/rdp_data_structures.hpp"
#include "ares/n64/vulkan/parallel-rdp/parallel-rdp/luts.hpp"

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
// paraLLEl-RDP limits (mirroring rdp_data_structures.hpp Limits namespace)
// ---------------------------------------------------------------------------

static constexpr u32 RDP_MAX_PRIMITIVES              = 256;
static constexpr u32 RDP_MAX_SPAN_SETUPS             = 32 * 1024;
static constexpr u32 RDP_MAX_WIDTH                   = 1024;
static constexpr u32 RDP_MAX_HEIGHT                  = 1024;
static constexpr u32 RDP_MAX_TILES_X                 = RDP_MAX_WIDTH  / 8;  // 128
static constexpr u32 RDP_MAX_TILES_Y                 = RDP_MAX_HEIGHT / 8;  // 128
static constexpr u32 RDP_MAX_STATIC_RASTER_STATES    = 64;
static constexpr u32 RDP_MAX_DEPTH_BLEND_STATES      = 64;
static constexpr u32 RDP_MAX_TILE_INFO_STATES        = 256;  // = MaxPrimitives

// Buffer sizes (bytes)
static constexpr u64 SZ_TRIANGLE_SETUP    = RDP_MAX_PRIMITIVES           * sizeof(RDP::TriangleSetup);       // 256*32  = 8192
static constexpr u64 SZ_ATTRIBUTE_SETUP   = RDP_MAX_PRIMITIVES           * sizeof(RDP::AttributeSetup);      // 256*128 = 32768
static constexpr u64 SZ_DERIVED_SETUP     = 16384;   // 256*56=14336, padded to 16384
static constexpr u64 SZ_SCISSOR_STATE     = RDP_MAX_PRIMITIVES           * sizeof(RDP::ScissorState);        // 256*16  = 4096
static constexpr u64 SZ_STATIC_RASTER     = RDP_MAX_STATIC_RASTER_STATES * sizeof(RDP::StaticRasterizationState); // 64*32 = 2048
static constexpr u64 SZ_DEPTH_BLEND       = RDP_MAX_DEPTH_BLEND_STATES   * sizeof(RDP::DepthBlendState);     // 64*16  = 1024
static constexpr u64 SZ_TILE_INFO         = RDP_MAX_TILE_INFO_STATES      * sizeof(RDP::TileInfo);            // 256*32 = 8192
static constexpr u64 SZ_STATE_INDICES     = RDP_MAX_PRIMITIVES           * sizeof(RDP::InstanceIndices);     // 256*16 = 4096
static constexpr u64 SZ_SPAN_INFO_OFFSETS = RDP_MAX_PRIMITIVES           * sizeof(RDP::SpanInfoOffsets);     // 256*16 = 4096
static constexpr u64 SZ_SPAN_INTERP_JOBS  = RDP_MAX_SPAN_SETUPS          * sizeof(RDP::SpanInterpolationJob); // 32768*8 = 262144
static constexpr u64 SZ_SPAN_SETUPS       = RDP_MAX_SPAN_SETUPS          * 64;                               // 32768*64 = 2097152
// tileBitmask: (MaxPrimitives/32) bitmask planes × MaxTilesX × MaxTilesY × 4 bytes
static constexpr u64 SZ_TILE_BITMASK      = (RDP_MAX_PRIMITIVES / 32) * RDP_MAX_TILES_X * RDP_MAX_TILES_Y * 4; // 8*128*128*4 = 524288
static constexpr u64 SZ_TILE_BITMASK_COARSE = RDP_MAX_TILES_X * RDP_MAX_TILES_Y * 4;                          // 128*128*4   = 65536
static constexpr u64 SZ_BLENDER_LUT       = 0x8000;    // 32768 bytes

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

    // --- Per-frame stream buffers (CPU → GPU upload each SyncFull) ---
    WGPUBuffer triangleSetupBuf         = nullptr;  // 256 * 32   = 8192 bytes
    WGPUBuffer attributeSetupBuf        = nullptr;  // 256 * 128  = 32768 bytes
    WGPUBuffer derivedSetupBuf          = nullptr;  // 256 * 56   = 14336 bytes (padded to 16384)
    WGPUBuffer scissorStateBuf          = nullptr;  // 256 * 16   = 4096 bytes
    WGPUBuffer staticRasterStateBuf     = nullptr;  // 64  * 32   = 2048 bytes
    WGPUBuffer depthBlendStateBuf       = nullptr;  // 64  * 16   = 1024 bytes
    WGPUBuffer tileInfoStateBuf         = nullptr;  // 256 * 32   = 8192 bytes
    WGPUBuffer stateIndicesBuf          = nullptr;  // 256 * 16   = 4096 bytes
    WGPUBuffer spanInfoOffsetsBuf       = nullptr;  // 256 * 16   = 4096 bytes
    WGPUBuffer spanInterpolationJobsBuf = nullptr;  // 32768 * 8  = 262144 bytes

    // --- Persistent GPU intermediate buffers ---
    WGPUBuffer spanSetupsBuf            = nullptr;  // 32768 * 64 = 2097152 bytes
    WGPUBuffer tileBitmaskBuf           = nullptr;  // 8*128*128*4 = 524288 bytes
    WGPUBuffer tileBitmaskCoarseBuf     = nullptr;  // 128*128*4   = 65536 bytes
    WGPUBuffer hiddenRdramBuf           = nullptr;  // 8 MiB (same as rdram, for 2-cycle blending)
    WGPUBuffer tmemBuf                  = nullptr;  // 4096 bytes (4 KiB TMEM)
    WGPUBuffer blenderDividerLUTBuf     = nullptr;  // 32768 bytes (0x8000)

    // --- Small UBO buffers (uniform, 256-byte aligned for WebGPU) ---
    WGPUBuffer tileBinningUniformBuf    = nullptr;  // 16 bytes: {resolution: vec2u, primitive_count: i32, pad: i32}
    WGPUBuffer globalFBInfoBuf          = nullptr;  // 16 bytes: GlobalFBInfo
    WGPUBuffer globalStateBuf           = nullptr;  // 32 bytes: GlobalState (padded to 256)

    // --- Bind groups for the 3-pass render dispatch ---
    // span_setup (pass 1)
    WGPUBindGroup bg_spanSetup_g0       = nullptr;  // triangleSetup, attributeSetup, scissorState, spanSetups
    WGPUBindGroup bg_spanSetup_g1       = nullptr;  // spanInterpolationJobs

    // tile_binning (pass 2)
    WGPUBindGroup bg_tileBin_g0         = nullptr;  // triangleSetup, scissorState, tileBitmask, tileBitmaskCoarse
    WGPUBindGroup bg_tileBin_g2         = nullptr;  // tileBinningUniform

    // ubershader (pass 3)
    WGPUBindGroup bg_uber_g0            = nullptr;  // rdram, hiddenRdram, tmem
    WGPUBindGroup bg_uber_g1            = nullptr;  // all stream/intermediate buffers
    WGPUBindGroup bg_uber_g2            = nullptr;  // globalFBInfo, globalState

    // Config fingerprint used to detect when bind groups must be rebuilt.
    u32 bindGroupFbAddr      = 0xFFFFFFFF;
    u32 bindGroupFbWidth     = 0xFFFFFFFF;

    // --- RDP command queue (u32 pairs = u64 commands, mirroring vulkan.cpp) ---
    u32  cmdBuffer[MAX_CMD_WORDS * 2] = {};
    u32  queueSize   = 0;
    u32  queueOffset = 0;

    // --- Per-SyncFull rendering state (filled by parseRdpCommand) ---
    u32  fbAddr        = 0;   // framebuffer byte address in RDRAM
    u32  fbDepthAddr   = 0;   // depth buffer byte address
    u32  fbWidth       = 0;   // fb pixel width
    u32  fbHeight      = 0;   // deduced fb height (from scissor yhi)
    u32  fbFmt         = 0;   // 0=RGBA8888, 2=RGBA5551 (FBFormat enum)
    u32  numPrimitives = 0;   // triangle count for this SyncFull batch
    u32  scissorYHi    = 0;   // scissor yhi (used to deduce height)

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

    // --- Allocate per-frame stream buffers (CPU → GPU each SyncFull) ---
    I.triangleSetupBuf         = createBuffer(I.device, "TriangleSetup",         SZ_TRIANGLE_SETUP,    BU_Storage | BU_CopyDst);
    I.attributeSetupBuf        = createBuffer(I.device, "AttributeSetup",        SZ_ATTRIBUTE_SETUP,   BU_Storage | BU_CopyDst);
    I.derivedSetupBuf          = createBuffer(I.device, "DerivedSetup",          SZ_DERIVED_SETUP,     BU_Storage | BU_CopyDst);
    I.scissorStateBuf          = createBuffer(I.device, "ScissorState",          SZ_SCISSOR_STATE,     BU_Storage | BU_CopyDst);
    I.staticRasterStateBuf     = createBuffer(I.device, "StaticRasterState",     SZ_STATIC_RASTER,     BU_Storage | BU_CopyDst);
    I.depthBlendStateBuf       = createBuffer(I.device, "DepthBlendState",       SZ_DEPTH_BLEND,       BU_Storage | BU_CopyDst);
    I.tileInfoStateBuf         = createBuffer(I.device, "TileInfoState",         SZ_TILE_INFO,         BU_Storage | BU_CopyDst);
    I.stateIndicesBuf          = createBuffer(I.device, "StateIndices",          SZ_STATE_INDICES,     BU_Storage | BU_CopyDst);
    I.spanInfoOffsetsBuf       = createBuffer(I.device, "SpanInfoOffsets",       SZ_SPAN_INFO_OFFSETS, BU_Storage | BU_CopyDst);
    I.spanInterpolationJobsBuf = createBuffer(I.device, "SpanInterpolationJobs", SZ_SPAN_INTERP_JOBS,  BU_Storage | BU_CopyDst);

    // --- Allocate persistent GPU intermediate buffers ---
    I.spanSetupsBuf            = createBuffer(I.device, "SpanSetups",            SZ_SPAN_SETUPS,         BU_Storage | BU_CopyDst);
    I.tileBitmaskBuf           = createBuffer(I.device, "TileBitmask",           SZ_TILE_BITMASK,        BU_Storage | BU_CopyDst);
    I.tileBitmaskCoarseBuf     = createBuffer(I.device, "TileBitmaskCoarse",     SZ_TILE_BITMASK_COARSE, BU_Storage | BU_CopyDst);
    I.hiddenRdramBuf           = createBuffer(I.device, "HiddenRDRAM",           RDRAM_SIZE,             BU_Storage | BU_CopyDst);
    I.tmemBuf                  = createBuffer(I.device, "TMEM",                  4096,                   BU_Storage | BU_CopyDst);
    I.blenderDividerLUTBuf     = createBuffer(I.device, "BlenderDividerLUT",     SZ_BLENDER_LUT,         BU_Storage | BU_CopyDst);

    // Upload the blender divider LUT immediately (static data from luts.hpp).
    wgpuQueueWriteBuffer(I.queue, I.blenderDividerLUTBuf, 0,
        RDP::blender_lut, SZ_BLENDER_LUT);

    // --- Allocate small UBO buffers ---
    // WebGPU requires uniform buffers to be at least 256 bytes aligned for
    // dynamic offsets, but fixed-binding UBOs just need to match the shader.
    I.tileBinningUniformBuf = createBuffer(I.device, "TileBinningUniform", 256, BU_Uniform | BU_CopyDst);
    I.globalFBInfoBuf       = createBuffer(I.device, "GlobalFBInfo",       256, BU_Uniform | BU_CopyDst);
    I.globalStateBuf        = createBuffer(I.device, "GlobalState",        256, BU_Uniform | BU_CopyDst);

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

    // Complex GPU rendering is active only when all required rendering pipelines
    // are compiled (non-null). When shaders are empty stubs, the pipelines will
    // be null and we fall back to the CPU scanout path.
    I.gpuRenderingActive = (I.pl_spanSetup    != nullptr &&
                            I.pl_tileBinning  != nullptr &&
                            I.pl_ubershader   != nullptr);

    if (I.gpuRenderingActive) {
        platform->status("WebGPU enabled: paraLLEl-RDP GPU dispatch active");
    } else {
        platform->status("WebGPU enabled: paraLLEl-RDP infrastructure ready (stub shaders)");
    }
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
    // Per-frame stream buffers
    releaseBuffer(I.triangleSetupBuf);
    releaseBuffer(I.attributeSetupBuf);
    releaseBuffer(I.derivedSetupBuf);
    releaseBuffer(I.scissorStateBuf);
    releaseBuffer(I.staticRasterStateBuf);
    releaseBuffer(I.depthBlendStateBuf);
    releaseBuffer(I.tileInfoStateBuf);
    releaseBuffer(I.stateIndicesBuf);
    releaseBuffer(I.spanInfoOffsetsBuf);
    releaseBuffer(I.spanInterpolationJobsBuf);
    // Persistent GPU intermediate buffers
    releaseBuffer(I.spanSetupsBuf);
    releaseBuffer(I.tileBitmaskBuf);
    releaseBuffer(I.tileBitmaskCoarseBuf);
    releaseBuffer(I.hiddenRdramBuf);
    releaseBuffer(I.tmemBuf);
    releaseBuffer(I.blenderDividerLUTBuf);
    // UBO buffers
    releaseBuffer(I.tileBinningUniformBuf);
    releaseBuffer(I.globalFBInfoBuf);
    releaseBuffer(I.globalStateBuf);
    // Bind groups
    auto releaseBG = [](WGPUBindGroup& bg){ if(bg){ wgpuBindGroupRelease(bg); bg=nullptr; } };
    releaseBG(I.bg_spanSetup_g0);
    releaseBG(I.bg_spanSetup_g1);
    releaseBG(I.bg_tileBin_g0);
    releaseBG(I.bg_tileBin_g2);
    releaseBG(I.bg_uber_g0);
    releaseBG(I.bg_uber_g1);
    releaseBG(I.bg_uber_g2);

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
static constexpr u32 OP_SYNC_FULL       = 0x29;
static constexpr u32 OP_SET_COLOR_IMAGE = 0x3f;
static constexpr u32 OP_SET_MASK_IMAGE  = 0x3e;
static constexpr u32 OP_SET_SCISSOR     = 0x2d;

// ---------------------------------------------------------------------------
// parseRdpCommand — extract framebuffer/scissor state from a single command.
// Call this for every command word pair before SyncFull flush.
// ---------------------------------------------------------------------------
static void parseRdpCommand(WebGpuRdp::Implementation& I, u32 w0, u32 w1) {
    u32 code = (w0 >> 24) & 63;
    switch (code) {
    case OP_SET_COLOR_IMAGE:
        // bits [25:0] of w1 = DRAM byte address; bits [22:19] of w0 = pixel format
        I.fbAddr = w1 & 0x03FFFFFFu;
        I.fbFmt  = (w0 >> 19) & 7u;
        break;
    case OP_SET_MASK_IMAGE:
        I.fbDepthAddr = w1 & 0x03FFFFFFu;
        break;
    case OP_SET_SCISSOR:
        // SET_SCISSOR: w0 = [opcode(6)|xh(12)|yh(12)], w1 = [f|o|xl(12)|yl(12)]
        // yhi (exclusive lower edge) is in w1 bits [11:2] (2.2 fixed → >> 2)
        {
            u32 yhi = (w1 >> 2) & 0x3FFu;
            I.scissorYHi = yhi;
            // Deduce fb width from scissor xhi field: w0 bits [23:12] (4.4 fixed → >> 2, round up)
            u32 xhi = ((w0 >> 12) & 0xFFFu) >> 2;
            if (xhi > I.fbWidth) I.fbWidth = xhi;
            if (yhi > I.fbHeight) I.fbHeight = yhi;
        }
        break;
    default:
        break;
    }
}

// ---------------------------------------------------------------------------
// Helper: create or recreate bind groups when framebuffer config changes.
// Uses wgpuComputePipelineGetBindGroupLayout() (auto-layout from shader).
// ---------------------------------------------------------------------------
static void rebuildBindGroups(WebGpuRdp::Implementation& I) {
    // Release old bind groups.
    auto releaseBG = [](WGPUBindGroup& bg){ if(bg){ wgpuBindGroupRelease(bg); bg=nullptr; } };
    releaseBG(I.bg_spanSetup_g0);
    releaseBG(I.bg_spanSetup_g1);
    releaseBG(I.bg_tileBin_g0);
    releaseBG(I.bg_tileBin_g2);
    releaseBG(I.bg_uber_g0);
    releaseBG(I.bg_uber_g1);
    releaseBG(I.bg_uber_g2);

    // Helper: build a WGPUBindGroupEntry for a storage buffer (whole range).
    auto bufEntry = [](u32 binding, WGPUBuffer buf, u64 size) -> WGPUBindGroupEntry {
        WGPUBindGroupEntry e = {};
        e.binding = binding;
        e.buffer  = buf;
        e.offset  = 0;
        e.size    = size;
        return e;
    };

    // ----- Pass 1: span_setup -----
    {
        WGPUBindGroupLayout bgl0 = wgpuComputePipelineGetBindGroupLayout(I.pl_spanSetup, 0);
        WGPUBindGroupEntry entries0[4] = {
            bufEntry(0, I.triangleSetupBuf,   SZ_TRIANGLE_SETUP),
            bufEntry(1, I.attributeSetupBuf,  SZ_ATTRIBUTE_SETUP),
            bufEntry(2, I.scissorStateBuf,    SZ_SCISSOR_STATE),
            bufEntry(3, I.spanSetupsBuf,      SZ_SPAN_SETUPS),
        };
        WGPUBindGroupDescriptor bgd0 = {};
        bgd0.layout     = bgl0;
        bgd0.entryCount = 4;
        bgd0.entries    = entries0;
        I.bg_spanSetup_g0 = wgpuDeviceCreateBindGroup(I.device, &bgd0);
        wgpuBindGroupLayoutRelease(bgl0);

        WGPUBindGroupLayout bgl1 = wgpuComputePipelineGetBindGroupLayout(I.pl_spanSetup, 1);
        WGPUBindGroupEntry entries1[1] = {
            bufEntry(0, I.spanInterpolationJobsBuf, SZ_SPAN_INTERP_JOBS),
        };
        WGPUBindGroupDescriptor bgd1 = {};
        bgd1.layout     = bgl1;
        bgd1.entryCount = 1;
        bgd1.entries    = entries1;
        I.bg_spanSetup_g1 = wgpuDeviceCreateBindGroup(I.device, &bgd1);
        wgpuBindGroupLayoutRelease(bgl1);
    }

    // ----- Pass 2: tile_binning -----
    {
        WGPUBindGroupLayout bgl0 = wgpuComputePipelineGetBindGroupLayout(I.pl_tileBinning, 0);
        WGPUBindGroupEntry entries0[4] = {
            bufEntry(0, I.triangleSetupBuf,     SZ_TRIANGLE_SETUP),
            bufEntry(1, I.scissorStateBuf,      SZ_SCISSOR_STATE),
            bufEntry(2, I.tileBitmaskBuf,       SZ_TILE_BITMASK),
            bufEntry(3, I.tileBitmaskCoarseBuf, SZ_TILE_BITMASK_COARSE),
        };
        WGPUBindGroupDescriptor bgd0 = {};
        bgd0.layout     = bgl0;
        bgd0.entryCount = 4;
        bgd0.entries    = entries0;
        I.bg_tileBin_g0 = wgpuDeviceCreateBindGroup(I.device, &bgd0);
        wgpuBindGroupLayoutRelease(bgl0);

        WGPUBindGroupLayout bgl2 = wgpuComputePipelineGetBindGroupLayout(I.pl_tileBinning, 2);
        WGPUBindGroupEntry entries2[1] = {
            bufEntry(0, I.tileBinningUniformBuf, 256),
        };
        WGPUBindGroupDescriptor bgd2 = {};
        bgd2.layout     = bgl2;
        bgd2.entryCount = 1;
        bgd2.entries    = entries2;
        I.bg_tileBin_g2 = wgpuDeviceCreateBindGroup(I.device, &bgd2);
        wgpuBindGroupLayoutRelease(bgl2);
    }

    // ----- Pass 3: ubershader -----
    {
        WGPUBindGroupLayout bgl0 = wgpuComputePipelineGetBindGroupLayout(I.pl_ubershader, 0);
        WGPUBindGroupEntry entries0[3] = {
            bufEntry(0, I.rdramBuf,       RDRAM_SIZE),
            bufEntry(1, I.hiddenRdramBuf, RDRAM_SIZE),
            bufEntry(2, I.tmemBuf,        4096),
        };
        WGPUBindGroupDescriptor bgd0 = {};
        bgd0.layout     = bgl0;
        bgd0.entryCount = 3;
        bgd0.entries    = entries0;
        I.bg_uber_g0 = wgpuDeviceCreateBindGroup(I.device, &bgd0);
        wgpuBindGroupLayoutRelease(bgl0);

        WGPUBindGroupLayout bgl1 = wgpuComputePipelineGetBindGroupLayout(I.pl_ubershader, 1);
        WGPUBindGroupEntry entries1[13] = {
            bufEntry( 0, I.triangleSetupBuf,         SZ_TRIANGLE_SETUP),
            bufEntry( 1, I.attributeSetupBuf,        SZ_ATTRIBUTE_SETUP),
            bufEntry( 2, I.derivedSetupBuf,          SZ_DERIVED_SETUP),
            bufEntry( 3, I.scissorStateBuf,          SZ_SCISSOR_STATE),
            bufEntry( 4, I.staticRasterStateBuf,     SZ_STATIC_RASTER),
            bufEntry( 5, I.depthBlendStateBuf,       SZ_DEPTH_BLEND),
            bufEntry( 6, I.stateIndicesBuf,          SZ_STATE_INDICES),
            bufEntry( 7, I.tileInfoStateBuf,         SZ_TILE_INFO),
            bufEntry( 8, I.spanSetupsBuf,            SZ_SPAN_SETUPS),
            bufEntry( 9, I.spanInfoOffsetsBuf,       SZ_SPAN_INFO_OFFSETS),
            bufEntry(10, I.blenderDividerLUTBuf,     SZ_BLENDER_LUT),
            bufEntry(11, I.tileBitmaskBuf,           SZ_TILE_BITMASK),
            bufEntry(12, I.tileBitmaskCoarseBuf,     SZ_TILE_BITMASK_COARSE),
        };
        WGPUBindGroupDescriptor bgd1 = {};
        bgd1.layout     = bgl1;
        bgd1.entryCount = 13;
        bgd1.entries    = entries1;
        I.bg_uber_g1 = wgpuDeviceCreateBindGroup(I.device, &bgd1);
        wgpuBindGroupLayoutRelease(bgl1);

        WGPUBindGroupLayout bgl2 = wgpuComputePipelineGetBindGroupLayout(I.pl_ubershader, 2);
        WGPUBindGroupEntry entries2[2] = {
            bufEntry(0, I.globalFBInfoBuf, 256),
            bufEntry(1, I.globalStateBuf,  256),
        };
        WGPUBindGroupDescriptor bgd2 = {};
        bgd2.layout     = bgl2;
        bgd2.entryCount = 2;
        bgd2.entries    = entries2;
        I.bg_uber_g2 = wgpuDeviceCreateBindGroup(I.device, &bgd2);
        wgpuBindGroupLayoutRelease(bgl2);
    }

    I.bindGroupFbAddr  = I.fbAddr;
    I.bindGroupFbWidth = I.fbWidth;
}

// ---------------------------------------------------------------------------
// flushGpuCommands — 3-pass GPU dispatch (span_setup → tile_binning → ubershader)
// ---------------------------------------------------------------------------
static void flushGpuCommands(WebGpuRdp::Implementation& I) {
    if (!I.device) return;

    // --- Upload CPU RDRAM to GPU if dirty ---
    if (I.rdramDirty) {
        wgpuQueueWriteBuffer(I.queue, I.rdramBuf, 0,
            rdram.ram.data, RDRAM_SIZE);
        I.rdramDirty = false;
    }

    // If GPU rendering is not active (stub shaders), submit a no-op to keep
    // the queue alive and return.
    if (!I.gpuRenderingActive) {
        WGPUCommandEncoderDescriptor encDesc = {};
        WGPUCommandEncoder enc = wgpuDeviceCreateCommandEncoder(I.device, &encDesc);
        WGPUCommandBuffer cmd  = wgpuCommandEncoderFinish(enc, nullptr);
        wgpuQueueSubmit(I.queue, 1, &cmd);
        wgpuCommandBufferRelease(cmd);
        wgpuCommandEncoderRelease(enc);
        return;
    }

    u32 numPrims = I.numPrimitives;
    u32 fbW      = (I.fbWidth  > 0) ? I.fbWidth  : 320;
    u32 fbH      = (I.fbHeight > 0) ? I.fbHeight : 240;

    // --- Upload UBO data for this SyncFull ---

    // tileBinningUniform: {resolution_x: u32, resolution_y: u32, primitive_count: i32, pad: i32}
    {
        u32 ubo[4] = { fbW, fbH, numPrims, 0 };
        wgpuQueueWriteBuffer(I.queue, I.tileBinningUniformBuf, 0, ubo, sizeof(ubo));
    }

    // GlobalFBInfo: dx_shift, dx_mask, fb_size, base_primitive_index
    {
        // dx_shift: log2 of bytes-per-pixel (0=8bpp, 1=16bpp, 2=32bpp)
        // For N64: fbFmt 2 = RGBA5551 (16bpp, shift=1), fbFmt 0 = RGBA8888 (32bpp, shift=2)
        u32 dxShift = (I.fbFmt == 2) ? 1u : 2u;
        u32 dxMask  = (1u << dxShift) - 1u;
        u32 fbSize  = fbW * fbH * (1u << dxShift);
        u32 globalFBInfo[4] = { dxShift, dxMask, fbSize, 0u };
        wgpuQueueWriteBuffer(I.queue, I.globalFBInfoBuf, 0, globalFBInfo, sizeof(globalFBInfo));
    }

    // GlobalState: addr_index, depth_addr_index, fb_width, fb_height, group_mask
    {
        // addr_index / depth_addr_index: RDRAM byte address >> 2 (u32 word index)
        u32 addrIndex      = I.fbAddr      >> 2;
        u32 depthAddrIndex = I.fbDepthAddr >> 2;
        u32 groupMask      = 0xFFFFFFFFu;  // all groups active
        u32 globalState[5] = { addrIndex, depthAddrIndex, fbW, fbH, groupMask };
        wgpuQueueWriteBuffer(I.queue, I.globalStateBuf, 0, globalState, sizeof(globalState));
    }

    // Rebuild bind groups if the framebuffer config changed (or first frame).
    if (I.bindGroupFbAddr != I.fbAddr || I.bindGroupFbWidth != I.fbWidth ||
        I.bg_spanSetup_g0 == nullptr) {
        rebuildBindGroups(I);
    }

    // Skip dispatch if no primitives (nothing to render).
    if (numPrims == 0) return;

    // --- Compute dispatch dimensions ---

    // Tile counts (each tile is 8×8 pixels)
    u32 numTilesX  = (fbW + 7) / 8;
    u32 numTilesY  = (fbH + 7) / 8;

    // Tile-binning meta-tile dimensions: each meta-tile covers 8 tiles X, 4 tiles Y
    u32 metaTilesX = (numTilesX + 7) / 8;
    u32 metaTilesY = (numTilesY + 3) / 4;

    // Primitives rounded up to 32 (tile_binning workgroup covers 32 prims)
    u32 numPrims32 = (numPrims + 31) / 32;

    // Ubershader: one workgroup per tile
    u32 uberX = numTilesX;
    u32 uberY = numTilesY;

    // --- Build and submit the command encoder with 3 compute passes ---
    WGPUCommandEncoderDescriptor encDesc = {};
    WGPUCommandEncoder enc = wgpuDeviceCreateCommandEncoder(I.device, &encDesc);

    // Pass 1: span_setup
    // Computes per-span attribute interpolation for all primitives.
    {
        WGPUComputePassDescriptor passDesc = {};
        passDesc.label = "span_setup";
        WGPUComputePassEncoder pass = wgpuCommandEncoderBeginComputePass(enc, &passDesc);
        wgpuComputePassEncoderSetPipeline(pass, I.pl_spanSetup);
        wgpuComputePassEncoderSetBindGroup(pass, 0, I.bg_spanSetup_g0, 0, nullptr);
        wgpuComputePassEncoderSetBindGroup(pass, 1, I.bg_spanSetup_g1, 0, nullptr);
        // Dispatch one workgroup per SpanInterpolationJob (= one per primitive for now).
        wgpuComputePassEncoderDispatchWorkgroups(pass, numPrims, 1, 1);
        wgpuComputePassEncoderEnd(pass);
        wgpuComputePassEncoderRelease(pass);
    }

    // Pass 2: tile_binning
    // Builds per-tile primitive bitmasks for the ubershader.
    {
        WGPUComputePassDescriptor passDesc = {};
        passDesc.label = "tile_binning";
        WGPUComputePassEncoder pass = wgpuCommandEncoderBeginComputePass(enc, &passDesc);
        wgpuComputePassEncoderSetPipeline(pass, I.pl_tileBinning);
        wgpuComputePassEncoderSetBindGroup(pass, 0, I.bg_tileBin_g0, 0, nullptr);
        wgpuComputePassEncoderSetBindGroup(pass, 2, I.bg_tileBin_g2, 0, nullptr);
        wgpuComputePassEncoderDispatchWorkgroups(pass, numPrims32, metaTilesX, metaTilesY);
        wgpuComputePassEncoderEnd(pass);
        wgpuComputePassEncoderRelease(pass);
    }

    // Pass 3: ubershader
    // Rasterises and shades each tile, writing pixels into rdramBuf.
    // In WebGPU, storage buffer writes from prior passes in the same submission
    // are visible to subsequent dispatches — no explicit barrier needed.
    {
        WGPUComputePassDescriptor passDesc = {};
        passDesc.label = "ubershader";
        WGPUComputePassEncoder pass = wgpuCommandEncoderBeginComputePass(enc, &passDesc);
        wgpuComputePassEncoderSetPipeline(pass, I.pl_ubershader);
        wgpuComputePassEncoderSetBindGroup(pass, 0, I.bg_uber_g0, 0, nullptr);
        wgpuComputePassEncoderSetBindGroup(pass, 1, I.bg_uber_g1, 0, nullptr);
        wgpuComputePassEncoderSetBindGroup(pass, 2, I.bg_uber_g2, 0, nullptr);
        wgpuComputePassEncoderDispatchWorkgroups(pass, uberX, uberY, 1);
        wgpuComputePassEncoderEnd(pass);
        wgpuComputePassEncoderRelease(pass);
    }

    WGPUCommandBuffer cmd = wgpuCommandEncoderFinish(enc, nullptr);
    wgpuQueueSubmit(I.queue, 1, &cmd);
    wgpuCommandBufferRelease(cmd);
    wgpuCommandEncoderRelease(enc);

    // Reset per-SyncFull primitive counter (scissor/fb state persists until overwritten).
    I.numPrimitives = 0;
}

auto WebGpuRdp::render() -> bool {
    if (!implementation) return false;
    auto& I = *implementation;

    // When GPU shaders are not yet active, return false so the software RDP
    // in render.cpp can process commands and write pixels into RDRAM.
    // mapScanoutRead() will then pick up those pixels from RDRAM directly.
    if (!I.gpuRenderingActive) return false;

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
        u32 w0   = I.cmdBuffer[I.queueOffset * 2 + 0];
        u32 w1   = I.cmdBuffer[I.queueOffset * 2 + 1];
        u32 code = (w0 >> 24) & 63;
        u32 len  = kCommandLength[code];

        if (I.queueOffset + len > I.queueSize) {
            // Partial command — wait for more data.
            command.start = command.current = command.end;
            return true;
        }

        // Extract framebuffer/scissor state from this command before dispatch.
        parseRdpCommand(I, w0, w1);

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
