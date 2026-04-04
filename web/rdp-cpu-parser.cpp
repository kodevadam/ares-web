// web/rdp-cpu-parser.cpp
//
// CPU-side RDP command parser — fills stream buffers for WebGPU dispatch.
// Mirrors logic from rdp_device.cpp (command decode) and rdp_renderer.cpp
// (state tracking + stream filling) without any Vulkan dependency.

#include "rdp-cpu-parser.hpp"

// STATE_MASK macro — same as rdp_device.cpp
#define STATE_MASK(flag, cond, mask) do { \
    (flag) &= ~(mask); \
    if (cond) (flag) |= (mask); \
} while(0)

using namespace RDP;

namespace Web {

// =========================================================================
// Static helpers
// =========================================================================

void RdpCpuParser::encode_rgb(uint8_t *rgba, uint32_t color) {
    rgba[0] = uint8_t(color >> 24);
    rgba[1] = uint8_t(color >> 16);
    rgba[2] = uint8_t(color >> 8);
}

void RdpCpuParser::encode_alpha(uint8_t *rgba, uint32_t color) {
    rgba[3] = uint8_t(color);
}

int RdpCpuParser::normalize_dzpix(int dz) {
    if (dz >= 0x8000) return 0x8000;
    if (dz == 0) return 1;
    // Find highest set bit: __builtin_clz gives leading zeros for unsigned int
    unsigned bit = 31 - (unsigned)__builtin_clz((unsigned)dz);
    return 1 << (bit + 1);
}

uint16_t RdpCpuParser::dz_compress(int dz) {
    int val = 0;
    if (dz & 0xff00) val |= 8;
    if (dz & 0xf0f0) val |= 4;
    if (dz & 0xcccc) val |= 2;
    if (dz & 0xaaaa) val |= 1;
    return uint16_t(val);
}

// =========================================================================
// Combiner access checks (free functions, mirror rdp_renderer.cpp)
// =========================================================================

static bool combiner_accesses_texel0(const CombinerInputs &inputs) {
    return inputs.rgb.muladd == RGBMulAdd::Texel0 ||
           inputs.rgb.mulsub == RGBMulSub::Texel0 ||
           inputs.rgb.mul    == RGBMul::Texel0 ||
           inputs.rgb.add    == RGBAdd::Texel0 ||
           inputs.rgb.mul    == RGBMul::Texel0Alpha ||
           inputs.alpha.muladd == AlphaAddSub::Texel0Alpha ||
           inputs.alpha.mulsub == AlphaAddSub::Texel0Alpha ||
           inputs.alpha.mul    == AlphaMul::Texel0Alpha ||
           inputs.alpha.add    == AlphaAddSub::Texel0Alpha;
}

static bool combiner_accesses_texel1(const CombinerInputs &inputs) {
    return inputs.rgb.muladd == RGBMulAdd::Texel1 ||
           inputs.rgb.mulsub == RGBMulSub::Texel1 ||
           inputs.rgb.mul    == RGBMul::Texel1 ||
           inputs.rgb.add    == RGBAdd::Texel1 ||
           inputs.rgb.mul    == RGBMul::Texel1Alpha ||
           inputs.alpha.muladd == AlphaAddSub::Texel1Alpha ||
           inputs.alpha.mulsub == AlphaAddSub::Texel1Alpha ||
           inputs.alpha.mul    == AlphaMul::Texel1Alpha ||
           inputs.alpha.add    == AlphaAddSub::Texel1Alpha;
}

static bool combiner_accesses_lod_frac(const CombinerInputs &inputs) {
    return inputs.rgb.mul == RGBMul::LODFrac || inputs.alpha.mul == AlphaMul::LODFrac;
}

static bool combiner_uses_texel0(const StaticRasterizationState &state) {
    if ((state.flags & RASTERIZATION_MULTI_CYCLE_BIT) != 0)
        return combiner_accesses_texel0(state.combiner[0]) ||
               combiner_accesses_texel1(state.combiner[1]);
    else
        return combiner_accesses_texel0(state.combiner[1]);
}

static bool combiner_uses_texel1(const StaticRasterizationState &state) {
    if ((state.flags & RASTERIZATION_MULTI_CYCLE_BIT) != 0)
        return combiner_accesses_texel1(state.combiner[0]) ||
               combiner_accesses_texel0(state.combiner[1]);
    else
        return false;
}

static bool combiner_uses_pipelined_texel1(const StaticRasterizationState &state) {
    if ((state.flags & RASTERIZATION_MULTI_CYCLE_BIT) == 0)
        return combiner_accesses_texel1(state.combiner[1]);
    else
        return false;
}

static bool combiner_uses_lod_frac(const StaticRasterizationState &state) {
    if ((state.flags & RASTERIZATION_MULTI_CYCLE_BIT) != 0)
        return combiner_accesses_lod_frac(state.combiner[0]) ||
               combiner_accesses_lod_frac(state.combiner[1]);
    else
        return false;
}

// =========================================================================
// Normalize combiner overloads (mirror rdp_renderer.cpp)
// =========================================================================

static RGBMulAdd normalize_combiner(RGBMulAdd v) {
    switch (v) {
    case RGBMulAdd::Noise: case RGBMulAdd::Texel0: case RGBMulAdd::Texel1:
    case RGBMulAdd::Combined: case RGBMulAdd::One: case RGBMulAdd::Shade:
        return v;
    default: return RGBMulAdd::Zero;
    }
}

static RGBMulSub normalize_combiner(RGBMulSub v) {
    switch (v) {
    case RGBMulSub::Combined: case RGBMulSub::Texel0: case RGBMulSub::Texel1:
    case RGBMulSub::Shade: case RGBMulSub::ConvertK4:
        return v;
    default: return RGBMulSub::Zero;
    }
}

static RGBMul normalize_combiner(RGBMul v) {
    switch (v) {
    case RGBMul::Combined: case RGBMul::CombinedAlpha:
    case RGBMul::Texel0: case RGBMul::Texel1:
    case RGBMul::Texel0Alpha: case RGBMul::Texel1Alpha:
    case RGBMul::Shade: case RGBMul::ShadeAlpha:
    case RGBMul::LODFrac: case RGBMul::ConvertK5:
        return v;
    default: return RGBMul::Zero;
    }
}

static RGBAdd normalize_combiner(RGBAdd v) {
    switch (v) {
    case RGBAdd::Texel0: case RGBAdd::Texel1: case RGBAdd::Combined:
    case RGBAdd::One: case RGBAdd::Shade:
        return v;
    default: return RGBAdd::Zero;
    }
}

static AlphaAddSub normalize_combiner(AlphaAddSub v) {
    switch (v) {
    case AlphaAddSub::CombinedAlpha: case AlphaAddSub::Texel0Alpha:
    case AlphaAddSub::Texel1Alpha: case AlphaAddSub::ShadeAlpha:
    case AlphaAddSub::One:
        return v;
    default: return AlphaAddSub::Zero;
    }
}

static AlphaMul normalize_combiner(AlphaMul v) {
    switch (v) {
    case AlphaMul::LODFrac: case AlphaMul::Texel0Alpha:
    case AlphaMul::Texel1Alpha: case AlphaMul::ShadeAlpha:
        return v;
    default: return AlphaMul::Zero;
    }
}

static void normalize_combiner(CombinerInputs &c) {
    c.rgb.muladd = normalize_combiner(c.rgb.muladd);
    c.rgb.mulsub = normalize_combiner(c.rgb.mulsub);
    c.rgb.mul    = normalize_combiner(c.rgb.mul);
    c.rgb.add    = normalize_combiner(c.rgb.add);
    c.alpha.muladd = normalize_combiner(c.alpha.muladd);
    c.alpha.mulsub = normalize_combiner(c.alpha.mulsub);
    c.alpha.mul    = normalize_combiner(c.alpha.mul);
    c.alpha.add    = normalize_combiner(c.alpha.add);
}

// =========================================================================
// Constructor / Reset
// =========================================================================

RdpCpuParser::RdpCpuParser() {
    memset(&scissor_state, 0, sizeof(scissor_state));
    memset(&static_raster_state, 0, sizeof(static_raster_state));
    memset(&depth_blend_state, 0, sizeof(depth_blend_state));
    memset(tiles, 0, sizeof(tiles));
}

void RdpCpuParser::reset() {
    triangle_setup.reset();
    attribute_setup.reset();
    derived_setup.reset();
    scissor_setup.reset();
    state_indices.reset();
    span_info_offsets.reset();
    span_info_jobs.reset();
    static_raster_cache.reset();
    depth_blend_cache.reset();
    tile_info_cache.reset();
    tmem_upload_count = 0;
}

// =========================================================================
// Decode helpers (mirror rdp_device.cpp)
// =========================================================================

void RdpCpuParser::decode_triangle_setup(TriangleSetup &setup, const uint32_t *words) const {
    bool copy_cycle = (static_raster_state.flags & RASTERIZATION_COPY_BIT) != 0;
    bool flip = (words[0] & 0x800000u) != 0;
    bool sign_dxhdy = (words[5] & 0x80000000u) != 0;
    bool do_offset = flip == sign_dxhdy;

    setup.flags |= flip ? TRIANGLE_SETUP_FLIP_BIT : 0;
    setup.flags |= do_offset ? TRIANGLE_SETUP_DO_OFFSET_BIT : 0;
    setup.flags |= copy_cycle ? TRIANGLE_SETUP_SKIP_XFRAC_BIT : 0;
    // No native_texture_lod quirk in web build

    setup.tile = (words[0] >> 16) & 63;
    setup.yl = sext<14>(words[0]);
    setup.ym = sext<14>(words[1] >> 16);
    setup.yh = sext<14>(words[1]);

    setup.xl    = sext<28>(words[2]) >> 1;
    setup.xh    = sext<28>(words[4]) >> 1;
    setup.xm    = sext<28>(words[6]) >> 1;
    setup.dxldy = sext<28>(words[3] >> 2) >> 1;
    setup.dxhdy = sext<28>(words[5] >> 2) >> 1;
    setup.dxmdy = sext<28>(words[7] >> 2) >> 1;
}

static void decode_tex_setup(AttributeSetup &attr, const uint32_t *words) {
    attr.s = (words[0] & 0xffff0000u) | ((words[4] >> 16) & 0x0000ffffu);
    attr.t = ((words[0] << 16) & 0xffff0000u) | (words[4] & 0x0000ffffu);
    attr.w = (words[1] & 0xffff0000u) | ((words[5] >> 16) & 0x0000ffffu);

    attr.dsdx = (words[2] & 0xffff0000u) | ((words[6] >> 16) & 0x0000ffffu);
    attr.dtdx = ((words[2] << 16) & 0xffff0000u) | (words[6] & 0x0000ffffu);
    attr.dwdx = (words[3] & 0xffff0000u) | ((words[7] >> 16) & 0x0000ffffu);

    attr.dsde = (words[8] & 0xffff0000u)  | ((words[12] >> 16) & 0x0000ffffu);
    attr.dtde = ((words[8] << 16) & 0xffff0000u) | (words[12] & 0x0000ffffu);
    attr.dwde = (words[9] & 0xffff0000u)  | ((words[13] >> 16) & 0x0000ffffu);

    attr.dsdy = (words[10] & 0xffff0000u) | ((words[14] >> 16) & 0x0000ffffu);
    attr.dtdy = ((words[10] << 16) & 0xffff0000u) | (words[14] & 0x0000ffffu);
    attr.dwdy = (words[11] & 0xffff0000u) | ((words[15] >> 16) & 0x0000ffffu);
}

static void decode_rgba_setup(AttributeSetup &attr, const uint32_t *words) {
    attr.r = (words[0] & 0xffff0000u) | ((words[4] >> 16) & 0xffff);
    attr.g = (words[0] << 16) | (words[4] & 0xffff);
    attr.b = (words[1] & 0xffff0000u) | ((words[5] >> 16) & 0xffff);
    attr.a = (words[1] << 16) | (words[5] & 0xffff);

    attr.drdx = (words[2] & 0xffff0000u) | ((words[6] >> 16) & 0xffff);
    attr.dgdx = (words[2] << 16) | (words[6] & 0xffff);
    attr.dbdx = (words[3] & 0xffff0000u) | ((words[7] >> 16) & 0xffff);
    attr.dadx = (words[3] << 16) | (words[7] & 0xffff);

    attr.drde = (words[8] & 0xffff0000u)  | ((words[12] >> 16) & 0xffff);
    attr.dgde = (words[8] << 16) | (words[12] & 0xffff);
    attr.dbde = (words[9] & 0xffff0000u)  | ((words[13] >> 16) & 0xffff);
    attr.dade = (words[9] << 16) | (words[13] & 0xffff);

    attr.drdy = (words[10] & 0xffff0000u) | ((words[14] >> 16) & 0xffff);
    attr.dgdy = (words[10] << 16) | (words[14] & 0xffff);
    attr.dbdy = (words[11] & 0xffff0000u) | ((words[15] >> 16) & 0xffff);
    attr.dady = (words[11] << 16) | (words[15] & 0xffff);
}

static void decode_z_setup(AttributeSetup &attr, const uint32_t *words) {
    attr.z    = words[0];
    attr.dzdx = words[1];
    attr.dzde = words[2];
    attr.dzdy = words[3];
}

// =========================================================================
// State deduction (mirror rdp_renderer.cpp)
// =========================================================================

void RdpCpuParser::fixup_triangle_setup(TriangleSetup &setup) const {
    static constexpr unsigned SUBPIXELS_Y = 4;
    int start_y = setup.yh & ~(SUBPIXELS_Y - 1);
    if (setup.ym < start_y)
        setup.ym = std::numeric_limits<int16_t>::max();

    if ((static_raster_state.flags & RASTERIZATION_INTERLACE_FIELD_BIT) != 0) {
        setup.flags |= (static_raster_state.flags & RASTERIZATION_INTERLACE_FIELD_BIT)
                        ? TRIANGLE_SETUP_INTERLACE_FIELD_BIT : 0;
        setup.flags |= (static_raster_state.flags & RASTERIZATION_INTERLACE_KEEP_ODD_BIT)
                        ? TRIANGLE_SETUP_INTERLACE_KEEP_ODD_BIT : 0;
    }

    if ((static_raster_state.flags & (RASTERIZATION_COPY_BIT | RASTERIZATION_FILL_BIT)) != 0)
        setup.flags |= TRIANGLE_SETUP_FILL_COPY_RASTER_BIT;
}

void RdpCpuParser::deduce_noise_state() {
    auto &state = static_raster_state;
    state.flags &= ~(RASTERIZATION_NEED_NOISE_BIT | RASTERIZATION_NEED_NOISE_DUAL_BIT);

    if ((state.dither & 3) == 2 || ((state.dither >> 2) & 3) == 2) {
        state.flags |= RASTERIZATION_NEED_NOISE_BIT;
        return;
    }

    if ((state.flags & (RASTERIZATION_COPY_BIT | RASTERIZATION_FILL_BIT)) != 0)
        return;

    if ((state.flags & RASTERIZATION_MULTI_CYCLE_BIT) != 0)
        if (state.combiner[0].rgb.muladd == RGBMulAdd::Noise)
            state.flags |= RASTERIZATION_NEED_NOISE_BIT;

    if (state.combiner[1].rgb.muladd == RGBMulAdd::Noise)
        state.flags |= RASTERIZATION_NEED_NOISE_BIT;

    if ((state.flags & RASTERIZATION_MULTI_CYCLE_BIT) != 0 &&
        state.combiner[0].rgb.muladd == RGBMulAdd::Noise &&
        state.combiner[1].rgb.muladd == RGBMulAdd::Noise)
        state.flags |= RASTERIZATION_NEED_NOISE_DUAL_BIT;

    if ((state.flags & (RASTERIZATION_ALPHA_TEST_BIT | RASTERIZATION_ALPHA_TEST_DITHER_BIT)) ==
        (RASTERIZATION_ALPHA_TEST_BIT | RASTERIZATION_ALPHA_TEST_DITHER_BIT))
        state.flags |= RASTERIZATION_NEED_NOISE_BIT;
}

StaticRasterizationState RdpCpuParser::normalize_static_state(StaticRasterizationState state) {
    if ((state.flags & RASTERIZATION_FILL_BIT) != 0) {
        state = {};
        state.flags = RASTERIZATION_FILL_BIT;
        return state;
    }

    if ((state.flags & RASTERIZATION_COPY_BIT) != 0) {
        auto flags = state.flags &
                     (RASTERIZATION_COPY_BIT |
                      RASTERIZATION_TLUT_BIT |
                      RASTERIZATION_TLUT_TYPE_BIT |
                      RASTERIZATION_USES_TEXEL0_BIT |
                      RASTERIZATION_USE_STATIC_TEXTURE_SIZE_FORMAT_BIT |
                      RASTERIZATION_TEX_LOD_ENABLE_BIT |
                      RASTERIZATION_DETAIL_LOD_ENABLE_BIT |
                      RASTERIZATION_PERSPECTIVE_CORRECT_BIT |
                      RASTERIZATION_ALPHA_TEST_BIT);
        auto fmt = state.texture_fmt;
        auto siz = state.texture_size;
        state = {};
        state.flags = flags;
        state.texture_fmt = fmt;
        state.texture_size = siz;
        return state;
    }

    if ((state.flags & (RASTERIZATION_MULTI_CYCLE_BIT | RASTERIZATION_USES_PIPELINED_TEXEL1_BIT)) == 0)
        state.flags &= ~(RASTERIZATION_BILERP_1_BIT | RASTERIZATION_CONVERT_ONE_BIT);

    normalize_combiner(state.combiner[0]);
    normalize_combiner(state.combiner[1]);
    return state;
}

void RdpCpuParser::deduce_static_texture_state(unsigned tile, unsigned max_lod_level) {
    auto &state = static_raster_state;
    state.flags &= ~RASTERIZATION_USE_STATIC_TEXTURE_SIZE_FORMAT_BIT;
    state.texture_size = 0;
    state.texture_fmt  = 0;

    if ((state.flags & RASTERIZATION_FILL_BIT) != 0)
        return;

    auto fmt = tiles[tile].meta.fmt;
    auto siz = tiles[tile].meta.size;

    if ((state.flags & RASTERIZATION_COPY_BIT) == 0) {
        bool uses_texel0 = combiner_uses_texel0(state);
        bool uses_texel1 = combiner_uses_texel1(state);
        bool uses_pipelined_texel1 = combiner_uses_pipelined_texel1(state);
        bool uses_lod_frac_val = combiner_uses_lod_frac(state);

        if (uses_texel1 && (state.flags & RASTERIZATION_CONVERT_ONE_BIT) != 0)
            uses_texel0 = true;

        state.flags &= ~(RASTERIZATION_USES_TEXEL0_BIT |
                         RASTERIZATION_USES_TEXEL1_BIT |
                         RASTERIZATION_USES_PIPELINED_TEXEL1_BIT |
                         RASTERIZATION_USES_LOD_BIT);
        if (uses_texel0)            state.flags |= RASTERIZATION_USES_TEXEL0_BIT;
        if (uses_texel1)            state.flags |= RASTERIZATION_USES_TEXEL1_BIT;
        if (uses_pipelined_texel1)  state.flags |= RASTERIZATION_USES_PIPELINED_TEXEL1_BIT;
        if (uses_lod_frac_val || (state.flags & RASTERIZATION_TEX_LOD_ENABLE_BIT) != 0)
            state.flags |= RASTERIZATION_USES_LOD_BIT;

        if (!uses_texel0 && !uses_texel1 && !uses_pipelined_texel1)
            return;

        bool use_lod    = (state.flags & RASTERIZATION_TEX_LOD_ENABLE_BIT) != 0;
        bool use_detail = (state.flags & RASTERIZATION_DETAIL_LOD_ENABLE_BIT) != 0;

        bool uses_physical_texel1 = uses_texel1 &&
                                    ((state.flags & RASTERIZATION_CONVERT_ONE_BIT) == 0 ||
                                     (state.flags & RASTERIZATION_BILERP_1_BIT) != 0);

        if (!use_lod)
            max_lod_level = uses_physical_texel1 ? 1 : 0;
        if (use_detail)
            max_lod_level++;
        max_lod_level = std::min(max_lod_level, 7u);

        for (unsigned i = 1; i <= max_lod_level; i++) {
            auto &t = tiles[(tile + i) & 7].meta;
            if (t.fmt != fmt) return;
            if (t.size != siz) return;
        }
    }

    state.flags |= RASTERIZATION_USE_STATIC_TEXTURE_SIZE_FORMAT_BIT;
    state.texture_fmt  = uint32_t(fmt);
    state.texture_size = uint32_t(siz);
}

bool RdpCpuParser::need_flush() const {
    bool cache_full = static_raster_cache.full() ||
                      depth_blend_cache.full() ||
                      (tile_info_cache.size() + 8 > Limits::MaxTileInfoStates);
    bool tri_full = triangle_setup.full();
    bool span_full = (span_info_jobs.size() * ImplementationConstants::DefaultWorkgroupSize +
                      Limits::MaxHeight > Limits::MaxSpanSetups);
    return cache_full || tri_full || span_full;
}

// =========================================================================
// build_combiner_constants (mirror rdp_renderer.cpp)
// =========================================================================

void RdpCpuParser::build_combiner_constants(DerivedSetup &setup, unsigned cycle) const {
    auto &comb = static_raster_state.combiner[cycle];
    auto &output = setup.constants[cycle];

    // RGB muladd
    switch (comb.rgb.muladd) {
    case RGBMulAdd::Env:       encode_rgb(output.muladd, env_color); break;
    case RGBMulAdd::Primitive: encode_rgb(output.muladd, primitive_color); break;
    default: break;
    }
    // RGB mulsub
    switch (comb.rgb.mulsub) {
    case RGBMulSub::Env:       encode_rgb(output.mulsub, env_color); break;
    case RGBMulSub::Primitive: encode_rgb(output.mulsub, primitive_color); break;
    case RGBMulSub::ConvertK4: encode_rgb(output.mulsub, uint32_t(convert[4]) << 8); break;
    case RGBMulSub::KeyCenter:
        output.mulsub[0] = key_center[0];
        output.mulsub[1] = key_center[1];
        output.mulsub[2] = key_center[2];
        break;
    default: break;
    }
    // RGB mul
    switch (comb.rgb.mul) {
    case RGBMul::Primitive:      encode_rgb(output.mul, primitive_color); break;
    case RGBMul::Env:            encode_rgb(output.mul, env_color); break;
    case RGBMul::PrimitiveAlpha: encode_rgb(output.mul, 0x01010101u * (primitive_color & 0xff)); break;
    case RGBMul::EnvAlpha:       encode_rgb(output.mul, 0x01010101u * (env_color & 0xff)); break;
    case RGBMul::PrimLODFrac:    encode_rgb(output.mul, 0x01010101u * prim_lod_frac); break;
    case RGBMul::ConvertK5:      encode_rgb(output.mul, uint32_t(convert[5]) << 8); break;
    case RGBMul::KeyScale:
        output.mul[0] = key_scale[0];
        output.mul[1] = key_scale[1];
        output.mul[2] = key_scale[2];
        break;
    default: break;
    }
    // RGB add
    switch (comb.rgb.add) {
    case RGBAdd::Primitive: encode_rgb(output.add, primitive_color); break;
    case RGBAdd::Env:       encode_rgb(output.add, env_color); break;
    default: break;
    }
    // Alpha muladd
    switch (comb.alpha.muladd) {
    case AlphaAddSub::PrimitiveAlpha: encode_alpha(output.muladd, primitive_color); break;
    case AlphaAddSub::EnvAlpha:       encode_alpha(output.muladd, env_color); break;
    default: break;
    }
    // Alpha mulsub
    switch (comb.alpha.mulsub) {
    case AlphaAddSub::PrimitiveAlpha: encode_alpha(output.mulsub, primitive_color); break;
    case AlphaAddSub::EnvAlpha:       encode_alpha(output.mulsub, env_color); break;
    default: break;
    }
    // Alpha mul
    switch (comb.alpha.mul) {
    case AlphaMul::PrimitiveAlpha: encode_alpha(output.mul, primitive_color); break;
    case AlphaMul::EnvAlpha:       encode_alpha(output.mul, env_color); break;
    case AlphaMul::PrimLODFrac:    encode_alpha(output.mul, prim_lod_frac); break;
    default: break;
    }
    // Alpha add
    switch (comb.alpha.add) {
    case AlphaAddSub::PrimitiveAlpha: encode_alpha(output.add, primitive_color); break;
    case AlphaAddSub::EnvAlpha:       encode_alpha(output.add, env_color); break;
    default: break;
    }
}

// =========================================================================
// build_derived_attributes
// =========================================================================

DerivedSetup RdpCpuParser::build_derived_attributes(const AttributeSetup &attr) const {
    DerivedSetup setup = {};

    if (use_prim_depth) {
        setup.dz = prim_dz;
        setup.dz_compressed = dz_compress(setup.dz);
    } else {
        int dzdx = attr.dzdx >> 16;
        int dzdy = attr.dzdy >> 16;
        int dzpix = (dzdx < 0 ? (~dzdx & 0x7fff) : dzdx) +
                    (dzdy < 0 ? (~dzdy & 0x7fff) : dzdy);
        dzpix = normalize_dzpix(dzpix);
        setup.dz = dzpix;
        setup.dz_compressed = dz_compress(dzpix);
    }

    build_combiner_constants(setup, 0);
    build_combiner_constants(setup, 1);

    setup.fog_color[0]   = uint8_t(fog_color >> 24);
    setup.fog_color[1]   = uint8_t(fog_color >> 16);
    setup.fog_color[2]   = uint8_t(fog_color >> 8);
    setup.fog_color[3]   = uint8_t(fog_color >> 0);

    setup.blend_color[0] = uint8_t(blend_color >> 24);
    setup.blend_color[1] = uint8_t(blend_color >> 16);
    setup.blend_color[2] = uint8_t(blend_color >> 8);
    setup.blend_color[3] = uint8_t(blend_color >> 0);

    setup.fill_color = fill_color;
    setup.min_lod    = min_level;

    for (unsigned i = 0; i < 4; i++)
        setup.convert_factors[i] = int16_t(convert[i]);

    return setup;
}

// =========================================================================
// allocate_span_jobs
// =========================================================================

SpanInfoOffsets RdpCpuParser::allocate_span_jobs(const TriangleSetup &setup) {
    int min_active_sub = std::max(int(setup.yh), int(scissor_state.ylo));
    int min_active_line = min_active_sub >> 2;

    int max_active_sub = std::min(int(setup.yl) - 1, int(scissor_state.yhi) - 1);
    int max_active_line = max_active_sub >> 2;

    if (max_active_line < min_active_line)
        return { 0, 0, -1, 0 };

    int height = std::max(max_active_line - min_active_line + 2, 0);
    height = std::min(height, 1024);

    int num_jobs = (height + int(ImplementationConstants::DefaultWorkgroupSize) - 1) /
                   int(ImplementationConstants::DefaultWorkgroupSize);

    SpanInfoOffsets offsets = {};
    offsets.offset = uint32_t(span_info_jobs.size()) * ImplementationConstants::DefaultWorkgroupSize;
    offsets.ylo = min_active_line;
    offsets.yhi = max_active_line;

    for (int i = 0; i < num_jobs; i++) {
        SpanInterpolationJob job = {};
        job.primitive_index = uint16_t(triangle_setup.size());
        job.base_y = uint16_t(min_active_line + ImplementationConstants::DefaultWorkgroupSize * i);
        job.max_y  = uint16_t(max_active_line + 1);
        span_info_jobs.add(job);
    }
    return offsets;
}

// =========================================================================
// draw_shaded_primitive / draw_flat_primitive
// =========================================================================

void RdpCpuParser::draw_shaded_primitive(TriangleSetup &setup, const AttributeSetup &attr) {
    fixup_triangle_setup(setup);

    span_info_offsets.add(allocate_span_jobs(setup));
    triangle_setup.add(setup);

    if (use_prim_depth) {
        auto tmp = attr;
        tmp.z    = prim_depth;
        tmp.dzdx = 0;
        tmp.dzde = 0;
        tmp.dzdy = 0;
        attribute_setup.add(tmp);
    } else {
        attribute_setup.add(attr);
    }

    derived_setup.add(build_derived_attributes(attr));
    scissor_setup.add(scissor_state);

    deduce_static_texture_state(setup.tile & 7, setup.tile >> 3);
    deduce_noise_state();

    InstanceIndices indices = {};
    indices.static_index       = uint8_t(static_raster_cache.add(normalize_static_state(static_raster_state)));
    indices.depth_blend_index  = uint8_t(depth_blend_cache.add(depth_blend_state));
    indices.tile_instance_index = uint8_t(tmem_upload_count);
    for (unsigned i = 0; i < 8; i++)
        indices.tile_indices[i] = uint8_t(tile_info_cache.add(tiles[i]));
    state_indices.add(indices);
}

void RdpCpuParser::draw_flat_primitive(TriangleSetup &setup) {
    draw_shaded_primitive(setup, {});
}

// =========================================================================
// parseCommand — main RDP command dispatch
// =========================================================================

void RdpCpuParser::parseCommand(const uint32_t *words) {
    uint32_t code = (words[0] >> 24) & 63;

    switch (code) {

    // ---- Triangles ----
    case 0x08: { // FillTriangle
        TriangleSetup setup = {};
        decode_triangle_setup(setup, words);
        draw_flat_primitive(setup);
        break;
    }
    case 0x09: { // FillZBufferTriangle
        TriangleSetup setup = {};
        AttributeSetup attr = {};
        decode_triangle_setup(setup, words);
        decode_z_setup(attr, words + 8);
        draw_shaded_primitive(setup, attr);
        break;
    }
    case 0x0a: { // TextureTriangle
        TriangleSetup setup = {};
        AttributeSetup attr = {};
        decode_triangle_setup(setup, words);
        decode_tex_setup(attr, words + 8);
        draw_shaded_primitive(setup, attr);
        break;
    }
    case 0x0b: { // TextureZBufferTriangle
        TriangleSetup setup = {};
        AttributeSetup attr = {};
        decode_triangle_setup(setup, words);
        decode_tex_setup(attr, words + 8);
        decode_z_setup(attr, words + 24);
        draw_shaded_primitive(setup, attr);
        break;
    }
    case 0x0c: { // ShadeTriangle
        TriangleSetup setup = {};
        AttributeSetup attr = {};
        decode_triangle_setup(setup, words);
        decode_rgba_setup(attr, words + 8);
        draw_shaded_primitive(setup, attr);
        break;
    }
    case 0x0d: { // ShadeZBufferTriangle
        TriangleSetup setup = {};
        AttributeSetup attr = {};
        decode_triangle_setup(setup, words);
        decode_rgba_setup(attr, words + 8);
        decode_z_setup(attr, words + 24);
        draw_shaded_primitive(setup, attr);
        break;
    }
    case 0x0e: { // ShadeTextureTriangle
        TriangleSetup setup = {};
        AttributeSetup attr = {};
        decode_triangle_setup(setup, words);
        decode_rgba_setup(attr, words + 8);
        decode_tex_setup(attr, words + 24);
        draw_shaded_primitive(setup, attr);
        break;
    }
    case 0x0f: { // ShadeTextureZBufferTriangle
        TriangleSetup setup = {};
        AttributeSetup attr = {};
        decode_triangle_setup(setup, words);
        decode_rgba_setup(attr, words + 8);
        decode_tex_setup(attr, words + 24);
        decode_z_setup(attr, words + 40);
        draw_shaded_primitive(setup, attr);
        break;
    }

    // ---- Rectangles ----
    case 0x24: { // TextureRectangle
        uint32_t xl = (words[0] >> 12) & 0xfff;
        uint32_t yl = (words[0] >> 0)  & 0xfff;
        uint32_t xh = (words[1] >> 12) & 0xfff;
        uint32_t yh = (words[1] >> 0)  & 0xfff;
        uint32_t tile = (words[1] >> 24) & 0x7;

        int32_t s    = (words[2] >> 16) & 0xffff;
        int32_t t    = (words[2] >> 0)  & 0xffff;
        int32_t dsdx = (words[3] >> 16) & 0xffff;
        int32_t dtdy = (words[3] >> 0)  & 0xffff;
        dsdx = sext<16>(dsdx);
        dtdy = sext<16>(dtdy);

        if ((static_raster_state.flags & (RASTERIZATION_COPY_BIT | RASTERIZATION_FILL_BIT)) != 0)
            yl |= 3;

        TriangleSetup setup = {};
        AttributeSetup attr = {};
        setup.xh = xh << 13;
        setup.xl = xl << 13;
        setup.xm = xl << 13;
        setup.ym = yl;
        setup.yl = yl;
        setup.yh = yh;
        setup.flags = TRIANGLE_SETUP_FLIP_BIT | TRIANGLE_SETUP_DISABLE_UPSCALING_BIT;
        setup.tile = tile;

        attr.s    = s << 16;
        attr.t    = t << 16;
        attr.dsdx = dsdx << 11;
        attr.dtde = dtdy << 11;
        attr.dtdy = dtdy << 11;

        if ((static_raster_state.flags & RASTERIZATION_COPY_BIT) != 0)
            setup.flags |= TRIANGLE_SETUP_SKIP_XFRAC_BIT;

        draw_shaded_primitive(setup, attr);
        break;
    }
    case 0x25: { // TextureRectangleFlip
        uint32_t xl = (words[0] >> 12) & 0xfff;
        uint32_t yl = (words[0] >> 0)  & 0xfff;
        uint32_t xh = (words[1] >> 12) & 0xfff;
        uint32_t yh = (words[1] >> 0)  & 0xfff;
        uint32_t tile = (words[1] >> 24) & 0x7;

        int32_t s    = (words[2] >> 16) & 0xffff;
        int32_t t    = (words[2] >> 0)  & 0xffff;
        int32_t dsdx = (words[3] >> 16) & 0xffff;
        int32_t dtdy = (words[3] >> 0)  & 0xffff;
        dsdx = sext<16>(dsdx);
        dtdy = sext<16>(dtdy);

        if ((static_raster_state.flags & (RASTERIZATION_COPY_BIT | RASTERIZATION_FILL_BIT)) != 0)
            yl |= 3;

        TriangleSetup setup = {};
        AttributeSetup attr = {};
        setup.xh = xh << 13;
        setup.xl = xl << 13;
        setup.xm = xl << 13;
        setup.ym = yl;
        setup.yl = yl;
        setup.yh = yh;
        setup.flags = TRIANGLE_SETUP_FLIP_BIT | TRIANGLE_SETUP_DISABLE_UPSCALING_BIT;
        setup.tile = tile;

        attr.s    = s << 16;
        attr.t    = t << 16;
        attr.dtdx = dtdy << 11;
        attr.dsde = dsdx << 11;
        attr.dsdy = dsdx << 11;

        if ((static_raster_state.flags & RASTERIZATION_COPY_BIT) != 0)
            setup.flags |= TRIANGLE_SETUP_SKIP_XFRAC_BIT;

        draw_shaded_primitive(setup, attr);
        break;
    }
    case 0x36: { // FillRectangle
        uint32_t xl = (words[0] >> 12) & 0xfff;
        uint32_t yl = (words[0] >> 0)  & 0xfff;
        uint32_t xh = (words[1] >> 12) & 0xfff;
        uint32_t yh = (words[1] >> 0)  & 0xfff;

        if ((static_raster_state.flags & (RASTERIZATION_COPY_BIT | RASTERIZATION_FILL_BIT)) != 0)
            yl |= 3;

        TriangleSetup setup = {};
        setup.xh    = xh << 13;
        setup.xl    = xl << 13;
        setup.xm    = xl << 13;
        setup.ym    = yl;
        setup.yl    = yl;
        setup.yh    = yh;
        setup.flags = TRIANGLE_SETUP_FLIP_BIT | TRIANGLE_SETUP_DISABLE_UPSCALING_BIT;
        draw_flat_primitive(setup);
        break;
    }

    // ---- Scissor ----
    case 0x2d: { // SetScissor
        scissor_state.xlo = (words[0] >> 12) & 0xfff;
        scissor_state.xhi = (words[1] >> 12) & 0xfff;
        scissor_state.ylo = (words[0] >> 0)  & 0xfff;
        scissor_state.yhi = (words[1] >> 0)  & 0xfff;
        STATE_MASK(static_raster_state.flags, bool(words[1] & (1 << 25)), RASTERIZATION_INTERLACE_FIELD_BIT);
        STATE_MASK(static_raster_state.flags, bool(words[1] & (1 << 24)), RASTERIZATION_INTERLACE_KEEP_ODD_BIT);
        break;
    }

    // ---- SetOtherModes ----
    case 0x2f: {
        STATE_MASK(static_raster_state.flags, bool(words[0] & (1 << 19)), RASTERIZATION_PERSPECTIVE_CORRECT_BIT);
        STATE_MASK(static_raster_state.flags, bool(words[0] & (1 << 18)), RASTERIZATION_DETAIL_LOD_ENABLE_BIT);
        STATE_MASK(static_raster_state.flags, bool(words[0] & (1 << 17)), RASTERIZATION_SHARPEN_LOD_ENABLE_BIT);
        STATE_MASK(static_raster_state.flags, bool(words[0] & (1 << 16)), RASTERIZATION_TEX_LOD_ENABLE_BIT);
        STATE_MASK(static_raster_state.flags, bool(words[0] & (1 << 15)), RASTERIZATION_TLUT_BIT);
        STATE_MASK(static_raster_state.flags, bool(words[0] & (1 << 14)), RASTERIZATION_TLUT_TYPE_BIT);
        STATE_MASK(static_raster_state.flags, bool(words[0] & (1 << 13)), RASTERIZATION_SAMPLE_MODE_BIT);
        STATE_MASK(static_raster_state.flags, bool(words[0] & (1 << 12)), RASTERIZATION_SAMPLE_MID_TEXEL_BIT);
        STATE_MASK(static_raster_state.flags, bool(words[0] & (1 << 11)), RASTERIZATION_BILERP_0_BIT);
        STATE_MASK(static_raster_state.flags, bool(words[0] & (1 << 10)), RASTERIZATION_BILERP_1_BIT);
        STATE_MASK(static_raster_state.flags, bool(words[0] & (1 << 9)),  RASTERIZATION_CONVERT_ONE_BIT);

        STATE_MASK(depth_blend_state.flags, bool(words[1] & (1 << 14)), DEPTH_BLEND_FORCE_BLEND_BIT);
        STATE_MASK(static_raster_state.flags, bool(words[1] & (1 << 13)), RASTERIZATION_ALPHA_CVG_SELECT_BIT);
        STATE_MASK(static_raster_state.flags, bool(words[1] & (1 << 12)), RASTERIZATION_CVG_TIMES_ALPHA_BIT);
        STATE_MASK(depth_blend_state.flags, bool(words[1] & (1 << 7)),  DEPTH_BLEND_COLOR_ON_COVERAGE_BIT);
        STATE_MASK(depth_blend_state.flags, bool(words[1] & (1 << 6)),  DEPTH_BLEND_IMAGE_READ_ENABLE_BIT);
        STATE_MASK(depth_blend_state.flags, bool(words[1] & (1 << 5)),  DEPTH_BLEND_DEPTH_UPDATE_BIT);
        STATE_MASK(depth_blend_state.flags, bool(words[1] & (1 << 4)),  DEPTH_BLEND_DEPTH_TEST_BIT);
        STATE_MASK(static_raster_state.flags, bool(words[1] & (1 << 3)), RASTERIZATION_AA_BIT);
        STATE_MASK(depth_blend_state.flags, bool(words[1] & (1 << 3)),  DEPTH_BLEND_AA_BIT);
        STATE_MASK(static_raster_state.flags, bool(words[1] & (1 << 1)), RASTERIZATION_ALPHA_TEST_DITHER_BIT);
        STATE_MASK(static_raster_state.flags, bool(words[1] & (1 << 0)), RASTERIZATION_ALPHA_TEST_BIT);

        static_raster_state.dither = (words[0] >> 4) & 0x0f;
        STATE_MASK(depth_blend_state.flags,
                   RGBDitherMode(static_raster_state.dither >> 2) != RGBDitherMode::Off,
                   DEPTH_BLEND_DITHER_ENABLE_BIT);

        depth_blend_state.coverage_mode = static_cast<CoverageMode>((words[1] >> 8) & 3);
        depth_blend_state.z_mode        = static_cast<ZMode>((words[1] >> 10) & 3);

        static_raster_state.flags &= ~(RASTERIZATION_MULTI_CYCLE_BIT |
                                        RASTERIZATION_FILL_BIT |
                                        RASTERIZATION_COPY_BIT);
        depth_blend_state.flags &= ~DEPTH_BLEND_MULTI_CYCLE_BIT;

        switch (CycleType((words[0] >> 20) & 3)) {
        case CycleType::Cycle2:
            static_raster_state.flags |= RASTERIZATION_MULTI_CYCLE_BIT;
            depth_blend_state.flags   |= DEPTH_BLEND_MULTI_CYCLE_BIT;
            break;
        case CycleType::Fill:
            static_raster_state.flags |= RASTERIZATION_FILL_BIT;
            break;
        case CycleType::Copy:
            static_raster_state.flags |= RASTERIZATION_COPY_BIT;
            break;
        default:
            break;
        }

        depth_blend_state.blend_cycles[0].blend_1a = static_cast<BlendMode1A>((words[1] >> 30) & 3);
        depth_blend_state.blend_cycles[1].blend_1a = static_cast<BlendMode1A>((words[1] >> 28) & 3);
        depth_blend_state.blend_cycles[0].blend_1b = static_cast<BlendMode1B>((words[1] >> 26) & 3);
        depth_blend_state.blend_cycles[1].blend_1b = static_cast<BlendMode1B>((words[1] >> 24) & 3);
        depth_blend_state.blend_cycles[0].blend_2a = static_cast<BlendMode2A>((words[1] >> 22) & 3);
        depth_blend_state.blend_cycles[1].blend_2a = static_cast<BlendMode2A>((words[1] >> 20) & 3);
        depth_blend_state.blend_cycles[0].blend_2b = static_cast<BlendMode2B>((words[1] >> 18) & 3);
        depth_blend_state.blend_cycles[1].blend_2b = static_cast<BlendMode2B>((words[1] >> 16) & 3);

        use_prim_depth = bool(words[1] & (1 << 2));
        break;
    }

    // ---- SetCombine ----
    case 0x3c: {
        static_raster_state.combiner[0].rgb.muladd = static_cast<RGBMulAdd>((words[0] >> 20) & 0xf);
        static_raster_state.combiner[0].rgb.mul    = static_cast<RGBMul>((words[0] >> 15) & 0x1f);
        static_raster_state.combiner[0].rgb.mulsub = static_cast<RGBMulSub>((words[1] >> 28) & 0xf);
        static_raster_state.combiner[0].rgb.add    = static_cast<RGBAdd>((words[1] >> 15) & 0x7);

        static_raster_state.combiner[0].alpha.muladd = static_cast<AlphaAddSub>((words[0] >> 12) & 0x7);
        static_raster_state.combiner[0].alpha.mulsub = static_cast<AlphaAddSub>((words[1] >> 12) & 0x7);
        static_raster_state.combiner[0].alpha.mul    = static_cast<AlphaMul>((words[0] >> 9) & 0x7);
        static_raster_state.combiner[0].alpha.add    = static_cast<AlphaAddSub>((words[1] >> 9) & 0x7);

        static_raster_state.combiner[1].rgb.muladd = static_cast<RGBMulAdd>((words[0] >> 5) & 0xf);
        static_raster_state.combiner[1].rgb.mul    = static_cast<RGBMul>((words[0] >> 0) & 0x1f);
        static_raster_state.combiner[1].rgb.mulsub = static_cast<RGBMulSub>((words[1] >> 24) & 0xf);
        static_raster_state.combiner[1].rgb.add    = static_cast<RGBAdd>((words[1] >> 6) & 0x7);

        static_raster_state.combiner[1].alpha.muladd = static_cast<AlphaAddSub>((words[1] >> 21) & 0x7);
        static_raster_state.combiner[1].alpha.mulsub = static_cast<AlphaAddSub>((words[1] >> 3) & 0x7);
        static_raster_state.combiner[1].alpha.mul    = static_cast<AlphaMul>((words[1] >> 18) & 0x7);
        static_raster_state.combiner[1].alpha.add    = static_cast<AlphaAddSub>((words[1] >> 0) & 0x7);
        break;
    }

    // ---- Tile commands ----
    case 0x35: { // SetTile
        uint32_t tile = (words[1] >> 24) & 7;
        TileMeta info = {};
        info.offset  = ((words[0] >> 0) & 511) << 3;
        info.stride  = ((words[0] >> 9) & 511) << 3;
        info.size    = TextureSize((words[0] >> 19) & 3);
        info.fmt     = TextureFormat((words[0] >> 21) & 7);
        info.palette = (words[1] >> 20) & 15;
        info.shift_s = (words[1] >> 0) & 15;
        info.mask_s  = (words[1] >> 4) & 15;
        info.shift_t = (words[1] >> 10) & 15;
        info.mask_t  = (words[1] >> 14) & 15;

        if (words[1] & (1 << 8))  info.flags |= TILE_INFO_MIRROR_S_BIT;
        if (words[1] & (1 << 9))  info.flags |= TILE_INFO_CLAMP_S_BIT;
        if (words[1] & (1 << 18)) info.flags |= TILE_INFO_MIRROR_T_BIT;
        if (words[1] & (1 << 19)) info.flags |= TILE_INFO_CLAMP_T_BIT;

        if (info.mask_s > 10)     info.mask_s = 10;
        else if (info.mask_s == 0) info.flags |= TILE_INFO_CLAMP_S_BIT;
        if (info.mask_t > 10)     info.mask_t = 10;
        else if (info.mask_t == 0) info.flags |= TILE_INFO_CLAMP_T_BIT;

        tiles[tile].meta = info;
        break;
    }
    case 0x32: { // SetTileSize
        uint32_t tile = (words[1] >> 24) & 7;
        tiles[tile].size.slo = (words[0] >> 12) & 0xfff;
        tiles[tile].size.shi = (words[1] >> 12) & 0xfff;
        tiles[tile].size.tlo = (words[0] >> 0)  & 0xfff;
        tiles[tile].size.thi = (words[1] >> 0)  & 0xfff;
        break;
    }
    case 0x34: // LoadTile
    case 0x30: // LoadTLUT
    case 0x33: // LoadBlock
        // Count TMEM uploads for tile_instance_index tracking.
        // Actual TMEM simulation is not implemented yet — the GPU will
        // use stale TMEM contents, which is acceptable for initial bringup.
        tmem_upload_count++;
        break;

    // ---- Texture image register ----
    case 0x3d: { // SetTextureImage
        tex_fmt   = TextureFormat((words[0] >> 21) & 7);
        tex_size  = TextureSize((words[0] >> 19) & 3);
        tex_width = (words[0] & 0x3ff) + 1;
        tex_addr  = words[1] & 0x00ffffffu;
        break;
    }

    // ---- Color registers ----
    case 0x39: blend_color     = words[1]; break;  // SetBlendColor
    case 0x3b: env_color       = words[1]; break;  // SetEnvColor
    case 0x38: fog_color       = words[1]; break;  // SetFogColor
    case 0x37: fill_color      = words[1]; break;  // SetFillColor

    case 0x3a: { // SetPrimColor
        min_level     = (words[0] >> 8) & 31;
        prim_lod_frac = (words[0] >> 0) & 0xff;
        primitive_color = words[1];
        break;
    }
    case 0x2e: { // SetPrimDepth
        prim_depth = int32_t((words[1] >> 16) & 0x7fff) << 16;
        prim_dz    = words[1] & 0xffff;
        break;
    }
    case 0x2c: { // SetConvert
        uint64_t merged = (uint64_t(words[0]) << 32) | words[1];
        uint16_t k5 = (merged >> 0)  & 0x1ff;
        uint16_t k4 = (merged >> 9)  & 0x1ff;
        uint16_t k3 = (merged >> 18) & 0x1ff;
        uint16_t k2 = (merged >> 27) & 0x1ff;
        uint16_t k1 = (merged >> 36) & 0x1ff;
        uint16_t k0 = (merged >> 45) & 0x1ff;
        convert[0] = 2 * sext<9>(k0) + 1;
        convert[1] = 2 * sext<9>(k1) + 1;
        convert[2] = 2 * sext<9>(k2) + 1;
        convert[3] = 2 * sext<9>(k3) + 1;
        convert[4] = k4;
        convert[5] = k5;
        break;
    }
    case 0x2a: { // SetKeyGB
        uint32_t g_width  = (words[0] >> 12) & 0xfff;
        uint32_t b_width  = (words[0] >> 0)  & 0xfff;
        uint32_t g_center = (words[1] >> 24) & 0xff;
        uint32_t g_scale  = (words[1] >> 16) & 0xff;
        uint32_t b_center = (words[1] >> 8)  & 0xff;
        uint32_t b_scale  = (words[1] >> 0)  & 0xff;
        key_width[1]  = g_width;  key_center[1] = g_center; key_scale[1] = g_scale;
        key_width[2]  = b_width;  key_center[2] = b_center; key_scale[2] = b_scale;
        break;
    }
    case 0x2b: { // SetKeyR
        uint32_t r_width  = (words[1] >> 16) & 0xfff;
        uint32_t r_center = (words[1] >> 8)  & 0xff;
        uint32_t r_scale  = (words[1] >> 0)  & 0xff;
        key_width[0]  = r_width;  key_center[0] = r_center; key_scale[0] = r_scale;
        break;
    }

    // ---- Framebuffer (also handled by webgpu-rdp.cpp's parseRdpCommand) ----
    case 0x3f: // SetColorImage — no-op here; webgpu-rdp.cpp tracks fb state
    case 0x3e: // SetMaskImage
        break;

    // ---- Sync / Nop ----
    case 0x26: // SyncLoad
    case 0x27: // SyncPipe
    case 0x28: // SyncTile
    case 0x29: // SyncFull — handled by webgpu-rdp.cpp caller
    default:
        break;
    }
}

} // namespace Web
