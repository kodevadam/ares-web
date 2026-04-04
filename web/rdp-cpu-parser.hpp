// web/rdp-cpu-parser.hpp
//
// Standalone CPU-side RDP command parser for the WebGPU paraLLEl-RDP port.
//
// Decodes every RDP command and fills the stream buffers consumed by the
// three-pass GPU dispatch (span_setup → tile_binning → ubershader).
//
// Design constraints
// ------------------
// • Zero Vulkan dependencies: only rdp_data_structures.hpp (which only pulls
//   in rdp_common.hpp that forward-declares Vulkan::Program / Vulkan::Shader).
// • Mirrors the CPU-side logic of rdp_device.cpp + rdp_renderer.cpp without
//   any GPU submission, coherency handling, or TMEM simulation.
// • TMEM uploads are *counted* (tile_instance_index) but not simulated; the
//   first TMEM snapshot is reused for all primitives — acceptable until a
//   full TMEM upload path is added.

#pragma once

#include <stdint.h>
#include <string.h>
#include <algorithm>
#include <limits>

// paraLLEl-RDP data structures — no Vulkan headers required
#include "ares/n64/vulkan/parallel-rdp/parallel-rdp/rdp_data_structures.hpp"

namespace Web {

// Minimal re-export of the enums / structs from rdp_renderer.hpp that we need
// locally (to avoid including that header which pulls in Vulkan).
enum class FBFormat : uint32_t { I4=0, I8=1, RGBA5551=2, IA88=3, RGBA8888=4 };
enum class UploadMode : uint32_t { Tile=0, TLUT=1, Block=2 };

struct LoadTileInfo {
    uint32_t tex_addr   = 0;
    uint32_t tex_width  = 1;
    uint16_t slo=0, tlo=0, shi=0, thi=0;
    RDP::TextureFormat fmt  = RDP::TextureFormat::RGBA;
    RDP::TextureSize   size = RDP::TextureSize::Bpp16;
    UploadMode         mode = UploadMode::Tile;
};

// -------------------------------------------------------------------------

class RdpCpuParser {
public:
    RdpCpuParser();

    // Parse one complete RDP command.  |words| points to the first u32
    // of the command (the full multi-word payload for triangle commands).
    // The opcode is derived from (words[0] >> 24) & 63.
    void parseCommand(const uint32_t *words);

    // Reset all stream caches.  Call after uploading the buffers to GPU
    // (i.e. after each SyncFull flush).
    void reset();

    // ---- Stream data exposed for wgpuQueueWriteBuffer upload ----
    // triangle_setup and attribute_setup are per-primitive arrays (size = numPrimitives).
    // span_info_jobs drives the span_setup workgroup dispatch count.

    RDP::StreamCache<RDP::TriangleSetup,            RDP::Limits::MaxPrimitives>             triangle_setup;
    RDP::StreamCache<RDP::AttributeSetup,           RDP::Limits::MaxPrimitives>             attribute_setup;
    RDP::StreamCache<RDP::DerivedSetup,             RDP::Limits::MaxPrimitives>             derived_setup;
    RDP::StreamCache<RDP::ScissorState,             RDP::Limits::MaxPrimitives>             scissor_setup;
    RDP::StreamCache<RDP::InstanceIndices,          RDP::Limits::MaxPrimitives>             state_indices;
    RDP::StreamCache<RDP::SpanInfoOffsets,          RDP::Limits::MaxPrimitives>             span_info_offsets;
    // span_info_jobs: one entry per workgroup (64 scanlines each) across all primitives
    RDP::StreamCache<RDP::SpanInterpolationJob,
                     RDP::Limits::MaxSpanSetups / RDP::ImplementationConstants::DefaultWorkgroupSize>
                                                                                            span_info_jobs;

    RDP::StateCache<RDP::StaticRasterizationState,  RDP::Limits::MaxStaticRasterizationStates>
                                                                                            static_raster_cache;
    RDP::StateCache<RDP::DepthBlendState,           RDP::Limits::MaxDepthBlendStates>      depth_blend_cache;
    RDP::StateCache<RDP::TileInfo,                  RDP::Limits::MaxTileInfoStates>        tile_info_cache;

private:
    // ---- Persistent render state (survives across SyncFull resets) ----
    RDP::ScissorState             scissor_state{};
    RDP::StaticRasterizationState static_raster_state{};
    RDP::DepthBlendState          depth_blend_state{};
    RDP::TileInfo                 tiles[8]{};

    // ---- Color / depth constants ----
    uint32_t blend_color     = 0;
    uint32_t fog_color       = 0;
    uint32_t env_color       = 0;
    uint32_t primitive_color = 0;
    uint32_t fill_color      = 0;
    int32_t  prim_depth      = 0;  // in 16.16 fixed-point
    uint16_t prim_dz         = 0;
    bool     use_prim_depth  = false;
    uint8_t  min_level       = 0;
    uint8_t  prim_lod_frac   = 0;
    int32_t  convert[6]      = {};
    uint32_t key_width[3]    = {};
    uint8_t  key_center[3]   = {};
    uint8_t  key_scale[3]    = {};

    // ---- Texture image register ----
    uint32_t           tex_addr  = 0;
    uint32_t           tex_width = 1;
    RDP::TextureFormat tex_fmt   = RDP::TextureFormat::RGBA;
    RDP::TextureSize   tex_size  = RDP::TextureSize::Bpp16;

    // ---- TMEM upload count (used as tile_instance_index) ----
    uint32_t tmem_upload_count = 0;

    // ---- Internal helpers ----
    void decode_triangle_setup(RDP::TriangleSetup &setup, const uint32_t *words) const;
    void draw_shaded_primitive(RDP::TriangleSetup &setup, const RDP::AttributeSetup &attr);
    void draw_flat_primitive  (RDP::TriangleSetup &setup);
    RDP::SpanInfoOffsets allocate_span_jobs(const RDP::TriangleSetup &setup);
    RDP::DerivedSetup    build_derived_attributes(const RDP::AttributeSetup &attr) const;
    void build_combiner_constants(RDP::DerivedSetup &setup, unsigned cycle) const;
    void fixup_triangle_setup(RDP::TriangleSetup &setup) const;
    RDP::StaticRasterizationState normalize_static_state(RDP::StaticRasterizationState state);
    void deduce_static_texture_state(unsigned tile, unsigned max_lod_level);
    void deduce_noise_state();

    static void     encode_rgb    (uint8_t *rgba, uint32_t color);
    static void     encode_alpha  (uint8_t *rgba, uint32_t color);
    static int      normalize_dzpix(int dz);
    static uint16_t dz_compress   (int dz);

    // Sign-extend a bitfield of <bits> width.
    template<int bits>
    static int32_t sext(int32_t v) {
        struct { int32_t d : bits; } s;
        s.d = v;
        return s.d;
    }

    bool need_flush() const;
};

} // namespace Web
