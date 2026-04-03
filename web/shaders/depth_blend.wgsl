struct DerivedSetup {
    constant_muladd0_: vec4<i32>,
    constant_mulsub0_: vec4<i32>,
    constant_mul0_: vec4<i32>,
    constant_add0_: vec4<i32>,
    constant_muladd1_: vec4<i32>,
    constant_mulsub1_: vec4<i32>,
    constant_mul1_: vec4<i32>,
    constant_add1_: vec4<i32>,
    fog_color: vec4<i32>,
    blend_color: vec4<i32>,
    fill_color: u32,
    dz: i32,
    dz_compressed: i32,
    min_lod: i32,
    factors: vec4<i32>,
}

struct DepthBlendState {
    blend_modes0_: vec4<i32>,
    blend_modes1_: vec4<i32>,
    flags: u32,
    coverage_mode: i32,
    z_mode: i32,
    padding0_: i32,
    padding1_: i32,
}

struct BlendInputs {
    pixel_color: vec4<i32>,
    memory_color: vec4<i32>,
    fog_color: vec4<i32>,
    blend_color: vec4<i32>,
    shade_alpha: i32,
}

struct ShadedData {
    combined: vec4<i32>,
    z_dith: i32,
    coverage_count: i32,
    shade_alpha: i32,
}

struct DerivedSetupBuffer {
    derived_setup_raw: array<u32>,
}

struct DepthBlendStateBuffer {
    depth_blend_state_raw: array<u32>,
}

struct VRAM8_ {
    data: array<u32>,
}

struct HiddenVRAM {
    data: array<u32>,
}

struct StateIndicesBuffer {
    state_indices_raw: array<u32>,
}

struct TileBinningCoarse {
    elems: array<u32>,
}

struct TileInstanceOffset {
    elems: array<u32>,
}

struct TileBinning {
    elems: array<u32>,
}

struct Coverage {
    elems: array<u32>,
}

struct ColorRawBuffer {
    elems: array<u32>,
}

struct DepthBuffer {
    elems: array<i32>,
}

struct ShadeAlpha {
    elems: array<u32>,
}

struct Registers {
    fb_addr_index: u32,
    fb_depth_addr_index: u32,
    fb_width: u32,
    fb_height: u32,
    group_mask: u32,
}

struct UBLENDERDIVIDERLUT_BUF {
    uBlenderDividerLUT_raw: array<vec4<u32>>,
}

@group(1) @binding(2) 
var<storage, read_write> derived_setup: DerivedSetupBuffer;
@group(1) @binding(5) 
var<storage, read_write> depth_blend_state: DepthBlendStateBuffer;
@group(0) @binding(0) 
var<storage, read_write> vram8_: VRAM8_;
@group(0) @binding(1) 
var<storage, read_write> hidden_vram: HiddenVRAM;
@group(1) @binding(6) 
var<storage, read_write> state_indices: StateIndicesBuffer;
@group(1) @binding(12) 
var<storage, read_write> tile_binning_coarse: TileBinningCoarse;
@group(0) @binding(7) 
var<storage, read_write> tile_instance_offsets: TileInstanceOffset;
@group(1) @binding(11) 
var<storage, read_write> tile_binning: TileBinning;
@group(0) @binding(6) 
var<storage, read_write> coverage: Coverage;
@group(0) @binding(3) 
var<storage, read_write> raw_color: ColorRawBuffer;
@group(0) @binding(4) 
var<storage, read_write> depth: DepthBuffer;
@group(0) @binding(5) 
var<storage, read_write> shade_alpha: ShadeAlpha;
@group(2) @binding(0) 
var<uniform> registers: Registers;
@group(1) @binding(10) 
var<storage> uBlenderDividerLUT_blk: UBLENDERDIVIDERLUT_BUF;
var<private> seeded_noise: i32;
var<private> current_color: vec4<i32>;
var<private> current_dz: i32;
var<private> current_depth: i32;
var<private> current_color_dirty: bool;
var<private> current_depth_dirty: bool;
var<private> color_fb_index: u32;
var<private> gl_GlobalInvocationID_1: vec3<u32>;
var<private> gl_WorkGroupID_1: vec3<u32>;
var<private> gl_LocalInvocationIndex_1: u32;

fn load_vram_color(index: ptr<function, u32>, slice: u32) {
    var slice_1: u32;
    var word: i32;

    slice_1 = slice;
    let _e60 = (*index);
    (*index) = (_e60 & 8388607u);
    let _e63 = (*index);
    let _e64 = slice_1;
    (*index) = (_e63 + (_e64 * 8388608u));
    let _e68 = (*index);
    let _e75 = vram8_.data[((_e68 ^ 3u) >> 2u)];
    let _e76 = (*index);
    word = i32(((_e75 >> (((_e76 ^ 3u) & 3u) * 8u)) & 255u));
    let _e88 = word;
    let _e89 = word;
    let _e90 = word;
    let _e91 = (*index);
    let _e99 = hidden_vram.data[((_e91 >> 1u) >> 2u)];
    let _e100 = (*index);
    current_color = vec4<i32>(_e88, _e89, _e90, i32(((_e99 >> (((_e100 >> 1u) & 3u) * 8u)) & 255u)));
    return;
}

fn load_vram_depth(index_1: ptr<function, u32>, slice_2: u32) {
    var slice_3: u32;
    var word_1: i32;

    slice_3 = slice_2;
    let _e60 = (*index_1);
    (*index_1) = (_e60 & 4194303u);
    let _e63 = (*index_1);
    let _e64 = slice_3;
    (*index_1) = (_e63 + (_e64 * 4194304u));
    let _e68 = (*index_1);
    let _e75 = vram8_.data[((_e68 ^ 1u) >> 1u)];
    let _e76 = (*index_1);
    word_1 = i32(((_e75 >> (((_e76 ^ 1u) & 1u) * 16u)) & 65535u));
    let _e88 = word_1;
    current_depth = (_e88 >> 2u);
    let _e92 = (*index_1);
    let _e97 = hidden_vram.data[(_e92 >> 2u)];
    let _e98 = (*index_1);
    let _e107 = word_1;
    current_dz = (i32(((_e97 >> ((_e98 & 3u) * 8u)) & 255u)) | ((_e107 & 3i) << 2u));
    return;
}

fn init_tile(coord: ptr<function, vec2<u32>>, fb_width: u32, fb_height: u32, fb_addr_index: u32, fb_depth_addr_index: u32) {
    var fb_width_1: u32;
    var fb_height_1: u32;
    var fb_addr_index_1: u32;
    var fb_depth_addr_index_1: u32;
    var slice2d: vec2<u32>;
    var slice_4: u32;
    var index_2: u32;
    var param: u32;
    var param_1_: u32;
    var param_2_: u32;
    var param_3_: u32;

    fb_width_1 = fb_width;
    fb_height_1 = fb_height;
    fb_addr_index_1 = fb_addr_index;
    fb_depth_addr_index_1 = fb_depth_addr_index;
    current_color_dirty = false;
    current_depth_dirty = false;
    let _e68 = (*coord);
    let _e69 = fb_width_1;
    let _e70 = fb_height_1;
    if all((_e68 < vec2<u32>(_e69, _e70))) {
        {
            let _e74 = (*coord);
            slice2d = (_e74 & vec2(0u));
            let _e79 = (*coord);
            (*coord) = (_e79 >> vec2(0u));
            let _e85 = slice2d;
            let _e89 = slice2d;
            slice_4 = ((_e85.y * 1u) + _e89.x);
            let _e93 = fb_addr_index_1;
            let _e94 = fb_width_1;
            let _e98 = (*coord);
            let _e102 = (*coord);
            index_2 = ((_e93 + ((_e94 >> 0u) * _e98.y)) + _e102.x);
            let _e106 = index_2;
            color_fb_index = _e106;
            let _e107 = index_2;
            param = _e107;
            let _e109 = slice_4;
            param_1_ = _e109;
            let _e112 = param_1_;
            load_vram_color((&param), _e112);
            let _e114 = fb_depth_addr_index_1;
            let _e115 = fb_width_1;
            let _e119 = (*coord);
            let _e123 = (*coord);
            index_2 = ((_e114 + ((_e115 >> 0u) * _e119.y)) + _e123.x);
            let _e126 = index_2;
            param_2_ = _e126;
            let _e128 = slice_4;
            param_3_ = _e128;
            let _e131 = param_3_;
            load_vram_depth((&param_2_), _e131);
            return;
        }
    } else {
        return;
    }
}

fn load_derived_setup(index_3: u32) -> DerivedSetup {
    var index_4: u32;

    index_4 = index_3;
    let _e59 = index_4;
    let _e66 = derived_setup.derived_setup_raw[((_e59 * 14u) + 0u)];
    let _e69 = index_4;
    let _e76 = derived_setup.derived_setup_raw[((_e69 * 14u) + 0u)];
    let _e81 = index_4;
    let _e88 = derived_setup.derived_setup_raw[((_e81 * 14u) + 0u)];
    let _e93 = index_4;
    let _e100 = derived_setup.derived_setup_raw[((_e93 * 14u) + 0u)];
    let _e105 = index_4;
    let _e112 = derived_setup.derived_setup_raw[((_e105 * 14u) + 1u)];
    let _e115 = index_4;
    let _e122 = derived_setup.derived_setup_raw[((_e115 * 14u) + 1u)];
    let _e127 = index_4;
    let _e134 = derived_setup.derived_setup_raw[((_e127 * 14u) + 1u)];
    let _e139 = index_4;
    let _e146 = derived_setup.derived_setup_raw[((_e139 * 14u) + 1u)];
    let _e151 = index_4;
    let _e158 = derived_setup.derived_setup_raw[((_e151 * 14u) + 2u)];
    let _e161 = index_4;
    let _e168 = derived_setup.derived_setup_raw[((_e161 * 14u) + 2u)];
    let _e173 = index_4;
    let _e180 = derived_setup.derived_setup_raw[((_e173 * 14u) + 2u)];
    let _e185 = index_4;
    let _e192 = derived_setup.derived_setup_raw[((_e185 * 14u) + 2u)];
    let _e197 = index_4;
    let _e204 = derived_setup.derived_setup_raw[((_e197 * 14u) + 3u)];
    let _e207 = index_4;
    let _e214 = derived_setup.derived_setup_raw[((_e207 * 14u) + 3u)];
    let _e219 = index_4;
    let _e226 = derived_setup.derived_setup_raw[((_e219 * 14u) + 3u)];
    let _e231 = index_4;
    let _e238 = derived_setup.derived_setup_raw[((_e231 * 14u) + 3u)];
    let _e243 = index_4;
    let _e250 = derived_setup.derived_setup_raw[((_e243 * 14u) + 4u)];
    let _e253 = index_4;
    let _e260 = derived_setup.derived_setup_raw[((_e253 * 14u) + 4u)];
    let _e265 = index_4;
    let _e272 = derived_setup.derived_setup_raw[((_e265 * 14u) + 4u)];
    let _e277 = index_4;
    let _e284 = derived_setup.derived_setup_raw[((_e277 * 14u) + 4u)];
    let _e289 = index_4;
    let _e296 = derived_setup.derived_setup_raw[((_e289 * 14u) + 5u)];
    let _e299 = index_4;
    let _e306 = derived_setup.derived_setup_raw[((_e299 * 14u) + 5u)];
    let _e311 = index_4;
    let _e318 = derived_setup.derived_setup_raw[((_e311 * 14u) + 5u)];
    let _e323 = index_4;
    let _e330 = derived_setup.derived_setup_raw[((_e323 * 14u) + 5u)];
    let _e335 = index_4;
    let _e342 = derived_setup.derived_setup_raw[((_e335 * 14u) + 6u)];
    let _e345 = index_4;
    let _e352 = derived_setup.derived_setup_raw[((_e345 * 14u) + 6u)];
    let _e357 = index_4;
    let _e364 = derived_setup.derived_setup_raw[((_e357 * 14u) + 6u)];
    let _e369 = index_4;
    let _e376 = derived_setup.derived_setup_raw[((_e369 * 14u) + 6u)];
    let _e381 = index_4;
    let _e388 = derived_setup.derived_setup_raw[((_e381 * 14u) + 7u)];
    let _e391 = index_4;
    let _e398 = derived_setup.derived_setup_raw[((_e391 * 14u) + 7u)];
    let _e403 = index_4;
    let _e410 = derived_setup.derived_setup_raw[((_e403 * 14u) + 7u)];
    let _e415 = index_4;
    let _e422 = derived_setup.derived_setup_raw[((_e415 * 14u) + 7u)];
    let _e427 = index_4;
    let _e434 = derived_setup.derived_setup_raw[((_e427 * 14u) + 8u)];
    let _e437 = index_4;
    let _e444 = derived_setup.derived_setup_raw[((_e437 * 14u) + 8u)];
    let _e449 = index_4;
    let _e456 = derived_setup.derived_setup_raw[((_e449 * 14u) + 8u)];
    let _e461 = index_4;
    let _e468 = derived_setup.derived_setup_raw[((_e461 * 14u) + 8u)];
    let _e473 = index_4;
    let _e480 = derived_setup.derived_setup_raw[((_e473 * 14u) + 9u)];
    let _e483 = index_4;
    let _e490 = derived_setup.derived_setup_raw[((_e483 * 14u) + 9u)];
    let _e495 = index_4;
    let _e502 = derived_setup.derived_setup_raw[((_e495 * 14u) + 9u)];
    let _e507 = index_4;
    let _e514 = derived_setup.derived_setup_raw[((_e507 * 14u) + 9u)];
    let _e519 = index_4;
    let _e526 = derived_setup.derived_setup_raw[((_e519 * 14u) + 10u)];
    let _e527 = index_4;
    let _e534 = derived_setup.derived_setup_raw[((_e527 * 14u) + 11u)];
    let _e538 = index_4;
    let _e545 = derived_setup.derived_setup_raw[((_e538 * 14u) + 11u)];
    let _e551 = index_4;
    let _e558 = derived_setup.derived_setup_raw[((_e551 * 14u) + 11u)];
    let _e564 = index_4;
    let _e571 = derived_setup.derived_setup_raw[((_e564 * 14u) + 12u)];
    let _e579 = index_4;
    let _e586 = derived_setup.derived_setup_raw[((_e579 * 14u) + 12u)];
    let _e591 = index_4;
    let _e600 = derived_setup.derived_setup_raw[(((_e591 * 14u) + 12u) + 1u)];
    let _e608 = index_4;
    let _e617 = derived_setup.derived_setup_raw[(((_e608 * 14u) + 12u) + 1u)];
    return DerivedSetup(vec4<i32>(vec4<u32>((_e66 & 255u), ((_e76 >> 8u) & 255u), ((_e88 >> 16u) & 255u), (_e100 >> 24u))), vec4<i32>(vec4<u32>((_e112 & 255u), ((_e122 >> 8u) & 255u), ((_e134 >> 16u) & 255u), (_e146 >> 24u))), vec4<i32>(vec4<u32>((_e158 & 255u), ((_e168 >> 8u) & 255u), ((_e180 >> 16u) & 255u), (_e192 >> 24u))), vec4<i32>(vec4<u32>((_e204 & 255u), ((_e214 >> 8u) & 255u), ((_e226 >> 16u) & 255u), (_e238 >> 24u))), vec4<i32>(vec4<u32>((_e250 & 255u), ((_e260 >> 8u) & 255u), ((_e272 >> 16u) & 255u), (_e284 >> 24u))), vec4<i32>(vec4<u32>((_e296 & 255u), ((_e306 >> 8u) & 255u), ((_e318 >> 16u) & 255u), (_e330 >> 24u))), vec4<i32>(vec4<u32>((_e342 & 255u), ((_e352 >> 8u) & 255u), ((_e364 >> 16u) & 255u), (_e376 >> 24u))), vec4<i32>(vec4<u32>((_e388 & 255u), ((_e398 >> 8u) & 255u), ((_e410 >> 16u) & 255u), (_e422 >> 24u))), vec4<i32>(vec4<u32>((_e434 & 255u), ((_e444 >> 8u) & 255u), ((_e456 >> 16u) & 255u), (_e468 >> 24u))), vec4<i32>(vec4<u32>((_e480 & 255u), ((_e490 >> 8u) & 255u), ((_e502 >> 16u) & 255u), (_e514 >> 24u))), _e526, i32((_e534 & 65535u)), i32(((_e545 >> 16u) & 255u)), i32(((_e558 >> 24u) & 255u)), vec4<i32>(((i32(_e571) << 16u) >> 16u), (i32(_e586) >> 16u), ((i32(_e600) << 16u) >> 16u), (i32(_e617) >> 16u)));
}

fn load_depth_blend_state(index_5: u32) -> DepthBlendState {
    var index_6: u32;

    index_6 = index_5;
    let _e59 = index_6;
    let _e66 = depth_blend_state.depth_blend_state_raw[((_e59 * 4u) + 0u)];
    let _e69 = index_6;
    let _e76 = depth_blend_state.depth_blend_state_raw[((_e69 * 4u) + 0u)];
    let _e81 = index_6;
    let _e88 = depth_blend_state.depth_blend_state_raw[((_e81 * 4u) + 0u)];
    let _e93 = index_6;
    let _e100 = depth_blend_state.depth_blend_state_raw[((_e93 * 4u) + 0u)];
    let _e105 = index_6;
    let _e112 = depth_blend_state.depth_blend_state_raw[((_e105 * 4u) + 1u)];
    let _e115 = index_6;
    let _e122 = depth_blend_state.depth_blend_state_raw[((_e115 * 4u) + 1u)];
    let _e127 = index_6;
    let _e134 = depth_blend_state.depth_blend_state_raw[((_e127 * 4u) + 1u)];
    let _e139 = index_6;
    let _e146 = depth_blend_state.depth_blend_state_raw[((_e139 * 4u) + 1u)];
    let _e151 = index_6;
    let _e158 = depth_blend_state.depth_blend_state_raw[((_e151 * 4u) + 2u)];
    let _e159 = index_6;
    let _e166 = depth_blend_state.depth_blend_state_raw[((_e159 * 4u) + 3u)];
    let _e170 = index_6;
    let _e177 = depth_blend_state.depth_blend_state_raw[((_e170 * 4u) + 3u)];
    return DepthBlendState(vec4<i32>(vec4<u32>((_e66 & 255u), ((_e76 >> 8u) & 255u), ((_e88 >> 16u) & 255u), (_e100 >> 24u))), vec4<i32>(vec4<u32>((_e112 & 255u), ((_e122 >> 8u) & 255u), ((_e134 >> 16u) & 255u), (_e146 >> 24u))), _e158, i32((_e166 & 255u)), i32(((_e177 >> 8u) & 255u)), 0i, 0i);
}

fn decode_memory_color(image_read_en: bool) -> vec4<i32> {
    var image_read_en_1: bool;
    var _1608_: i32;
    var memory_coverage: i32;
    var color_1_: vec3<i32> = vec3(0i);

    image_read_en_1 = image_read_en;
    let _e60 = image_read_en_1;
    if _e60 {
        {
            let _e61 = current_color;
            _1608_ = (_e61.w & 224i);
        }
    } else {
        {
            _1608_ = 224i;
        }
    }
    let _e66 = _1608_;
    memory_coverage = _e66;
    memory_coverage = 224i;
    let _e72 = color_1_;
    let _e73 = memory_coverage;
    return vec4<i32>(_e72.x, _e72.y, _e72.z, _e73);
}

fn z_decompress(z: i32) -> i32 {
    var z_1: i32;
    var z_2: i32;
    var exponent: i32;
    var mantissa: i32;
    var shift: i32;
    var base: i32;

    z_1 = z;
    let _e59 = z_1;
    z_2 = _e59;
    let _e61 = z_2;
    exponent = (_e61 >> 11u);
    let _e66 = z_2;
    mantissa = (_e66 & 2047i);
    let _e71 = exponent;
    shift = max((6i - _e71), 0i);
    let _e78 = exponent;
    base = (262144i - (262144i >> u32(_e78)));
    let _e83 = mantissa;
    let _e84 = shift;
    let _e87 = base;
    return ((_e83 << u32(_e84)) + _e87);
}

fn dz_decompress(dz: i32) -> i32 {
    var dz_1: i32;

    dz_1 = dz;
    let _e60 = dz_1;
    return (1i << u32(_e60));
}

fn combine_dz(dz_2: ptr<function, i32>) -> i32 {
    let _e58 = (*dz_2);
    if (_e58 != 0i) {
        {
            let _e62 = (*dz_2);
            (*dz_2) = (1i << u32(firstLeadingBit(_e62)));
        }
    }
    let _e66 = (*dz_2);
    return _e66;
}

fn dz_compress(dz_3: i32) -> i32 {
    var dz_4: i32;

    dz_4 = dz_3;
    let _e59 = dz_4;
    return max(firstLeadingBit(_e59), 0i);
}

fn depth_test(z_3: i32, dz_5: i32, dz_compressed: i32, current_depth_1_: i32, current_dz_1_: i32, coverage_count: ptr<function, i32>, current_coverage_count: i32, z_compare: bool, z_mode: i32, force_blend: bool, aa_enable: bool, blend_en: ptr<function, bool>, coverage_wrap: ptr<function, bool>, blend_shift: ptr<function, vec2<i32>>) -> bool {
    var z_4: i32;
    var dz_6: i32;
    var dz_compressed_1: i32;
    var current_depth_1_1: i32;
    var current_dz_1_1: i32;
    var current_coverage_count_1: i32;
    var z_compare_1: bool;
    var z_mode_1: i32;
    var force_blend_1: bool;
    var aa_enable_1: bool;
    var depth_pass: bool;
    var param_1: i32;
    var memory_z: i32;
    var param_1_1: i32;
    var memory_dz: i32;
    var precision_factor: i32;
    var coplanar: bool = false;
    var param_2_1: i32;
    var _701_: i32;
    var combined_dz: i32;
    var combined_dz_interpenetrate: i32;
    var _716_: bool;
    var farther: bool;
    var overflow: bool;
    var _732_: bool;
    var max_z: bool;
    var front: bool;
    var z_closest_possible: i32;
    var nearer: bool;
    var _766_: bool;
    var local: bool;
    var _786_: bool;
    var local_1: bool;
    var param_3_1: i32;
    var cvg_coeff: i32;
    var overflow_1_: bool;
    var _838_: bool;

    z_4 = z_3;
    dz_6 = dz_5;
    dz_compressed_1 = dz_compressed;
    current_depth_1_1 = current_depth_1_;
    current_dz_1_1 = current_dz_1_;
    current_coverage_count_1 = current_coverage_count;
    z_compare_1 = z_compare;
    z_mode_1 = z_mode;
    force_blend_1 = force_blend;
    aa_enable_1 = aa_enable;
    let _e82 = z_compare_1;
    if _e82 {
        {
            let _e83 = current_depth_1_1;
            param_1 = _e83;
            let _e85 = param_1;
            let _e86 = z_decompress(_e85);
            memory_z = _e86;
            let _e88 = current_dz_1_1;
            param_1_1 = _e88;
            let _e90 = param_1_1;
            let _e91 = dz_decompress(_e90);
            memory_dz = _e91;
            let _e93 = current_depth_1_1;
            precision_factor = ((_e93 >> 11u) & 15i);
            let _e103 = dz_compressed_1;
            let _e104 = current_dz_1_1;
            (*blend_shift).x = clamp((_e103 - _e104), 0i, 4i);
            let _e110 = current_dz_1_1;
            let _e111 = dz_compressed_1;
            (*blend_shift).y = clamp((_e110 - _e111), 0i, 4i);
            let _e116 = precision_factor;
            if (_e116 < 3i) {
                {
                    let _e119 = memory_dz;
                    if (_e119 != 32768i) {
                        {
                            let _e122 = memory_dz;
                            let _e127 = precision_factor;
                            memory_dz = max((_e122 << 1u), (16i >> u32(_e127)));
                        }
                    } else {
                        {
                            coplanar = true;
                            memory_dz = 65535i;
                        }
                    }
                }
            }
            let _e133 = dz_6;
            let _e134 = memory_dz;
            param_2_1 = (_e133 | _e134);
            let _e139 = combine_dz((&param_2_1));
            _701_ = _e139;
            let _e141 = _701_;
            combined_dz = _e141;
            let _e143 = combined_dz;
            combined_dz_interpenetrate = _e143;
            let _e145 = combined_dz;
            combined_dz = (_e145 << 3u);
            let _e150 = coplanar;
            if !(_e150) {
                {
                    let _e152 = z_4;
                    let _e153 = combined_dz;
                    let _e155 = memory_z;
                    _716_ = ((_e152 + _e153) >= _e155);
                }
            } else {
                {
                    let _e157 = coplanar;
                    _716_ = _e157;
                }
            }
            let _e158 = _716_;
            farther = _e158;
            let _e160 = (*coverage_count);
            let _e161 = current_coverage_count_1;
            overflow = ((_e160 + _e161) >= 8i);
            let _e167 = force_blend_1;
            if !(_e167) {
                {
                    let _e169 = overflow;
                    let _e171 = aa_enable_1;
                    let _e173 = farther;
                    _732_ = ((!(_e169) && _e171) && _e173);
                }
            } else {
                {
                    let _e175 = force_blend_1;
                    _732_ = _e175;
                }
            }
            let _e176 = _732_;
            (*blend_en) = _e176;
            let _e177 = overflow;
            (*coverage_wrap) = _e177;
            depth_pass = false;
            let _e179 = memory_z;
            max_z = (_e179 == 262143i);
            let _e183 = z_4;
            let _e184 = memory_z;
            front = (_e183 < _e184);
            let _e187 = z_4;
            let _e188 = combined_dz;
            z_closest_possible = (_e187 - _e188);
            let _e191 = coplanar;
            let _e192 = z_closest_possible;
            let _e193 = memory_z;
            nearer = (_e191 || (_e192 <= _e193));
            let _e197 = z_mode_1;
            switch _e197 {
                case 0: {
                    let _e199 = max_z;
                    if !(_e199) {
                        {
                            let _e201 = overflow;
                            if _e201 {
                                let _e202 = front;
                                local = _e202;
                            } else {
                                let _e203 = nearer;
                                local = _e203;
                            }
                            let _e205 = local;
                            _766_ = _e205;
                        }
                    } else {
                        {
                            let _e206 = max_z;
                            _766_ = _e206;
                        }
                    }
                    let _e207 = _766_;
                    depth_pass = _e207;
                }
                case 1: {
                    let _e208 = front;
                    let _e210 = farther;
                    let _e213 = overflow;
                    if ((!(_e208) || !(_e210)) || !(_e213)) {
                        {
                            let _e217 = max_z;
                            if !(_e217) {
                                {
                                    let _e219 = overflow;
                                    if _e219 {
                                        let _e220 = front;
                                        local_1 = _e220;
                                    } else {
                                        let _e221 = nearer;
                                        local_1 = _e221;
                                    }
                                    let _e223 = local_1;
                                    _786_ = _e223;
                                }
                            } else {
                                {
                                    let _e224 = max_z;
                                    _786_ = _e224;
                                }
                            }
                            let _e225 = _786_;
                            depth_pass = _e225;
                        }
                    } else {
                        {
                            let _e226 = combined_dz_interpenetrate;
                            param_3_1 = (_e226 & 65535i);
                            let _e230 = param_3_1;
                            let _e231 = dz_compress(_e230);
                            combined_dz_interpenetrate = _e231;
                            let _e232 = memory_z;
                            let _e233 = combined_dz_interpenetrate;
                            let _e236 = z_4;
                            let _e237 = combined_dz_interpenetrate;
                            cvg_coeff = (((_e232 >> u32(_e233)) - (_e236 >> u32(_e237))) & 15i);
                            let _e244 = cvg_coeff;
                            let _e245 = (*coverage_count);
                            (*coverage_count) = min(((_e244 * _e245) >> 3u), 8i);
                            depth_pass = true;
                        }
                    }
                }
                case 2: {
                    let _e253 = front;
                    let _e254 = max_z;
                    depth_pass = (_e253 || _e254);
                }
                case 3: {
                    let _e256 = farther;
                    let _e257 = nearer;
                    let _e259 = max_z;
                    depth_pass = ((_e256 && _e257) && !(_e259));
                }
                default: {
                }
            }
        }
    } else {
        {
            (*blend_shift).x = 0i;
            let _e266 = dz_compressed_1;
            (*blend_shift).y = min((15i - _e266), 4i);
            let _e270 = (*coverage_count);
            let _e271 = current_coverage_count_1;
            overflow_1_ = ((_e270 + _e271) >= 8i);
            let _e277 = force_blend_1;
            if !(_e277) {
                {
                    let _e279 = overflow_1_;
                    let _e281 = aa_enable_1;
                    _838_ = (!(_e279) && _e281);
                }
            } else {
                {
                    let _e283 = force_blend_1;
                    _838_ = _e283;
                }
            }
            let _e284 = _838_;
            (*blend_en) = _e284;
            let _e285 = overflow_1_;
            (*coverage_wrap) = _e285;
            depth_pass = true;
        }
    }
    let _e287 = depth_pass;
    return _e287;
}

fn blender(inputs: BlendInputs, blend_modes: vec4<i32>, force_blend_2: bool, blend_en_1: bool, color_on_coverage: bool, coverage_wrap_1: bool, blend_shift_1: vec2<i32>, final_cycle: bool) -> vec3<i32> {
    var inputs_1: BlendInputs;
    var blend_modes_1: vec4<i32>;
    var force_blend_3: bool;
    var blend_en_2: bool;
    var color_on_coverage_1: bool;
    var coverage_wrap_2: bool;
    var blend_shift_2: vec2<i32>;
    var final_cycle_1: bool;
    var rgb1_: vec3<i32>;
    var rgb0_: vec3<i32>;
    var _473_: bool;
    var _494_: bool;
    var _480_: bool;
    var _487_: bool;
    var _493_: bool;
    var a0_: i32;
    var a1_: i32;
    var blended: vec3<i32>;
    var blend_sum: i32;

    inputs_1 = inputs;
    blend_modes_1 = blend_modes;
    force_blend_3 = force_blend_2;
    blend_en_2 = blend_en_1;
    color_on_coverage_1 = color_on_coverage;
    coverage_wrap_2 = coverage_wrap_1;
    blend_shift_2 = blend_shift_1;
    final_cycle_1 = final_cycle;
    let _e74 = blend_modes_1;
    switch _e74.z {
        case 0: {
            let _e76 = inputs_1;
            rgb1_ = _e76.pixel_color.xyz;
        }
        case 1: {
            let _e79 = inputs_1;
            rgb1_ = _e79.memory_color.xyz;
        }
        case 2: {
            let _e82 = inputs_1;
            rgb1_ = _e82.blend_color.xyz;
        }
        case 3: {
            let _e85 = inputs_1;
            rgb1_ = _e85.fog_color.xyz;
        }
        default: {
        }
    }
    let _e88 = final_cycle_1;
    if _e88 {
        {
            let _e89 = color_on_coverage_1;
            let _e90 = coverage_wrap_2;
            if (_e89 && !(_e90)) {
                {
                    let _e93 = rgb1_;
                    return _e93;
                }
            }
        }
    }
    let _e95 = blend_modes_1;
    switch _e95.x {
        case 0: {
            let _e97 = inputs_1;
            rgb0_ = _e97.pixel_color.xyz;
        }
        case 1: {
            let _e100 = inputs_1;
            rgb0_ = _e100.memory_color.xyz;
        }
        case 2: {
            let _e103 = inputs_1;
            rgb0_ = _e103.blend_color.xyz;
        }
        case 3: {
            let _e106 = inputs_1;
            rgb0_ = _e106.fog_color.xyz;
        }
        default: {
        }
    }
    let _e109 = final_cycle_1;
    if _e109 {
        {
            let _e110 = blend_en_2;
            _473_ = !(_e110);
            let _e114 = _473_;
            if !(_e114) {
                {
                    let _e116 = blend_modes_1;
                    _480_ = (_e116.y == 0i);
                    let _e122 = _480_;
                    if _e122 {
                        {
                            let _e123 = blend_modes_1;
                            _487_ = (_e123.w == 0i);
                        }
                    } else {
                        {
                            let _e127 = _480_;
                            _487_ = _e127;
                        }
                    }
                    let _e129 = _487_;
                    if _e129 {
                        {
                            let _e130 = inputs_1;
                            _493_ = (_e130.pixel_color.w == 255i);
                        }
                    } else {
                        {
                            let _e135 = _487_;
                            _493_ = _e135;
                        }
                    }
                    let _e136 = _493_;
                    _494_ = _e136;
                }
            } else {
                {
                    let _e137 = _473_;
                    _494_ = _e137;
                }
            }
            let _e138 = _494_;
            if _e138 {
                {
                    let _e139 = rgb0_;
                    return _e139;
                }
            }
        }
    }
    let _e141 = blend_modes_1;
    switch _e141.y {
        case 0: {
            let _e143 = inputs_1;
            a0_ = _e143.pixel_color.w;
        }
        case 1: {
            let _e146 = inputs_1;
            a0_ = _e146.fog_color.w;
        }
        case 2: {
            let _e149 = inputs_1;
            a0_ = _e149.shade_alpha;
        }
        case 3: {
            a0_ = 0i;
        }
        default: {
        }
    }
    let _e153 = blend_modes_1;
    switch _e153.w {
        case 0: {
            let _e155 = a0_;
            a1_ = (~(_e155) & 255i);
        }
        case 1: {
            let _e159 = inputs_1;
            a1_ = _e159.memory_color.w;
        }
        case 2: {
            a1_ = 255i;
        }
        case 3: {
            a1_ = 0i;
        }
        default: {
        }
    }
    let _e164 = a0_;
    a0_ = (_e164 >> 3u);
    let _e168 = a1_;
    a1_ = (_e168 >> 3u);
    let _e172 = blend_modes_1;
    if (_e172.w == 1i) {
        {
            let _e176 = a0_;
            let _e177 = blend_shift_2;
            a0_ = ((_e176 >> u32(_e177.x)) & 60i);
            let _e183 = a1_;
            let _e184 = blend_shift_2;
            a1_ = ((_e183 >> u32(_e184.y)) | 3i);
        }
    }
    let _e190 = rgb0_;
    let _e192 = a0_;
    let _e195 = rgb1_;
    let _e197 = a1_;
    blended = ((vec3<i32>(_e190) * vec3(_e192)) + (vec3<i32>(_e195) * vec3((_e197 + 1i))));
    let _e204 = final_cycle_1;
    let _e206 = force_blend_3;
    if (!(_e204) || _e206) {
        {
            let _e208 = blended;
            rgb0_ = vec3<i32>((_e208 >> vec3(5u)));
        }
    } else {
        {
            let _e215 = a0_;
            let _e219 = a1_;
            blend_sum = (((_e215 >> 2u) + (_e219 >> 2u)) + 1i);
            let _e227 = blended;
            blended = (_e227 >> vec3(2u));
            let _e233 = blended;
            blended = (_e233 & vec3(2047i));
            let _e238 = blend_sum;
            let _e242 = blended;
            let _e247 = uBlenderDividerLUT_blk.uBlenderDividerLUT_raw[((_e238 << 11u) | _e242.x)];
            rgb0_.x = i32(_e247.x);
            let _e251 = blend_sum;
            let _e255 = blended;
            let _e260 = uBlenderDividerLUT_blk.uBlenderDividerLUT_raw[((_e251 << 11u) | _e255.y)];
            rgb0_.y = i32(_e260.x);
            let _e264 = blend_sum;
            let _e268 = blended;
            let _e273 = uBlenderDividerLUT_blk.uBlenderDividerLUT_raw[((_e264 << 11u) | _e268.z)];
            rgb0_.z = i32(_e273.x);
        }
    }
    let _e276 = rgb0_;
    return (_e276 & vec3(255i));
}

fn rgb_dither(orig_rgb: vec3<i32>, dith: i32) -> vec3<i32> {
    var orig_rgb_1: vec3<i32>;
    var dith_1: i32;
    var rgb_dith: vec3<i32>;
    var rgb: vec3<i32>;
    var replace_sign: vec3<i32>;
    var dither_diff: vec3<i32>;

    orig_rgb_1 = orig_rgb;
    dith_1 = dith;
    let _e61 = dith_1;
    rgb_dith = ((vec3(_e61) >> vec3<u32>(0u, 3u, 6u)) & vec3(7i));
    let _e76 = orig_rgb_1;
    let _e85 = orig_rgb_1;
    rgb = select(((_e76 & vec3(248i)) + vec3(8i)), vec3(255i), (_e85 > vec3(247i)));
    let _e91 = rgb_dith;
    let _e92 = orig_rgb_1;
    replace_sign = ((_e91 - (_e92 & vec3(7i))) >> vec3(31u));
    let _e103 = rgb;
    let _e104 = orig_rgb_1;
    dither_diff = (_e103 - _e104);
    let _e107 = orig_rgb_1;
    let _e108 = dither_diff;
    let _e109 = replace_sign;
    rgb = (_e107 + (_e108 & _e109));
    let _e112 = rgb;
    return vec3<i32>((_e112 & vec3(255i)));
}

fn blend_coverage(coverage_1_: i32, memory_coverage_1: i32, blend_en_3: bool, mode: i32) -> i32 {
    var coverage_1_1: i32;
    var memory_coverage_2: i32;
    var blend_en_4: bool;
    var mode_1: i32;
    var res: i32 = 0i;

    coverage_1_1 = coverage_1_;
    memory_coverage_2 = memory_coverage_1;
    blend_en_4 = blend_en_3;
    mode_1 = mode;
    let _e67 = mode_1;
    switch _e67 {
        case 0: {
            let _e68 = blend_en_4;
            if _e68 {
                {
                    let _e70 = memory_coverage_2;
                    let _e71 = coverage_1_1;
                    res = min(7i, (_e70 + _e71));
                }
            } else {
                {
                    let _e74 = coverage_1_1;
                    res = ((_e74 - 1i) & 7i);
                }
            }
        }
        case 1: {
            let _e79 = coverage_1_1;
            let _e80 = memory_coverage_2;
            res = ((_e79 + _e80) & 7i);
        }
        case 2: {
            res = 7i;
        }
        case 3: {
            let _e85 = memory_coverage_2;
            res = _e85;
        }
        default: {
        }
    }
    let _e86 = res;
    return _e86;
}

fn write_color(col: vec4<i32>) {
    var col_1: vec4<i32>;

    col_1 = col;
    let _e60 = col_1;
    current_color.x = _e60.x;
    let _e64 = col_1;
    current_color.y = _e64.y;
    let _e68 = col_1;
    current_color.z = _e68.z;
    current_color_dirty = true;
    return;
}

fn z_compress(z_5: i32) -> i32 {
    var z_6: i32;
    var inv_z: i32;
    var exponent_1: i32;
    var shift_1: i32;
    var mantissa_1: i32;

    z_6 = z_5;
    let _e60 = z_6;
    inv_z = max((262143i - _e60), 1i);
    let _e66 = inv_z;
    exponent_1 = (17i - firstLeadingBit(_e66));
    let _e70 = exponent_1;
    exponent_1 = clamp(_e70, 0i, 7i);
    let _e75 = exponent_1;
    shift_1 = max((6i - _e75), 0i);
    let _e80 = z_6;
    let _e81 = shift_1;
    mantissa_1 = ((_e80 >> u32(_e81)) & 2047i);
    let _e87 = exponent_1;
    let _e91 = mantissa_1;
    return ((_e87 << 11u) + _e91);
}

fn depth_blend(x: i32, y: i32, primitive_index: u32, shaded: ShadedData) {
    var x_1: i32;
    var y_1: i32;
    var primitive_index_1: u32;
    var shaded_1: ShadedData;
    var z_7: i32;
    var dith_2: i32;
    var coverage_count_1: i32;
    var combined: vec4<i32>;
    var shade_alpha_1_: i32;
    var blend_state_index: u32;
    var param_2: u32;
    var derived: DerivedSetup;
    var param_1_2: u32;
    var depth_blend_1_: DepthBlendState;
    var force_blend_4: bool;
    var z_compare_2: bool;
    var z_update: bool;
    var image_read_enable: bool;
    var color_on_coverage_2: bool;
    var blend_multicycle: bool;
    var aa_enable_2: bool;
    var dither_en: bool;
    var param_2_2: bool;
    var memory_color: vec4<i32>;
    var memory_coverage_3: i32;
    var param_3_2: i32;
    var param_4_: i32;
    var param_5_: i32;
    var param_6_: i32;
    var param_7_: i32;
    var param_8_: i32;
    var param_9_: i32;
    var param_10_: bool;
    var param_11_: i32;
    var param_12_: bool;
    var param_13_: bool;
    var param_14_: bool;
    var param_15_: bool;
    var param_16_: vec2<i32>;
    var _1945_: bool;
    var blend_en_5: bool;
    var coverage_wrap_3: bool;
    var blend_shift_3: vec2<i32>;
    var z_pass: bool;
    var _1958_: bool;
    var blender_inputs: BlendInputs;
    var blend_modes_2: vec4<i32>;
    var param_17_: BlendInputs;
    var param_18_: vec4<i32>;
    var param_19_: bool;
    var param_20_: bool;
    var param_21_: bool;
    var param_22_: bool;
    var param_23_: vec2<i32>;
    var param_24_: bool = false;
    var _1991_: vec3<i32>;
    var param_25_: BlendInputs;
    var param_26_: vec4<i32>;
    var param_27_: bool;
    var param_28_: bool;
    var param_29_: bool;
    var param_30_: bool;
    var param_31_: vec2<i32>;
    var param_32_: bool = true;
    var rgb_1: vec3<i32>;
    var param_33_: vec3<i32>;
    var param_34_: i32;
    var param_35_: i32;
    var param_36_: i32;
    var param_37_: bool;
    var param_38_: i32;
    var new_coverage: i32;
    var param_39_: vec4<i32>;
    var param_40_: i32;

    x_1 = x;
    y_1 = y;
    primitive_index_1 = primitive_index;
    shaded_1 = shaded;
    let _e65 = shaded_1;
    z_7 = (_e65.z_dith >> 9u);
    let _e71 = shaded_1;
    dith_2 = (_e71.z_dith & 511i);
    let _e76 = shaded_1;
    coverage_count_1 = _e76.coverage_count;
    let _e79 = shaded_1;
    combined = _e79.combined;
    let _e82 = shaded_1;
    shade_alpha_1_ = _e82.shade_alpha;
    let _e85 = primitive_index_1;
    let _e92 = state_indices.state_indices_raw[((_e85 * 4u) + 0u)];
    let _e95 = primitive_index_1;
    let _e102 = state_indices.state_indices_raw[((_e95 * 4u) + 0u)];
    let _e107 = primitive_index_1;
    let _e114 = state_indices.state_indices_raw[((_e107 * 4u) + 0u)];
    let _e119 = primitive_index_1;
    let _e126 = state_indices.state_indices_raw[((_e119 * 4u) + 0u)];
    blend_state_index = u32(vec4<u32>((_e92 & 255u), ((_e102 >> 8u) & 255u), ((_e114 >> 16u) & 255u), (_e126 >> 24u)).y);
    let _e133 = primitive_index_1;
    param_2 = _e133;
    let _e135 = param_2;
    let _e136 = load_derived_setup(_e135);
    derived = _e136;
    let _e138 = blend_state_index;
    param_1_2 = _e138;
    let _e140 = param_1_2;
    let _e141 = load_depth_blend_state(_e140);
    depth_blend_1_ = _e141;
    let _e143 = depth_blend_1_;
    force_blend_4 = ((_e143.flags & 8u) != 0u);
    let _e150 = depth_blend_1_;
    z_compare_2 = ((_e150.flags & 1u) != 0u);
    let _e157 = depth_blend_1_;
    z_update = ((_e157.flags & 2u) != 0u);
    let _e164 = depth_blend_1_;
    image_read_enable = ((_e164.flags & 16u) != 0u);
    let _e171 = depth_blend_1_;
    color_on_coverage_2 = ((_e171.flags & 32u) != 0u);
    let _e178 = depth_blend_1_;
    blend_multicycle = ((_e178.flags & 64u) != 0u);
    let _e185 = depth_blend_1_;
    aa_enable_2 = ((_e185.flags & 128u) != 0u);
    let _e192 = depth_blend_1_;
    dither_en = ((_e192.flags & 256u) != 0u);
    let _e199 = image_read_enable;
    param_2_2 = _e199;
    let _e201 = param_2_2;
    let _e202 = decode_memory_color(_e201);
    memory_color = _e202;
    let _e204 = memory_color;
    memory_coverage_3 = (_e204.w >> 5u);
    let _e210 = z_7;
    param_3_2 = _e210;
    let _e212 = derived;
    param_4_ = _e212.dz;
    let _e215 = derived;
    param_5_ = _e215.dz_compressed;
    let _e218 = current_depth;
    param_6_ = _e218;
    let _e220 = current_dz;
    param_7_ = _e220;
    let _e222 = coverage_count_1;
    param_8_ = _e222;
    let _e224 = memory_coverage_3;
    param_9_ = _e224;
    let _e226 = z_compare_2;
    param_10_ = _e226;
    let _e228 = depth_blend_1_;
    param_11_ = _e228.z_mode;
    let _e231 = force_blend_4;
    param_12_ = _e231;
    let _e233 = aa_enable_2;
    param_13_ = _e233;
    let _e238 = param_3_2;
    let _e239 = param_4_;
    let _e240 = param_5_;
    let _e241 = param_6_;
    let _e242 = param_7_;
    let _e244 = param_9_;
    let _e245 = param_10_;
    let _e246 = param_11_;
    let _e247 = param_12_;
    let _e248 = param_13_;
    let _e256 = depth_test(_e238, _e239, _e240, _e241, _e242, (&param_8_), _e244, _e245, _e246, _e247, _e248, (&param_14_), (&param_15_), (&param_16_));
    _1945_ = _e256;
    let _e258 = param_8_;
    coverage_count_1 = _e258;
    let _e259 = param_14_;
    blend_en_5 = _e259;
    let _e261 = param_15_;
    coverage_wrap_3 = _e261;
    let _e263 = param_16_;
    blend_shift_3 = _e263;
    let _e265 = _1945_;
    z_pass = _e265;
    let _e268 = z_pass;
    if _e268 {
        {
            let _e269 = aa_enable_2;
            let _e271 = coverage_count_1;
            _1958_ = (!(_e269) || (_e271 != 0i));
        }
    } else {
        {
            let _e275 = z_pass;
            _1958_ = _e275;
        }
    }
    let _e276 = _1958_;
    if _e276 {
        {
            let _e277 = combined;
            let _e278 = memory_color;
            let _e279 = derived;
            let _e281 = derived;
            let _e283 = shade_alpha_1_;
            blender_inputs = BlendInputs(_e277, _e278, _e279.fog_color, _e281.blend_color, _e283);
            let _e286 = depth_blend_1_;
            blend_modes_2 = _e286.blend_modes0_;
            let _e289 = blend_multicycle;
            if _e289 {
                {
                    let _e290 = blender_inputs;
                    param_17_ = _e290;
                    let _e292 = blend_modes_2;
                    param_18_ = _e292;
                    let _e294 = force_blend_4;
                    param_19_ = _e294;
                    let _e296 = blend_en_5;
                    param_20_ = _e296;
                    let _e298 = color_on_coverage_2;
                    param_21_ = _e298;
                    let _e300 = coverage_wrap_3;
                    param_22_ = _e300;
                    let _e302 = blend_shift_3;
                    param_23_ = _e302;
                    let _e306 = param_17_;
                    let _e307 = param_18_;
                    let _e308 = param_19_;
                    let _e309 = param_20_;
                    let _e310 = param_21_;
                    let _e311 = param_22_;
                    let _e312 = param_23_;
                    let _e313 = param_24_;
                    let _e314 = blender(_e306, _e307, _e308, _e309, _e310, _e311, _e312, _e313);
                    _1991_ = _e314;
                    let _e318 = _1991_;
                    blender_inputs.pixel_color.x = _e318.x;
                    let _e322 = _1991_;
                    blender_inputs.pixel_color.y = _e322.y;
                    let _e326 = _1991_;
                    blender_inputs.pixel_color.z = _e326.z;
                    let _e328 = depth_blend_1_;
                    blend_modes_2 = _e328.blend_modes1_;
                }
            }
            let _e330 = blender_inputs;
            param_25_ = _e330;
            let _e332 = blend_modes_2;
            param_26_ = _e332;
            let _e334 = force_blend_4;
            param_27_ = _e334;
            let _e336 = blend_en_5;
            param_28_ = _e336;
            let _e338 = color_on_coverage_2;
            param_29_ = _e338;
            let _e340 = coverage_wrap_3;
            param_30_ = _e340;
            let _e342 = blend_shift_3;
            param_31_ = _e342;
            let _e346 = param_25_;
            let _e347 = param_26_;
            let _e348 = param_27_;
            let _e349 = param_28_;
            let _e350 = param_29_;
            let _e351 = param_30_;
            let _e352 = param_31_;
            let _e353 = param_32_;
            let _e354 = blender(_e346, _e347, _e348, _e349, _e350, _e351, _e352, _e353);
            rgb_1 = _e354;
            let _e356 = dither_en;
            if _e356 {
                {
                    let _e357 = rgb_1;
                    param_33_ = _e357;
                    let _e359 = dith_2;
                    param_34_ = _e359;
                    let _e361 = param_33_;
                    let _e362 = param_34_;
                    let _e363 = rgb_dither(_e361, _e362);
                    rgb_1 = _e363;
                }
            }
            let _e364 = coverage_count_1;
            param_35_ = _e364;
            let _e366 = memory_coverage_3;
            param_36_ = _e366;
            let _e368 = blend_en_5;
            param_37_ = _e368;
            let _e370 = depth_blend_1_;
            param_38_ = _e370.coverage_mode;
            let _e373 = param_35_;
            let _e374 = param_36_;
            let _e375 = param_37_;
            let _e376 = param_38_;
            let _e377 = blend_coverage(_e373, _e374, _e375, _e376);
            new_coverage = _e377;
            let _e379 = rgb_1;
            let _e380 = new_coverage;
            param_39_ = vec4<i32>(_e379.x, _e379.y, _e379.z, (_e380 << 5u));
            let _e389 = param_39_;
            write_color(_e389);
            let _e390 = z_update;
            if _e390 {
                {
                    let _e391 = z_7;
                    param_40_ = _e391;
                    let _e393 = param_40_;
                    let _e394 = z_compress(_e393);
                    current_depth = _e394;
                    let _e395 = derived;
                    current_dz = _e395.dz_compressed;
                    current_depth_dirty = true;
                    return;
                }
            } else {
                {
                    return;
                }
            }
        }
    } else {
        return;
    }
}

fn copy_pipeline(word_2: u32, primitive_index_2: u32) {
    var word_3: u32;
    var primitive_index_3: u32;

    word_3 = word_2;
    primitive_index_3 = primitive_index_2;
    current_color = vec4(0i);
    current_color_dirty = true;
    return;
}

fn fill_color(col_2: u32) {
    var col_3: u32;

    col_3 = col_2;
    return;
}

fn store_vram_color(index_7: ptr<function, u32>, slice_5: u32) {
    var slice_6: u32;

    slice_6 = slice_5;
    let _e60 = current_color_dirty;
    if _e60 {
        {
            let _e61 = (*index_7);
            (*index_7) = (_e61 & 8388607u);
            let _e64 = (*index_7);
            let _e65 = slice_6;
            (*index_7) = (_e64 + (_e65 * 8388608u));
            let _e69 = (*index_7);
            let _e76 = (*index_7);
            let _e83 = vram8_.data[((_e76 ^ 3u) >> 2u)];
            let _e85 = (*index_7);
            let _e98 = (*index_7);
            vram8_.data[((_e69 ^ 3u) >> 2u)] = ((_e83 & ~((255u << (((_e85 ^ 3u) & 3u) * 8u)))) | (0u << (((_e98 ^ 3u) & 3u) * 8u)));
            let _e107 = (*index_7);
            if ((_e107 & 1u) != 0u) {
                {
                    let _e112 = (*index_7);
                    let _e119 = (*index_7);
                    let _e126 = hidden_vram.data[((_e119 >> 1u) >> 2u)];
                    let _e128 = (*index_7);
                    let _e138 = current_color;
                    let _e143 = (*index_7);
                    hidden_vram.data[((_e112 >> 1u) >> 2u)] = ((_e126 & ~((255u << (((_e128 >> 1u) & 3u) * 8u)))) | ((u32(_e138.w) & 255u) << (((_e143 >> 1u) & 3u) * 8u)));
                    return;
                }
            } else {
                return;
            }
        }
    } else {
        return;
    }
}

fn store_vram_depth(index_8: ptr<function, u32>, slice_7: u32) {
    var slice_8: u32;

    slice_8 = slice_7;
    let _e60 = current_depth_dirty;
    if _e60 {
        {
            let _e61 = (*index_8);
            (*index_8) = (_e61 & 4194303u);
            let _e64 = (*index_8);
            let _e65 = slice_8;
            (*index_8) = (_e64 + (_e65 * 4194304u));
            let _e69 = (*index_8);
            let _e74 = current_depth;
            let _e82 = current_dz;
            vram8_.data[(_e69 ^ 1u)] = (u32((u32((_e74 << 2u)) & 65535u)) | u32((_e82 >> 2u)));
            let _e88 = (*index_8);
            let _e93 = (*index_8);
            let _e98 = hidden_vram.data[(_e93 >> 2u)];
            let _e100 = (*index_8);
            let _e108 = current_dz;
            let _e114 = (*index_8);
            hidden_vram.data[(_e88 >> 2u)] = ((_e98 & ~((255u << ((_e100 & 3u) * 8u)))) | ((u32((_e108 & 3i)) & 255u) << ((_e114 & 3u) * 8u)));
            return;
        }
    } else {
        return;
    }
}

fn finish_tile(coord_1: ptr<function, vec2<u32>>, fb_width_2: u32, fb_height_2: u32, fb_addr_index_2: u32, fb_depth_addr_index_2: u32) {
    var fb_width_3: u32;
    var fb_height_3: u32;
    var fb_addr_index_3: u32;
    var fb_depth_addr_index_3: u32;
    var unscaled_fb_width: u32;
    var slice2d_1: vec2<u32>;
    var slice_9: u32;
    var index_9: u32;
    var param_3: u32;
    var param_1_3: u32;
    var param_2_3: u32;
    var param_3_3: u32;

    fb_width_3 = fb_width_2;
    fb_height_3 = fb_height_2;
    fb_addr_index_3 = fb_addr_index_2;
    fb_depth_addr_index_3 = fb_depth_addr_index_2;
    let _e66 = (*coord_1);
    let _e67 = fb_width_3;
    let _e68 = fb_height_3;
    if any((_e66 >= vec2<u32>(_e67, _e68))) {
        {
            current_color_dirty = false;
            current_depth_dirty = false;
        }
    }
    let _e74 = fb_width_3;
    unscaled_fb_width = (_e74 >> 0u);
    let _e79 = (*coord_1);
    slice2d_1 = (_e79 & vec2(0u));
    let _e84 = (*coord_1);
    (*coord_1) = (_e84 >> vec2(0u));
    let _e90 = slice2d_1;
    let _e94 = slice2d_1;
    slice_9 = ((_e90.y * 1u) + _e94.x);
    let _e98 = fb_addr_index_3;
    let _e99 = unscaled_fb_width;
    let _e100 = (*coord_1);
    let _e104 = (*coord_1);
    index_9 = ((_e98 + (_e99 * _e100.y)) + _e104.x);
    let _e108 = index_9;
    param_3 = _e108;
    let _e110 = slice_9;
    param_1_3 = _e110;
    let _e113 = param_1_3;
    store_vram_color((&param_3), _e113);
    let _e115 = fb_depth_addr_index_3;
    let _e116 = unscaled_fb_width;
    let _e117 = (*coord_1);
    let _e121 = (*coord_1);
    index_9 = ((_e115 + (_e116 * _e117.y)) + _e121.x);
    let _e124 = index_9;
    param_2_3 = _e124;
    let _e126 = slice_9;
    param_3_3 = _e126;
    let _e129 = param_3_3;
    store_vram_depth((&param_2_3), _e129);
    return;
}

fn main_1() {
    var x_2: i32;
    var y_2: i32;
    var tile: vec2<i32>;
    var linear_tile: i32;
    var linear_tile_base: i32;
    var coarse_binned: u32;
    var param_4: vec2<u32>;
    var param_1_4: u32;
    var param_2_4: u32;
    var param_3_4: u32;
    var param_4_1: u32;
    var shaded_2: ShadedData;
    var mask_index: i32;
    var tile_instance: u32;
    var binned: u32;
    var i: i32;
    var primitive_index_4: u32;
    var index_10: u32;
    var coverage_1_2: i32;
    var param_5_1: u32;
    var word_4: u32;
    var param_6_1: u32;
    var param_7_1: u32;
    var param_8_1: i32;
    var param_9_1: i32;
    var param_10_1: u32;
    var param_11_1: ShadedData;
    var param_12_1: vec2<u32>;
    var param_13_1: u32;
    var param_14_1: u32;
    var param_15_1: u32;
    var param_16_1: u32;

    seeded_noise = 0i;
    let _e59 = gl_GlobalInvocationID_1;
    x_2 = i32(_e59.x);
    let _e63 = gl_GlobalInvocationID_1;
    y_2 = i32(_e63.y);
    let _e68 = gl_WorkGroupID_1;
    tile = vec2<i32>(_e68.xy);
    let _e72 = tile;
    let _e74 = tile;
    linear_tile = (_e72.x + (_e74.y * 0i));
    let _e80 = linear_tile;
    linear_tile_base = (_e80 * 0i);
    let _e84 = linear_tile;
    let _e87 = tile_binning_coarse.elems[_e84];
    let _e88 = registers;
    coarse_binned = (_e87 & _e88.group_mask);
    let _e92 = coarse_binned;
    if (_e92 == 0u) {
        {
            return;
        }
    }
    let _e95 = gl_GlobalInvocationID_1;
    param_4 = _e95.xy;
    let _e98 = registers;
    param_1_4 = _e98.fb_width;
    let _e101 = registers;
    param_2_4 = _e101.fb_height;
    let _e104 = registers;
    param_3_4 = _e104.fb_addr_index;
    let _e107 = registers;
    param_4_1 = _e107.fb_depth_addr_index;
    let _e111 = param_1_4;
    let _e112 = param_2_4;
    let _e113 = param_3_4;
    let _e114 = param_4_1;
    init_tile((&param_4), _e111, _e112, _e113, _e114);
    loop {
        let _e117 = coarse_binned;
        if !((_e117 != 0u)) {
            break;
        }
        {
            let _e121 = coarse_binned;
            mask_index = i32(firstTrailingBit(_e121));
            let _e125 = coarse_binned;
            let _e127 = mask_index;
            coarse_binned = (_e125 & ~(u32((1i << u32(_e127)))));
            let _e133 = linear_tile_base;
            let _e134 = mask_index;
            let _e138 = tile_instance_offsets.elems[(_e133 + _e134)];
            tile_instance = _e138;
            let _e140 = linear_tile_base;
            let _e141 = mask_index;
            let _e145 = tile_binning.elems[(_e140 + _e141)];
            binned = _e145;
            loop {
                let _e147 = binned;
                if !((_e147 != 0u)) {
                    break;
                }
                {
                    let _e151 = binned;
                    i = i32(firstTrailingBit(_e151));
                    let _e155 = binned;
                    let _e157 = i;
                    binned = (_e155 & ~(u32((1i << u32(_e157)))));
                    let _e163 = i;
                    let _e165 = mask_index;
                    primitive_index_4 = u32((_e163 + (32i * _e165)));
                    let _e171 = tile_instance;
                    let _e174 = gl_LocalInvocationIndex_1;
                    index_10 = ((_e171 * 64u) + _e174);
                    let _e177 = index_10;
                    let _e182 = coverage.elems[(_e177 >> 2u)];
                    let _e183 = index_10;
                    coverage_1_2 = i32(((_e182 >> ((_e183 & 3u) * 8u)) & 255u));
                    let _e193 = coverage_1_2;
                    if (_e193 >= 0i) {
                        {
                            let _e196 = coverage_1_2;
                            if ((_e196 & 64i) != 0i) {
                                {
                                    let _e201 = primitive_index_4;
                                    let _e208 = derived_setup.derived_setup_raw[((_e201 * 14u) + 10u)];
                                    param_5_1 = _e208;
                                    let _e210 = param_5_1;
                                    fill_color(_e210);
                                }
                            } else {
                                {
                                    let _e211 = coverage_1_2;
                                    if ((_e211 & 32i) != 0i) {
                                        {
                                            let _e216 = index_10;
                                            let _e219 = raw_color.elems[_e216];
                                            word_4 = _e219;
                                            let _e221 = word_4;
                                            param_6_1 = _e221;
                                            let _e223 = primitive_index_4;
                                            param_7_1 = _e223;
                                            let _e225 = param_6_1;
                                            let _e226 = param_7_1;
                                            copy_pipeline(_e225, _e226);
                                        }
                                    } else {
                                        {
                                            let _e228 = index_10;
                                            let _e231 = raw_color.elems[_e228];
                                            let _e234 = index_10;
                                            let _e237 = raw_color.elems[_e234];
                                            let _e242 = index_10;
                                            let _e245 = raw_color.elems[_e242];
                                            let _e250 = index_10;
                                            let _e253 = raw_color.elems[_e250];
                                            let _e259 = (vec4<u32>((_e231 & 255u), ((_e237 >> 8u) & 255u), ((_e245 >> 16u) & 255u), (_e253 >> 24u)) & vec4(255u));
                                            let _e260 = index_10;
                                            let _e263 = raw_color.elems[_e260];
                                            let _e266 = index_10;
                                            let _e269 = raw_color.elems[_e266];
                                            let _e274 = index_10;
                                            let _e277 = raw_color.elems[_e274];
                                            let _e282 = index_10;
                                            let _e285 = raw_color.elems[_e282];
                                            let _e295 = index_10;
                                            let _e298 = raw_color.elems[_e295];
                                            let _e301 = index_10;
                                            let _e304 = raw_color.elems[_e301];
                                            let _e309 = index_10;
                                            let _e312 = raw_color.elems[_e309];
                                            let _e317 = index_10;
                                            let _e320 = raw_color.elems[_e317];
                                            let _e330 = index_10;
                                            let _e333 = raw_color.elems[_e330];
                                            let _e336 = index_10;
                                            let _e339 = raw_color.elems[_e336];
                                            let _e344 = index_10;
                                            let _e347 = raw_color.elems[_e344];
                                            let _e352 = index_10;
                                            let _e355 = raw_color.elems[_e352];
                                            shaded_2.combined = vec4<i32>(vec4<u32>(_e259.x, _e259.y, _e259.z, _e259.w));
                                            let _e369 = index_10;
                                            let _e372 = depth.elems[_e369];
                                            shaded_2.z_dith = _e372;
                                            let _e374 = index_10;
                                            let _e379 = shade_alpha.elems[(_e374 >> 2u)];
                                            let _e380 = index_10;
                                            shaded_2.shade_alpha = i32(((_e379 >> ((_e380 & 3u) * 8u)) & 255u));
                                            let _e390 = coverage_1_2;
                                            shaded_2.coverage_count = _e390;
                                            let _e391 = x_2;
                                            param_8_1 = _e391;
                                            let _e393 = y_2;
                                            param_9_1 = _e393;
                                            let _e395 = primitive_index_4;
                                            param_10_1 = _e395;
                                            let _e397 = shaded_2;
                                            param_11_1 = _e397;
                                            let _e399 = param_8_1;
                                            let _e400 = param_9_1;
                                            let _e401 = param_10_1;
                                            let _e402 = param_11_1;
                                            depth_blend(_e399, _e400, _e401, _e402);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    let _e403 = tile_instance;
                    tile_instance = (_e403 + 1u);
                }
            }
        }
    }
    let _e406 = gl_GlobalInvocationID_1;
    param_12_1 = _e406.xy;
    let _e409 = registers;
    param_13_1 = _e409.fb_width;
    let _e412 = registers;
    param_14_1 = _e412.fb_height;
    let _e415 = registers;
    param_15_1 = _e415.fb_addr_index;
    let _e418 = registers;
    param_16_1 = _e418.fb_depth_addr_index;
    let _e422 = param_13_1;
    let _e423 = param_14_1;
    let _e424 = param_15_1;
    let _e425 = param_16_1;
    finish_tile((&param_12_1), _e422, _e423, _e424, _e425);
    return;
}

@compute @workgroup_size(8, 8, 1) 
fn main(@builtin(global_invocation_id) gl_GlobalInvocationID: vec3<u32>, @builtin(workgroup_id) gl_WorkGroupID: vec3<u32>, @builtin(local_invocation_index) gl_LocalInvocationIndex: u32) {
    gl_GlobalInvocationID_1 = gl_GlobalInvocationID;
    gl_WorkGroupID_1 = gl_WorkGroupID;
    gl_LocalInvocationIndex_1 = gl_LocalInvocationIndex;
    main_1();
    return;
}
