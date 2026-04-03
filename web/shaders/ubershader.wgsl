struct AttributeSetupMem {
    rgba: vec4<i32>,
    drgba_dx: vec4<i32>,
    drgba_de: vec4<i32>,
    drgba_dy: vec4<i32>,
    stzw: vec4<i32>,
    dstzw_dx: vec4<i32>,
    dstzw_de: vec4<i32>,
    dstzw_dy: vec4<i32>,
}

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

struct StaticRasterizationState {
    combiner_inputs_rgb0_: vec4<i32>,
    combiner_inputs_alpha0_: vec4<i32>,
    combiner_inputs_rgb1_: vec4<i32>,
    combiner_inputs_alpha1_: vec4<i32>,
    flags: u32,
    dither: i32,
    texture_size: i32,
    texture_fmt: i32,
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

struct TileInfo {
    slo: u32,
    shi: u32,
    tlo: u32,
    thi: u32,
    offset: u32,
    stride: u32,
    fmt: i32,
    size: i32,
    palette: i32,
    mask_s: i32,
    shift_s: i32,
    mask_t: i32,
    shift_t: i32,
    flags: i32,
}

struct SpanSetup {
    rgba: vec4<i32>,
    stzw: vec4<i32>,
    xleft: vec4<i32>,
    xright: vec4<i32>,
    interpolation_base_x: i32,
    start_x: i32,
    end_x: i32,
    lodlength: i32,
    valid_line: i32,
}

struct SpanInfoOffsetsMem {
    offset: i32,
    ylo: i32,
    yhi: i32,
    padding: i32,
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

struct CombinerInputs {
    constant_muladd: vec4<i32>,
    constant_mulsub: vec4<i32>,
    constant_mul: vec4<i32>,
    constant_add: vec4<i32>,
    shade: vec4<i32>,
    combined: vec4<i32>,
    texel0_: vec4<i32>,
    texel1_: vec4<i32>,
    lod_frac: i32,
    _noise: i32,
}

struct StaticRasterizationStateMem {
    combiner_inputs_rgb0_: vec4<u32>,
    combiner_inputs_alpha0_: vec4<u32>,
    combiner_inputs_rgb1_: vec4<u32>,
    combiner_inputs_alpha1_: vec4<u32>,
    flags: u32,
    dither: i32,
    texture_size: i32,
    texture_fmt: i32,
}

struct GlobalFBInfo {
    dx_shift: i32,
    dx_mask: i32,
    fb_size: i32,
    base_primitive_index: u32,
}

struct AttributeSetupBuffer {
    elems: array<AttributeSetupMem>,
}

struct DerivedSetupBuffer {
    derived_setup_raw: array<u32>,
}

struct StaticRasterStateBuffer {
    elems: array<StaticRasterizationStateMem>,
}

struct DepthBlendStateBuffer {
    depth_blend_state_raw: array<u32>,
}

struct TileInfoBuffer {
    tile_infos_raw: array<u32>,
}

struct SpanSetups {
    span_setups_raw: array<u32>,
}

struct SpanInfoOffsetBuffer {
    elems: array<SpanInfoOffsetsMem>,
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

struct GlobalConstants {
    fb_info: GlobalFBInfo,
}

struct TMEM8_ {
    raw: array<u32>,
}

struct TriangleSetupBuffer {
    triangle_setup_raw: array<u32>,
}

struct TileBinningCoarse {
    elems: array<u32>,
}

struct TileBinning {
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

const _973_: array<i32, 32> = array<i32, 32>(0i, 6i, 1i, 7i, 4i, 2i, 5i, 3i, 3i, 5i, 2i, 4i, 7i, 1i, 6i, 0i, 0i, 4i, 1i, 5i, 4i, 0i, 5i, 1i, 3i, 7i, 2i, 6i, 7i, 3i, 6i, 2i);
const _3061_: array<vec2<i32>, 64> = array<vec2<i32>, 64>(vec2<i32>(16384i, -1008i), vec2<i32>(16132i, -976i), vec2<i32>(15888i, -952i), vec2<i32>(15650i, -920i), vec2<i32>(15420i, -892i), vec2<i32>(15197i, -872i), vec2<i32>(14979i, -840i), vec2<i32>(14769i, -820i), vec2<i32>(14564i, -800i), vec2<i32>(14364i, -776i), vec2<i32>(14170i, -756i), vec2<i32>(13981i, -736i), vec2<i32>(13797i, -716i), vec2<i32>(13618i, -700i), vec2<i32>(13443i, -680i), vec2<i32>(13273i, -664i), vec2<i32>(13107i, -648i), vec2<i32>(12945i, -628i), vec2<i32>(12788i, -620i), vec2<i32>(12633i, -600i), vec2<i32>(12483i, -588i), vec2<i32>(12336i, -572i), vec2<i32>(12193i, -560i), vec2<i32>(12053i, -548i), vec2<i32>(11916i, -536i), vec2<i32>(11782i, -524i), vec2<i32>(11651i, -512i), vec2<i32>(11523i, -500i), vec2<i32>(11398i, -492i), vec2<i32>(11275i, -480i), vec2<i32>(11155i, -468i), vec2<i32>(11038i, -460i), vec2<i32>(10923i, -452i), vec2<i32>(10810i, -440i), vec2<i32>(10700i, -432i), vec2<i32>(10592i, -424i), vec2<i32>(10486i, -416i), vec2<i32>(10382i, -408i), vec2<i32>(10280i, -400i), vec2<i32>(10180i, -392i), vec2<i32>(10082i, -384i), vec2<i32>(9986i, -376i), vec2<i32>(9892i, -368i), vec2<i32>(9800i, -364i), vec2<i32>(9709i, -356i), vec2<i32>(9620i, -348i), vec2<i32>(9533i, -344i), vec2<i32>(9447i, -340i), vec2<i32>(9362i, -332i), vec2<i32>(9279i, -324i), vec2<i32>(9198i, -320i), vec2<i32>(9118i, -316i), vec2<i32>(9039i, -308i), vec2<i32>(8962i, -304i), vec2<i32>(8886i, -296i), vec2<i32>(8812i, -296i), vec2<i32>(8738i, -288i), vec2<i32>(8666i, -284i), vec2<i32>(8595i, -280i), vec2<i32>(8525i, -276i), vec2<i32>(8456i, -268i), vec2<i32>(8389i, -268i), vec2<i32>(8322i, -260i), vec2<i32>(8257i, -260i));

@group(1) @binding(1) 
var<storage, read_write> attribute_setup: AttributeSetupBuffer;
@group(1) @binding(2) 
var<storage, read_write> derived_setup: DerivedSetupBuffer;
@group(1) @binding(4) 
var<storage, read_write> static_raster_state: StaticRasterStateBuffer;
@group(1) @binding(5) 
var<storage, read_write> depth_blend_state: DepthBlendStateBuffer;
@group(1) @binding(7) 
var<storage, read_write> tile_infos: TileInfoBuffer;
@group(1) @binding(8) 
var<storage, read_write> span_setups: SpanSetups;
@group(1) @binding(9) 
var<storage, read_write> span_offsets: SpanInfoOffsetBuffer;
@group(0) @binding(0) 
var<storage, read_write> vram8_: VRAM8_;
@group(0) @binding(1) 
var<storage, read_write> hidden_vram: HiddenVRAM;
@group(1) @binding(6) 
var<storage, read_write> state_indices: StateIndicesBuffer;
@group(2) @binding(0) 
var<uniform> global_constants: GlobalConstants;
@group(0) @binding(2) 
var<storage, read_write> tmem8_: TMEM8_;
@group(1) @binding(0) 
var<storage, read_write> triangle_setup: TriangleSetupBuffer;
@group(1) @binding(12) 
var<storage, read_write> tile_binning_coarse: TileBinningCoarse;
@group(1) @binding(11) 
var<storage, read_write> tile_binning: TileBinning;
@group(2) @binding(1) 
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

fn load_vram_color(index: ptr<function, u32>, slice: u32) {
    var slice_1: u32;
    var word: i32;

    slice_1 = slice;
    let _e71 = (*index);
    (*index) = (_e71 & 8388607u);
    let _e74 = (*index);
    let _e75 = slice_1;
    (*index) = (_e74 + (_e75 * 8388608u));
    let _e79 = (*index);
    let _e86 = vram8_.data[((_e79 ^ 3u) >> 2u)];
    let _e87 = (*index);
    word = i32(((_e86 >> (((_e87 ^ 3u) & 3u) * 8u)) & 255u));
    let _e99 = word;
    let _e100 = word;
    let _e101 = word;
    let _e102 = (*index);
    let _e110 = hidden_vram.data[((_e102 >> 1u) >> 2u)];
    let _e111 = (*index);
    current_color = vec4<i32>(_e99, _e100, _e101, i32(((_e110 >> (((_e111 >> 1u) & 3u) * 8u)) & 255u)));
    return;
}

fn load_vram_depth(index_1: ptr<function, u32>, slice_2: u32) {
    var slice_3: u32;
    var word_1: i32;

    slice_3 = slice_2;
    let _e71 = (*index_1);
    (*index_1) = (_e71 & 4194303u);
    let _e74 = (*index_1);
    let _e75 = slice_3;
    (*index_1) = (_e74 + (_e75 * 4194304u));
    let _e79 = (*index_1);
    let _e86 = vram8_.data[((_e79 ^ 1u) >> 1u)];
    let _e87 = (*index_1);
    word_1 = i32(((_e86 >> (((_e87 ^ 1u) & 1u) * 16u)) & 65535u));
    let _e99 = word_1;
    current_depth = (_e99 >> 2u);
    let _e103 = (*index_1);
    let _e108 = hidden_vram.data[(_e103 >> 2u)];
    let _e109 = (*index_1);
    let _e118 = word_1;
    current_dz = (i32(((_e108 >> ((_e109 & 3u) * 8u)) & 255u)) | ((_e118 & 3i) << 2u));
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
    let _e79 = (*coord);
    let _e80 = fb_width_1;
    let _e81 = fb_height_1;
    if all((_e79 < vec2<u32>(_e80, _e81))) {
        {
            let _e85 = (*coord);
            slice2d = (_e85 & vec2(0u));
            let _e90 = (*coord);
            (*coord) = (_e90 >> vec2(0u));
            let _e96 = slice2d;
            let _e100 = slice2d;
            slice_4 = ((_e96.y * 1u) + _e100.x);
            let _e104 = fb_addr_index_1;
            let _e105 = fb_width_1;
            let _e109 = (*coord);
            let _e113 = (*coord);
            index_2 = ((_e104 + ((_e105 >> 0u) * _e109.y)) + _e113.x);
            let _e117 = index_2;
            color_fb_index = _e117;
            let _e118 = index_2;
            param = _e118;
            let _e120 = slice_4;
            param_1_ = _e120;
            let _e123 = param_1_;
            load_vram_color((&param), _e123);
            let _e125 = fb_depth_addr_index_1;
            let _e126 = fb_width_1;
            let _e130 = (*coord);
            let _e134 = (*coord);
            index_2 = ((_e125 + ((_e126 >> 0u) * _e130.y)) + _e134.x);
            let _e137 = index_2;
            param_2_ = _e137;
            let _e139 = slice_4;
            param_3_ = _e139;
            let _e142 = param_3_;
            load_vram_depth((&param_2_), _e142);
            return;
        }
    } else {
        return;
    }
}

fn load_span_offsets(index_3: u32) -> SpanInfoOffsetsMem {
    var index_4: u32;
    var _844_: SpanInfoOffsetsMem;

    index_4 = index_3;
    let _e72 = index_4;
    let _e75 = span_offsets.elems[_e72];
    _844_.offset = _e75.offset;
    let _e78 = index_4;
    let _e81 = span_offsets.elems[_e78];
    _844_.ylo = _e81.ylo;
    let _e84 = index_4;
    let _e87 = span_offsets.elems[_e84];
    _844_.yhi = _e87.yhi;
    let _e90 = index_4;
    let _e93 = span_offsets.elems[_e90];
    _844_.padding = _e93.padding;
    let _e95 = _844_;
    return _e95;
}

fn load_span_setup(index_5: u32) -> SpanSetup {
    var index_6: u32;

    index_6 = index_5;
    let _e70 = index_6;
    let _e77 = span_setups.span_setups_raw[((_e70 * 16u) + 0u)];
    let _e79 = index_6;
    let _e88 = span_setups.span_setups_raw[(((_e79 * 16u) + 0u) + 1u)];
    let _e90 = index_6;
    let _e99 = span_setups.span_setups_raw[(((_e90 * 16u) + 0u) + 2u)];
    let _e101 = index_6;
    let _e110 = span_setups.span_setups_raw[(((_e101 * 16u) + 0u) + 3u)];
    let _e113 = index_6;
    let _e120 = span_setups.span_setups_raw[((_e113 * 16u) + 4u)];
    let _e122 = index_6;
    let _e131 = span_setups.span_setups_raw[(((_e122 * 16u) + 4u) + 1u)];
    let _e133 = index_6;
    let _e142 = span_setups.span_setups_raw[(((_e133 * 16u) + 4u) + 2u)];
    let _e144 = index_6;
    let _e153 = span_setups.span_setups_raw[(((_e144 * 16u) + 4u) + 3u)];
    let _e156 = index_6;
    let _e163 = span_setups.span_setups_raw[((_e156 * 16u) + 8u)];
    let _e166 = index_6;
    let _e173 = span_setups.span_setups_raw[((_e166 * 16u) + 8u)];
    let _e176 = index_6;
    let _e185 = span_setups.span_setups_raw[(((_e176 * 16u) + 8u) + 1u)];
    let _e188 = index_6;
    let _e197 = span_setups.span_setups_raw[(((_e188 * 16u) + 8u) + 1u)];
    let _e202 = index_6;
    let _e209 = span_setups.span_setups_raw[((_e202 * 16u) + 10u)];
    let _e212 = index_6;
    let _e219 = span_setups.span_setups_raw[((_e212 * 16u) + 10u)];
    let _e222 = index_6;
    let _e231 = span_setups.span_setups_raw[(((_e222 * 16u) + 10u) + 1u)];
    let _e234 = index_6;
    let _e243 = span_setups.span_setups_raw[(((_e234 * 16u) + 10u) + 1u)];
    let _e248 = index_6;
    let _e255 = span_setups.span_setups_raw[((_e248 * 16u) + 12u)];
    let _e257 = index_6;
    let _e264 = span_setups.span_setups_raw[((_e257 * 16u) + 13u)];
    let _e266 = index_6;
    let _e273 = span_setups.span_setups_raw[((_e266 * 16u) + 14u)];
    let _e275 = index_6;
    let _e282 = span_setups.span_setups_raw[((_e275 * 16u) + 15u)];
    let _e291 = index_6;
    let _e298 = span_setups.span_setups_raw[((_e291 * 16u) + 15u)];
    return SpanSetup(vec4<i32>(i32(_e77), i32(_e88), i32(_e99), i32(_e110)), vec4<i32>(i32(_e120), i32(_e131), i32(_e142), i32(_e153)), vec4<i32>(vec4<u32>((_e163 & 65535u), (_e173 >> 16u), (_e185 & 65535u), (_e197 >> 16u))), vec4<i32>(vec4<u32>((_e209 & 65535u), (_e219 >> 16u), (_e231 & 65535u), (_e243 >> 16u))), i32(_e255), i32(_e264), i32(_e273), i32(((i32(_e282) << 16u) >> 16u)), i32((_e298 >> 16u)));
}

fn load_attribute_setup(index_7: u32) -> AttributeSetupMem {
    var index_8: u32;
    var _531_: AttributeSetupMem;

    index_8 = index_7;
    let _e72 = index_8;
    let _e75 = attribute_setup.elems[_e72];
    _531_.rgba = _e75.rgba;
    let _e78 = index_8;
    let _e81 = attribute_setup.elems[_e78];
    _531_.drgba_dx = _e81.drgba_dx;
    let _e84 = index_8;
    let _e87 = attribute_setup.elems[_e84];
    _531_.drgba_de = _e87.drgba_de;
    let _e90 = index_8;
    let _e93 = attribute_setup.elems[_e90];
    _531_.drgba_dy = _e93.drgba_dy;
    let _e96 = index_8;
    let _e99 = attribute_setup.elems[_e96];
    _531_.stzw = _e99.stzw;
    let _e102 = index_8;
    let _e105 = attribute_setup.elems[_e102];
    _531_.dstzw_dx = _e105.dstzw_dx;
    let _e108 = index_8;
    let _e111 = attribute_setup.elems[_e108];
    _531_.dstzw_de = _e111.dstzw_de;
    let _e114 = index_8;
    let _e117 = attribute_setup.elems[_e114];
    _531_.dstzw_dy = _e117.dstzw_dy;
    let _e119 = _531_;
    return _e119;
}

fn load_static_rasterization_state(index_9: u32) -> StaticRasterizationState {
    var index_10: u32;

    index_10 = index_9;
    let _e70 = index_10;
    let _e73 = static_raster_state.elems[_e70];
    let _e77 = index_10;
    let _e80 = static_raster_state.elems[_e77];
    let _e84 = index_10;
    let _e87 = static_raster_state.elems[_e84];
    let _e91 = index_10;
    let _e94 = static_raster_state.elems[_e91];
    let _e98 = index_10;
    let _e101 = static_raster_state.elems[_e98];
    let _e103 = index_10;
    let _e106 = static_raster_state.elems[_e103];
    return StaticRasterizationState(vec4<i32>(vec4<u32>(_e73.combiner_inputs_rgb0_)), vec4<i32>(vec4<u32>(_e80.combiner_inputs_alpha0_)), vec4<i32>(vec4<u32>(_e87.combiner_inputs_rgb1_)), vec4<i32>(vec4<u32>(_e94.combiner_inputs_alpha1_)), _e101.flags, _e106.dither, 0i, 0i);
}

fn reseed_noise(x: u32, y: u32, primitive_offset: u32) {
    var x_1: u32;
    var y_1: u32;
    var primitive_offset_1: u32;
    var seed: vec3<u32>;

    x_1 = x;
    y_1 = y;
    primitive_offset_1 = primitive_offset;
    let _e74 = x_1;
    let _e75 = y_1;
    let _e76 = primitive_offset_1;
    seed = vec3<u32>(_e74, _e75, _e76);
    let _e79 = seed;
    let _e83 = seed;
    seed = (((_e79 >> vec3(8u)) ^ _e83.yzx) * vec3(1103515245u));
    let _e89 = seed;
    let _e93 = seed;
    seed = (((_e89 >> vec3(8u)) ^ _e93.yzx) * vec3(1103515245u));
    let _e99 = seed;
    let _e103 = seed;
    seed = (((_e99 >> vec3(8u)) ^ _e103.yzx) * vec3(1103515245u));
    let _e109 = seed;
    seeded_noise = i32((_e109.x >> 16u));
    return;
}

fn no_perspective_divide(stw: vec3<i32>) -> vec2<i32> {
    var stw_1: vec3<i32>;

    stw_1 = stw;
    let _e70 = stw_1;
    return _e70.xy;
}

fn perspective_get_lut(w: i32) -> vec2<i32> {
    var w_1: i32;
    var shift: i32;
    var normout: i32;
    var wnorm: i32;
    var local: array<vec2<i32>, 64> = _3061_;
    var table: vec2<i32>;
    var rcp: i32;

    w_1 = w;
    let _e71 = w_1;
    shift = min((14i - firstLeadingBit(_e71)), 14i);
    let _e77 = w_1;
    let _e78 = shift;
    normout = ((_e77 << u32(_e78)) & 16383i);
    let _e84 = normout;
    wnorm = (_e84 & 255i);
    let _e88 = normout;
    let _e95 = local[(_e88 >> 8u)];
    table = vec2<i32>(_e95);
    let _e98 = table;
    let _e100 = wnorm;
    let _e105 = table;
    rcp = (((_e98.y * _e100) >> 10u) + _e105.x);
    let _e109 = rcp;
    let _e110 = shift;
    return vec2<i32>(_e109, _e110);
}

fn perspective_divide(stw_2: vec3<i32>, overflow: ptr<function, bool>) -> vec2<i32> {
    var stw_3: vec3<i32>;
    var w_2: i32;
    var w_carry: bool;
    var param_1: i32;
    var table_1: vec2<i32>;
    var shift_1: i32;
    var prod: vec2<i32>;
    var temp_mask: i32;
    var out_of_bounds: vec2<i32>;
    var temp: vec2<i32>;
    var _3129_: vec2<i32>;
    var _3133_: vec2<i32>;
    var _3147_: bool;
    var _3153_: bool;
    var _3169_: bool;
    var _3175_: bool;

    stw_3 = stw_2;
    let _e71 = stw_3;
    w_2 = _e71.z;
    let _e74 = w_2;
    w_carry = (_e74 <= 0i);
    let _e78 = w_2;
    w_2 = (_e78 & 32767i);
    let _e81 = w_2;
    param_1 = _e81;
    let _e83 = param_1;
    let _e84 = perspective_get_lut(_e83);
    table_1 = _e84;
    let _e86 = table_1;
    shift_1 = _e86.y;
    let _e89 = stw_3;
    let _e91 = table_1;
    prod = (_e89.xy * vec2(_e91.x));
    let _e98 = shift_1;
    temp_mask = (1073741823i & -((536870912i >> u32(_e98))));
    let _e104 = prod;
    let _e105 = temp_mask;
    out_of_bounds = (_e104 & vec2(_e105));
    let _e110 = shift_1;
    if (_e110 != 14i) {
        {
            let _e113 = prod;
            _3129_ = _e113;
            let _e115 = _3129_;
            let _e117 = shift_1;
            _3133_ = (_e115 >> vec2<u32>(vec2((13i - _e117))));
            let _e123 = _3133_;
            prod = _e123;
            let _e124 = _3133_;
            temp = _e124;
        }
    } else {
        {
            let _e125 = prod;
            temp = (_e125 << vec2(1u));
        }
    }
    let _e131 = out_of_bounds;
    if any((_e131 != vec2(0i))) {
        {
            let _e136 = out_of_bounds;
            let _e138 = temp_mask;
            _3147_ = (_e136.x != _e138);
            let _e142 = _3147_;
            if _e142 {
                {
                    let _e143 = out_of_bounds;
                    _3153_ = (_e143.x != 0i);
                }
            } else {
                {
                    let _e147 = _3147_;
                    _3153_ = _e147;
                }
            }
            let _e148 = _3153_;
            if _e148 {
                {
                    let _e149 = prod;
                    if ((_e149.x & 536870912i) == 0i) {
                        {
                            temp.x = 32767i;
                        }
                    } else {
                        {
                            temp.x = -32768i;
                        }
                    }
                    (*overflow) = true;
                }
            }
            let _e161 = out_of_bounds;
            let _e163 = temp_mask;
            _3169_ = (_e161.y != _e163);
            let _e167 = _3169_;
            if _e167 {
                {
                    let _e168 = out_of_bounds;
                    _3175_ = (_e168.y != 0i);
                }
            } else {
                {
                    let _e172 = _3169_;
                    _3175_ = _e172;
                }
            }
            let _e173 = _3175_;
            if _e173 {
                {
                    let _e174 = prod;
                    if ((_e174.y & 536870912i) == 0i) {
                        {
                            temp.y = 32767i;
                        }
                    } else {
                        {
                            temp.y = -32768i;
                        }
                    }
                    (*overflow) = true;
                }
            }
        }
    }
    let _e186 = w_carry;
    if _e186 {
        {
            temp = vec2(32767i);
            (*overflow) = true;
        }
    }
    let _e190 = temp;
    return clamp(_e190, vec2(-65536i), vec2(65535i));
}

fn interpolate_st_copy(span: SpanSetup, dstzw_dx: vec4<i32>, x_2: i32, perspective: bool, flip: bool, st: ptr<function, vec2<i32>>, s_offset: ptr<function, i32>) {
    var span_1: SpanSetup;
    var dstzw_dx_1: vec4<i32>;
    var x_3: i32;
    var perspective_1: bool;
    var flip_1: bool;
    var _3271_: i32;
    var dx: i32;
    var snapped_dx: i32;
    var local_1: i32;
    var lerp_dx: i32;
    var stw_4: vec3<i32>;
    var param_2: vec3<i32>;
    var st_overflow: bool;
    var param_1_1: bool;
    var _3330_: vec2<i32>;
    var param_2_1: vec3<i32>;

    span_1 = span;
    dstzw_dx_1 = dstzw_dx;
    x_3 = x_2;
    perspective_1 = perspective;
    flip_1 = flip;
    let _e81 = flip_1;
    if _e81 {
        {
            let _e82 = x_3;
            let _e83 = span_1;
            _3271_ = (_e82 - _e83.start_x);
        }
    } else {
        {
            let _e86 = span_1;
            let _e88 = x_3;
            _3271_ = (_e86.end_x - _e88);
        }
    }
    let _e90 = _3271_;
    dx = _e90;
    let _e92 = dx;
    dx = (_e92 >> 0u);
    let _e96 = dx;
    let _e97 = global_constants;
    snapped_dx = (_e96 & _e97.fb_info.dx_mask);
    let _e102 = dx;
    let _e103 = snapped_dx;
    (*s_offset) = (_e102 - _e103);
    let _e105 = dx;
    let _e106 = global_constants;
    let _e111 = flip_1;
    if _e111 {
        local_1 = 1i;
    } else {
        local_1 = -1i;
    }
    let _e116 = local_1;
    lerp_dx = ((_e105 >> u32(_e106.fb_info.dx_shift)) * _e116);
    let _e119 = span_1;
    let _e122 = dstzw_dx_1;
    let _e128 = lerp_dx;
    stw_4 = (_e119.stzw.xyw + ((_e122.xyw & vec3(-32i)) * vec3(_e128)));
    let _e133 = perspective_1;
    if _e133 {
        {
            let _e134 = stw_4;
            param_2 = (_e134 >> vec3(16u));
            let _e142 = st_overflow;
            param_1_1 = _e142;
            let _e144 = param_2;
            let _e147 = perspective_divide(_e144, (&param_1_1));
            _3330_ = _e147;
            let _e149 = param_1_1;
            st_overflow = _e149;
            let _e150 = _3330_;
            (*st) = _e150;
            return;
        }
    } else {
        {
            let _e151 = stw_4;
            param_2_1 = (_e151 >> vec3(16u));
            let _e158 = param_2_1;
            let _e159 = no_perspective_divide(_e158);
            (*st) = _e159;
            return;
        }
    }
}

fn load_tile_info(index_11: u32) -> TileInfo {
    var index_12: u32;

    index_12 = index_11;
    let _e70 = index_12;
    let _e77 = tile_infos.tile_infos_raw[((_e70 * 8u) + 0u)];
    let _e78 = index_12;
    let _e85 = tile_infos.tile_infos_raw[((_e78 * 8u) + 1u)];
    let _e86 = index_12;
    let _e93 = tile_infos.tile_infos_raw[((_e86 * 8u) + 2u)];
    let _e94 = index_12;
    let _e101 = tile_infos.tile_infos_raw[((_e94 * 8u) + 3u)];
    let _e102 = index_12;
    let _e109 = tile_infos.tile_infos_raw[((_e102 * 8u) + 4u)];
    let _e110 = index_12;
    let _e117 = tile_infos.tile_infos_raw[((_e110 * 8u) + 5u)];
    let _e118 = index_12;
    let _e125 = tile_infos.tile_infos_raw[((_e118 * 8u) + 6u)];
    let _e129 = index_12;
    let _e136 = tile_infos.tile_infos_raw[((_e129 * 8u) + 6u)];
    let _e142 = index_12;
    let _e149 = tile_infos.tile_infos_raw[((_e142 * 8u) + 6u)];
    let _e155 = index_12;
    let _e162 = tile_infos.tile_infos_raw[((_e155 * 8u) + 6u)];
    let _e168 = index_12;
    let _e175 = tile_infos.tile_infos_raw[((_e168 * 8u) + 7u)];
    let _e179 = index_12;
    let _e186 = tile_infos.tile_infos_raw[((_e179 * 8u) + 7u)];
    let _e192 = index_12;
    let _e199 = tile_infos.tile_infos_raw[((_e192 * 8u) + 7u)];
    let _e205 = index_12;
    let _e212 = tile_infos.tile_infos_raw[((_e205 * 8u) + 7u)];
    return TileInfo(_e77, _e85, _e93, _e101, _e109, _e117, i32((_e125 & 255u)), i32(((_e136 >> 8u) & 255u)), i32(((_e149 >> 16u) & 255u)), i32(((_e162 >> 24u) & 255u)), i32((_e175 & 255u)), i32(((_e186 >> 8u) & 255u)), i32(((_e199 >> 16u) & 255u)), i32(((_e212 >> 24u) & 255u)));
}

fn shift_coord(coord_1: ptr<function, i32>, lo: i32, shift_2: i32) -> i32 {
    var lo_1: i32;
    var shift_3: i32;

    lo_1 = lo;
    shift_3 = shift_2;
    let _e73 = (*coord_1);
    (*coord_1) = clamp(_e73, -32768i, 32767i);
    let _e78 = shift_3;
    if (_e78 < 11i) {
        {
            let _e81 = (*coord_1);
            let _e82 = shift_3;
            (*coord_1) = (_e81 >> u32(_e82));
        }
    } else {
        {
            let _e85 = (*coord_1);
            let _e87 = shift_3;
            (*coord_1) = (_e85 << u32((32i - _e87)));
            let _e91 = (*coord_1);
            (*coord_1) = (_e91 >> 16u);
        }
    }
    let _e95 = (*coord_1);
    let _e96 = lo_1;
    (*coord_1) = (_e95 - (_e96 << 3u));
    let _e101 = (*coord_1);
    return _e101;
}

fn texel_mask_s(tile: TileInfo, s: ptr<function, i32>) -> i32 {
    var tile_1: TileInfo;
    var mask: i32;

    tile_1 = tile;
    let _e71 = tile_1;
    if (_e71.mask_s != 0i) {
        {
            let _e76 = tile_1;
            mask = (1i << u32(_e76.mask_s));
            let _e81 = tile_1;
            if ((_e81.flags & 2i) != 0i) {
                {
                    let _e87 = (*s);
                    let _e88 = (*s);
                    let _e89 = mask;
                    (*s) = (_e87 ^ max(((_e88 & _e89) - 1i), 0i));
                }
            }
            let _e96 = (*s);
            let _e97 = mask;
            (*s) = (_e96 & (_e97 - 1i));
        }
    }
    let _e101 = (*s);
    return _e101;
}

fn texel_mask_t(tile_2: TileInfo, t: ptr<function, i32>) -> i32 {
    var tile_3: TileInfo;
    var mask_1: i32;

    tile_3 = tile_2;
    let _e71 = tile_3;
    if (_e71.mask_t != 0i) {
        {
            let _e76 = tile_3;
            mask_1 = (1i << u32(_e76.mask_t));
            let _e81 = tile_3;
            if ((_e81.flags & 8i) != 0i) {
                {
                    let _e87 = (*t);
                    let _e88 = (*t);
                    let _e89 = mask_1;
                    (*t) = (_e87 ^ max(((_e88 & _e89) - 1i), 0i));
                }
            }
            let _e96 = (*t);
            let _e97 = mask_1;
            (*t) = (_e96 & (_e97 - 1i));
        }
    }
    let _e101 = (*t);
    return _e101;
}

fn texel_mask_s_copy(tile_4: TileInfo, s_1: i32) -> vec2<i32> {
    var tile_5: TileInfo;
    var s_2: i32;
    var multi_s: vec2<i32>;
    var mask_2: i32;

    tile_5 = tile_4;
    s_2 = s_1;
    let _e72 = s_2;
    multi_s = (vec2(_e72) + vec2<i32>(0i, 1i));
    let _e79 = tile_5;
    if (_e79.mask_s != 0i) {
        {
            let _e84 = tile_5;
            mask_2 = (1i << u32(_e84.mask_s));
            let _e89 = tile_5;
            if ((_e89.flags & 2i) != 0i) {
                {
                    let _e95 = multi_s;
                    let _e96 = multi_s;
                    let _e97 = mask_2;
                    multi_s = (_e95 ^ max(((_e96 & vec2(_e97)) - vec2(1i)), vec2(0i)));
                }
            }
            let _e107 = multi_s;
            let _e108 = mask_2;
            multi_s = (_e107 & vec2((_e108 - 1i)));
        }
    }
    let _e113 = multi_s;
    return _e113;
}

fn sample_texture_copy_word(tile_6: TileInfo, tmem_instance: u32, st_1: ptr<function, vec2<i32>>, s_offset_1: i32, tlut: bool, tlut_type: bool) -> i32 {
    var tile_7: TileInfo;
    var tmem_instance_1: u32;
    var s_offset_2: i32;
    var tlut_1: bool;
    var tlut_type_1: bool;
    var high_word: bool;
    var _4478_: bool;
    var replicate_8bpp: bool;
    var s_shamt: i32;
    var large_texel: bool;
    var local_2: i32;
    var idx_mask: i32;
    var samp: i32;
    var param_3: TileInfo;
    var param_1_2: i32;
    var s_3: vec2<i32>;
    var param_2_2: TileInfo;
    var param_3_1: i32;
    var _4517_: i32;
    var t_1: i32;
    var tbase: u32;
    var nibble_offset: vec2<u32>;
    var index_13: vec2<u32>;
    var samp0_: i32;
    var samp1_: i32;
    var param_4_: TileInfo;
    var param_5_: i32;
    var _4649_: i32;
    var s_1_: i32;
    var param_6_: TileInfo;
    var param_7_: i32;
    var _4656_: i32;
    var t_1_: i32;
    var tbase_1_: u32;
    var nibble_offset_1_: u32;
    var index_1_: u32;

    tile_7 = tile_6;
    tmem_instance_1 = tmem_instance;
    s_offset_2 = s_offset_1;
    tlut_1 = tlut;
    tlut_type_1 = tlut_type;
    let _e79 = s_offset_2;
    high_word = (_e79 < 2i);
    let _e84 = high_word;
    if _e84 {
        {
            let _e85 = tile_7;
            _4478_ = (_e85.size != 2i);
        }
    } else {
        {
            let _e89 = high_word;
            _4478_ = _e89;
        }
    }
    let _e90 = _4478_;
    let _e91 = tlut_1;
    replicate_8bpp = (_e90 && !(_e91));
    let _e95 = tile_7;
    s_shamt = min(_e95.size, 2i);
    let _e100 = tile_7;
    large_texel = (_e100.size == 3i);
    let _e105 = large_texel;
    let _e106 = tlut_1;
    if (_e105 || _e106) {
        local_2 = 1023i;
    } else {
        local_2 = 2047i;
    }
    let _e111 = local_2;
    idx_mask = _e111;
    let _e114 = replicate_8bpp;
    if _e114 {
        {
            let _e116 = (*st_1);
            let _e119 = s_offset_2;
            (*st_1).x = (_e116.x + (2i * _e119));
            let _e122 = tile_7;
            param_3 = _e122;
            let _e124 = (*st_1);
            param_1_2 = _e124.x;
            let _e127 = param_3;
            let _e128 = param_1_2;
            let _e129 = texel_mask_s_copy(_e127, _e128);
            s_3 = _e129;
            let _e131 = tile_7;
            param_2_2 = _e131;
            let _e133 = (*st_1);
            param_3_1 = _e133.y;
            let _e136 = param_2_2;
            let _e139 = texel_mask_t(_e136, (&param_3_1));
            _4517_ = _e139;
            let _e141 = _4517_;
            t_1 = _e141;
            let _e143 = tile_7;
            let _e145 = tile_7;
            let _e147 = t_1;
            tbase = (_e143.offset + (_e145.stride * u32(_e147)));
            let _e152 = tbase;
            let _e156 = s_3;
            let _e157 = s_shamt;
            nibble_offset = ((vec2((_e152 * 2u)) + vec2<u32>((_e156 << vec2<u32>(vec2(_e157))))) & vec2(8191u));
            let _e167 = nibble_offset;
            let _e168 = t_1;
            nibble_offset = (_e167 ^ vec2(((u32(_e168) & 1u) * 8u)));
            let _e176 = nibble_offset;
            index_13 = (_e176 >> vec2(2u));
            let _e181 = index_13;
            let _e182 = idx_mask;
            index_13 = (_e181 & vec2(u32(_e182)));
            let _e186 = tmem_instance_1;
            let _e190 = index_13;
            let _e200 = tmem8_.raw[((u32(_e186) * 1024u) + (u32((_e190.x ^ 1u)) / 2u))];
            let _e201 = index_13;
            samp0_ = i32(((_e200 >> ((u32((_e201.x ^ 1u)) & 1u) * 16u)) & 65535u));
            let _e215 = tmem_instance_1;
            let _e219 = index_13;
            let _e229 = tmem8_.raw[((u32(_e215) * 1024u) + (u32((_e219.y ^ 1u)) / 2u))];
            let _e230 = index_13;
            samp1_ = i32(((_e229 >> ((u32((_e230.y ^ 1u)) & 1u) * 16u)) & 65535u));
            let _e244 = tile_7;
            if (_e244.size == 1i) {
                {
                    let _e248 = samp0_;
                    let _e251 = nibble_offset;
                    samp0_ = (_e248 >> u32((8i - (4i * i32((_e251.x & 2u))))));
                    let _e260 = samp1_;
                    let _e263 = nibble_offset;
                    samp1_ = (_e260 >> u32((8i - (4i * i32((_e263.y & 2u))))));
                    let _e272 = samp0_;
                    samp0_ = (_e272 & 255i);
                    let _e275 = samp1_;
                    samp1_ = (_e275 & 255i);
                }
            } else {
                {
                    let _e278 = tile_7;
                    if (_e278.size == 0i) {
                        {
                            let _e282 = samp0_;
                            let _e285 = nibble_offset;
                            samp0_ = (_e282 >> u32((12i - (4i * i32((_e285.x & 3u))))));
                            let _e294 = samp1_;
                            let _e297 = nibble_offset;
                            samp1_ = (_e294 >> u32((12i - (4i * i32((_e297.y & 3u))))));
                            let _e306 = samp0_;
                            samp0_ = ((_e306 & 15i) * 17i);
                            let _e311 = samp1_;
                            samp1_ = ((_e311 & 15i) * 17i);
                        }
                    } else {
                        {
                            let _e316 = samp0_;
                            samp0_ = (_e316 >> 8u);
                            let _e320 = samp1_;
                            samp1_ = (_e320 >> 8u);
                        }
                    }
                }
            }
            let _e324 = samp0_;
            let _e328 = samp1_;
            samp = ((_e324 << 8u) | _e328);
        }
    } else {
        {
            let _e331 = (*st_1);
            let _e333 = s_offset_2;
            (*st_1).x = (_e331.x + _e333);
            let _e335 = tile_7;
            param_4_ = _e335;
            let _e337 = (*st_1);
            param_5_ = _e337.x;
            let _e340 = param_4_;
            let _e343 = texel_mask_s(_e340, (&param_5_));
            _4649_ = _e343;
            let _e345 = _4649_;
            s_1_ = _e345;
            let _e347 = tile_7;
            param_6_ = _e347;
            let _e349 = (*st_1);
            param_7_ = _e349.y;
            let _e352 = param_6_;
            let _e355 = texel_mask_t(_e352, (&param_7_));
            _4656_ = _e355;
            let _e357 = _4656_;
            t_1_ = _e357;
            let _e359 = tile_7;
            let _e361 = tile_7;
            let _e363 = t_1_;
            tbase_1_ = (_e359.offset + (_e361.stride * u32(_e363)));
            let _e368 = tbase_1_;
            let _e371 = s_1_;
            let _e372 = s_shamt;
            nibble_offset_1_ = (((_e368 * 2u) + u32((_e371 << u32(_e372)))) & 8191u);
            let _e380 = nibble_offset_1_;
            let _e381 = t_1_;
            nibble_offset_1_ = (_e380 ^ ((u32(_e381) & 1u) * 8u));
            let _e388 = nibble_offset_1_;
            index_1_ = (_e388 >> 2u);
            let _e392 = index_1_;
            let _e393 = idx_mask;
            index_1_ = (_e392 & u32(_e393));
            let _e396 = tmem_instance_1;
            let _e400 = index_1_;
            let _e409 = tmem8_.raw[((u32(_e396) * 1024u) + (u32((_e400 ^ 1u)) / 2u))];
            let _e410 = index_1_;
            samp = i32(((_e409 >> ((u32((_e410 ^ 1u)) & 1u) * 16u)) & 65535u));
            let _e422 = tlut_1;
            if _e422 {
                {
                    let _e423 = tile_7;
                    if (_e423.size == 0i) {
                        {
                            let _e427 = samp;
                            let _e430 = nibble_offset_1_;
                            samp = (_e427 >> u32(i32((12u - (4u * (_e430 & 3u))))));
                            let _e438 = samp;
                            samp = (_e438 & 15i);
                            let _e441 = samp;
                            let _e442 = tile_7;
                            samp = (_e441 | (_e442.palette << 4u));
                            let _e448 = samp;
                            samp = (_e448 << 2u);
                            let _e452 = samp;
                            let _e453 = s_offset_2;
                            samp = (_e452 + _e453);
                        }
                    } else {
                        {
                            let _e455 = samp;
                            let _e458 = nibble_offset_1_;
                            samp = (_e455 >> u32(i32((8u - (4u * (_e458 & 2u))))));
                            let _e466 = samp;
                            samp = (_e466 & 255i);
                            let _e469 = samp;
                            samp = (_e469 << 2u);
                            let _e473 = samp;
                            let _e474 = s_offset_2;
                            samp = (_e473 + _e474);
                        }
                    }
                    let _e476 = tmem_instance_1;
                    let _e480 = samp;
                    let _e491 = tmem8_.raw[((u32(_e476) * 1024u) + (u32(((_e480 | 1024i) ^ 1i)) / 2u))];
                    let _e492 = samp;
                    samp = i32(((_e491 >> ((u32(((_e492 | 1024i) ^ 1i)) & 1u) * 16u)) & 65535u));
                }
            }
        }
    }
    let _e506 = samp;
    return _e506;
}

fn sample_texture_copy(tile_8: TileInfo, tmem_instance_2: u32, st_2: ptr<function, vec2<i32>>, s_offset_3: i32, tlut_2: bool, tlut_type_2: bool) -> i32 {
    var tile_9: TileInfo;
    var tmem_instance_3: u32;
    var s_offset_4: i32;
    var tlut_3: bool;
    var tlut_type_3: bool;
    var param_4: i32;
    var param_1_3: i32;
    var param_2_3: i32;
    var _4758_: i32;
    var param_3_2: i32;
    var param_4_1: i32;
    var param_5_1: i32;
    var _4770_: i32;
    var samp_1: i32;
    var param_6_1: TileInfo;
    var param_7_1: u32;
    var param_8_: vec2<i32>;
    var param_9_: i32;
    var param_10_: bool;
    var param_11_: bool;
    var _4800_: i32;
    var param_12_: TileInfo;
    var param_13_: u32;
    var param_14_: vec2<i32>;
    var param_15_: i32;
    var param_16_: bool;
    var param_17_: bool;
    var _4822_: i32;

    tile_9 = tile_8;
    tmem_instance_3 = tmem_instance_2;
    s_offset_4 = s_offset_3;
    tlut_3 = tlut_2;
    tlut_type_3 = tlut_type_2;
    let _e79 = (*st_2);
    param_4 = _e79.x;
    let _e82 = tile_9;
    param_1_3 = i32(_e82.slo);
    let _e86 = tile_9;
    param_2_3 = _e86.shift_s;
    let _e90 = param_1_3;
    let _e91 = param_2_3;
    let _e93 = shift_coord((&param_4), _e90, _e91);
    _4758_ = _e93;
    let _e96 = _4758_;
    (*st_2).x = _e96;
    let _e97 = (*st_2);
    param_3_2 = _e97.y;
    let _e100 = tile_9;
    param_4_1 = i32(_e100.tlo);
    let _e104 = tile_9;
    param_5_1 = _e104.shift_t;
    let _e108 = param_4_1;
    let _e109 = param_5_1;
    let _e111 = shift_coord((&param_3_2), _e108, _e109);
    _4770_ = _e111;
    let _e114 = _4770_;
    (*st_2).y = _e114;
    let _e115 = (*st_2);
    (*st_2) = (_e115 >> vec2(5u));
    let _e122 = global_constants;
    if (_e122.fb_info.fb_size == 0i) {
        {
            samp_1 = 0i;
        }
    } else {
        {
            let _e128 = global_constants;
            if (_e128.fb_info.fb_size == 1i) {
                {
                    let _e133 = tile_9;
                    param_6_1 = _e133;
                    let _e135 = tmem_instance_3;
                    param_7_1 = _e135;
                    let _e137 = (*st_2);
                    param_8_ = _e137;
                    let _e139 = s_offset_4;
                    param_9_ = (_e139 >> 1u);
                    let _e144 = tlut_3;
                    param_10_ = _e144;
                    let _e146 = tlut_type_3;
                    param_11_ = _e146;
                    let _e148 = param_6_1;
                    let _e149 = param_7_1;
                    let _e151 = param_9_;
                    let _e152 = param_10_;
                    let _e153 = param_11_;
                    let _e155 = sample_texture_copy_word(_e148, _e149, (&param_8_), _e151, _e152, _e153);
                    _4800_ = _e155;
                    let _e157 = _4800_;
                    samp_1 = _e157;
                    let _e158 = samp_1;
                    let _e161 = s_offset_4;
                    samp_1 = (_e158 >> u32((8i - (8i * (_e161 & 1i)))));
                    let _e168 = samp_1;
                    samp_1 = (_e168 & 255i);
                }
            } else {
                {
                    let _e171 = tile_9;
                    param_12_ = _e171;
                    let _e173 = tmem_instance_3;
                    param_13_ = _e173;
                    let _e175 = (*st_2);
                    param_14_ = _e175;
                    let _e177 = s_offset_4;
                    param_15_ = _e177;
                    let _e179 = tlut_3;
                    param_16_ = _e179;
                    let _e181 = tlut_type_3;
                    param_17_ = _e181;
                    let _e183 = param_12_;
                    let _e184 = param_13_;
                    let _e186 = param_15_;
                    let _e187 = param_16_;
                    let _e188 = param_17_;
                    let _e190 = sample_texture_copy_word(_e183, _e184, (&param_14_), _e186, _e187, _e188);
                    _4822_ = _e190;
                    let _e192 = _4822_;
                    samp_1 = _e192;
                }
            }
        }
    }
    let _e193 = samp_1;
    return _e193;
}

fn compute_coverage(xleft: vec4<i32>, xright: vec4<i32>, x_4: i32) -> i32 {
    var xleft_1: vec4<i32>;
    var xright_1: vec4<i32>;
    var x_5: i32;
    var xshift: vec4<i32>;
    var clip_lo_x01_: vec4<bool>;
    var clip_lo_x23_: vec4<bool>;
    var clip_hi_x01_: vec4<bool>;
    var clip_hi_x23_: vec4<bool>;
    var clip_x0_: vec4<i32>;
    var clip_x1_: vec4<i32>;
    var clip_x: vec4<i32>;
    var clip_coverage: i32;

    xleft_1 = xleft;
    xright_1 = xright;
    x_5 = x_4;
    let _e79 = x_5;
    xshift = (vec4<i32>(0i, 4i, 2i, 6i) + vec4((_e79 << 3u)));
    let _e86 = xshift;
    let _e87 = xleft_1;
    clip_lo_x01_ = (_e86 < _e87.xxyy);
    let _e91 = xshift;
    let _e92 = xleft_1;
    clip_lo_x23_ = (_e91 < _e92.zzww);
    let _e96 = xshift;
    let _e97 = xright_1;
    clip_hi_x01_ = (_e96 >= _e97.xxyy);
    let _e101 = xshift;
    let _e102 = xright_1;
    clip_hi_x23_ = (_e101 >= _e102.zzww);
    let _e106 = clip_lo_x01_;
    let _e112 = clip_hi_x01_;
    clip_x0_ = (select(vec4(0i), vec4(1i), _e106) | select(vec4(0i), vec4(1i), _e112));
    let _e120 = clip_lo_x23_;
    let _e126 = clip_hi_x23_;
    clip_x1_ = (select(vec4(0i), vec4(1i), _e120) | select(vec4(0i), vec4(1i), _e126));
    let _e134 = clip_x0_;
    let _e141 = clip_x1_;
    clip_x = ((_e134 * vec4<i32>(1i, 2i, 4i, 8i)) + (_e141 * vec4<i32>(16i, 32i, 64i, 128i)));
    let _e150 = clip_x;
    let _e152 = clip_x;
    let _e155 = clip_x;
    let _e157 = clip_x;
    clip_coverage = ((_e150.x | _e152.y) | (_e155.z | _e157.w));
    let _e162 = clip_coverage;
    return (~(_e162) & 255i);
}

fn load_derived_setup(index_14: u32) -> DerivedSetup {
    var index_15: u32;

    index_15 = index_14;
    let _e70 = index_15;
    let _e77 = derived_setup.derived_setup_raw[((_e70 * 14u) + 0u)];
    let _e80 = index_15;
    let _e87 = derived_setup.derived_setup_raw[((_e80 * 14u) + 0u)];
    let _e92 = index_15;
    let _e99 = derived_setup.derived_setup_raw[((_e92 * 14u) + 0u)];
    let _e104 = index_15;
    let _e111 = derived_setup.derived_setup_raw[((_e104 * 14u) + 0u)];
    let _e116 = index_15;
    let _e123 = derived_setup.derived_setup_raw[((_e116 * 14u) + 1u)];
    let _e126 = index_15;
    let _e133 = derived_setup.derived_setup_raw[((_e126 * 14u) + 1u)];
    let _e138 = index_15;
    let _e145 = derived_setup.derived_setup_raw[((_e138 * 14u) + 1u)];
    let _e150 = index_15;
    let _e157 = derived_setup.derived_setup_raw[((_e150 * 14u) + 1u)];
    let _e162 = index_15;
    let _e169 = derived_setup.derived_setup_raw[((_e162 * 14u) + 2u)];
    let _e172 = index_15;
    let _e179 = derived_setup.derived_setup_raw[((_e172 * 14u) + 2u)];
    let _e184 = index_15;
    let _e191 = derived_setup.derived_setup_raw[((_e184 * 14u) + 2u)];
    let _e196 = index_15;
    let _e203 = derived_setup.derived_setup_raw[((_e196 * 14u) + 2u)];
    let _e208 = index_15;
    let _e215 = derived_setup.derived_setup_raw[((_e208 * 14u) + 3u)];
    let _e218 = index_15;
    let _e225 = derived_setup.derived_setup_raw[((_e218 * 14u) + 3u)];
    let _e230 = index_15;
    let _e237 = derived_setup.derived_setup_raw[((_e230 * 14u) + 3u)];
    let _e242 = index_15;
    let _e249 = derived_setup.derived_setup_raw[((_e242 * 14u) + 3u)];
    let _e254 = index_15;
    let _e261 = derived_setup.derived_setup_raw[((_e254 * 14u) + 4u)];
    let _e264 = index_15;
    let _e271 = derived_setup.derived_setup_raw[((_e264 * 14u) + 4u)];
    let _e276 = index_15;
    let _e283 = derived_setup.derived_setup_raw[((_e276 * 14u) + 4u)];
    let _e288 = index_15;
    let _e295 = derived_setup.derived_setup_raw[((_e288 * 14u) + 4u)];
    let _e300 = index_15;
    let _e307 = derived_setup.derived_setup_raw[((_e300 * 14u) + 5u)];
    let _e310 = index_15;
    let _e317 = derived_setup.derived_setup_raw[((_e310 * 14u) + 5u)];
    let _e322 = index_15;
    let _e329 = derived_setup.derived_setup_raw[((_e322 * 14u) + 5u)];
    let _e334 = index_15;
    let _e341 = derived_setup.derived_setup_raw[((_e334 * 14u) + 5u)];
    let _e346 = index_15;
    let _e353 = derived_setup.derived_setup_raw[((_e346 * 14u) + 6u)];
    let _e356 = index_15;
    let _e363 = derived_setup.derived_setup_raw[((_e356 * 14u) + 6u)];
    let _e368 = index_15;
    let _e375 = derived_setup.derived_setup_raw[((_e368 * 14u) + 6u)];
    let _e380 = index_15;
    let _e387 = derived_setup.derived_setup_raw[((_e380 * 14u) + 6u)];
    let _e392 = index_15;
    let _e399 = derived_setup.derived_setup_raw[((_e392 * 14u) + 7u)];
    let _e402 = index_15;
    let _e409 = derived_setup.derived_setup_raw[((_e402 * 14u) + 7u)];
    let _e414 = index_15;
    let _e421 = derived_setup.derived_setup_raw[((_e414 * 14u) + 7u)];
    let _e426 = index_15;
    let _e433 = derived_setup.derived_setup_raw[((_e426 * 14u) + 7u)];
    let _e438 = index_15;
    let _e445 = derived_setup.derived_setup_raw[((_e438 * 14u) + 8u)];
    let _e448 = index_15;
    let _e455 = derived_setup.derived_setup_raw[((_e448 * 14u) + 8u)];
    let _e460 = index_15;
    let _e467 = derived_setup.derived_setup_raw[((_e460 * 14u) + 8u)];
    let _e472 = index_15;
    let _e479 = derived_setup.derived_setup_raw[((_e472 * 14u) + 8u)];
    let _e484 = index_15;
    let _e491 = derived_setup.derived_setup_raw[((_e484 * 14u) + 9u)];
    let _e494 = index_15;
    let _e501 = derived_setup.derived_setup_raw[((_e494 * 14u) + 9u)];
    let _e506 = index_15;
    let _e513 = derived_setup.derived_setup_raw[((_e506 * 14u) + 9u)];
    let _e518 = index_15;
    let _e525 = derived_setup.derived_setup_raw[((_e518 * 14u) + 9u)];
    let _e530 = index_15;
    let _e537 = derived_setup.derived_setup_raw[((_e530 * 14u) + 10u)];
    let _e538 = index_15;
    let _e545 = derived_setup.derived_setup_raw[((_e538 * 14u) + 11u)];
    let _e549 = index_15;
    let _e556 = derived_setup.derived_setup_raw[((_e549 * 14u) + 11u)];
    let _e562 = index_15;
    let _e569 = derived_setup.derived_setup_raw[((_e562 * 14u) + 11u)];
    let _e575 = index_15;
    let _e582 = derived_setup.derived_setup_raw[((_e575 * 14u) + 12u)];
    let _e590 = index_15;
    let _e597 = derived_setup.derived_setup_raw[((_e590 * 14u) + 12u)];
    let _e602 = index_15;
    let _e611 = derived_setup.derived_setup_raw[(((_e602 * 14u) + 12u) + 1u)];
    let _e619 = index_15;
    let _e628 = derived_setup.derived_setup_raw[(((_e619 * 14u) + 12u) + 1u)];
    return DerivedSetup(vec4<i32>(vec4<u32>((_e77 & 255u), ((_e87 >> 8u) & 255u), ((_e99 >> 16u) & 255u), (_e111 >> 24u))), vec4<i32>(vec4<u32>((_e123 & 255u), ((_e133 >> 8u) & 255u), ((_e145 >> 16u) & 255u), (_e157 >> 24u))), vec4<i32>(vec4<u32>((_e169 & 255u), ((_e179 >> 8u) & 255u), ((_e191 >> 16u) & 255u), (_e203 >> 24u))), vec4<i32>(vec4<u32>((_e215 & 255u), ((_e225 >> 8u) & 255u), ((_e237 >> 16u) & 255u), (_e249 >> 24u))), vec4<i32>(vec4<u32>((_e261 & 255u), ((_e271 >> 8u) & 255u), ((_e283 >> 16u) & 255u), (_e295 >> 24u))), vec4<i32>(vec4<u32>((_e307 & 255u), ((_e317 >> 8u) & 255u), ((_e329 >> 16u) & 255u), (_e341 >> 24u))), vec4<i32>(vec4<u32>((_e353 & 255u), ((_e363 >> 8u) & 255u), ((_e375 >> 16u) & 255u), (_e387 >> 24u))), vec4<i32>(vec4<u32>((_e399 & 255u), ((_e409 >> 8u) & 255u), ((_e421 >> 16u) & 255u), (_e433 >> 24u))), vec4<i32>(vec4<u32>((_e445 & 255u), ((_e455 >> 8u) & 255u), ((_e467 >> 16u) & 255u), (_e479 >> 24u))), vec4<i32>(vec4<u32>((_e491 & 255u), ((_e501 >> 8u) & 255u), ((_e513 >> 16u) & 255u), (_e525 >> 24u))), _e537, i32((_e545 & 65535u)), i32(((_e556 >> 16u) & 255u)), i32(((_e569 >> 24u) & 255u)), vec4<i32>(((i32(_e582) << 16u) >> 16u), (i32(_e597) >> 16u), ((i32(_e611) << 16u) >> 16u), (i32(_e628) >> 16u)));
}

fn clamp_9bit_notrunc(color: ptr<function, vec4<i32>>) -> vec4<i32> {
    let _e69 = (*color);
    (*color) = (_e69 - vec4(128i));
    let _e73 = (*color);
    (*color) = extractBits(_e73, 0u, 9u);
    let _e79 = (*color);
    (*color) = (_e79 + vec4(128i));
    let _e83 = (*color);
    return vec4<i32>(clamp(_e83, vec4(0i), vec4(255i)));
}

fn clamp_9bit(color_1: vec4<i32>) -> vec4<i32> {
    var color_2: vec4<i32>;
    var param_5: vec4<i32>;
    var _2828_: vec4<i32>;

    color_2 = color_1;
    let _e70 = color_2;
    param_5 = _e70;
    let _e74 = clamp_9bit_notrunc((&param_5));
    _2828_ = _e74;
    let _e76 = _2828_;
    return vec4<i32>(_e76);
}

fn interpolate_rgba(rgba: ptr<function, vec4<i32>>, drgba_dx: vec4<i32>, drgba_dy: vec4<i32>, dx_1: i32, coverage: i32) -> vec4<i32> {
    var drgba_dx_1: vec4<i32>;
    var drgba_dy_1: vec4<i32>;
    var dx_2: i32;
    var coverage_1: i32;
    var snapped_rgba: vec4<i32>;
    var first_coverage: i32;
    var yoff: i32;
    var xoff: i32;
    var param_6: vec4<i32>;

    drgba_dx_1 = drgba_dx;
    drgba_dy_1 = drgba_dy;
    dx_2 = dx_1;
    coverage_1 = coverage;
    let _e77 = (*rgba);
    let _e78 = drgba_dx_1;
    let _e88 = dx_2;
    (*rgba) = (_e77 + (((_e78 & vec4(-32i)) >> vec4(0u)) * vec4(_e88)));
    let _e92 = (*rgba);
    snapped_rgba = vec4<i32>((_e92 >> vec4(14u)));
    let _e100 = coverage_1;
    first_coverage = firstTrailingBit(_e100);
    let _e103 = first_coverage;
    yoff = (_e103 >> 1u);
    let _e108 = first_coverage;
    let _e114 = yoff;
    xoff = (((_e108 & 1i) << 1u) + (_e114 & 1i));
    let _e119 = snapped_rgba;
    snapped_rgba = (_e119 << vec4(2u));
    let _e125 = snapped_rgba;
    let _e126 = xoff;
    let _e128 = drgba_dx_1;
    let _e136 = yoff;
    let _e138 = drgba_dy_1;
    snapped_rgba = (_e125 + ((vec4(_e126) * vec4<i32>((_e128 >> vec4(14u)))) + (vec4(_e136) * vec4<i32>((_e138 >> vec4(14u))))));
    let _e148 = snapped_rgba;
    snapped_rgba = (_e148 >> vec4(4u));
    let _e154 = snapped_rgba;
    param_6 = _e154;
    let _e156 = param_6;
    let _e157 = clamp_9bit(_e156);
    return _e157;
}

fn clamp_z(z: ptr<function, i32>) -> i32 {
    let _e69 = (*z);
    (*z) = (_e69 - 131072i);
    let _e72 = (*z);
    (*z) = (_e72 << 13u);
    let _e76 = (*z);
    (*z) = (_e76 >> 13u);
    let _e80 = (*z);
    (*z) = (_e80 + 131072i);
    let _e83 = (*z);
    return clamp(_e83, 0i, 262143i);
}

fn interpolate_stz(stzw: vec4<i32>, dstzw_dx_2: vec4<i32>, dstzw_dy: vec4<i32>, dx_3: i32, coverage_2: i32, perspective_2: bool, uses_lod: bool, flip_direction: i32, st_3: ptr<function, vec2<i32>>, st_dx: ptr<function, vec2<i32>>, st_dy: ptr<function, vec2<i32>>, z_1: ptr<function, i32>, st_overflow_1: ptr<function, bool>) {
    var stzw_1: vec4<i32>;
    var dstzw_dx_3: vec4<i32>;
    var dstzw_dy_1: vec4<i32>;
    var dx_4: i32;
    var coverage_3: i32;
    var perspective_3: bool;
    var uses_lod_1: bool;
    var flip_direction_1: i32;
    var stw_5: vec3<i32>;
    var stw_dx: vec3<i32>;
    var stw_dy: vec3<i32>;
    var param_7: vec3<i32>;
    var param_1_4: bool;
    var _3434_: vec2<i32>;
    var param_2_4: vec3<i32>;
    var param_3_3: bool;
    var _3445_: vec2<i32>;
    var param_4_2: vec3<i32>;
    var param_5_2: bool;
    var _3453_: vec2<i32>;
    var param_6_2: vec3<i32>;
    var param_7_2: vec3<i32>;
    var param_8_1: vec3<i32>;
    var snapped_z: i32;
    var first_coverage_1: i32;
    var yoff_1: i32;
    var xoff_1: i32;
    var param_9_1: i32;
    var _3527_: i32;

    stzw_1 = stzw;
    dstzw_dx_3 = dstzw_dx_2;
    dstzw_dy_1 = dstzw_dy;
    dx_4 = dx_3;
    coverage_3 = coverage_2;
    perspective_3 = perspective_2;
    uses_lod_1 = uses_lod;
    flip_direction_1 = flip_direction;
    let _e89 = stzw_1;
    let _e91 = dstzw_dx_3;
    let _e102 = dx_4;
    stw_5 = (_e89.xyw + (((_e91.xyw & vec3(-32i)) >> vec3(0u)) * vec3(_e102)));
    let _e109 = uses_lod_1;
    if _e109 {
        {
            let _e110 = stw_5;
            let _e111 = flip_direction_1;
            let _e113 = dstzw_dx_3;
            stw_dx = (_e110 + (vec3(_e111) * ((_e113.xyw & vec3(-32i)) >> vec3(0u))));
            let _e126 = stw_5;
            let _e127 = dstzw_dy_1;
            stw_dy = (_e126 + ((_e127.xyw & vec3(-32768i)) >> vec3(0u)));
        }
    }
    let _e139 = perspective_3;
    if _e139 {
        {
            let _e140 = stw_5;
            param_7 = (_e140 >> vec3(16u));
            let _e147 = (*st_overflow_1);
            param_1_4 = _e147;
            let _e149 = param_7;
            let _e152 = perspective_divide(_e149, (&param_1_4));
            _3434_ = _e152;
            let _e154 = param_1_4;
            (*st_overflow_1) = _e154;
            let _e155 = _3434_;
            (*st_3) = _e155;
            let _e156 = uses_lod_1;
            if _e156 {
                {
                    let _e157 = stw_dx;
                    param_2_4 = (_e157 >> vec3(16u));
                    let _e164 = (*st_overflow_1);
                    param_3_3 = _e164;
                    let _e166 = param_2_4;
                    let _e169 = perspective_divide(_e166, (&param_3_3));
                    _3445_ = _e169;
                    let _e171 = param_3_3;
                    (*st_overflow_1) = _e171;
                    let _e172 = _3445_;
                    (*st_dx) = _e172;
                    let _e173 = stw_dy;
                    param_4_2 = (_e173 >> vec3(16u));
                    let _e180 = (*st_overflow_1);
                    param_5_2 = _e180;
                    let _e182 = param_4_2;
                    let _e185 = perspective_divide(_e182, (&param_5_2));
                    _3453_ = _e185;
                    let _e187 = param_5_2;
                    (*st_overflow_1) = _e187;
                    let _e188 = _3453_;
                    (*st_dy) = _e188;
                }
            }
        }
    } else {
        {
            let _e189 = stw_5;
            param_6_2 = (_e189 >> vec3(16u));
            let _e196 = param_6_2;
            let _e197 = no_perspective_divide(_e196);
            (*st_3) = _e197;
            let _e198 = uses_lod_1;
            if _e198 {
                {
                    let _e199 = stw_dx;
                    param_7_2 = (_e199 >> vec3(16u));
                    let _e206 = param_7_2;
                    let _e207 = no_perspective_divide(_e206);
                    (*st_dx) = _e207;
                    let _e208 = stw_dy;
                    param_8_1 = (_e208 >> vec3(16u));
                    let _e215 = param_8_1;
                    let _e216 = no_perspective_divide(_e215);
                    (*st_dy) = _e216;
                }
            }
        }
    }
    let _e217 = stzw_1;
    let _e219 = dstzw_dx_3;
    let _e221 = dx_4;
    let _e227 = dstzw_dx_3;
    let _e232 = dx_4;
    (*z_1) = ((_e217.z + (_e219.z * (_e221 >> 0u))) + ((_e227.z >> 0u) * (_e232 & 0i)));
    let _e237 = (*z_1);
    snapped_z = (_e237 >> 10u);
    let _e242 = coverage_3;
    first_coverage_1 = firstTrailingBit(_e242);
    let _e245 = first_coverage_1;
    yoff_1 = (_e245 >> 1u);
    let _e250 = first_coverage_1;
    let _e256 = yoff_1;
    xoff_1 = (((_e250 & 1i) << 1u) + (_e256 & 1i));
    let _e261 = snapped_z;
    snapped_z = (_e261 << 2u);
    let _e265 = snapped_z;
    let _e266 = xoff_1;
    let _e267 = dstzw_dx_3;
    let _e273 = yoff_1;
    let _e274 = dstzw_dy_1;
    snapped_z = (_e265 + ((_e266 * (_e267.z >> 10u)) + (_e273 * (_e274.z >> 10u))));
    let _e282 = snapped_z;
    snapped_z = (_e282 >> 5u);
    let _e286 = snapped_z;
    param_9_1 = _e286;
    let _e290 = clamp_z((&param_9_1));
    _3527_ = _e290;
    let _e292 = _3527_;
    (*z_1) = _e292;
    return;
}

fn compute_lod_2cycle(tile0_: ptr<function, u32>, tile1_: ptr<function, u32>, lod_frac: ptr<function, i32>, max_level: u32, min_lod: i32, st_4: vec2<i32>, st_dx_1: vec2<i32>, st_dy_1: vec2<i32>, perspective_overflow: bool, tex_lod_en: bool, sharpen_tex_en: bool, detail_tex_en: bool) {
    var max_level_1: u32;
    var min_lod_1: i32;
    var st_5: vec2<i32>;
    var st_dx_2: vec2<i32>;
    var st_dy_2: vec2<i32>;
    var perspective_overflow_1: bool;
    var tex_lod_en_1: bool;
    var sharpen_tex_en_1: bool;
    var detail_tex_en_1: bool;
    var magnify: bool = false;
    var distant: bool = false;
    var tile_offset: u32 = 0u;
    var dx_5: vec2<i32>;
    var dy: vec2<i32>;
    var max_d2_: vec2<i32>;
    var max_d: i32;
    var local_3: i32;
    var local_4: i32;
    var mip_base: i32;
    var _6665_: bool;
    var local_5: i32;
    var local_6: i32;

    max_level_1 = max_level;
    min_lod_1 = min_lod;
    st_5 = st_4;
    st_dx_2 = st_dx_1;
    st_dy_2 = st_dy_1;
    perspective_overflow_1 = perspective_overflow;
    tex_lod_en_1 = tex_lod_en;
    sharpen_tex_en_1 = sharpen_tex_en;
    detail_tex_en_1 = detail_tex_en;
    let _e95 = perspective_overflow_1;
    if _e95 {
        {
            distant = true;
            (*lod_frac) = 255i;
        }
    } else {
        {
            let _e98 = st_dx_2;
            let _e99 = st_5;
            dx_5 = (_e98 - _e99);
            let _e102 = dx_5;
            let _e103 = dx_5;
            dx_5 = (_e102 ^ (_e103 >> vec2(31u)));
            let _e110 = st_dy_2;
            let _e111 = st_5;
            dy = (_e110 - _e111);
            let _e114 = dy;
            let _e115 = dy;
            dy = (_e114 ^ (_e115 >> vec2(31u)));
            let _e122 = dx_5;
            let _e123 = dy;
            max_d2_ = max(_e122, _e123);
            let _e126 = max_d2_;
            let _e128 = max_d2_;
            max_d = max(_e126.x, _e128.y);
            let _e132 = max_d;
            if (_e132 >= 16384i) {
                {
                    distant = true;
                    (*lod_frac) = 255i;
                    let _e137 = max_level_1;
                    tile_offset = _e137;
                }
            } else {
                {
                    let _e138 = max_d;
                    if (_e138 < 32i) {
                        {
                            let _e141 = max_level_1;
                            distant = (_e141 == 0u);
                            magnify = true;
                            let _e145 = sharpen_tex_en_1;
                            let _e147 = detail_tex_en_1;
                            if (!(_e145) && !(_e147)) {
                                {
                                    let _e150 = distant;
                                    if _e150 {
                                        local_3 = 255i;
                                    } else {
                                        local_3 = 0i;
                                    }
                                    let _e154 = local_3;
                                    (*lod_frac) = _e154;
                                }
                            } else {
                                {
                                    let _e155 = min_lod_1;
                                    let _e156 = max_d;
                                    let _e161 = sharpen_tex_en_1;
                                    if _e161 {
                                        local_4 = -256i;
                                    } else {
                                        local_4 = 0i;
                                    }
                                    let _e166 = local_4;
                                    (*lod_frac) = ((max(_e155, _e156) << 3u) + _e166);
                                }
                            }
                        }
                    } else {
                        {
                            let _e168 = max_d;
                            mip_base = max(firstLeadingBit((_e168 >> 5u)), 0i);
                            let _e176 = mip_base;
                            let _e178 = max_level_1;
                            distant = (u32(_e176) >= _e178);
                            let _e180 = distant;
                            let _e181 = sharpen_tex_en_1;
                            let _e184 = detail_tex_en_1;
                            if ((_e180 && !(_e181)) && !(_e184)) {
                                {
                                    (*lod_frac) = 255i;
                                }
                            } else {
                                {
                                    let _e188 = max_d;
                                    let _e192 = mip_base;
                                    (*lod_frac) = (((_e188 << 3u) >> u32(_e192)) & 255i);
                                    let _e197 = mip_base;
                                    tile_offset = u32(_e197);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    let _e199 = tex_lod_en_1;
    if _e199 {
        {
            let _e200 = distant;
            if _e200 {
                {
                    let _e201 = max_level_1;
                    tile_offset = _e201;
                }
            }
            let _e202 = detail_tex_en_1;
            if !(_e202) {
                {
                    let _e204 = (*tile0_);
                    let _e205 = tile_offset;
                    (*tile0_) = ((_e204 + _e205) & 7u);
                    let _e210 = distant;
                    if !(_e210) {
                        {
                            let _e212 = sharpen_tex_en_1;
                            let _e214 = magnify;
                            _6665_ = (!(_e212) && _e214);
                        }
                    } else {
                        {
                            let _e216 = distant;
                            _6665_ = _e216;
                        }
                    }
                    let _e217 = _6665_;
                    if _e217 {
                        {
                            let _e218 = (*tile0_);
                            (*tile1_) = _e218;
                            return;
                        }
                    } else {
                        {
                            let _e219 = (*tile0_);
                            (*tile1_) = ((_e219 + 1u) & 7u);
                            return;
                        }
                    }
                }
            } else {
                {
                    let _e224 = (*tile0_);
                    let _e225 = tile_offset;
                    let _e227 = distant;
                    let _e228 = magnify;
                    if (_e227 || _e228) {
                        local_5 = 1i;
                    } else {
                        local_5 = 2i;
                    }
                    let _e233 = local_5;
                    (*tile1_) = (((_e224 + _e225) + u32(_e233)) & 7u);
                    let _e238 = (*tile0_);
                    let _e239 = tile_offset;
                    let _e241 = magnify;
                    if _e241 {
                        local_6 = 0i;
                    } else {
                        local_6 = 1i;
                    }
                    let _e245 = local_6;
                    (*tile0_) = (((_e238 + _e239) + u32(_e245)) & 7u);
                    return;
                }
            }
        }
    } else {
        return;
    }
}

fn clamp_and_shift_coord(clamp_bit: bool, coord_2: ptr<function, i32>, lo_2: i32, hi: i32, shift_4: i32) -> i32 {
    var clamp_bit_1: bool;
    var lo_3: i32;
    var hi_1: i32;
    var shift_5: i32;
    var clamp_hi: bool;

    clamp_bit_1 = clamp_bit;
    lo_3 = lo_2;
    hi_1 = hi;
    shift_5 = shift_4;
    let _e77 = (*coord_2);
    (*coord_2) = clamp(_e77, -32768i, 32767i);
    let _e82 = shift_5;
    if (_e82 < 11i) {
        {
            let _e85 = (*coord_2);
            let _e86 = shift_5;
            (*coord_2) = (_e85 >> u32(_e86));
        }
    } else {
        {
            let _e89 = (*coord_2);
            let _e91 = shift_5;
            (*coord_2) = (_e89 << u32((32i - _e91)));
            let _e95 = (*coord_2);
            (*coord_2) = (_e95 >> 16u);
        }
    }
    let _e99 = clamp_bit_1;
    if _e99 {
        {
            let _e100 = (*coord_2);
            let _e104 = hi_1;
            clamp_hi = ((_e100 >> 3u) >= _e104);
            let _e107 = clamp_hi;
            if _e107 {
                {
                    let _e108 = hi_1;
                    let _e112 = lo_3;
                    (*coord_2) = ((((_e108 >> 2u) - (_e112 >> 2u)) & 1023i) << 5u);
                }
            } else {
                {
                    let _e122 = (*coord_2);
                    let _e123 = lo_3;
                    (*coord_2) = max((_e122 - (_e123 << 3u)), 0i);
                }
            }
        }
    } else {
        {
            let _e130 = (*coord_2);
            let _e131 = lo_3;
            (*coord_2) = (_e130 - (_e131 << 3u));
        }
    }
    let _e136 = (*coord_2);
    return _e136;
}

fn sample_texel_rgba8_(tile_10: TileInfo, tmem_instance_4: u32, st_6: vec2<u32>) -> vec4<i32> {
    var tile_11: TileInfo;
    var tmem_instance_5: u32;
    var st_7: vec2<u32>;
    var byte_offset: u32;
    var index_16: u32;
    var word_2: u32;

    tile_11 = tile_10;
    tmem_instance_5 = tmem_instance_4;
    st_7 = st_6;
    let _e74 = tile_11;
    let _e76 = tile_11;
    let _e78 = st_7;
    byte_offset = (_e74.offset + (_e76.stride * _e78.y));
    let _e83 = byte_offset;
    let _e84 = st_7;
    byte_offset = (_e83 + _e84.x);
    let _e87 = byte_offset;
    byte_offset = (_e87 & 4095u);
    let _e90 = byte_offset;
    index_16 = _e90;
    let _e92 = index_16;
    let _e93 = st_7;
    index_16 = (_e92 ^ ((_e93.y & 1u) << 2u));
    let _e101 = index_16;
    index_16 = (_e101 ^ 3u);
    let _e104 = tmem_instance_5;
    let _e108 = index_16;
    let _e115 = tmem8_.raw[((u32(_e104) * 1024u) + (u32(_e108) / 4u))];
    let _e116 = index_16;
    word_2 = ((_e115 >> ((u32(_e116) % 4u) * 8u)) & 255u);
    let _e126 = word_2;
    return vec4(i32(_e126));
}

fn sample_texel_rgba4_(tile_12: TileInfo, tmem_instance_6: u32, st_8: vec2<u32>) -> vec4<i32> {
    var tile_13: TileInfo;
    var tmem_instance_7: u32;
    var st_9: vec2<u32>;
    var byte_offset_1: u32;
    var shift_6: u32;
    var index_17: u32;
    var word_3: u32;

    tile_13 = tile_12;
    tmem_instance_7 = tmem_instance_6;
    st_9 = st_8;
    let _e74 = tile_13;
    let _e76 = tile_13;
    let _e78 = st_9;
    byte_offset_1 = (_e74.offset + (_e76.stride * _e78.y));
    let _e83 = byte_offset_1;
    let _e84 = st_9;
    byte_offset_1 = (_e83 + (_e84.x >> 1u));
    let _e90 = byte_offset_1;
    byte_offset_1 = (_e90 & 4095u);
    let _e93 = st_9;
    shift_6 = ((~(_e93.x) & 1u) * 4u);
    let _e101 = byte_offset_1;
    index_17 = _e101;
    let _e103 = index_17;
    let _e104 = st_9;
    index_17 = (_e103 ^ ((_e104.y & 1u) << 2u));
    let _e112 = index_17;
    index_17 = (_e112 ^ 3u);
    let _e115 = tmem_instance_7;
    let _e119 = index_17;
    let _e126 = tmem8_.raw[((u32(_e115) * 1024u) + (u32(_e119) / 4u))];
    let _e127 = index_17;
    word_3 = ((_e126 >> ((u32(_e127) % 4u) * 8u)) & 255u);
    let _e137 = word_3;
    let _e138 = shift_6;
    word_3 = ((_e137 >> _e138) & 15u);
    let _e142 = word_3;
    let _e143 = word_3;
    word_3 = (_e142 | (_e143 << 4u));
    let _e148 = word_3;
    return vec4(i32(_e148));
}

fn sample_texel_ci32_(tile_14: TileInfo, tmem_instance_8: u32, st_10: vec2<u32>) -> vec4<i32> {
    var tile_15: TileInfo;
    var tmem_instance_9: u32;
    var st_11: vec2<u32>;
    var byte_offset_2: u32;
    var index_18: u32;
    var word_4: u32;

    tile_15 = tile_14;
    tmem_instance_9 = tmem_instance_8;
    st_11 = st_10;
    let _e74 = tile_15;
    let _e76 = tile_15;
    let _e78 = st_11;
    byte_offset_2 = (_e74.offset + (_e76.stride * _e78.y));
    let _e83 = byte_offset_2;
    let _e84 = st_11;
    byte_offset_2 = (_e83 + (_e84.x * 2u));
    let _e89 = byte_offset_2;
    byte_offset_2 = (_e89 & 4095u);
    let _e92 = byte_offset_2;
    index_18 = (_e92 >> 1u);
    let _e97 = index_18;
    let _e98 = st_11;
    index_18 = (_e97 ^ ((_e98.y & 1u) << 1u));
    let _e106 = index_18;
    index_18 = (_e106 ^ 1u);
    let _e109 = tmem_instance_9;
    let _e113 = index_18;
    let _e120 = tmem8_.raw[((u32(_e109) * 1024u) + (u32(_e113) / 2u))];
    let _e121 = index_18;
    word_4 = ((_e120 >> ((u32(_e121) & 1u) * 16u)) & 65535u);
    let _e131 = word_4;
    let _e136 = word_4;
    return vec2<i32>(i32((_e131 >> 8u)), i32((_e136 & 255u))).xyxy;
}

fn convert_ia16_(word_5: u32) -> vec4<i32> {
    var word_6: u32;
    var intensity: u32;
    var alpha: u32;

    word_6 = word_5;
    let _e70 = word_6;
    intensity = (_e70 >> 8u);
    let _e75 = word_6;
    alpha = (_e75 & 255u);
    let _e79 = intensity;
    let _e81 = intensity;
    let _e83 = intensity;
    let _e85 = alpha;
    return vec4<i32>(i32(_e79), i32(_e81), i32(_e83), i32(_e85));
}

fn sample_texel_ia16_(tile_16: TileInfo, tmem_instance_10: u32, st_12: vec2<u32>) -> vec4<i32> {
    var tile_17: TileInfo;
    var tmem_instance_11: u32;
    var st_13: vec2<u32>;
    var byte_offset_3: u32;
    var index_19: u32;
    var word_7: u32;
    var param_8: u32;

    tile_17 = tile_16;
    tmem_instance_11 = tmem_instance_10;
    st_13 = st_12;
    let _e74 = tile_17;
    let _e76 = tile_17;
    let _e78 = st_13;
    byte_offset_3 = (_e74.offset + (_e76.stride * _e78.y));
    let _e83 = byte_offset_3;
    let _e84 = st_13;
    byte_offset_3 = (_e83 + (_e84.x * 2u));
    let _e89 = byte_offset_3;
    byte_offset_3 = (_e89 & 4095u);
    let _e92 = byte_offset_3;
    index_19 = (_e92 >> 1u);
    let _e97 = index_19;
    let _e98 = st_13;
    index_19 = (_e97 ^ ((_e98.y & 1u) << 1u));
    let _e106 = index_19;
    index_19 = (_e106 ^ 1u);
    let _e109 = tmem_instance_11;
    let _e113 = index_19;
    let _e120 = tmem8_.raw[((u32(_e109) * 1024u) + (u32(_e113) / 2u))];
    let _e121 = index_19;
    word_7 = ((_e120 >> ((u32(_e121) & 1u) * 16u)) & 65535u);
    let _e131 = word_7;
    param_8 = _e131;
    let _e133 = param_8;
    let _e134 = convert_ia16_(_e133);
    return _e134;
}

fn sample_texel_ia8_(tile_18: TileInfo, tmem_instance_12: u32, st_14: vec2<u32>) -> vec4<i32> {
    var tile_19: TileInfo;
    var tmem_instance_13: u32;
    var st_15: vec2<u32>;
    var byte_offset_4: u32;
    var index_20: u32;
    var word_8: u32;
    var intensity_1: u32;
    var alpha_1: u32;

    tile_19 = tile_18;
    tmem_instance_13 = tmem_instance_12;
    st_15 = st_14;
    let _e74 = tile_19;
    let _e76 = tile_19;
    let _e78 = st_15;
    byte_offset_4 = (_e74.offset + (_e76.stride * _e78.y));
    let _e83 = byte_offset_4;
    let _e84 = st_15;
    byte_offset_4 = (_e83 + _e84.x);
    let _e87 = byte_offset_4;
    byte_offset_4 = (_e87 & 4095u);
    let _e90 = byte_offset_4;
    index_20 = _e90;
    let _e92 = index_20;
    let _e93 = st_15;
    index_20 = (_e92 ^ ((_e93.y & 1u) << 2u));
    let _e101 = index_20;
    index_20 = (_e101 ^ 3u);
    let _e104 = tmem_instance_13;
    let _e108 = index_20;
    let _e115 = tmem8_.raw[((u32(_e104) * 1024u) + (u32(_e108) / 4u))];
    let _e116 = index_20;
    word_8 = ((_e115 >> ((u32(_e116) % 4u) * 8u)) & 255u);
    let _e126 = word_8;
    intensity_1 = (_e126 >> 4u);
    let _e131 = word_8;
    alpha_1 = (_e131 & 15u);
    let _e135 = alpha_1;
    let _e136 = alpha_1;
    alpha_1 = (_e135 | (_e136 << 4u));
    let _e141 = intensity_1;
    let _e142 = intensity_1;
    intensity_1 = (_e141 | (_e142 << 4u));
    let _e147 = intensity_1;
    let _e149 = intensity_1;
    let _e151 = intensity_1;
    let _e153 = alpha_1;
    return vec4<i32>(i32(_e147), i32(_e149), i32(_e151), i32(_e153));
}

fn sample_texel_ia4_(tile_20: TileInfo, tmem_instance_14: u32, st_16: vec2<u32>) -> vec4<i32> {
    var tile_21: TileInfo;
    var tmem_instance_15: u32;
    var st_17: vec2<u32>;
    var byte_offset_5: u32;
    var shift_7: u32;
    var index_21: u32;
    var word_9: u32;
    var intensity_2: u32;

    tile_21 = tile_20;
    tmem_instance_15 = tmem_instance_14;
    st_17 = st_16;
    let _e74 = tile_21;
    let _e76 = tile_21;
    let _e78 = st_17;
    byte_offset_5 = (_e74.offset + (_e76.stride * _e78.y));
    let _e83 = byte_offset_5;
    let _e84 = st_17;
    byte_offset_5 = (_e83 + (_e84.x >> 1u));
    let _e90 = byte_offset_5;
    byte_offset_5 = (_e90 & 4095u);
    let _e93 = st_17;
    shift_7 = ((~(_e93.x) & 1u) * 4u);
    let _e101 = byte_offset_5;
    index_21 = _e101;
    let _e103 = index_21;
    let _e104 = st_17;
    index_21 = (_e103 ^ ((_e104.y & 1u) << 2u));
    let _e112 = index_21;
    index_21 = (_e112 ^ 3u);
    let _e115 = tmem_instance_15;
    let _e119 = index_21;
    let _e126 = tmem8_.raw[((u32(_e115) * 1024u) + (u32(_e119) / 4u))];
    let _e127 = index_21;
    word_9 = ((_e126 >> ((u32(_e127) % 4u) * 8u)) & 255u);
    let _e137 = word_9;
    let _e138 = shift_7;
    word_9 = ((_e137 >> _e138) & 15u);
    let _e142 = word_9;
    intensity_2 = (_e142 & 14u);
    let _e146 = intensity_2;
    let _e150 = intensity_2;
    let _e155 = intensity_2;
    intensity_2 = (((_e146 << 4u) | (_e150 << 1u)) | (_e155 >> 2u));
    let _e160 = intensity_2;
    let _e162 = intensity_2;
    let _e164 = intensity_2;
    let _e166 = word_9;
    return vec4<i32>(i32(_e160), i32(_e162), i32(_e164), i32(((_e166 & 1u) * 255u)));
}

fn sample_texel_ci4_(tile_22: TileInfo, tmem_instance_16: u32, st_18: vec2<u32>, pal: u32) -> vec4<i32> {
    var tile_23: TileInfo;
    var tmem_instance_17: u32;
    var st_19: vec2<u32>;
    var pal_1: u32;
    var byte_offset_6: u32;
    var shift_8: u32;
    var index_22: u32;
    var word_10: u32;

    tile_23 = tile_22;
    tmem_instance_17 = tmem_instance_16;
    st_19 = st_18;
    pal_1 = pal;
    let _e76 = tile_23;
    let _e78 = tile_23;
    let _e80 = st_19;
    byte_offset_6 = (_e76.offset + (_e78.stride * _e80.y));
    let _e85 = byte_offset_6;
    let _e86 = st_19;
    byte_offset_6 = (_e85 + (_e86.x >> 1u));
    let _e92 = byte_offset_6;
    byte_offset_6 = (_e92 & 4095u);
    let _e95 = st_19;
    shift_8 = ((~(_e95.x) & 1u) * 4u);
    let _e103 = byte_offset_6;
    index_22 = _e103;
    let _e105 = index_22;
    let _e106 = st_19;
    index_22 = (_e105 ^ ((_e106.y & 1u) << 2u));
    let _e114 = index_22;
    index_22 = (_e114 ^ 3u);
    let _e117 = tmem_instance_17;
    let _e121 = index_22;
    let _e128 = tmem8_.raw[((u32(_e117) * 1024u) + (u32(_e121) / 4u))];
    let _e129 = index_22;
    word_10 = ((_e128 >> ((u32(_e129) % 4u) * 8u)) & 255u);
    let _e139 = word_10;
    let _e140 = shift_8;
    word_10 = ((_e139 >> _e140) & 15u);
    let _e144 = word_10;
    let _e145 = pal_1;
    word_10 = (_e144 | (_e145 << 4u));
    let _e150 = word_10;
    return vec4(i32(_e150));
}

fn sample_texel_yuv16_(tile_24: TileInfo, tmem_instance_18: u32, st_20: vec2<u32>, chroma_x: u32) -> vec4<i32> {
    var tile_25: TileInfo;
    var tmem_instance_19: u32;
    var st_21: vec2<u32>;
    var chroma_x_1: u32;
    var byte_offset_7: u32;
    var byte_offset_luma: u32;
    var byte_offset_chroma: u32;
    var index_luma: u32;
    var index_chroma: u32;
    var luma: i32;
    var chroma: i32;
    var u: i32;
    var v: i32;

    tile_25 = tile_24;
    tmem_instance_19 = tmem_instance_18;
    st_21 = st_20;
    chroma_x_1 = chroma_x;
    let _e76 = tile_25;
    let _e78 = tile_25;
    let _e80 = st_21;
    byte_offset_7 = (_e76.offset + (_e78.stride * _e80.y));
    let _e85 = byte_offset_7;
    let _e86 = st_21;
    byte_offset_luma = (_e85 + _e86.x);
    let _e90 = byte_offset_luma;
    byte_offset_luma = (_e90 & 2047u);
    let _e93 = byte_offset_7;
    let _e94 = chroma_x_1;
    byte_offset_chroma = (_e93 + (_e94 * 2u));
    let _e99 = byte_offset_chroma;
    byte_offset_chroma = (_e99 & 2047u);
    let _e102 = byte_offset_luma;
    index_luma = _e102;
    let _e104 = index_luma;
    let _e105 = st_21;
    index_luma = (_e104 ^ ((_e105.y & 1u) << 2u));
    let _e113 = index_luma;
    index_luma = (_e113 ^ 3u);
    let _e116 = byte_offset_chroma;
    index_chroma = (_e116 >> 1u);
    let _e121 = index_chroma;
    let _e122 = st_21;
    index_chroma = (_e121 ^ ((_e122.y & 1u) << 1u));
    let _e130 = index_chroma;
    index_chroma = (_e130 ^ 1u);
    let _e133 = tmem_instance_19;
    let _e137 = index_luma;
    let _e146 = tmem8_.raw[((u32(_e133) * 1024u) + (u32((_e137 | 2048u)) / 4u))];
    let _e147 = index_luma;
    luma = i32(((_e146 >> ((u32((_e147 | 2048u)) % 4u) * 8u)) & 255u));
    let _e160 = tmem_instance_19;
    let _e164 = index_chroma;
    let _e171 = tmem8_.raw[((u32(_e160) * 1024u) + (u32(_e164) / 2u))];
    let _e172 = index_chroma;
    chroma = i32(((_e171 >> ((u32(_e172) & 1u) * 16u)) & 65535u));
    let _e183 = chroma;
    u = ((_e183 >> 8u) & 255i);
    let _e190 = chroma;
    v = ((_e190 >> 0u) & 255i);
    let _e197 = u;
    let _e200 = v;
    let _e203 = luma;
    let _e204 = luma;
    return vec4<i32>((_e197 - 128i), (_e200 - 128i), _e203, _e204);
}

fn sample_texel_rgba32_(tile_26: TileInfo, tmem_instance_20: u32, st_22: vec2<u32>) -> vec4<i32> {
    var tile_27: TileInfo;
    var tmem_instance_21: u32;
    var st_23: vec2<u32>;
    var byte_offset_8: u32;
    var index_23: u32;
    var lower_word: u32;
    var upper_word: u32;

    tile_27 = tile_26;
    tmem_instance_21 = tmem_instance_20;
    st_23 = st_22;
    let _e74 = tile_27;
    let _e76 = tile_27;
    let _e78 = st_23;
    byte_offset_8 = (_e74.offset + (_e76.stride * _e78.y));
    let _e83 = byte_offset_8;
    let _e84 = st_23;
    byte_offset_8 = (_e83 + (_e84.x * 2u));
    let _e89 = byte_offset_8;
    byte_offset_8 = (_e89 & 2047u);
    let _e92 = byte_offset_8;
    index_23 = (_e92 >> 1u);
    let _e97 = index_23;
    let _e98 = st_23;
    index_23 = (_e97 ^ ((_e98.y & 1u) << 1u));
    let _e106 = index_23;
    index_23 = (_e106 ^ 1u);
    let _e109 = tmem_instance_21;
    let _e113 = index_23;
    let _e120 = tmem8_.raw[((u32(_e109) * 1024u) + (u32(_e113) / 2u))];
    let _e121 = index_23;
    lower_word = ((_e120 >> ((u32(_e121) & 1u) * 16u)) & 65535u);
    let _e131 = tmem_instance_21;
    let _e135 = index_23;
    let _e144 = tmem8_.raw[((u32(_e131) * 1024u) + (u32((_e135 | 1024u)) / 2u))];
    let _e145 = index_23;
    upper_word = ((_e144 >> ((u32((_e145 | 1024u)) & 1u) * 16u)) & 65535u);
    let _e157 = lower_word;
    let _e162 = lower_word;
    let _e166 = upper_word;
    let _e171 = upper_word;
    return vec4<i32>(i32((_e157 >> 8u)), i32((_e162 & 255u)), i32((_e166 >> 8u)), i32((_e171 & 255u)));
}

fn convert_rgba16_(word_11: u32) -> vec4<i32> {
    var word_12: u32;
    var rgb: vec3<u32>;
    var alpha_2: u32;

    word_12 = word_11;
    let _e70 = word_12;
    rgb = ((vec3(_e70) >> vec3<u32>(11u, 6u, 1u)) & vec3(31u));
    let _e81 = rgb;
    let _e85 = rgb;
    rgb = ((_e81 << vec3(3u)) | (_e85 >> vec3(2u)));
    let _e90 = word_12;
    alpha_2 = ((_e90 & 1u) * 255u);
    let _e96 = rgb;
    let _e97 = vec3<i32>(_e96);
    let _e98 = alpha_2;
    return vec4<i32>(_e97.x, _e97.y, _e97.z, i32(_e98));
}

fn sample_texel_rgba16_(tile_28: TileInfo, tmem_instance_22: u32, st_24: vec2<u32>) -> vec4<i32> {
    var tile_29: TileInfo;
    var tmem_instance_23: u32;
    var st_25: vec2<u32>;
    var byte_offset_9: u32;
    var index_24: u32;
    var word_13: u32;
    var param_9: u32;

    tile_29 = tile_28;
    tmem_instance_23 = tmem_instance_22;
    st_25 = st_24;
    let _e74 = tile_29;
    let _e76 = tile_29;
    let _e78 = st_25;
    byte_offset_9 = (_e74.offset + (_e76.stride * _e78.y));
    let _e83 = byte_offset_9;
    let _e84 = st_25;
    byte_offset_9 = (_e83 + (_e84.x * 2u));
    let _e89 = byte_offset_9;
    byte_offset_9 = (_e89 & 4095u);
    let _e92 = byte_offset_9;
    index_24 = (_e92 >> 1u);
    let _e97 = index_24;
    let _e98 = st_25;
    index_24 = (_e97 ^ ((_e98.y & 1u) << 1u));
    let _e106 = index_24;
    index_24 = (_e106 ^ 1u);
    let _e109 = tmem_instance_23;
    let _e113 = index_24;
    let _e120 = tmem8_.raw[((u32(_e109) * 1024u) + (u32(_e113) / 2u))];
    let _e121 = index_24;
    word_13 = ((_e120 >> ((u32(_e121) & 1u) * 16u)) & 65535u);
    let _e131 = word_13;
    param_9 = _e131;
    let _e133 = param_9;
    let _e134 = convert_rgba16_(_e133);
    return _e134;
}

fn sample_texel_ci8_tlut(tile_30: TileInfo, tmem_instance_24: u32, st_26: vec2<u32>, lut_offset: u32, addr_xor: u32, tlut_type_4: bool) -> vec4<i32> {
    var tile_31: TileInfo;
    var tmem_instance_25: u32;
    var st_27: vec2<u32>;
    var lut_offset_1: u32;
    var addr_xor_1: u32;
    var tlut_type_5: bool;
    var byte_offset_10: u32;
    var index_25: u32;
    var word_14: u32;
    var lut_entry: u32;
    var _3978_: vec4<i32>;
    var param_10: u32;
    var param_1_5: u32;

    tile_31 = tile_30;
    tmem_instance_25 = tmem_instance_24;
    st_27 = st_26;
    lut_offset_1 = lut_offset;
    addr_xor_1 = addr_xor;
    tlut_type_5 = tlut_type_4;
    let _e80 = tile_31;
    let _e82 = tile_31;
    let _e84 = st_27;
    byte_offset_10 = (_e80.offset + (_e82.stride * _e84.y));
    let _e89 = byte_offset_10;
    let _e90 = st_27;
    byte_offset_10 = (_e89 + _e90.x);
    let _e93 = byte_offset_10;
    byte_offset_10 = (_e93 & 2047u);
    let _e96 = byte_offset_10;
    index_25 = _e96;
    let _e98 = index_25;
    let _e99 = st_27;
    index_25 = (_e98 ^ ((_e99.y & 1u) << 2u));
    let _e107 = index_25;
    index_25 = (_e107 ^ 3u);
    let _e110 = tmem_instance_25;
    let _e114 = index_25;
    let _e121 = tmem8_.raw[((u32(_e110) * 1024u) + (u32(_e114) / 4u))];
    let _e122 = index_25;
    word_14 = ((_e121 >> ((u32(_e122) % 4u) * 8u)) & 255u);
    let _e132 = word_14;
    let _e136 = lut_offset_1;
    lut_entry = ((_e132 << 2u) + _e136);
    let _e139 = lut_entry;
    let _e140 = addr_xor_1;
    lut_entry = (_e139 ^ _e140);
    let _e142 = tmem_instance_25;
    let _e147 = lut_entry;
    let _e155 = tmem8_.raw[((u32(_e142) * 1024u) + (u32((1024u | _e147)) / 2u))];
    let _e157 = lut_entry;
    word_14 = ((_e155 >> ((u32((1024u | _e157)) & 1u) * 16u)) & 65535u);
    let _e168 = tlut_type_5;
    if _e168 {
        {
            let _e169 = word_14;
            param_10 = _e169;
            let _e171 = param_10;
            let _e172 = convert_ia16_(_e171);
            _3978_ = _e172;
        }
    } else {
        {
            let _e173 = word_14;
            param_1_5 = _e173;
            let _e175 = param_1_5;
            let _e176 = convert_rgba16_(_e175);
            _3978_ = _e176;
        }
    }
    let _e177 = _3978_;
    return _e177;
}

fn sample_texel_ci4_tlut(tile_32: TileInfo, tmem_instance_26: u32, st_28: vec2<u32>, pal_2: u32, lut_offset_2: u32, addr_xor_2: u32, tlut_type_6: bool) -> vec4<i32> {
    var tile_33: TileInfo;
    var tmem_instance_27: u32;
    var st_29: vec2<u32>;
    var pal_3: u32;
    var lut_offset_3: u32;
    var addr_xor_3: u32;
    var tlut_type_7: bool;
    var byte_offset_11: u32;
    var shift_9: u32;
    var index_26: u32;
    var word_15: u32;
    var lut_entry_1: u32;
    var _3919_: vec4<i32>;
    var param_11: u32;
    var param_1_6: u32;

    tile_33 = tile_32;
    tmem_instance_27 = tmem_instance_26;
    st_29 = st_28;
    pal_3 = pal_2;
    lut_offset_3 = lut_offset_2;
    addr_xor_3 = addr_xor_2;
    tlut_type_7 = tlut_type_6;
    let _e82 = tile_33;
    let _e84 = tile_33;
    let _e86 = st_29;
    byte_offset_11 = (_e82.offset + (_e84.stride * _e86.y));
    let _e91 = byte_offset_11;
    let _e92 = st_29;
    byte_offset_11 = (_e91 + (_e92.x >> 1u));
    let _e98 = byte_offset_11;
    byte_offset_11 = (_e98 & 2047u);
    let _e101 = st_29;
    shift_9 = ((~(_e101.x) & 1u) * 4u);
    let _e109 = byte_offset_11;
    index_26 = _e109;
    let _e111 = index_26;
    let _e112 = st_29;
    index_26 = (_e111 ^ ((_e112.y & 1u) << 2u));
    let _e120 = index_26;
    index_26 = (_e120 ^ 3u);
    let _e123 = tmem_instance_27;
    let _e127 = index_26;
    let _e134 = tmem8_.raw[((u32(_e123) * 1024u) + (u32(_e127) / 4u))];
    let _e135 = index_26;
    word_15 = ((_e134 >> ((u32(_e135) % 4u) * 8u)) & 255u);
    let _e145 = word_15;
    let _e146 = shift_9;
    word_15 = ((_e145 >> _e146) & 15u);
    let _e150 = word_15;
    let _e151 = pal_3;
    word_15 = (_e150 | (_e151 << 4u));
    let _e156 = word_15;
    let _e160 = lut_offset_3;
    lut_entry_1 = ((_e156 << 2u) + _e160);
    let _e163 = lut_entry_1;
    let _e164 = addr_xor_3;
    lut_entry_1 = (_e163 ^ _e164);
    let _e166 = tmem_instance_27;
    let _e171 = lut_entry_1;
    let _e179 = tmem8_.raw[((u32(_e166) * 1024u) + (u32((1024u | _e171)) / 2u))];
    let _e181 = lut_entry_1;
    word_15 = ((_e179 >> ((u32((1024u | _e181)) & 1u) * 16u)) & 65535u);
    let _e192 = tlut_type_7;
    if _e192 {
        {
            let _e193 = word_15;
            param_11 = _e193;
            let _e195 = param_11;
            let _e196 = convert_ia16_(_e195);
            _3919_ = _e196;
        }
    } else {
        {
            let _e197 = word_15;
            param_1_6 = _e197;
            let _e199 = param_1_6;
            let _e200 = convert_rgba16_(_e199);
            _3919_ = _e200;
        }
    }
    let _e201 = _3919_;
    return _e201;
}

fn sample_texel_ci32_tlut(tile_34: TileInfo, tmem_instance_28: u32, st_30: vec2<u32>, lut_offset_4: u32, addr_xor_4: u32, tlut_type_8: bool) -> vec4<i32> {
    var tile_35: TileInfo;
    var tmem_instance_29: u32;
    var st_31: vec2<u32>;
    var lut_offset_5: u32;
    var addr_xor_5: u32;
    var tlut_type_9: bool;
    var byte_offset_12: u32;
    var index_27: u32;
    var word_16: u32;
    var lut_entry_2: u32;
    var _4084_: vec4<i32>;
    var param_12: u32;
    var param_1_7: u32;

    tile_35 = tile_34;
    tmem_instance_29 = tmem_instance_28;
    st_31 = st_30;
    lut_offset_5 = lut_offset_4;
    addr_xor_5 = addr_xor_4;
    tlut_type_9 = tlut_type_8;
    let _e80 = tile_35;
    let _e82 = tile_35;
    let _e84 = st_31;
    byte_offset_12 = (_e80.offset + (_e82.stride * _e84.y));
    let _e89 = byte_offset_12;
    let _e90 = st_31;
    byte_offset_12 = (_e89 + (_e90.x * 2u));
    let _e95 = byte_offset_12;
    byte_offset_12 = (_e95 & 2047u);
    let _e98 = byte_offset_12;
    index_27 = (_e98 >> 1u);
    let _e103 = index_27;
    let _e104 = st_31;
    index_27 = (_e103 ^ ((_e104.y & 1u) << 1u));
    let _e112 = index_27;
    index_27 = (_e112 ^ 1u);
    let _e115 = tmem_instance_29;
    let _e119 = index_27;
    let _e126 = tmem8_.raw[((u32(_e115) * 1024u) + (u32(_e119) / 2u))];
    let _e127 = index_27;
    word_16 = ((_e126 >> ((u32(_e127) & 1u) * 16u)) & 65535u);
    let _e137 = word_16;
    let _e143 = lut_offset_5;
    lut_entry_2 = (((_e137 >> 6u) & 4294967292u) + _e143);
    let _e146 = lut_entry_2;
    let _e147 = addr_xor_5;
    lut_entry_2 = (_e146 ^ _e147);
    let _e149 = tmem_instance_29;
    let _e154 = lut_entry_2;
    let _e162 = tmem8_.raw[((u32(_e149) * 1024u) + (u32((1024u | _e154)) / 2u))];
    let _e164 = lut_entry_2;
    word_16 = ((_e162 >> ((u32((1024u | _e164)) & 1u) * 16u)) & 65535u);
    let _e175 = tlut_type_9;
    if _e175 {
        {
            let _e176 = word_16;
            param_12 = _e176;
            let _e178 = param_12;
            let _e179 = convert_ia16_(_e178);
            _4084_ = _e179;
        }
    } else {
        {
            let _e180 = word_16;
            param_1_7 = _e180;
            let _e182 = param_1_7;
            let _e183 = convert_rgba16_(_e182);
            _4084_ = _e183;
        }
    }
    let _e184 = _4084_;
    return _e184;
}

fn bilinear_3tap(t00_: vec2<i32>, t10_: vec2<i32>, t01_: vec2<i32>, t11_: vec2<i32>, frac: vec2<i32>) -> vec2<i32> {
    var t00_1: vec2<i32>;
    var t10_1: vec2<i32>;
    var t01_1: vec2<i32>;
    var t11_1: vec2<i32>;
    var frac_1: vec2<i32>;
    var sum_frac: i32;
    var t_base: vec2<i32>;
    var _4842_: vec2<i32>;
    var flip_frac: vec2<i32>;
    var accum: vec2<i32>;

    t00_1 = t00_;
    t10_1 = t10_;
    t01_1 = t01_;
    t11_1 = t11_;
    frac_1 = frac;
    let _e78 = frac_1;
    let _e80 = frac_1;
    sum_frac = (_e78.x + _e80.y);
    let _e84 = t00_1;
    let _e85 = t11_1;
    let _e86 = sum_frac;
    t_base = select(_e84, _e85, vec2((_e86 >= 32i)));
    let _e93 = sum_frac;
    if (_e93 >= 32i) {
        {
            let _e98 = frac_1;
            _4842_ = (vec2(32i) - _e98.yx);
        }
    } else {
        {
            let _e101 = frac_1;
            _4842_ = _e101;
        }
    }
    let _e102 = _4842_;
    flip_frac = vec2<i32>(_e102);
    let _e105 = t10_1;
    let _e106 = t_base;
    let _e108 = flip_frac;
    accum = ((_e105 - _e106) * vec2(_e108.x));
    let _e113 = accum;
    let _e114 = t01_1;
    let _e115 = t_base;
    let _e117 = flip_frac;
    accum = (_e113 + ((_e114 - _e115) * vec2(_e117.y)));
    let _e122 = accum;
    accum = (_e122 + vec2(16i));
    let _e126 = accum;
    accum = (_e126 >> vec2(5u));
    let _e132 = accum;
    let _e133 = t_base;
    accum = (_e132 + _e133);
    let _e135 = accum;
    return _e135;
}

fn texture_convert_factors(texel_in: vec4<i32>, factors: vec4<i32>) -> vec4<i32> {
    var texel_in_1: vec4<i32>;
    var factors_1: vec4<i32>;
    var texel: vec4<i32>;
    var r: i32;
    var g: i32;
    var b: i32;
    var a: i32;

    texel_in_1 = texel_in;
    factors_1 = factors;
    let _e72 = texel_in_1;
    texel = extractBits(vec4<i32>(_e72), 0u, 9u);
    let _e80 = texel;
    let _e82 = factors_1;
    let _e84 = texel;
    r = (_e80.z + (((_e82.x * _e84.y) + 128i) >> 8u));
    let _e94 = texel;
    let _e96 = factors_1;
    let _e98 = texel;
    let _e101 = factors_1;
    let _e103 = texel;
    g = (_e94.z + ((((_e96.y * _e98.x) + (_e101.z * _e103.y)) + 128i) >> 8u));
    let _e114 = texel;
    let _e116 = factors_1;
    let _e118 = texel;
    b = (_e114.z + (((_e116.w * _e118.x) + 128i) >> 8u));
    let _e128 = texel;
    a = _e128.z;
    let _e131 = r;
    let _e132 = g;
    let _e133 = b;
    let _e134 = a;
    return vec4<i32>(_e131, _e132, _e133, _e134);
}

fn sample_texture(tile_36: TileInfo, tmem_instance_30: u32, st_32: ptr<function, vec2<i32>>, tlut_4: bool, tlut_type_10: bool, sample_quad: bool, mid_texel_state: bool, convert_one: bool, bilerp: bool, conversion_factors: vec4<i32>, prev_cycle: vec4<i32>) -> vec4<i32> {
    var tile_37: TileInfo;
    var tmem_instance_31: u32;
    var tlut_5: bool;
    var tlut_type_11: bool;
    var sample_quad_1: bool;
    var mid_texel_state_1: bool;
    var convert_one_1: bool;
    var bilerp_1: bool;
    var conversion_factors_1: vec4<i32>;
    var prev_cycle_1: vec4<i32>;
    var param_13: bool;
    var param_1_8: i32;
    var param_2_5: i32;
    var param_3_4: i32;
    var param_4_3: i32;
    var _4960_: i32;
    var param_5_3: bool;
    var param_6_3: i32;
    var param_7_3: i32;
    var param_8_2: i32;
    var param_9_2: i32;
    var _4981_: i32;
    var frac_2: vec2<i32>;
    var sum_frac_1: i32;
    var param_10_1: TileInfo;
    var param_11_1: i32;
    var _5008_: i32;
    var s0_: i32;
    var param_12_1: TileInfo;
    var param_13_1: i32;
    var _5015_: i32;
    var t0_: i32;
    var param_14_1: TileInfo;
    var param_15_1: i32;
    var _5023_: i32;
    var s1_: i32;
    var param_16_1: TileInfo;
    var param_17_1: i32;
    var _5031_: i32;
    var t1_: i32;
    var tdiff: i32;
    var mid_texel: bool;
    var upper_lut: bool;
    var yuv: bool;
    var _5067_: vec2<i32>;
    var base_st: vec2<i32>;
    var chroma_frac: i32;
    var t_base_1: vec4<i32>;
    var t10_2: vec4<i32>;
    var t01_2: vec4<i32>;
    var t11_2: vec4<i32>;
    var upper: bool;
    var local_7: i32;
    var addr_xor_6: u32;
    var param_18_: TileInfo;
    var param_19_: u32;
    var param_20_: vec2<u32>;
    var param_21_: u32;
    var local_8: i32;
    var param_22_: u32;
    var param_23_: u32;
    var param_24_: bool;
    var param_25_: TileInfo;
    var param_26_: u32;
    var param_27_: vec2<u32>;
    var param_28_: u32;
    var param_29_: u32 = 1u;
    var param_30_: u32;
    var param_31_: bool;
    var param_32_: TileInfo;
    var param_33_: u32;
    var param_34_: vec2<u32>;
    var param_35_: u32;
    var param_36_: u32 = 2u;
    var param_37_: u32;
    var param_38_: bool;
    var param_39_: TileInfo;
    var param_40_: u32;
    var param_41_: vec2<u32>;
    var param_42_: u32;
    var param_43_: u32 = 3u;
    var param_44_: u32;
    var param_45_: bool;
    var param_46_: TileInfo;
    var param_47_: u32;
    var param_48_: vec2<u32>;
    var local_9: i32;
    var param_49_: u32;
    var param_50_: u32;
    var param_51_: bool;
    var param_52_: TileInfo;
    var param_53_: u32;
    var param_54_: vec2<u32>;
    var param_55_: u32 = 1u;
    var param_56_: u32;
    var param_57_: bool;
    var param_58_: TileInfo;
    var param_59_: u32;
    var param_60_: vec2<u32>;
    var param_61_: u32 = 2u;
    var param_62_: u32;
    var param_63_: bool;
    var param_64_: TileInfo;
    var param_65_: u32;
    var param_66_: vec2<u32>;
    var param_67_: u32 = 3u;
    var param_68_: u32;
    var param_69_: bool;
    var param_70_: TileInfo;
    var param_71_: u32;
    var param_72_: vec2<u32>;
    var local_10: i32;
    var param_73_: u32;
    var param_74_: u32;
    var param_75_: bool;
    var param_76_: TileInfo;
    var param_77_: u32;
    var param_78_: vec2<u32>;
    var param_79_: u32 = 1u;
    var param_80_: u32;
    var param_81_: bool;
    var param_82_: TileInfo;
    var param_83_: u32;
    var param_84_: vec2<u32>;
    var param_85_: u32 = 2u;
    var param_86_: u32;
    var param_87_: bool;
    var param_88_: TileInfo;
    var param_89_: u32;
    var param_90_: vec2<u32>;
    var param_91_: u32 = 3u;
    var param_92_: u32;
    var param_93_: bool;
    var param_94_: TileInfo;
    var param_95_: u32;
    var param_96_: vec2<u32>;
    var param_97_: TileInfo;
    var param_98_: u32;
    var param_99_: vec2<u32>;
    var param_100_: TileInfo;
    var param_101_: u32;
    var param_102_: vec2<u32>;
    var param_103_: TileInfo;
    var param_104_: u32;
    var param_105_: vec2<u32>;
    var param_106_: TileInfo;
    var param_107_: u32;
    var param_108_: vec2<u32>;
    var param_109_: TileInfo;
    var param_110_: u32;
    var param_111_: vec2<u32>;
    var param_112_: TileInfo;
    var param_113_: u32;
    var param_114_: vec2<u32>;
    var param_115_: TileInfo;
    var param_116_: u32;
    var param_117_: vec2<u32>;
    var param_118_: TileInfo;
    var param_119_: u32;
    var param_120_: vec2<u32>;
    var param_121_: TileInfo;
    var param_122_: u32;
    var param_123_: vec2<u32>;
    var param_124_: TileInfo;
    var param_125_: u32;
    var param_126_: vec2<u32>;
    var param_127_: TileInfo;
    var param_128_: u32;
    var param_129_: vec2<u32>;
    var param_130_: TileInfo;
    var param_131_: u32;
    var param_132_: vec2<u32>;
    var param_133_: TileInfo;
    var param_134_: u32;
    var param_135_: vec2<u32>;
    var param_136_: TileInfo;
    var param_137_: u32;
    var param_138_: vec2<u32>;
    var param_139_: TileInfo;
    var param_140_: u32;
    var param_141_: vec2<u32>;
    var chroma_x0_: u32;
    var chroma_x1_: u32;
    var param_142_: TileInfo;
    var param_143_: u32;
    var param_144_: vec2<u32>;
    var param_145_: u32;
    var param_146_: TileInfo;
    var param_147_: u32;
    var param_148_: vec2<u32>;
    var param_149_: u32;
    var param_150_: TileInfo;
    var param_151_: u32;
    var param_152_: vec2<u32>;
    var param_153_: u32;
    var param_154_: TileInfo;
    var param_155_: u32;
    var param_156_: vec2<u32>;
    var param_157_: u32;
    var param_158_: TileInfo;
    var param_159_: u32;
    var param_160_: vec2<u32>;
    var param_161_: u32;
    var param_162_: TileInfo;
    var param_163_: u32;
    var param_164_: vec2<u32>;
    var param_165_: u32;
    var param_166_: TileInfo;
    var param_167_: u32;
    var param_168_: vec2<u32>;
    var param_169_: u32;
    var param_170_: TileInfo;
    var param_171_: u32;
    var param_172_: vec2<u32>;
    var param_173_: u32;
    var param_174_: TileInfo;
    var param_175_: u32;
    var param_176_: vec2<u32>;
    var param_177_: TileInfo;
    var param_178_: u32;
    var param_179_: vec2<u32>;
    var param_180_: TileInfo;
    var param_181_: u32;
    var param_182_: vec2<u32>;
    var param_183_: TileInfo;
    var param_184_: u32;
    var param_185_: vec2<u32>;
    var param_186_: TileInfo;
    var param_187_: u32;
    var param_188_: vec2<u32>;
    var param_189_: TileInfo;
    var param_190_: u32;
    var param_191_: vec2<u32>;
    var param_192_: TileInfo;
    var param_193_: u32;
    var param_194_: vec2<u32>;
    var param_195_: TileInfo;
    var param_196_: u32;
    var param_197_: vec2<u32>;
    var param_198_: TileInfo;
    var param_199_: u32;
    var param_200_: vec2<u32>;
    var param_201_: TileInfo;
    var param_202_: u32;
    var param_203_: vec2<u32>;
    var param_204_: TileInfo;
    var param_205_: u32;
    var param_206_: vec2<u32>;
    var param_207_: TileInfo;
    var param_208_: u32;
    var param_209_: vec2<u32>;
    var param_210_: TileInfo;
    var param_211_: u32;
    var param_212_: vec2<u32>;
    var param_213_: TileInfo;
    var param_214_: u32;
    var param_215_: vec2<u32>;
    var param_216_: TileInfo;
    var param_217_: u32;
    var param_218_: vec2<u32>;
    var param_219_: TileInfo;
    var param_220_: u32;
    var param_221_: vec2<u32>;
    var param_222_: TileInfo;
    var param_223_: u32;
    var param_224_: vec2<u32>;
    var param_225_: TileInfo;
    var param_226_: u32;
    var param_227_: vec2<u32>;
    var param_228_: TileInfo;
    var param_229_: u32;
    var param_230_: vec2<u32>;
    var param_231_: TileInfo;
    var param_232_: u32;
    var param_233_: vec2<u32>;
    var param_234_: TileInfo;
    var param_235_: u32;
    var param_236_: vec2<u32>;
    var param_237_: TileInfo;
    var param_238_: u32;
    var param_239_: vec2<u32>;
    var param_240_: TileInfo;
    var param_241_: u32;
    var param_242_: vec2<u32>;
    var param_243_: TileInfo;
    var param_244_: u32;
    var param_245_: vec2<u32>;
    var param_246_: TileInfo;
    var param_247_: u32;
    var param_248_: vec2<u32>;
    var param_249_: TileInfo;
    var param_250_: u32;
    var param_251_: vec2<u32>;
    var param_252_: TileInfo;
    var param_253_: u32;
    var param_254_: vec2<u32>;
    var param_255_: TileInfo;
    var param_256_: u32;
    var param_257_: vec2<u32>;
    var param_258_: TileInfo;
    var param_259_: u32;
    var param_260_: vec2<u32>;
    var param_261_: TileInfo;
    var param_262_: u32;
    var param_263_: vec2<u32>;
    var param_264_: TileInfo;
    var param_265_: u32;
    var param_266_: vec2<u32>;
    var param_267_: TileInfo;
    var param_268_: u32;
    var param_269_: vec2<u32>;
    var param_270_: TileInfo;
    var param_271_: u32;
    var param_272_: vec2<u32>;
    var param_273_: TileInfo;
    var param_274_: u32;
    var param_275_: vec2<u32>;
    var param_276_: TileInfo;
    var param_277_: u32;
    var param_278_: vec2<u32>;
    var param_279_: TileInfo;
    var param_280_: u32;
    var param_281_: vec2<u32>;
    var accum_1: vec4<i32>;
    var prev_sext: vec4<i32>;
    var _6112_: bool;
    var mid_rg: bool;
    var mid_ba: bool;
    var upper_ba: bool;
    var _6135_: bool;
    var upper_rg: bool;
    var _6151_: vec2<i32>;
    var factors_rg: vec2<i32>;
    var _6162_: vec2<i32>;
    var factors_ba: vec2<i32>;
    var converted_rg: vec2<i32>;
    var _6209_: vec2<i32>;
    var base_rg: vec2<i32>;
    var converted_ba: vec2<i32>;
    var _6275_: vec2<i32>;
    var base_ba: vec2<i32>;
    var converted: vec4<i32>;
    var accum_chroma: vec2<i32>;
    var accum_luma: vec2<i32>;
    var mid_chroma: bool;
    var param_282_: vec2<i32>;
    var param_283_: vec2<i32>;
    var param_284_: vec2<i32>;
    var param_285_: vec2<i32>;
    var param_286_: vec2<i32>;
    var param_287_: vec2<i32>;
    var param_288_: vec2<i32>;
    var param_289_: vec2<i32>;
    var param_290_: vec2<i32>;
    var param_291_: vec2<i32>;
    var _6435_: vec2<i32>;
    var _6449_: vec2<i32>;
    var _6489_: bool;
    var _6495_: vec2<i32>;
    var flip_frac_1: vec2<i32>;
    var param_292_: vec4<i32>;
    var param_293_: vec4<i32>;

    tile_37 = tile_36;
    tmem_instance_31 = tmem_instance_30;
    tlut_5 = tlut_4;
    tlut_type_11 = tlut_type_10;
    sample_quad_1 = sample_quad;
    mid_texel_state_1 = mid_texel_state;
    convert_one_1 = convert_one;
    bilerp_1 = bilerp;
    conversion_factors_1 = conversion_factors;
    prev_cycle_1 = prev_cycle;
    let _e89 = tile_37;
    param_13 = ((_e89.flags & 1i) != 0i);
    let _e96 = (*st_32);
    param_1_8 = _e96.x;
    let _e99 = tile_37;
    param_2_5 = i32(_e99.slo);
    let _e103 = tile_37;
    param_3_4 = i32(_e103.shi);
    let _e107 = tile_37;
    param_4_3 = _e107.shift_s;
    let _e110 = param_13;
    let _e112 = param_2_5;
    let _e113 = param_3_4;
    let _e114 = param_4_3;
    let _e116 = clamp_and_shift_coord(_e110, (&param_1_8), _e112, _e113, _e114);
    _4960_ = _e116;
    let _e119 = _4960_;
    (*st_32).x = _e119;
    let _e120 = tile_37;
    param_5_3 = ((_e120.flags & 4i) != 0i);
    let _e127 = (*st_32);
    param_6_3 = _e127.y;
    let _e130 = tile_37;
    param_7_3 = i32(_e130.tlo);
    let _e134 = tile_37;
    param_8_2 = i32(_e134.thi);
    let _e138 = tile_37;
    param_9_2 = _e138.shift_t;
    let _e141 = param_5_3;
    let _e143 = param_7_3;
    let _e144 = param_8_2;
    let _e145 = param_9_2;
    let _e147 = clamp_and_shift_coord(_e141, (&param_6_3), _e143, _e144, _e145);
    _4981_ = _e147;
    let _e150 = _4981_;
    (*st_32).y = _e150;
    let _e152 = sample_quad_1;
    let _e153 = tlut_5;
    if (_e152 || _e153) {
        {
            let _e155 = (*st_32);
            frac_2 = (_e155 & vec2(31i));
        }
    } else {
        {
            frac_2 = vec2(0i);
        }
    }
    let _e161 = frac_2;
    let _e163 = frac_2;
    sum_frac_1 = (_e161.x + _e163.y);
    let _e167 = (*st_32);
    (*st_32) = (_e167 >> vec2(5u));
    let _e173 = tile_37;
    param_10_1 = _e173;
    let _e175 = (*st_32);
    param_11_1 = _e175.x;
    let _e178 = param_10_1;
    let _e181 = texel_mask_s(_e178, (&param_11_1));
    _5008_ = _e181;
    let _e183 = _5008_;
    s0_ = _e183;
    let _e185 = tile_37;
    param_12_1 = _e185;
    let _e187 = (*st_32);
    param_13_1 = _e187.y;
    let _e190 = param_12_1;
    let _e193 = texel_mask_t(_e190, (&param_13_1));
    _5015_ = _e193;
    let _e195 = _5015_;
    t0_ = _e195;
    let _e197 = tile_37;
    param_14_1 = _e197;
    let _e199 = (*st_32);
    param_15_1 = (_e199.x + 1i);
    let _e204 = param_14_1;
    let _e207 = texel_mask_s(_e204, (&param_15_1));
    _5023_ = _e207;
    let _e209 = _5023_;
    s1_ = _e209;
    let _e211 = tile_37;
    param_16_1 = _e211;
    let _e213 = (*st_32);
    param_17_1 = (_e213.y + 1i);
    let _e218 = param_16_1;
    let _e221 = texel_mask_t(_e218, (&param_17_1));
    _5031_ = _e221;
    let _e223 = _5031_;
    t1_ = _e223;
    let _e225 = t1_;
    let _e226 = t0_;
    tdiff = max((_e225 - _e226), -255i);
    let _e232 = t0_;
    let _e235 = tdiff;
    t1_ = ((_e232 & 255i) + _e235);
    let _e237 = t0_;
    t0_ = (_e237 & 255i);
    let _e240 = mid_texel_state_1;
    let _e241 = bilerp_1;
    let _e242 = frac_2;
    let _e245 = (_e242 == vec2(16i));
    mid_texel = all(vec4<bool>(_e240, _e241, _e245.x, _e245.y));
    let _e251 = sum_frac_1;
    upper_lut = (_e251 >= 32i);
    let _e255 = mid_texel;
    if _e255 {
        {
            sum_frac_1 = 0i;
        }
    }
    let _e257 = tile_37;
    yuv = (_e257.fmt == 1i);
    let _e263 = sum_frac_1;
    if (_e263 >= 32i) {
        {
            let _e266 = s1_;
            let _e267 = t1_;
            _5067_ = vec2<i32>(_e266, _e267);
        }
    } else {
        {
            let _e269 = s0_;
            let _e270 = t0_;
            _5067_ = vec2<i32>(_e269, _e270);
        }
    }
    let _e272 = _5067_;
    base_st = _e272;
    let _e274 = s0_;
    let _e280 = frac_2;
    chroma_frac = (((_e274 & 1i) << 4u) | (_e280.x >> 1u));
    let _e291 = tlut_5;
    if _e291 {
        {
            let _e292 = sample_quad_1;
            if !(_e292) {
                {
                    let _e294 = s0_;
                    let _e295 = t0_;
                    base_st = vec2<i32>(_e294, _e295);
                    let _e297 = s0_;
                    s1_ = _e297;
                    let _e298 = t0_;
                    t1_ = _e298;
                }
            }
            let _e299 = tile_37;
            switch _e299.fmt {
                case 0, 2, 3, 4: {
                    let _e301 = sum_frac_1;
                    upper = (_e301 >= 32i);
                    let _e305 = upper_lut;
                    if _e305 {
                        local_7 = 2i;
                    } else {
                        local_7 = 1i;
                    }
                    let _e309 = local_7;
                    addr_xor_6 = u32(_e309);
                    let _e312 = tile_37;
                    switch _e312.size {
                        case 0: {
                            let _e314 = tile_37;
                            param_18_ = _e314;
                            let _e316 = tmem_instance_31;
                            param_19_ = _e316;
                            let _e318 = base_st;
                            param_20_ = vec2<u32>(_e318);
                            let _e321 = tile_37;
                            param_21_ = u32(_e321.palette);
                            let _e325 = upper;
                            if _e325 {
                                local_8 = 3i;
                            } else {
                                local_8 = 0i;
                            }
                            let _e329 = local_8;
                            param_22_ = u32(_e329);
                            let _e332 = addr_xor_6;
                            param_23_ = _e332;
                            let _e334 = tlut_type_11;
                            param_24_ = _e334;
                            let _e336 = param_18_;
                            let _e337 = param_19_;
                            let _e338 = param_20_;
                            let _e339 = param_21_;
                            let _e340 = param_22_;
                            let _e341 = param_23_;
                            let _e342 = param_24_;
                            let _e343 = sample_texel_ci4_tlut(_e336, _e337, _e338, _e339, _e340, _e341, _e342);
                            t_base_1 = _e343;
                            let _e344 = bilerp_1;
                            if _e344 {
                                {
                                    let _e345 = tile_37;
                                    param_25_ = _e345;
                                    let _e347 = tmem_instance_31;
                                    param_26_ = _e347;
                                    let _e349 = s1_;
                                    let _e350 = t0_;
                                    param_27_ = vec2<u32>(vec2<i32>(_e349, _e350));
                                    let _e354 = tile_37;
                                    param_28_ = u32(_e354.palette);
                                    let _e360 = addr_xor_6;
                                    param_30_ = _e360;
                                    let _e362 = tlut_type_11;
                                    param_31_ = _e362;
                                    let _e364 = param_25_;
                                    let _e365 = param_26_;
                                    let _e366 = param_27_;
                                    let _e367 = param_28_;
                                    let _e368 = param_29_;
                                    let _e369 = param_30_;
                                    let _e370 = param_31_;
                                    let _e371 = sample_texel_ci4_tlut(_e364, _e365, _e366, _e367, _e368, _e369, _e370);
                                    t10_2 = _e371;
                                    let _e372 = tile_37;
                                    param_32_ = _e372;
                                    let _e374 = tmem_instance_31;
                                    param_33_ = _e374;
                                    let _e376 = s0_;
                                    let _e377 = t1_;
                                    param_34_ = vec2<u32>(vec2<i32>(_e376, _e377));
                                    let _e381 = tile_37;
                                    param_35_ = u32(_e381.palette);
                                    let _e387 = addr_xor_6;
                                    param_37_ = _e387;
                                    let _e389 = tlut_type_11;
                                    param_38_ = _e389;
                                    let _e391 = param_32_;
                                    let _e392 = param_33_;
                                    let _e393 = param_34_;
                                    let _e394 = param_35_;
                                    let _e395 = param_36_;
                                    let _e396 = param_37_;
                                    let _e397 = param_38_;
                                    let _e398 = sample_texel_ci4_tlut(_e391, _e392, _e393, _e394, _e395, _e396, _e397);
                                    t01_2 = _e398;
                                }
                            }
                            let _e399 = mid_texel;
                            if _e399 {
                                {
                                    let _e400 = tile_37;
                                    param_39_ = _e400;
                                    let _e402 = tmem_instance_31;
                                    param_40_ = _e402;
                                    let _e404 = s1_;
                                    let _e405 = t1_;
                                    param_41_ = vec2<u32>(vec2<i32>(_e404, _e405));
                                    let _e409 = tile_37;
                                    param_42_ = u32(_e409.palette);
                                    let _e415 = addr_xor_6;
                                    param_44_ = _e415;
                                    let _e417 = tlut_type_11;
                                    param_45_ = _e417;
                                    let _e419 = param_39_;
                                    let _e420 = param_40_;
                                    let _e421 = param_41_;
                                    let _e422 = param_42_;
                                    let _e423 = param_43_;
                                    let _e424 = param_44_;
                                    let _e425 = param_45_;
                                    let _e426 = sample_texel_ci4_tlut(_e419, _e420, _e421, _e422, _e423, _e424, _e425);
                                    t11_2 = _e426;
                                }
                            }
                        }
                        case 1: {
                            let _e427 = tile_37;
                            param_46_ = _e427;
                            let _e429 = tmem_instance_31;
                            param_47_ = _e429;
                            let _e431 = base_st;
                            param_48_ = vec2<u32>(_e431);
                            let _e434 = upper;
                            if _e434 {
                                local_9 = 3i;
                            } else {
                                local_9 = 0i;
                            }
                            let _e438 = local_9;
                            param_49_ = u32(_e438);
                            let _e441 = addr_xor_6;
                            param_50_ = _e441;
                            let _e443 = tlut_type_11;
                            param_51_ = _e443;
                            let _e445 = param_46_;
                            let _e446 = param_47_;
                            let _e447 = param_48_;
                            let _e448 = param_49_;
                            let _e449 = param_50_;
                            let _e450 = param_51_;
                            let _e451 = sample_texel_ci8_tlut(_e445, _e446, _e447, _e448, _e449, _e450);
                            t_base_1 = _e451;
                            let _e452 = bilerp_1;
                            if _e452 {
                                {
                                    let _e453 = tile_37;
                                    param_52_ = _e453;
                                    let _e455 = tmem_instance_31;
                                    param_53_ = _e455;
                                    let _e457 = s1_;
                                    let _e458 = t0_;
                                    param_54_ = vec2<u32>(vec2<i32>(_e457, _e458));
                                    let _e464 = addr_xor_6;
                                    param_56_ = _e464;
                                    let _e466 = tlut_type_11;
                                    param_57_ = _e466;
                                    let _e468 = param_52_;
                                    let _e469 = param_53_;
                                    let _e470 = param_54_;
                                    let _e471 = param_55_;
                                    let _e472 = param_56_;
                                    let _e473 = param_57_;
                                    let _e474 = sample_texel_ci8_tlut(_e468, _e469, _e470, _e471, _e472, _e473);
                                    t10_2 = _e474;
                                    let _e475 = tile_37;
                                    param_58_ = _e475;
                                    let _e477 = tmem_instance_31;
                                    param_59_ = _e477;
                                    let _e479 = s0_;
                                    let _e480 = t1_;
                                    param_60_ = vec2<u32>(vec2<i32>(_e479, _e480));
                                    let _e486 = addr_xor_6;
                                    param_62_ = _e486;
                                    let _e488 = tlut_type_11;
                                    param_63_ = _e488;
                                    let _e490 = param_58_;
                                    let _e491 = param_59_;
                                    let _e492 = param_60_;
                                    let _e493 = param_61_;
                                    let _e494 = param_62_;
                                    let _e495 = param_63_;
                                    let _e496 = sample_texel_ci8_tlut(_e490, _e491, _e492, _e493, _e494, _e495);
                                    t01_2 = _e496;
                                }
                            }
                            let _e497 = mid_texel;
                            if _e497 {
                                {
                                    let _e498 = tile_37;
                                    param_64_ = _e498;
                                    let _e500 = tmem_instance_31;
                                    param_65_ = _e500;
                                    let _e502 = s1_;
                                    let _e503 = t1_;
                                    param_66_ = vec2<u32>(vec2<i32>(_e502, _e503));
                                    let _e509 = addr_xor_6;
                                    param_68_ = _e509;
                                    let _e511 = tlut_type_11;
                                    param_69_ = _e511;
                                    let _e513 = param_64_;
                                    let _e514 = param_65_;
                                    let _e515 = param_66_;
                                    let _e516 = param_67_;
                                    let _e517 = param_68_;
                                    let _e518 = param_69_;
                                    let _e519 = sample_texel_ci8_tlut(_e513, _e514, _e515, _e516, _e517, _e518);
                                    t11_2 = _e519;
                                }
                            }
                        }
                        default: {
                            let _e520 = tile_37;
                            param_70_ = _e520;
                            let _e522 = tmem_instance_31;
                            param_71_ = _e522;
                            let _e524 = base_st;
                            param_72_ = vec2<u32>(_e524);
                            let _e527 = upper;
                            if _e527 {
                                local_10 = 3i;
                            } else {
                                local_10 = 0i;
                            }
                            let _e531 = local_10;
                            param_73_ = u32(_e531);
                            let _e534 = addr_xor_6;
                            param_74_ = _e534;
                            let _e536 = tlut_type_11;
                            param_75_ = _e536;
                            let _e538 = param_70_;
                            let _e539 = param_71_;
                            let _e540 = param_72_;
                            let _e541 = param_73_;
                            let _e542 = param_74_;
                            let _e543 = param_75_;
                            let _e544 = sample_texel_ci32_tlut(_e538, _e539, _e540, _e541, _e542, _e543);
                            t_base_1 = _e544;
                            let _e545 = bilerp_1;
                            if _e545 {
                                {
                                    let _e546 = tile_37;
                                    param_76_ = _e546;
                                    let _e548 = tmem_instance_31;
                                    param_77_ = _e548;
                                    let _e550 = s1_;
                                    let _e551 = t0_;
                                    param_78_ = vec2<u32>(vec2<i32>(_e550, _e551));
                                    let _e557 = addr_xor_6;
                                    param_80_ = _e557;
                                    let _e559 = tlut_type_11;
                                    param_81_ = _e559;
                                    let _e561 = param_76_;
                                    let _e562 = param_77_;
                                    let _e563 = param_78_;
                                    let _e564 = param_79_;
                                    let _e565 = param_80_;
                                    let _e566 = param_81_;
                                    let _e567 = sample_texel_ci32_tlut(_e561, _e562, _e563, _e564, _e565, _e566);
                                    t10_2 = _e567;
                                    let _e568 = tile_37;
                                    param_82_ = _e568;
                                    let _e570 = tmem_instance_31;
                                    param_83_ = _e570;
                                    let _e572 = s0_;
                                    let _e573 = t1_;
                                    param_84_ = vec2<u32>(vec2<i32>(_e572, _e573));
                                    let _e579 = addr_xor_6;
                                    param_86_ = _e579;
                                    let _e581 = tlut_type_11;
                                    param_87_ = _e581;
                                    let _e583 = param_82_;
                                    let _e584 = param_83_;
                                    let _e585 = param_84_;
                                    let _e586 = param_85_;
                                    let _e587 = param_86_;
                                    let _e588 = param_87_;
                                    let _e589 = sample_texel_ci32_tlut(_e583, _e584, _e585, _e586, _e587, _e588);
                                    t01_2 = _e589;
                                }
                            }
                            let _e590 = mid_texel;
                            if _e590 {
                                {
                                    let _e591 = tile_37;
                                    param_88_ = _e591;
                                    let _e593 = tmem_instance_31;
                                    param_89_ = _e593;
                                    let _e595 = s1_;
                                    let _e596 = t1_;
                                    param_90_ = vec2<u32>(vec2<i32>(_e595, _e596));
                                    let _e602 = addr_xor_6;
                                    param_92_ = _e602;
                                    let _e604 = tlut_type_11;
                                    param_93_ = _e604;
                                    let _e606 = param_88_;
                                    let _e607 = param_89_;
                                    let _e608 = param_90_;
                                    let _e609 = param_91_;
                                    let _e610 = param_92_;
                                    let _e611 = param_93_;
                                    let _e612 = sample_texel_ci32_tlut(_e606, _e607, _e608, _e609, _e610, _e611);
                                    t11_2 = _e612;
                                }
                            }
                        }
                    }
                }
                default: {
                }
            }
        }
    } else {
        {
            let _e613 = tile_37;
            switch _e613.fmt {
                case 0: {
                    let _e615 = tile_37;
                    switch _e615.size {
                        case 0: {
                            let _e617 = tile_37;
                            param_94_ = _e617;
                            let _e619 = tmem_instance_31;
                            param_95_ = _e619;
                            let _e621 = base_st;
                            param_96_ = vec2<u32>(_e621);
                            let _e624 = param_94_;
                            let _e625 = param_95_;
                            let _e626 = param_96_;
                            let _e627 = sample_texel_rgba4_(_e624, _e625, _e626);
                            t_base_1 = _e627;
                            let _e628 = sample_quad_1;
                            if _e628 {
                                {
                                    let _e629 = tile_37;
                                    param_97_ = _e629;
                                    let _e631 = tmem_instance_31;
                                    param_98_ = _e631;
                                    let _e633 = s1_;
                                    let _e634 = t0_;
                                    param_99_ = vec2<u32>(vec2<i32>(_e633, _e634));
                                    let _e638 = param_97_;
                                    let _e639 = param_98_;
                                    let _e640 = param_99_;
                                    let _e641 = sample_texel_rgba4_(_e638, _e639, _e640);
                                    t10_2 = _e641;
                                    let _e642 = tile_37;
                                    param_100_ = _e642;
                                    let _e644 = tmem_instance_31;
                                    param_101_ = _e644;
                                    let _e646 = s0_;
                                    let _e647 = t1_;
                                    param_102_ = vec2<u32>(vec2<i32>(_e646, _e647));
                                    let _e651 = param_100_;
                                    let _e652 = param_101_;
                                    let _e653 = param_102_;
                                    let _e654 = sample_texel_rgba4_(_e651, _e652, _e653);
                                    t01_2 = _e654;
                                }
                            }
                            let _e655 = mid_texel;
                            if _e655 {
                                {
                                    let _e656 = tile_37;
                                    param_103_ = _e656;
                                    let _e658 = tmem_instance_31;
                                    param_104_ = _e658;
                                    let _e660 = s1_;
                                    let _e661 = t1_;
                                    param_105_ = vec2<u32>(vec2<i32>(_e660, _e661));
                                    let _e665 = param_103_;
                                    let _e666 = param_104_;
                                    let _e667 = param_105_;
                                    let _e668 = sample_texel_rgba4_(_e665, _e666, _e667);
                                    t11_2 = _e668;
                                }
                            }
                        }
                        case 1: {
                            let _e669 = tile_37;
                            param_106_ = _e669;
                            let _e671 = tmem_instance_31;
                            param_107_ = _e671;
                            let _e673 = base_st;
                            param_108_ = vec2<u32>(_e673);
                            let _e676 = param_106_;
                            let _e677 = param_107_;
                            let _e678 = param_108_;
                            let _e679 = sample_texel_rgba8_(_e676, _e677, _e678);
                            t_base_1 = _e679;
                            let _e680 = sample_quad_1;
                            if _e680 {
                                {
                                    let _e681 = tile_37;
                                    param_109_ = _e681;
                                    let _e683 = tmem_instance_31;
                                    param_110_ = _e683;
                                    let _e685 = s1_;
                                    let _e686 = t0_;
                                    param_111_ = vec2<u32>(vec2<i32>(_e685, _e686));
                                    let _e690 = param_109_;
                                    let _e691 = param_110_;
                                    let _e692 = param_111_;
                                    let _e693 = sample_texel_rgba8_(_e690, _e691, _e692);
                                    t10_2 = _e693;
                                    let _e694 = tile_37;
                                    param_112_ = _e694;
                                    let _e696 = tmem_instance_31;
                                    param_113_ = _e696;
                                    let _e698 = s0_;
                                    let _e699 = t1_;
                                    param_114_ = vec2<u32>(vec2<i32>(_e698, _e699));
                                    let _e703 = param_112_;
                                    let _e704 = param_113_;
                                    let _e705 = param_114_;
                                    let _e706 = sample_texel_rgba8_(_e703, _e704, _e705);
                                    t01_2 = _e706;
                                }
                            }
                            let _e707 = mid_texel;
                            if _e707 {
                                {
                                    let _e708 = tile_37;
                                    param_115_ = _e708;
                                    let _e710 = tmem_instance_31;
                                    param_116_ = _e710;
                                    let _e712 = s1_;
                                    let _e713 = t1_;
                                    param_117_ = vec2<u32>(vec2<i32>(_e712, _e713));
                                    let _e717 = param_115_;
                                    let _e718 = param_116_;
                                    let _e719 = param_117_;
                                    let _e720 = sample_texel_rgba8_(_e717, _e718, _e719);
                                    t11_2 = _e720;
                                }
                            }
                        }
                        case 2: {
                            let _e721 = tile_37;
                            param_118_ = _e721;
                            let _e723 = tmem_instance_31;
                            param_119_ = _e723;
                            let _e725 = base_st;
                            param_120_ = vec2<u32>(_e725);
                            let _e728 = param_118_;
                            let _e729 = param_119_;
                            let _e730 = param_120_;
                            let _e731 = sample_texel_rgba16_(_e728, _e729, _e730);
                            t_base_1 = _e731;
                            let _e732 = sample_quad_1;
                            if _e732 {
                                {
                                    let _e733 = tile_37;
                                    param_121_ = _e733;
                                    let _e735 = tmem_instance_31;
                                    param_122_ = _e735;
                                    let _e737 = s1_;
                                    let _e738 = t0_;
                                    param_123_ = vec2<u32>(vec2<i32>(_e737, _e738));
                                    let _e742 = param_121_;
                                    let _e743 = param_122_;
                                    let _e744 = param_123_;
                                    let _e745 = sample_texel_rgba16_(_e742, _e743, _e744);
                                    t10_2 = _e745;
                                    let _e746 = tile_37;
                                    param_124_ = _e746;
                                    let _e748 = tmem_instance_31;
                                    param_125_ = _e748;
                                    let _e750 = s0_;
                                    let _e751 = t1_;
                                    param_126_ = vec2<u32>(vec2<i32>(_e750, _e751));
                                    let _e755 = param_124_;
                                    let _e756 = param_125_;
                                    let _e757 = param_126_;
                                    let _e758 = sample_texel_rgba16_(_e755, _e756, _e757);
                                    t01_2 = _e758;
                                }
                            }
                            let _e759 = mid_texel;
                            if _e759 {
                                {
                                    let _e760 = tile_37;
                                    param_127_ = _e760;
                                    let _e762 = tmem_instance_31;
                                    param_128_ = _e762;
                                    let _e764 = s1_;
                                    let _e765 = t1_;
                                    param_129_ = vec2<u32>(vec2<i32>(_e764, _e765));
                                    let _e769 = param_127_;
                                    let _e770 = param_128_;
                                    let _e771 = param_129_;
                                    let _e772 = sample_texel_rgba16_(_e769, _e770, _e771);
                                    t11_2 = _e772;
                                }
                            }
                        }
                        case 3: {
                            let _e773 = tile_37;
                            param_130_ = _e773;
                            let _e775 = tmem_instance_31;
                            param_131_ = _e775;
                            let _e777 = base_st;
                            param_132_ = vec2<u32>(_e777);
                            let _e780 = param_130_;
                            let _e781 = param_131_;
                            let _e782 = param_132_;
                            let _e783 = sample_texel_rgba32_(_e780, _e781, _e782);
                            t_base_1 = _e783;
                            let _e784 = sample_quad_1;
                            if _e784 {
                                {
                                    let _e785 = tile_37;
                                    param_133_ = _e785;
                                    let _e787 = tmem_instance_31;
                                    param_134_ = _e787;
                                    let _e789 = s1_;
                                    let _e790 = t0_;
                                    param_135_ = vec2<u32>(vec2<i32>(_e789, _e790));
                                    let _e794 = param_133_;
                                    let _e795 = param_134_;
                                    let _e796 = param_135_;
                                    let _e797 = sample_texel_rgba32_(_e794, _e795, _e796);
                                    t10_2 = _e797;
                                    let _e798 = tile_37;
                                    param_136_ = _e798;
                                    let _e800 = tmem_instance_31;
                                    param_137_ = _e800;
                                    let _e802 = s0_;
                                    let _e803 = t1_;
                                    param_138_ = vec2<u32>(vec2<i32>(_e802, _e803));
                                    let _e807 = param_136_;
                                    let _e808 = param_137_;
                                    let _e809 = param_138_;
                                    let _e810 = sample_texel_rgba32_(_e807, _e808, _e809);
                                    t01_2 = _e810;
                                }
                            }
                            let _e811 = mid_texel;
                            if _e811 {
                                {
                                    let _e812 = tile_37;
                                    param_139_ = _e812;
                                    let _e814 = tmem_instance_31;
                                    param_140_ = _e814;
                                    let _e816 = s1_;
                                    let _e817 = t1_;
                                    param_141_ = vec2<u32>(vec2<i32>(_e816, _e817));
                                    let _e821 = param_139_;
                                    let _e822 = param_140_;
                                    let _e823 = param_141_;
                                    let _e824 = sample_texel_rgba32_(_e821, _e822, _e823);
                                    t11_2 = _e824;
                                }
                            }
                        }
                        default: {
                        }
                    }
                }
                case 1: {
                    let _e825 = s0_;
                    chroma_x0_ = u32((_e825 >> 1u));
                    let _e831 = s1_;
                    let _e832 = s1_;
                    let _e833 = s0_;
                    chroma_x1_ = u32(((_e831 + (_e832 - _e833)) >> 1u));
                    let _e841 = tile_37;
                    param_142_ = _e841;
                    let _e843 = tmem_instance_31;
                    param_143_ = _e843;
                    let _e845 = s0_;
                    let _e846 = t0_;
                    param_144_ = vec2<u32>(vec2<i32>(_e845, _e846));
                    let _e850 = chroma_x0_;
                    param_145_ = _e850;
                    let _e852 = param_142_;
                    let _e853 = param_143_;
                    let _e854 = param_144_;
                    let _e855 = param_145_;
                    let _e856 = sample_texel_yuv16_(_e852, _e853, _e854, _e855);
                    t_base_1 = _e856;
                    let _e857 = sample_quad_1;
                    if _e857 {
                        {
                            let _e858 = tile_37;
                            param_146_ = _e858;
                            let _e860 = tmem_instance_31;
                            param_147_ = _e860;
                            let _e862 = s1_;
                            let _e863 = t0_;
                            param_148_ = vec2<u32>(vec2<i32>(_e862, _e863));
                            let _e867 = chroma_x1_;
                            param_149_ = _e867;
                            let _e869 = param_146_;
                            let _e870 = param_147_;
                            let _e871 = param_148_;
                            let _e872 = param_149_;
                            let _e873 = sample_texel_yuv16_(_e869, _e870, _e871, _e872);
                            t10_2 = _e873;
                            let _e874 = tile_37;
                            param_150_ = _e874;
                            let _e876 = tmem_instance_31;
                            param_151_ = _e876;
                            let _e878 = s0_;
                            let _e879 = t1_;
                            param_152_ = vec2<u32>(vec2<i32>(_e878, _e879));
                            let _e883 = chroma_x0_;
                            param_153_ = _e883;
                            let _e885 = param_150_;
                            let _e886 = param_151_;
                            let _e887 = param_152_;
                            let _e888 = param_153_;
                            let _e889 = sample_texel_yuv16_(_e885, _e886, _e887, _e888);
                            t01_2 = _e889;
                            let _e890 = tile_37;
                            param_154_ = _e890;
                            let _e892 = tmem_instance_31;
                            param_155_ = _e892;
                            let _e894 = s1_;
                            let _e895 = t1_;
                            param_156_ = vec2<u32>(vec2<i32>(_e894, _e895));
                            let _e899 = chroma_x1_;
                            param_157_ = _e899;
                            let _e901 = param_154_;
                            let _e902 = param_155_;
                            let _e903 = param_156_;
                            let _e904 = param_157_;
                            let _e905 = sample_texel_yuv16_(_e901, _e902, _e903, _e904);
                            t11_2 = _e905;
                        }
                    }
                }
                case 2: {
                    let _e906 = tile_37;
                    switch _e906.size {
                        case 0: {
                            let _e908 = tile_37;
                            param_158_ = _e908;
                            let _e910 = tmem_instance_31;
                            param_159_ = _e910;
                            let _e912 = base_st;
                            param_160_ = vec2<u32>(_e912);
                            let _e915 = tile_37;
                            param_161_ = u32(_e915.palette);
                            let _e919 = param_158_;
                            let _e920 = param_159_;
                            let _e921 = param_160_;
                            let _e922 = param_161_;
                            let _e923 = sample_texel_ci4_(_e919, _e920, _e921, _e922);
                            t_base_1 = _e923;
                            let _e924 = sample_quad_1;
                            if _e924 {
                                {
                                    let _e925 = tile_37;
                                    param_162_ = _e925;
                                    let _e927 = tmem_instance_31;
                                    param_163_ = _e927;
                                    let _e929 = s1_;
                                    let _e930 = t0_;
                                    param_164_ = vec2<u32>(vec2<i32>(_e929, _e930));
                                    let _e934 = tile_37;
                                    param_165_ = u32(_e934.palette);
                                    let _e938 = param_162_;
                                    let _e939 = param_163_;
                                    let _e940 = param_164_;
                                    let _e941 = param_165_;
                                    let _e942 = sample_texel_ci4_(_e938, _e939, _e940, _e941);
                                    t10_2 = _e942;
                                    let _e943 = tile_37;
                                    param_166_ = _e943;
                                    let _e945 = tmem_instance_31;
                                    param_167_ = _e945;
                                    let _e947 = s0_;
                                    let _e948 = t1_;
                                    param_168_ = vec2<u32>(vec2<i32>(_e947, _e948));
                                    let _e952 = tile_37;
                                    param_169_ = u32(_e952.palette);
                                    let _e956 = param_166_;
                                    let _e957 = param_167_;
                                    let _e958 = param_168_;
                                    let _e959 = param_169_;
                                    let _e960 = sample_texel_ci4_(_e956, _e957, _e958, _e959);
                                    t01_2 = _e960;
                                }
                            }
                            let _e961 = mid_texel;
                            if _e961 {
                                {
                                    let _e962 = tile_37;
                                    param_170_ = _e962;
                                    let _e964 = tmem_instance_31;
                                    param_171_ = _e964;
                                    let _e966 = s1_;
                                    let _e967 = t1_;
                                    param_172_ = vec2<u32>(vec2<i32>(_e966, _e967));
                                    let _e971 = tile_37;
                                    param_173_ = u32(_e971.palette);
                                    let _e975 = param_170_;
                                    let _e976 = param_171_;
                                    let _e977 = param_172_;
                                    let _e978 = param_173_;
                                    let _e979 = sample_texel_ci4_(_e975, _e976, _e977, _e978);
                                    t11_2 = _e979;
                                }
                            }
                        }
                        case 1: {
                            let _e980 = tile_37;
                            param_174_ = _e980;
                            let _e982 = tmem_instance_31;
                            param_175_ = _e982;
                            let _e984 = base_st;
                            param_176_ = vec2<u32>(_e984);
                            let _e987 = param_174_;
                            let _e988 = param_175_;
                            let _e989 = param_176_;
                            let _e990 = sample_texel_rgba8_(_e987, _e988, _e989);
                            t_base_1 = _e990;
                            let _e991 = sample_quad_1;
                            if _e991 {
                                {
                                    let _e992 = tile_37;
                                    param_177_ = _e992;
                                    let _e994 = tmem_instance_31;
                                    param_178_ = _e994;
                                    let _e996 = s1_;
                                    let _e997 = t0_;
                                    param_179_ = vec2<u32>(vec2<i32>(_e996, _e997));
                                    let _e1001 = param_177_;
                                    let _e1002 = param_178_;
                                    let _e1003 = param_179_;
                                    let _e1004 = sample_texel_rgba8_(_e1001, _e1002, _e1003);
                                    t10_2 = _e1004;
                                    let _e1005 = tile_37;
                                    param_180_ = _e1005;
                                    let _e1007 = tmem_instance_31;
                                    param_181_ = _e1007;
                                    let _e1009 = s0_;
                                    let _e1010 = t1_;
                                    param_182_ = vec2<u32>(vec2<i32>(_e1009, _e1010));
                                    let _e1014 = param_180_;
                                    let _e1015 = param_181_;
                                    let _e1016 = param_182_;
                                    let _e1017 = sample_texel_rgba8_(_e1014, _e1015, _e1016);
                                    t01_2 = _e1017;
                                }
                            }
                            let _e1018 = mid_texel;
                            if _e1018 {
                                {
                                    let _e1019 = tile_37;
                                    param_183_ = _e1019;
                                    let _e1021 = tmem_instance_31;
                                    param_184_ = _e1021;
                                    let _e1023 = s1_;
                                    let _e1024 = t1_;
                                    param_185_ = vec2<u32>(vec2<i32>(_e1023, _e1024));
                                    let _e1028 = param_183_;
                                    let _e1029 = param_184_;
                                    let _e1030 = param_185_;
                                    let _e1031 = sample_texel_rgba8_(_e1028, _e1029, _e1030);
                                    t11_2 = _e1031;
                                }
                            }
                        }
                        default: {
                            let _e1032 = tile_37;
                            param_186_ = _e1032;
                            let _e1034 = tmem_instance_31;
                            param_187_ = _e1034;
                            let _e1036 = base_st;
                            param_188_ = vec2<u32>(_e1036);
                            let _e1039 = param_186_;
                            let _e1040 = param_187_;
                            let _e1041 = param_188_;
                            let _e1042 = sample_texel_ci32_(_e1039, _e1040, _e1041);
                            t_base_1 = _e1042;
                            let _e1043 = sample_quad_1;
                            if _e1043 {
                                {
                                    let _e1044 = tile_37;
                                    param_189_ = _e1044;
                                    let _e1046 = tmem_instance_31;
                                    param_190_ = _e1046;
                                    let _e1048 = s1_;
                                    let _e1049 = t0_;
                                    param_191_ = vec2<u32>(vec2<i32>(_e1048, _e1049));
                                    let _e1053 = param_189_;
                                    let _e1054 = param_190_;
                                    let _e1055 = param_191_;
                                    let _e1056 = sample_texel_ci32_(_e1053, _e1054, _e1055);
                                    t10_2 = _e1056;
                                    let _e1057 = tile_37;
                                    param_192_ = _e1057;
                                    let _e1059 = tmem_instance_31;
                                    param_193_ = _e1059;
                                    let _e1061 = s0_;
                                    let _e1062 = t1_;
                                    param_194_ = vec2<u32>(vec2<i32>(_e1061, _e1062));
                                    let _e1066 = param_192_;
                                    let _e1067 = param_193_;
                                    let _e1068 = param_194_;
                                    let _e1069 = sample_texel_ci32_(_e1066, _e1067, _e1068);
                                    t01_2 = _e1069;
                                }
                            }
                            let _e1070 = mid_texel;
                            if _e1070 {
                                {
                                    let _e1071 = tile_37;
                                    param_195_ = _e1071;
                                    let _e1073 = tmem_instance_31;
                                    param_196_ = _e1073;
                                    let _e1075 = s1_;
                                    let _e1076 = t1_;
                                    param_197_ = vec2<u32>(vec2<i32>(_e1075, _e1076));
                                    let _e1080 = param_195_;
                                    let _e1081 = param_196_;
                                    let _e1082 = param_197_;
                                    let _e1083 = sample_texel_ci32_(_e1080, _e1081, _e1082);
                                    t11_2 = _e1083;
                                }
                            }
                        }
                    }
                }
                case 3: {
                    let _e1084 = tile_37;
                    switch _e1084.size {
                        case 0: {
                            let _e1086 = tile_37;
                            param_198_ = _e1086;
                            let _e1088 = tmem_instance_31;
                            param_199_ = _e1088;
                            let _e1090 = base_st;
                            param_200_ = vec2<u32>(_e1090);
                            let _e1093 = param_198_;
                            let _e1094 = param_199_;
                            let _e1095 = param_200_;
                            let _e1096 = sample_texel_ia4_(_e1093, _e1094, _e1095);
                            t_base_1 = _e1096;
                            let _e1097 = sample_quad_1;
                            if _e1097 {
                                {
                                    let _e1098 = tile_37;
                                    param_201_ = _e1098;
                                    let _e1100 = tmem_instance_31;
                                    param_202_ = _e1100;
                                    let _e1102 = s1_;
                                    let _e1103 = t0_;
                                    param_203_ = vec2<u32>(vec2<i32>(_e1102, _e1103));
                                    let _e1107 = param_201_;
                                    let _e1108 = param_202_;
                                    let _e1109 = param_203_;
                                    let _e1110 = sample_texel_ia4_(_e1107, _e1108, _e1109);
                                    t10_2 = _e1110;
                                    let _e1111 = tile_37;
                                    param_204_ = _e1111;
                                    let _e1113 = tmem_instance_31;
                                    param_205_ = _e1113;
                                    let _e1115 = s0_;
                                    let _e1116 = t1_;
                                    param_206_ = vec2<u32>(vec2<i32>(_e1115, _e1116));
                                    let _e1120 = param_204_;
                                    let _e1121 = param_205_;
                                    let _e1122 = param_206_;
                                    let _e1123 = sample_texel_ia4_(_e1120, _e1121, _e1122);
                                    t01_2 = _e1123;
                                }
                            }
                            let _e1124 = mid_texel;
                            if _e1124 {
                                {
                                    let _e1125 = tile_37;
                                    param_207_ = _e1125;
                                    let _e1127 = tmem_instance_31;
                                    param_208_ = _e1127;
                                    let _e1129 = s1_;
                                    let _e1130 = t1_;
                                    param_209_ = vec2<u32>(vec2<i32>(_e1129, _e1130));
                                    let _e1134 = param_207_;
                                    let _e1135 = param_208_;
                                    let _e1136 = param_209_;
                                    let _e1137 = sample_texel_ia4_(_e1134, _e1135, _e1136);
                                    t11_2 = _e1137;
                                }
                            }
                        }
                        case 1: {
                            let _e1138 = tile_37;
                            param_210_ = _e1138;
                            let _e1140 = tmem_instance_31;
                            param_211_ = _e1140;
                            let _e1142 = base_st;
                            param_212_ = vec2<u32>(_e1142);
                            let _e1145 = param_210_;
                            let _e1146 = param_211_;
                            let _e1147 = param_212_;
                            let _e1148 = sample_texel_ia8_(_e1145, _e1146, _e1147);
                            t_base_1 = _e1148;
                            let _e1149 = sample_quad_1;
                            if _e1149 {
                                {
                                    let _e1150 = tile_37;
                                    param_213_ = _e1150;
                                    let _e1152 = tmem_instance_31;
                                    param_214_ = _e1152;
                                    let _e1154 = s1_;
                                    let _e1155 = t0_;
                                    param_215_ = vec2<u32>(vec2<i32>(_e1154, _e1155));
                                    let _e1159 = param_213_;
                                    let _e1160 = param_214_;
                                    let _e1161 = param_215_;
                                    let _e1162 = sample_texel_ia8_(_e1159, _e1160, _e1161);
                                    t10_2 = _e1162;
                                    let _e1163 = tile_37;
                                    param_216_ = _e1163;
                                    let _e1165 = tmem_instance_31;
                                    param_217_ = _e1165;
                                    let _e1167 = s0_;
                                    let _e1168 = t1_;
                                    param_218_ = vec2<u32>(vec2<i32>(_e1167, _e1168));
                                    let _e1172 = param_216_;
                                    let _e1173 = param_217_;
                                    let _e1174 = param_218_;
                                    let _e1175 = sample_texel_ia8_(_e1172, _e1173, _e1174);
                                    t01_2 = _e1175;
                                }
                            }
                            let _e1176 = mid_texel;
                            if _e1176 {
                                {
                                    let _e1177 = tile_37;
                                    param_219_ = _e1177;
                                    let _e1179 = tmem_instance_31;
                                    param_220_ = _e1179;
                                    let _e1181 = s1_;
                                    let _e1182 = t1_;
                                    param_221_ = vec2<u32>(vec2<i32>(_e1181, _e1182));
                                    let _e1186 = param_219_;
                                    let _e1187 = param_220_;
                                    let _e1188 = param_221_;
                                    let _e1189 = sample_texel_ia8_(_e1186, _e1187, _e1188);
                                    t11_2 = _e1189;
                                }
                            }
                        }
                        case 2: {
                            let _e1190 = tile_37;
                            param_222_ = _e1190;
                            let _e1192 = tmem_instance_31;
                            param_223_ = _e1192;
                            let _e1194 = base_st;
                            param_224_ = vec2<u32>(_e1194);
                            let _e1197 = param_222_;
                            let _e1198 = param_223_;
                            let _e1199 = param_224_;
                            let _e1200 = sample_texel_ia16_(_e1197, _e1198, _e1199);
                            t_base_1 = _e1200;
                            let _e1201 = sample_quad_1;
                            if _e1201 {
                                {
                                    let _e1202 = tile_37;
                                    param_225_ = _e1202;
                                    let _e1204 = tmem_instance_31;
                                    param_226_ = _e1204;
                                    let _e1206 = s1_;
                                    let _e1207 = t0_;
                                    param_227_ = vec2<u32>(vec2<i32>(_e1206, _e1207));
                                    let _e1211 = param_225_;
                                    let _e1212 = param_226_;
                                    let _e1213 = param_227_;
                                    let _e1214 = sample_texel_ia16_(_e1211, _e1212, _e1213);
                                    t10_2 = _e1214;
                                    let _e1215 = tile_37;
                                    param_228_ = _e1215;
                                    let _e1217 = tmem_instance_31;
                                    param_229_ = _e1217;
                                    let _e1219 = s0_;
                                    let _e1220 = t1_;
                                    param_230_ = vec2<u32>(vec2<i32>(_e1219, _e1220));
                                    let _e1224 = param_228_;
                                    let _e1225 = param_229_;
                                    let _e1226 = param_230_;
                                    let _e1227 = sample_texel_ia16_(_e1224, _e1225, _e1226);
                                    t01_2 = _e1227;
                                }
                            }
                            let _e1228 = mid_texel;
                            if _e1228 {
                                {
                                    let _e1229 = tile_37;
                                    param_231_ = _e1229;
                                    let _e1231 = tmem_instance_31;
                                    param_232_ = _e1231;
                                    let _e1233 = s1_;
                                    let _e1234 = t1_;
                                    param_233_ = vec2<u32>(vec2<i32>(_e1233, _e1234));
                                    let _e1238 = param_231_;
                                    let _e1239 = param_232_;
                                    let _e1240 = param_233_;
                                    let _e1241 = sample_texel_ia16_(_e1238, _e1239, _e1240);
                                    t11_2 = _e1241;
                                }
                            }
                        }
                        case 3: {
                            let _e1242 = tile_37;
                            param_234_ = _e1242;
                            let _e1244 = tmem_instance_31;
                            param_235_ = _e1244;
                            let _e1246 = base_st;
                            param_236_ = vec2<u32>(_e1246);
                            let _e1249 = param_234_;
                            let _e1250 = param_235_;
                            let _e1251 = param_236_;
                            let _e1252 = sample_texel_ci32_(_e1249, _e1250, _e1251);
                            t_base_1 = _e1252;
                            let _e1253 = sample_quad_1;
                            if _e1253 {
                                {
                                    let _e1254 = tile_37;
                                    param_237_ = _e1254;
                                    let _e1256 = tmem_instance_31;
                                    param_238_ = _e1256;
                                    let _e1258 = s1_;
                                    let _e1259 = t0_;
                                    param_239_ = vec2<u32>(vec2<i32>(_e1258, _e1259));
                                    let _e1263 = param_237_;
                                    let _e1264 = param_238_;
                                    let _e1265 = param_239_;
                                    let _e1266 = sample_texel_ci32_(_e1263, _e1264, _e1265);
                                    t10_2 = _e1266;
                                    let _e1267 = tile_37;
                                    param_240_ = _e1267;
                                    let _e1269 = tmem_instance_31;
                                    param_241_ = _e1269;
                                    let _e1271 = s0_;
                                    let _e1272 = t1_;
                                    param_242_ = vec2<u32>(vec2<i32>(_e1271, _e1272));
                                    let _e1276 = param_240_;
                                    let _e1277 = param_241_;
                                    let _e1278 = param_242_;
                                    let _e1279 = sample_texel_ci32_(_e1276, _e1277, _e1278);
                                    t01_2 = _e1279;
                                }
                            }
                            let _e1280 = mid_texel;
                            if _e1280 {
                                {
                                    let _e1281 = tile_37;
                                    param_243_ = _e1281;
                                    let _e1283 = tmem_instance_31;
                                    param_244_ = _e1283;
                                    let _e1285 = s1_;
                                    let _e1286 = t1_;
                                    param_245_ = vec2<u32>(vec2<i32>(_e1285, _e1286));
                                    let _e1290 = param_243_;
                                    let _e1291 = param_244_;
                                    let _e1292 = param_245_;
                                    let _e1293 = sample_texel_ci32_(_e1290, _e1291, _e1292);
                                    t11_2 = _e1293;
                                }
                            }
                        }
                        default: {
                        }
                    }
                }
                case 4: {
                    let _e1294 = tile_37;
                    switch _e1294.size {
                        case 0: {
                            let _e1296 = tile_37;
                            param_246_ = _e1296;
                            let _e1298 = tmem_instance_31;
                            param_247_ = _e1298;
                            let _e1300 = base_st;
                            param_248_ = vec2<u32>(_e1300);
                            let _e1303 = param_246_;
                            let _e1304 = param_247_;
                            let _e1305 = param_248_;
                            let _e1306 = sample_texel_rgba4_(_e1303, _e1304, _e1305);
                            t_base_1 = _e1306;
                            let _e1307 = sample_quad_1;
                            if _e1307 {
                                {
                                    let _e1308 = tile_37;
                                    param_249_ = _e1308;
                                    let _e1310 = tmem_instance_31;
                                    param_250_ = _e1310;
                                    let _e1312 = s1_;
                                    let _e1313 = t0_;
                                    param_251_ = vec2<u32>(vec2<i32>(_e1312, _e1313));
                                    let _e1317 = param_249_;
                                    let _e1318 = param_250_;
                                    let _e1319 = param_251_;
                                    let _e1320 = sample_texel_rgba4_(_e1317, _e1318, _e1319);
                                    t10_2 = _e1320;
                                    let _e1321 = tile_37;
                                    param_252_ = _e1321;
                                    let _e1323 = tmem_instance_31;
                                    param_253_ = _e1323;
                                    let _e1325 = s0_;
                                    let _e1326 = t1_;
                                    param_254_ = vec2<u32>(vec2<i32>(_e1325, _e1326));
                                    let _e1330 = param_252_;
                                    let _e1331 = param_253_;
                                    let _e1332 = param_254_;
                                    let _e1333 = sample_texel_rgba4_(_e1330, _e1331, _e1332);
                                    t01_2 = _e1333;
                                }
                            }
                            let _e1334 = mid_texel;
                            if _e1334 {
                                {
                                    let _e1335 = tile_37;
                                    param_255_ = _e1335;
                                    let _e1337 = tmem_instance_31;
                                    param_256_ = _e1337;
                                    let _e1339 = s1_;
                                    let _e1340 = t1_;
                                    param_257_ = vec2<u32>(vec2<i32>(_e1339, _e1340));
                                    let _e1344 = param_255_;
                                    let _e1345 = param_256_;
                                    let _e1346 = param_257_;
                                    let _e1347 = sample_texel_rgba4_(_e1344, _e1345, _e1346);
                                    t11_2 = _e1347;
                                }
                            }
                        }
                        case 1: {
                            let _e1348 = tile_37;
                            param_258_ = _e1348;
                            let _e1350 = tmem_instance_31;
                            param_259_ = _e1350;
                            let _e1352 = base_st;
                            param_260_ = vec2<u32>(_e1352);
                            let _e1355 = param_258_;
                            let _e1356 = param_259_;
                            let _e1357 = param_260_;
                            let _e1358 = sample_texel_rgba8_(_e1355, _e1356, _e1357);
                            t_base_1 = _e1358;
                            let _e1359 = sample_quad_1;
                            if _e1359 {
                                {
                                    let _e1360 = tile_37;
                                    param_261_ = _e1360;
                                    let _e1362 = tmem_instance_31;
                                    param_262_ = _e1362;
                                    let _e1364 = s1_;
                                    let _e1365 = t0_;
                                    param_263_ = vec2<u32>(vec2<i32>(_e1364, _e1365));
                                    let _e1369 = param_261_;
                                    let _e1370 = param_262_;
                                    let _e1371 = param_263_;
                                    let _e1372 = sample_texel_rgba8_(_e1369, _e1370, _e1371);
                                    t10_2 = _e1372;
                                    let _e1373 = tile_37;
                                    param_264_ = _e1373;
                                    let _e1375 = tmem_instance_31;
                                    param_265_ = _e1375;
                                    let _e1377 = s0_;
                                    let _e1378 = t1_;
                                    param_266_ = vec2<u32>(vec2<i32>(_e1377, _e1378));
                                    let _e1382 = param_264_;
                                    let _e1383 = param_265_;
                                    let _e1384 = param_266_;
                                    let _e1385 = sample_texel_rgba8_(_e1382, _e1383, _e1384);
                                    t01_2 = _e1385;
                                }
                            }
                            let _e1386 = mid_texel;
                            if _e1386 {
                                {
                                    let _e1387 = tile_37;
                                    param_267_ = _e1387;
                                    let _e1389 = tmem_instance_31;
                                    param_268_ = _e1389;
                                    let _e1391 = s1_;
                                    let _e1392 = t1_;
                                    param_269_ = vec2<u32>(vec2<i32>(_e1391, _e1392));
                                    let _e1396 = param_267_;
                                    let _e1397 = param_268_;
                                    let _e1398 = param_269_;
                                    let _e1399 = sample_texel_rgba8_(_e1396, _e1397, _e1398);
                                    t11_2 = _e1399;
                                }
                            }
                        }
                        default: {
                            let _e1400 = tile_37;
                            param_270_ = _e1400;
                            let _e1402 = tmem_instance_31;
                            param_271_ = _e1402;
                            let _e1404 = base_st;
                            param_272_ = vec2<u32>(_e1404);
                            let _e1407 = param_270_;
                            let _e1408 = param_271_;
                            let _e1409 = param_272_;
                            let _e1410 = sample_texel_ci32_(_e1407, _e1408, _e1409);
                            t_base_1 = _e1410;
                            let _e1411 = sample_quad_1;
                            if _e1411 {
                                {
                                    let _e1412 = tile_37;
                                    param_273_ = _e1412;
                                    let _e1414 = tmem_instance_31;
                                    param_274_ = _e1414;
                                    let _e1416 = s1_;
                                    let _e1417 = t0_;
                                    param_275_ = vec2<u32>(vec2<i32>(_e1416, _e1417));
                                    let _e1421 = param_273_;
                                    let _e1422 = param_274_;
                                    let _e1423 = param_275_;
                                    let _e1424 = sample_texel_ci32_(_e1421, _e1422, _e1423);
                                    t10_2 = _e1424;
                                    let _e1425 = tile_37;
                                    param_276_ = _e1425;
                                    let _e1427 = tmem_instance_31;
                                    param_277_ = _e1427;
                                    let _e1429 = s0_;
                                    let _e1430 = t1_;
                                    param_278_ = vec2<u32>(vec2<i32>(_e1429, _e1430));
                                    let _e1434 = param_276_;
                                    let _e1435 = param_277_;
                                    let _e1436 = param_278_;
                                    let _e1437 = sample_texel_ci32_(_e1434, _e1435, _e1436);
                                    t01_2 = _e1437;
                                }
                            }
                            let _e1438 = mid_texel;
                            if _e1438 {
                                {
                                    let _e1439 = tile_37;
                                    param_279_ = _e1439;
                                    let _e1441 = tmem_instance_31;
                                    param_280_ = _e1441;
                                    let _e1443 = s1_;
                                    let _e1444 = t1_;
                                    param_281_ = vec2<u32>(vec2<i32>(_e1443, _e1444));
                                    let _e1448 = param_279_;
                                    let _e1449 = param_280_;
                                    let _e1450 = param_281_;
                                    let _e1451 = sample_texel_ci32_(_e1448, _e1449, _e1450);
                                    t11_2 = _e1451;
                                }
                            }
                        }
                    }
                }
                default: {
                }
            }
        }
    }
    let _e1453 = convert_one_1;
    if _e1453 {
        {
            let _e1454 = prev_cycle_1;
            prev_sext = extractBits(vec4<i32>(_e1454), 0u, 9u);
            let _e1462 = sample_quad_1;
            if _e1462 {
                {
                    let _e1464 = yuv;
                    if _e1464 {
                        {
                            let _e1465 = mid_texel_state_1;
                            let _e1466 = chroma_frac;
                            let _e1467 = frac_2;
                            let _e1472 = (vec2<i32>(_e1466, _e1467.y) == vec2(16i));
                            _6112_ = all(vec3<bool>(_e1465, _e1472.x, _e1472.y));
                        }
                    } else {
                        {
                            let _e1477 = mid_texel;
                            _6112_ = _e1477;
                        }
                    }
                    let _e1478 = _6112_;
                    mid_rg = _e1478;
                    let _e1480 = mid_texel;
                    mid_ba = _e1480;
                    let _e1482 = sum_frac_1;
                    upper_ba = (_e1482 >= 32i);
                    let _e1487 = yuv;
                    if _e1487 {
                        {
                            let _e1488 = chroma_frac;
                            let _e1489 = frac_2;
                            let _e1494 = mid_rg;
                            _6135_ = (((_e1488 + _e1489.y) >= 32i) && !(_e1494));
                        }
                    } else {
                        {
                            let _e1497 = upper_ba;
                            _6135_ = _e1497;
                        }
                    }
                    let _e1498 = _6135_;
                    upper_rg = _e1498;
                    let _e1501 = upper_rg;
                    if _e1501 {
                        {
                            let _e1502 = prev_sext;
                            _6151_ = _e1502.yx;
                        }
                    } else {
                        {
                            let _e1504 = prev_sext;
                            _6151_ = _e1504.xy;
                        }
                    }
                    let _e1506 = _6151_;
                    factors_rg = _e1506;
                    let _e1509 = upper_ba;
                    if _e1509 {
                        {
                            let _e1510 = prev_sext;
                            _6162_ = _e1510.yx;
                        }
                    } else {
                        {
                            let _e1512 = prev_sext;
                            _6162_ = _e1512.xy;
                        }
                    }
                    let _e1514 = _6162_;
                    factors_ba = _e1514;
                    let _e1517 = mid_rg;
                    if _e1517 {
                        {
                            let _e1518 = factors_rg;
                            let _e1521 = t01_2;
                            let _e1523 = t11_2;
                            let _e1527 = factors_rg;
                            let _e1530 = t10_2;
                            let _e1532 = t11_2;
                            let _e1537 = t_base_1;
                            let _e1539 = t11_2;
                            converted_rg = ((((vec2(_e1518.x) * (_e1521.xy - _e1523.xy)) + (vec2(_e1527.y) * (_e1530.xy - _e1532.xy))) + ((_e1537.xy - _e1539.xy) << vec2(6u))) + vec2(128i));
                        }
                    } else {
                        {
                            let _e1552 = upper_rg;
                            let _e1553 = yuv;
                            if (_e1552 && _e1553) {
                                {
                                    let _e1555 = t11_2;
                                    _6209_ = _e1555.xy;
                                }
                            } else {
                                {
                                    let _e1557 = t_base_1;
                                    _6209_ = _e1557.xy;
                                }
                            }
                            let _e1559 = _6209_;
                            base_rg = _e1559;
                            let _e1561 = factors_rg;
                            let _e1564 = t10_2;
                            let _e1566 = base_rg;
                            let _e1569 = factors_rg;
                            let _e1572 = t01_2;
                            let _e1574 = base_rg;
                            converted_rg = (((vec2(_e1561.x) * (_e1564.xy - _e1566)) + (vec2(_e1569.y) * (_e1572.xy - _e1574))) + vec2(128i));
                        }
                    }
                    let _e1582 = mid_ba;
                    if _e1582 {
                        {
                            let _e1583 = factors_ba;
                            let _e1586 = t01_2;
                            let _e1588 = t11_2;
                            let _e1592 = factors_ba;
                            let _e1595 = t10_2;
                            let _e1597 = t11_2;
                            let _e1602 = t_base_1;
                            let _e1604 = t11_2;
                            converted_ba = ((((vec2(_e1583.x) * (_e1586.zw - _e1588.zw)) + (vec2(_e1592.y) * (_e1595.zw - _e1597.zw))) + ((_e1602.zw - _e1604.zw) << vec2(6u))) + vec2(128i));
                        }
                    } else {
                        {
                            let _e1617 = upper_ba;
                            let _e1618 = yuv;
                            if (_e1617 && _e1618) {
                                {
                                    let _e1620 = t11_2;
                                    _6275_ = _e1620.zw;
                                }
                            } else {
                                {
                                    let _e1622 = t_base_1;
                                    _6275_ = _e1622.zw;
                                }
                            }
                            let _e1624 = _6275_;
                            base_ba = _e1624;
                            let _e1626 = factors_ba;
                            let _e1629 = t10_2;
                            let _e1631 = base_ba;
                            let _e1634 = factors_ba;
                            let _e1637 = t01_2;
                            let _e1639 = base_ba;
                            converted_ba = (((vec2(_e1626.x) * (_e1629.zw - _e1631)) + (vec2(_e1634.y) * (_e1637.zw - _e1639))) + vec2(128i));
                        }
                    }
                    let _e1646 = converted_rg;
                    let _e1647 = converted_ba;
                    converted = vec4<i32>(_e1646.x, _e1646.y, _e1647.x, _e1647.y);
                    let _e1654 = converted;
                    converted = (_e1654 >> vec4(8u));
                    let _e1660 = converted;
                    let _e1661 = prev_sext;
                    converted = (_e1660 + vec4(_e1661.z));
                    let _e1665 = converted;
                    accum_1 = vec4<i32>(_e1665);
                }
            } else {
                {
                    let _e1667 = prev_sext;
                    accum_1 = vec4<i32>(_e1667.zzzz);
                }
            }
        }
    } else {
        {
            let _e1670 = yuv;
            if _e1670 {
                {
                    let _e1671 = sample_quad_1;
                    if _e1671 {
                        {
                            let _e1674 = bilerp_1;
                            if _e1674 {
                                {
                                    let _e1675 = mid_texel_state_1;
                                    let _e1676 = chroma_frac;
                                    let _e1677 = frac_2;
                                    let _e1682 = (vec2<i32>(_e1676, _e1677.y) == vec2(16i));
                                    mid_chroma = all(vec3<bool>(_e1675, _e1682.x, _e1682.y));
                                    let _e1688 = mid_chroma;
                                    if _e1688 {
                                        {
                                            let _e1689 = t_base_1;
                                            let _e1691 = t10_2;
                                            let _e1694 = t11_2;
                                            let _e1697 = t01_2;
                                            accum_chroma = (((((_e1689.xy + _e1691.xy) + _e1694.xy) + _e1697.xy) + vec2(2i)) >> vec2(2u));
                                        }
                                    } else {
                                        {
                                            let _e1708 = t_base_1;
                                            param_282_ = _e1708.xy;
                                            let _e1711 = t10_2;
                                            param_283_ = _e1711.xy;
                                            let _e1714 = t01_2;
                                            param_284_ = _e1714.xy;
                                            let _e1717 = t11_2;
                                            param_285_ = _e1717.xy;
                                            let _e1720 = chroma_frac;
                                            let _e1721 = frac_2;
                                            param_286_ = vec2<i32>(_e1720, _e1721.y);
                                            let _e1725 = param_282_;
                                            let _e1726 = param_283_;
                                            let _e1727 = param_284_;
                                            let _e1728 = param_285_;
                                            let _e1729 = param_286_;
                                            let _e1730 = bilinear_3tap(_e1725, _e1726, _e1727, _e1728, _e1729);
                                            accum_chroma = _e1730;
                                        }
                                    }
                                    let _e1731 = mid_texel;
                                    if _e1731 {
                                        {
                                            let _e1732 = t_base_1;
                                            let _e1734 = t10_2;
                                            let _e1737 = t11_2;
                                            let _e1740 = t01_2;
                                            accum_luma = (((((_e1732.zw + _e1734.zw) + _e1737.zw) + _e1740.zw) + vec2(2i)) >> vec2(2u));
                                        }
                                    } else {
                                        {
                                            let _e1751 = t_base_1;
                                            param_287_ = _e1751.zw;
                                            let _e1754 = t10_2;
                                            param_288_ = _e1754.zw;
                                            let _e1757 = t01_2;
                                            param_289_ = _e1757.zw;
                                            let _e1760 = t11_2;
                                            param_290_ = _e1760.zw;
                                            let _e1763 = frac_2;
                                            param_291_ = _e1763;
                                            let _e1765 = param_287_;
                                            let _e1766 = param_288_;
                                            let _e1767 = param_289_;
                                            let _e1768 = param_290_;
                                            let _e1769 = param_291_;
                                            let _e1770 = bilinear_3tap(_e1765, _e1766, _e1767, _e1768, _e1769);
                                            accum_luma = _e1770;
                                        }
                                    }
                                }
                            } else {
                                {
                                    let _e1772 = frac_2;
                                    let _e1774 = frac_2;
                                    if ((_e1772.x + _e1774.y) >= 32i) {
                                        {
                                            let _e1779 = t11_2;
                                            _6435_ = _e1779.zw;
                                        }
                                    } else {
                                        {
                                            let _e1781 = t_base_1;
                                            _6435_ = _e1781.zw;
                                        }
                                    }
                                    let _e1783 = _6435_;
                                    accum_luma = _e1783;
                                    let _e1785 = chroma_frac;
                                    let _e1786 = frac_2;
                                    if ((_e1785 + _e1786.y) >= 32i) {
                                        {
                                            let _e1791 = t11_2;
                                            _6449_ = _e1791.xy;
                                        }
                                    } else {
                                        {
                                            let _e1793 = t_base_1;
                                            _6449_ = _e1793.xy;
                                        }
                                    }
                                    let _e1795 = _6449_;
                                    accum_chroma = _e1795;
                                }
                            }
                            let _e1796 = accum_chroma;
                            let _e1797 = accum_luma;
                            accum_1 = vec4<i32>(_e1796.x, _e1796.y, _e1797.x, _e1797.y);
                        }
                    } else {
                        {
                            let _e1803 = t_base_1;
                            accum_1 = _e1803;
                        }
                    }
                }
            } else {
                {
                    let _e1804 = mid_texel;
                    if _e1804 {
                        {
                            let _e1805 = t_base_1;
                            let _e1806 = t01_2;
                            let _e1808 = t10_2;
                            let _e1810 = t11_2;
                            accum_1 = (((((_e1805 + _e1806) + _e1808) + _e1810) + vec4(2i)) >> vec4(2u));
                        }
                    } else {
                        {
                            let _e1821 = bilerp_1;
                            if _e1821 {
                                {
                                    let _e1822 = sample_quad_1;
                                    let _e1823 = tlut_5;
                                    _6489_ = (_e1822 || _e1823);
                                }
                            } else {
                                {
                                    let _e1825 = bilerp_1;
                                    _6489_ = _e1825;
                                }
                            }
                            let _e1826 = _6489_;
                            if _e1826 {
                                {
                                    let _e1828 = sum_frac_1;
                                    if (_e1828 >= 32i) {
                                        {
                                            let _e1833 = frac_2;
                                            _6495_ = (vec2(32i) - _e1833.yx);
                                        }
                                    } else {
                                        {
                                            let _e1836 = frac_2;
                                            _6495_ = _e1836;
                                        }
                                    }
                                    let _e1837 = _6495_;
                                    flip_frac_1 = vec2<i32>(_e1837);
                                    let _e1840 = t10_2;
                                    let _e1841 = t_base_1;
                                    let _e1843 = flip_frac_1;
                                    accum_1 = ((_e1840 - _e1841) * vec4(_e1843.x));
                                    let _e1847 = accum_1;
                                    let _e1848 = t01_2;
                                    let _e1849 = t_base_1;
                                    let _e1851 = flip_frac_1;
                                    accum_1 = (_e1847 + ((_e1848 - _e1849) * vec4(_e1851.y)));
                                    let _e1856 = accum_1;
                                    accum_1 = (_e1856 + vec4(16i));
                                    let _e1860 = accum_1;
                                    accum_1 = (_e1860 >> vec4(5u));
                                    let _e1866 = accum_1;
                                    let _e1867 = t_base_1;
                                    accum_1 = (_e1866 + _e1867);
                                }
                            } else {
                                {
                                    let _e1869 = t_base_1;
                                    accum_1 = _e1869;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    let _e1870 = bilerp_1;
    let _e1872 = convert_one_1;
    if (!(_e1870) && !(_e1872)) {
        {
            let _e1875 = accum_1;
            param_292_ = _e1875;
            let _e1877 = conversion_factors_1;
            param_293_ = _e1877;
            let _e1879 = param_292_;
            let _e1880 = param_293_;
            let _e1881 = texture_convert_factors(_e1879, _e1880);
            accum_1 = _e1881;
        }
    }
    let _e1882 = accum_1;
    return _e1882;
}

fn interpolate_st_single(stzw_2: vec4<i32>, dstzw_dx_4: vec4<i32>, dx_6: i32, perspective_4: bool) -> vec2<i32> {
    var stzw_3: vec4<i32>;
    var dstzw_dx_5: vec4<i32>;
    var dx_7: i32;
    var perspective_5: bool;
    var stw_6: vec3<i32>;
    var st_33: vec2<i32>;
    var param_14: vec3<i32>;
    var st_overflow_2: bool;
    var param_1_9: bool;
    var _3363_: vec2<i32>;
    var param_2_6: vec3<i32>;

    stzw_3 = stzw_2;
    dstzw_dx_5 = dstzw_dx_4;
    dx_7 = dx_6;
    perspective_5 = perspective_4;
    let _e76 = stzw_3;
    let _e78 = dstzw_dx_5;
    let _e89 = dx_7;
    stw_6 = (_e76.xyw + (((_e78.xyw & vec3(-32i)) >> vec3(0u)) * vec3(_e89)));
    let _e94 = stw_6;
    stw_6 = (_e94 >> vec3(16u));
    let _e101 = perspective_5;
    if _e101 {
        {
            let _e102 = stw_6;
            param_14 = _e102;
            let _e105 = st_overflow_2;
            param_1_9 = _e105;
            let _e107 = param_14;
            let _e110 = perspective_divide(_e107, (&param_1_9));
            _3363_ = _e110;
            let _e112 = param_1_9;
            st_overflow_2 = _e112;
            let _e113 = _3363_;
            st_33 = _e113;
        }
    } else {
        {
            let _e114 = stw_6;
            param_2_6 = _e114;
            let _e116 = param_2_6;
            let _e117 = no_perspective_divide(_e116);
            st_33 = _e117;
        }
    }
    let _e118 = st_33;
    return _e118;
}

fn noise_get_dither_color() -> i32 {
    let _e68 = seeded_noise;
    return (_e68 & 511i);
}

fn noise_get_dither_alpha() -> i32 {
    let _e68 = seeded_noise;
    return (_e68 & 7i);
}

fn dither_coefficients(x_6: i32, y_2: i32, dither_mode_rgb: i32, dither_mode_alpha: i32, rgb_dither: ptr<function, i32>, alpha_dither: ptr<function, i32>) {
    var x_7: i32;
    var y_3: i32;
    var dither_mode_rgb_1: i32;
    var dither_mode_alpha_1: i32;
    var local_11: array<i32, 32> = _973_;
    var _1007_: i32;
    var local_12: array<i32, 32> = _973_;

    x_7 = x_6;
    y_3 = y_2;
    dither_mode_rgb_1 = dither_mode_rgb;
    dither_mode_alpha_1 = dither_mode_alpha;
    let _e78 = dither_mode_rgb_1;
    if (_e78 < 2i) {
        {
            let _e81 = dither_mode_rgb_1;
            let _e84 = y_3;
            let _e89 = x_7;
            let _e97 = local_11[((_e81 * 16i) + (((_e84 & 3i) * 4i) + (_e89 & 3i)))];
            (*rgb_dither) = (_e97 * 73i);
        }
    } else {
        {
            let _e100 = dither_mode_rgb_1;
            if (_e100 == 2i) {
                {
                    let _e103 = noise_get_dither_color();
                    (*rgb_dither) = _e103;
                }
            } else {
                {
                    (*rgb_dither) = 0i;
                }
            }
        }
    }
    let _e105 = dither_mode_alpha_1;
    if (_e105 == 3i) {
        {
            (*alpha_dither) = 0i;
            return;
        }
    } else {
        {
            let _e109 = dither_mode_alpha_1;
            if (_e109 == 2i) {
                {
                    let _e112 = noise_get_dither_alpha();
                    (*alpha_dither) = _e112;
                    return;
                }
            } else {
                {
                    let _e114 = dither_mode_rgb_1;
                    if (_e114 >= 2i) {
                        {
                            let _e117 = dither_mode_rgb_1;
                            let _e122 = y_3;
                            let _e127 = x_7;
                            let _e135 = local_12[(((_e117 & 1i) * 16i) + (((_e122 & 3i) * 4i) + (_e127 & 3i)))];
                            _1007_ = _e135;
                        }
                    } else {
                        {
                            let _e136 = (*rgb_dither);
                            _1007_ = (_e136 & 7i);
                        }
                    }
                    let _e139 = _1007_;
                    (*alpha_dither) = _e139;
                    let _e140 = dither_mode_alpha_1;
                    if (_e140 == 1i) {
                        {
                            let _e143 = (*alpha_dither);
                            (*alpha_dither) = (~(_e143) & 7i);
                            return;
                        }
                    } else {
                        return;
                    }
                }
            }
        }
    }
}

fn noise_get_combiner() -> i32 {
    let _e68 = seeded_noise;
    return (((_e68 & 7i) << 6u) | 32i);
}

fn select_muladd(inputs: CombinerInputs, selector_rgb: i32, selector_alpha: i32) -> vec4<i32> {
    var inputs_1: CombinerInputs;
    var selector_rgb_1: i32;
    var selector_alpha_1: i32;
    var res: vec3<i32>;
    var alpha_3: i32;

    inputs_1 = inputs;
    selector_rgb_1 = selector_rgb;
    selector_alpha_1 = selector_alpha;
    let _e75 = selector_rgb_1;
    switch _e75 {
        case 0: {
            let _e76 = inputs_1;
            res = _e76.combined.xyz;
        }
        case 1: {
            let _e79 = inputs_1;
            res = _e79.texel0_.xyz;
        }
        case 2: {
            let _e82 = inputs_1;
            res = _e82.texel1_.xyz;
        }
        case 4: {
            let _e85 = inputs_1;
            res = _e85.shade.xyz;
        }
        case 7: {
            let _e88 = inputs_1;
            res = vec3(_e88._noise);
        }
        case 6: {
            res = vec3(256i);
        }
        default: {
            let _e93 = inputs_1;
            res = _e93.constant_muladd.xyz;
        }
    }
    let _e97 = selector_alpha_1;
    switch _e97 {
        case 0: {
            let _e98 = inputs_1;
            alpha_3 = _e98.combined.w;
        }
        case 1: {
            let _e101 = inputs_1;
            alpha_3 = _e101.texel0_.w;
        }
        case 2: {
            let _e104 = inputs_1;
            alpha_3 = _e104.texel1_.w;
        }
        case 4: {
            let _e107 = inputs_1;
            alpha_3 = _e107.shade.w;
        }
        case 6: {
            alpha_3 = 256i;
        }
        default: {
            let _e111 = inputs_1;
            alpha_3 = _e111.constant_muladd.w;
        }
    }
    let _e114 = res;
    let _e115 = alpha_3;
    return vec4<i32>(_e114.x, _e114.y, _e114.z, _e115);
}

fn select_mulsub(inputs_2: CombinerInputs, selector_rgb_2: i32, selector_alpha_2: i32) -> vec4<i32> {
    var inputs_3: CombinerInputs;
    var selector_rgb_3: i32;
    var selector_alpha_3: i32;
    var res_1: vec3<i32>;
    var alpha_4: i32;

    inputs_3 = inputs_2;
    selector_rgb_3 = selector_rgb_2;
    selector_alpha_3 = selector_alpha_2;
    let _e75 = selector_rgb_3;
    switch _e75 {
        case 0: {
            let _e76 = inputs_3;
            res_1 = _e76.combined.xyz;
        }
        case 1: {
            let _e79 = inputs_3;
            res_1 = _e79.texel0_.xyz;
        }
        case 2: {
            let _e82 = inputs_3;
            res_1 = _e82.texel1_.xyz;
        }
        case 4: {
            let _e85 = inputs_3;
            res_1 = _e85.shade.xyz;
        }
        case 7: {
            let _e88 = inputs_3;
            let _e94 = inputs_3;
            res_1 = vec3(((_e88.constant_mulsub.y << 8u) | _e94.constant_mulsub.z));
        }
        default: {
            let _e99 = inputs_3;
            res_1 = _e99.constant_mulsub.xyz;
        }
    }
    let _e103 = selector_alpha_3;
    switch _e103 {
        case 0: {
            let _e104 = inputs_3;
            alpha_4 = _e104.combined.w;
        }
        case 1: {
            let _e107 = inputs_3;
            alpha_4 = _e107.texel0_.w;
        }
        case 2: {
            let _e110 = inputs_3;
            alpha_4 = _e110.texel1_.w;
        }
        case 4: {
            let _e113 = inputs_3;
            alpha_4 = _e113.shade.w;
        }
        case 6: {
            alpha_4 = 256i;
        }
        default: {
            let _e117 = inputs_3;
            alpha_4 = _e117.constant_mulsub.w;
        }
    }
    let _e120 = res_1;
    let _e121 = alpha_4;
    return vec4<i32>(_e120.x, _e120.y, _e120.z, _e121);
}

fn select_mul(inputs_4: CombinerInputs, selector_rgb_4: i32, selector_alpha_4: i32) -> vec4<i32> {
    var inputs_5: CombinerInputs;
    var selector_rgb_5: i32;
    var selector_alpha_5: i32;
    var res_2: vec3<i32>;
    var alpha_5: i32;

    inputs_5 = inputs_4;
    selector_rgb_5 = selector_rgb_4;
    selector_alpha_5 = selector_alpha_4;
    let _e75 = selector_rgb_5;
    switch _e75 {
        case 0: {
            let _e76 = inputs_5;
            res_2 = _e76.combined.xyz;
        }
        case 7: {
            let _e79 = inputs_5;
            res_2 = _e79.combined.www;
        }
        case 1: {
            let _e82 = inputs_5;
            res_2 = _e82.texel0_.xyz;
        }
        case 2: {
            let _e85 = inputs_5;
            res_2 = _e85.texel1_.xyz;
        }
        case 4: {
            let _e88 = inputs_5;
            res_2 = _e88.shade.xyz;
        }
        case 8: {
            let _e91 = inputs_5;
            res_2 = _e91.texel0_.www;
        }
        case 9: {
            let _e94 = inputs_5;
            res_2 = _e94.texel1_.www;
        }
        case 11: {
            let _e97 = inputs_5;
            res_2 = _e97.shade.www;
        }
        case 13: {
            let _e100 = inputs_5;
            res_2 = vec3(_e100.lod_frac);
        }
        case 15: {
            let _e103 = inputs_5;
            let _e109 = inputs_5;
            res_2 = vec3(((_e103.constant_mul.y << 8u) | _e109.constant_mul.z));
        }
        default: {
            let _e114 = inputs_5;
            res_2 = _e114.constant_mul.xyz;
        }
    }
    let _e118 = selector_alpha_5;
    switch _e118 {
        case 0: {
            let _e119 = inputs_5;
            alpha_5 = _e119.lod_frac;
        }
        case 1: {
            let _e121 = inputs_5;
            alpha_5 = _e121.texel0_.w;
        }
        case 2: {
            let _e124 = inputs_5;
            alpha_5 = _e124.texel1_.w;
        }
        case 4: {
            let _e127 = inputs_5;
            alpha_5 = _e127.shade.w;
        }
        default: {
            let _e130 = inputs_5;
            alpha_5 = _e130.constant_mul.w;
        }
    }
    let _e133 = res_2;
    let _e134 = alpha_5;
    return vec4<i32>(_e133.x, _e133.y, _e133.z, _e134);
}

fn select_add(inputs_6: CombinerInputs, selector_rgb_6: i32, selector_alpha_6: i32) -> vec4<i32> {
    var inputs_7: CombinerInputs;
    var selector_rgb_7: i32;
    var selector_alpha_7: i32;
    var res_3: vec3<i32>;
    var alpha_6: i32;

    inputs_7 = inputs_6;
    selector_rgb_7 = selector_rgb_6;
    selector_alpha_7 = selector_alpha_6;
    let _e75 = selector_rgb_7;
    switch _e75 {
        case 0: {
            let _e76 = inputs_7;
            res_3 = _e76.combined.xyz;
        }
        case 1: {
            let _e79 = inputs_7;
            res_3 = _e79.texel0_.xyz;
        }
        case 2: {
            let _e82 = inputs_7;
            res_3 = _e82.texel1_.xyz;
        }
        case 4: {
            let _e85 = inputs_7;
            res_3 = _e85.shade.xyz;
        }
        case 6: {
            res_3 = vec3(256i);
        }
        default: {
            let _e90 = inputs_7;
            res_3 = _e90.constant_add.xyz;
        }
    }
    let _e94 = selector_alpha_7;
    switch _e94 {
        case 0: {
            let _e95 = inputs_7;
            alpha_6 = _e95.combined.w;
        }
        case 1: {
            let _e98 = inputs_7;
            alpha_6 = _e98.texel0_.w;
        }
        case 2: {
            let _e101 = inputs_7;
            alpha_6 = _e101.texel1_.w;
        }
        case 4: {
            let _e104 = inputs_7;
            alpha_6 = _e104.shade.w;
        }
        case 6: {
            alpha_6 = 256i;
        }
        default: {
            let _e108 = inputs_7;
            alpha_6 = _e108.constant_add.w;
        }
    }
    let _e111 = res_3;
    let _e112 = alpha_6;
    return vec4<i32>(_e111.x, _e111.y, _e111.z, _e112);
}

fn special_expand(value: vec4<i32>) -> vec4<i32> {
    var value_1: vec4<i32>;

    value_1 = value;
    let _e70 = value_1;
    return (extractBits((_e70 - vec4(128i)), 0u, 9u) + vec4(128i));
}

fn combiner_equation(a_1: ptr<function, vec4<i32>>, b_1: ptr<function, vec4<i32>>, c: ptr<function, vec4<i32>>, d: ptr<function, vec4<i32>>) -> vec4<i32> {
    var param_15: vec4<i32>;
    var param_1_10: vec4<i32>;
    var param_2_7: vec4<i32>;
    var color_3: vec4<i32>;

    let _e72 = (*c);
    (*c) = extractBits(_e72, 0u, 9u);
    let _e78 = (*a_1);
    param_15 = _e78;
    let _e80 = param_15;
    let _e81 = special_expand(_e80);
    (*a_1) = _e81;
    let _e82 = (*b_1);
    param_1_10 = _e82;
    let _e84 = param_1_10;
    let _e85 = special_expand(_e84);
    (*b_1) = _e85;
    let _e86 = (*d);
    param_2_7 = _e86;
    let _e88 = param_2_7;
    let _e89 = special_expand(_e88);
    (*d) = _e89;
    let _e90 = (*a_1);
    let _e91 = (*b_1);
    let _e93 = (*c);
    color_3 = ((_e90 - _e91) * _e93);
    let _e96 = color_3;
    color_3 = (_e96 + vec4(128i));
    let _e100 = color_3;
    let _e107 = (*d);
    return (vec4<i32>((_e100 >> vec4(8u))) + vec4<i32>(_e107));
}

fn combiner_cycle1_(inputs_8: CombinerInputs, combiner_inputs_rgb: vec4<i32>, combiner_inputs_alpha: vec4<i32>, alpha_dith: i32, coverage_4: ptr<function, i32>, cvg_times_alpha: bool, alpha_cvg_select: bool) -> vec4<i32> {
    var inputs_9: CombinerInputs;
    var combiner_inputs_rgb_1: vec4<i32>;
    var combiner_inputs_alpha_1: vec4<i32>;
    var alpha_dith_1: i32;
    var cvg_times_alpha_1: bool;
    var alpha_cvg_select_1: bool;
    var param_16: CombinerInputs;
    var param_1_11: i32;
    var param_2_8: i32;
    var muladd: vec4<i32>;
    var param_3_5: CombinerInputs;
    var param_4_4: i32;
    var param_5_4: i32;
    var mulsub: vec4<i32>;
    var param_6_4: CombinerInputs;
    var param_7_4: i32;
    var param_8_3: i32;
    var mul: vec4<i32>;
    var param_9_3: CombinerInputs;
    var param_10_2: i32;
    var param_11_2: i32;
    var add: vec4<i32>;
    var param_12_2: vec4<i32>;
    var param_13_2: vec4<i32>;
    var param_14_2: vec4<i32>;
    var param_15_2: vec4<i32>;
    var _7180_: vec4<i32>;
    var combined: vec4<i32>;
    var param_16_2: vec4<i32>;
    var _7183_: vec4<i32>;
    var expanded_alpha: i32;
    var modulated_alpha: i32;

    inputs_9 = inputs_8;
    combiner_inputs_rgb_1 = combiner_inputs_rgb;
    combiner_inputs_alpha_1 = combiner_inputs_alpha;
    alpha_dith_1 = alpha_dith;
    cvg_times_alpha_1 = cvg_times_alpha;
    alpha_cvg_select_1 = alpha_cvg_select;
    let _e81 = inputs_9;
    param_16 = _e81;
    let _e83 = combiner_inputs_rgb_1;
    param_1_11 = _e83.x;
    let _e86 = combiner_inputs_alpha_1;
    param_2_8 = _e86.x;
    let _e89 = param_16;
    let _e90 = param_1_11;
    let _e91 = param_2_8;
    let _e92 = select_muladd(_e89, _e90, _e91);
    muladd = _e92;
    let _e94 = inputs_9;
    param_3_5 = _e94;
    let _e96 = combiner_inputs_rgb_1;
    param_4_4 = _e96.y;
    let _e99 = combiner_inputs_alpha_1;
    param_5_4 = _e99.y;
    let _e102 = param_3_5;
    let _e103 = param_4_4;
    let _e104 = param_5_4;
    let _e105 = select_mulsub(_e102, _e103, _e104);
    mulsub = _e105;
    let _e107 = inputs_9;
    param_6_4 = _e107;
    let _e109 = combiner_inputs_rgb_1;
    param_7_4 = _e109.z;
    let _e112 = combiner_inputs_alpha_1;
    param_8_3 = _e112.z;
    let _e115 = param_6_4;
    let _e116 = param_7_4;
    let _e117 = param_8_3;
    let _e118 = select_mul(_e115, _e116, _e117);
    mul = _e118;
    let _e120 = inputs_9;
    param_9_3 = _e120;
    let _e122 = combiner_inputs_rgb_1;
    param_10_2 = _e122.w;
    let _e125 = combiner_inputs_alpha_1;
    param_11_2 = _e125.w;
    let _e128 = param_9_3;
    let _e129 = param_10_2;
    let _e130 = param_11_2;
    let _e131 = select_add(_e128, _e129, _e130);
    add = _e131;
    let _e133 = muladd;
    param_12_2 = _e133;
    let _e135 = mulsub;
    param_13_2 = _e135;
    let _e137 = mul;
    param_14_2 = _e137;
    let _e139 = add;
    param_15_2 = _e139;
    let _e149 = combiner_equation((&param_12_2), (&param_13_2), (&param_14_2), (&param_15_2));
    _7180_ = _e149;
    let _e151 = _7180_;
    combined = _e151;
    let _e153 = combined;
    param_16_2 = _e153;
    let _e157 = clamp_9bit_notrunc((&param_16_2));
    _7183_ = _e157;
    let _e159 = _7183_;
    combined = _e159;
    let _e160 = combined;
    let _e162 = combined;
    expanded_alpha = (_e160.w + ((_e162.w + 1i) >> 8u));
    let _e172 = cvg_times_alpha_1;
    if _e172 {
        {
            let _e173 = expanded_alpha;
            let _e174 = (*coverage_4);
            modulated_alpha = (((_e173 * _e174) + 4i) >> 3u);
            let _e181 = modulated_alpha;
            (*coverage_4) = (_e181 >> 5u);
        }
    } else {
        {
            let _e185 = (*coverage_4);
            modulated_alpha = (_e185 << 5u);
        }
    }
    let _e189 = alpha_cvg_select_1;
    if _e189 {
        {
            let _e190 = modulated_alpha;
            expanded_alpha = _e190;
        }
    } else {
        {
            let _e191 = expanded_alpha;
            let _e192 = alpha_dith_1;
            expanded_alpha = (_e191 + _e192);
        }
    }
    let _e195 = expanded_alpha;
    combined.w = clamp(_e195, 0i, 255i);
    let _e199 = combined;
    return _e199;
}

fn clamp_9bit_1(color_4: i32) -> i32 {
    var color_5: i32;

    color_5 = color_4;
    let _e70 = color_5;
    return clamp((extractBits((_e70 - 128i), 0u, 9u) + 128i), 0i, 255i);
}

fn combiner_cycle0_(inputs_10: CombinerInputs, combiner_inputs_rgb_2: vec4<i32>, combiner_inputs_alpha_2: vec4<i32>, alpha_dith_2: i32, coverage_5: i32, cvg_times_alpha_2: bool, alpha_cvg_select_2: bool, alpha_test: bool, alpha_test_reference: ptr<function, i32>) -> vec4<i32> {
    var inputs_11: CombinerInputs;
    var combiner_inputs_rgb_3: vec4<i32>;
    var combiner_inputs_alpha_3: vec4<i32>;
    var alpha_dith_3: i32;
    var coverage_6: i32;
    var cvg_times_alpha_3: bool;
    var alpha_cvg_select_3: bool;
    var alpha_test_1: bool;
    var param_17: CombinerInputs;
    var param_1_12: i32;
    var param_2_9: i32;
    var muladd_1: vec4<i32>;
    var param_3_6: CombinerInputs;
    var param_4_5: i32;
    var param_5_5: i32;
    var mulsub_1: vec4<i32>;
    var param_6_5: CombinerInputs;
    var param_7_5: i32;
    var param_8_4: i32;
    var mul_1: vec4<i32>;
    var param_9_4: CombinerInputs;
    var param_10_3: i32;
    var param_11_3: i32;
    var add_1: vec4<i32>;
    var param_12_3: vec4<i32>;
    var param_13_3: vec4<i32>;
    var param_14_3: vec4<i32>;
    var param_15_3: vec4<i32>;
    var _7090_: vec4<i32>;
    var combined_1: vec4<i32>;
    var param_16_3: i32;
    var clamped_alpha: i32;
    var expanded_alpha_1: i32;
    var modulated_alpha_1: i32;

    inputs_11 = inputs_10;
    combiner_inputs_rgb_3 = combiner_inputs_rgb_2;
    combiner_inputs_alpha_3 = combiner_inputs_alpha_2;
    alpha_dith_3 = alpha_dith_2;
    coverage_6 = coverage_5;
    cvg_times_alpha_3 = cvg_times_alpha_2;
    alpha_cvg_select_3 = alpha_cvg_select_2;
    alpha_test_1 = alpha_test;
    let _e85 = inputs_11;
    param_17 = _e85;
    let _e87 = combiner_inputs_rgb_3;
    param_1_12 = _e87.x;
    let _e90 = combiner_inputs_alpha_3;
    param_2_9 = _e90.x;
    let _e93 = param_17;
    let _e94 = param_1_12;
    let _e95 = param_2_9;
    let _e96 = select_muladd(_e93, _e94, _e95);
    muladd_1 = _e96;
    let _e98 = inputs_11;
    param_3_6 = _e98;
    let _e100 = combiner_inputs_rgb_3;
    param_4_5 = _e100.y;
    let _e103 = combiner_inputs_alpha_3;
    param_5_5 = _e103.y;
    let _e106 = param_3_6;
    let _e107 = param_4_5;
    let _e108 = param_5_5;
    let _e109 = select_mulsub(_e106, _e107, _e108);
    mulsub_1 = _e109;
    let _e111 = inputs_11;
    param_6_5 = _e111;
    let _e113 = combiner_inputs_rgb_3;
    param_7_5 = _e113.z;
    let _e116 = combiner_inputs_alpha_3;
    param_8_4 = _e116.z;
    let _e119 = param_6_5;
    let _e120 = param_7_5;
    let _e121 = param_8_4;
    let _e122 = select_mul(_e119, _e120, _e121);
    mul_1 = _e122;
    let _e124 = inputs_11;
    param_9_4 = _e124;
    let _e126 = combiner_inputs_rgb_3;
    param_10_3 = _e126.w;
    let _e129 = combiner_inputs_alpha_3;
    param_11_3 = _e129.w;
    let _e132 = param_9_4;
    let _e133 = param_10_3;
    let _e134 = param_11_3;
    let _e135 = select_add(_e132, _e133, _e134);
    add_1 = _e135;
    let _e137 = muladd_1;
    param_12_3 = _e137;
    let _e139 = mulsub_1;
    param_13_3 = _e139;
    let _e141 = mul_1;
    param_14_3 = _e141;
    let _e143 = add_1;
    param_15_3 = _e143;
    let _e153 = combiner_equation((&param_12_3), (&param_13_3), (&param_14_3), (&param_15_3));
    _7090_ = _e153;
    let _e155 = _7090_;
    combined_1 = _e155;
    let _e157 = alpha_test_1;
    if _e157 {
        {
            let _e158 = combined_1;
            param_16_3 = _e158.w;
            let _e161 = param_16_3;
            let _e162 = clamp_9bit_1(_e161);
            clamped_alpha = _e162;
            let _e164 = clamped_alpha;
            let _e165 = clamped_alpha;
            expanded_alpha_1 = (_e164 + ((_e165 + 1i) >> 8u));
            let _e173 = alpha_cvg_select_3;
            if _e173 {
                {
                    let _e175 = cvg_times_alpha_3;
                    if _e175 {
                        {
                            let _e176 = expanded_alpha_1;
                            let _e177 = coverage_6;
                            modulated_alpha_1 = (((_e176 * _e177) + 4i) >> 3u);
                        }
                    } else {
                        {
                            let _e184 = coverage_6;
                            modulated_alpha_1 = (_e184 << 5u);
                        }
                    }
                    let _e188 = modulated_alpha_1;
                    expanded_alpha_1 = _e188;
                }
            } else {
                {
                    let _e189 = expanded_alpha_1;
                    let _e190 = alpha_dith_3;
                    expanded_alpha_1 = (_e189 + _e190);
                }
            }
            let _e192 = expanded_alpha_1;
            (*alpha_test_reference) = clamp(_e192, 0i, 255i);
        }
    } else {
        {
            (*alpha_test_reference) = 0i;
        }
    }
    let _e197 = combined_1;
    return _e197;
}

fn noise_get_blend_threshold() -> i32 {
    let _e68 = seeded_noise;
    return (_e68 & 255i);
}

fn shade_pixel(x_8: i32, y_4: i32, primitive_index: u32, shaded: ptr<function, ShadedData>) -> bool {
    var x_9: i32;
    var y_5: i32;
    var primitive_index_1: u32;
    var param_18: u32;
    var span_offsets_1_: SpanInfoOffsetsMem;
    var _7228_: bool;
    var _7239_: bool;
    var setup_flags: u32;
    var param_1_13: u32;
    var span_setup: SpanSetup;
    var setup_tile: u32;
    var param_2_10: u32;
    var attr: AttributeSetupMem;
    var states: vec4<u32>;
    var static_state_index: u32;
    var tmem_instance_index: u32;
    var param_3_7: u32;
    var static_state: StaticRasterizationState;
    var static_state_flags: u32;
    var static_state_dither: i32;
    var combiner_inputs_rgb0_: vec4<i32>;
    var combiner_inputs_alpha0_: vec4<i32>;
    var combiner_inputs_rgb1_: vec4<i32>;
    var combiner_inputs_alpha1_: vec4<i32>;
    var tlut_6: bool;
    var tlut_type_12: bool;
    var sample_quad_2: bool;
    var cvg_times_alpha_4: bool;
    var alpha_cvg_select_4: bool;
    var perspective_6: bool;
    var tex_lod_en_2: bool;
    var sharpen_lod_en: bool;
    var detail_lod_en: bool;
    var aa_enable: bool;
    var multi_cycle: bool;
    var interlace_en: bool;
    var fill_en: bool;
    var copy_en: bool;
    var alpha_test_2: bool;
    var alpha_test_dither: bool;
    var mid_texel_1: bool;
    var uses_texel0_: bool;
    var uses_texel1_: bool;
    var uses_pipelined_texel1_: bool;
    var uses_lod_2: bool;
    var convert_one_2: bool;
    var bilerp0_: bool;
    var bilerp1_: bool;
    var param_4_6: u32;
    var param_5_6: u32;
    var param_6_6: u32;
    var flip_2: bool;
    var _7470_: bool;
    var _7477_: bool;
    var valid: bool;
    var param_7_6: SpanSetup;
    var param_8_5: vec4<i32>;
    var param_9_5: i32;
    var param_10_4: bool;
    var param_11_4: bool;
    var param_12_4: vec2<i32>;
    var param_13_4: i32;
    var st_34: vec2<i32>;
    var s_offset_5: i32;
    var tile0_1: u32;
    var tile_info_index0_: u32;
    var param_14_4: u32;
    var tile_info0_: TileInfo;
    var param_15_4: TileInfo;
    var param_16_4: u32;
    var param_17_2: vec2<i32>;
    var param_18_1: i32;
    var param_19_1: bool;
    var param_20_1: bool;
    var _7527_: i32;
    var texel0_: i32;
    var _7537_: bool;
    var _7543_: bool;
    var _7556_: bool;
    var _7563_: bool;
    var param_21_1: vec4<i32>;
    var param_22_1: vec4<i32>;
    var param_23_1: i32;
    var coverage_7: i32;
    var coverage_count: i32;
    var _7584_: bool;
    var _7590_: bool;
    var param_24_1: u32;
    var derived: DerivedSetup;
    var dx_8: i32;
    var local_13: i32;
    var interpolation_direction: i32;
    var param_25_1: vec4<i32>;
    var param_26_1: vec4<i32>;
    var param_27_1: vec4<i32>;
    var param_28_1: i32;
    var param_29_1: i32;
    var _7620_: vec4<i32>;
    var shade: vec4<i32>;
    var perspective_overflow_2: bool = false;
    var tex_interpolation_direction: i32;
    var param_30_1: vec4<i32>;
    var param_31_1: vec4<i32>;
    var param_32_1: vec4<i32>;
    var param_33_1: i32;
    var param_34_1: i32;
    var param_35_1: bool;
    var param_36_1: bool;
    var param_37_1: i32;
    var param_42_1: bool;
    var param_38_1: vec2<i32>;
    var param_39_1: vec2<i32>;
    var param_40_1: vec2<i32>;
    var param_41_1: i32;
    var st_1_: vec2<i32>;
    var st_dx_3: vec2<i32>;
    var st_dy_3: vec2<i32>;
    var z_2: i32;
    var tile0_1_: u32;
    var tile1_1: u32;
    var max_level_2: u32;
    var min_lod_2: i32;
    var lod_frac_1: i32;
    var param_43_1: u32;
    var param_44_1: u32;
    var param_46_1: u32;
    var param_47_1: i32;
    var param_48_1: vec2<i32>;
    var param_49_1: vec2<i32>;
    var param_50_1: vec2<i32>;
    var param_51_1: bool;
    var param_52_1: bool;
    var param_53_1: bool;
    var param_54_1: bool;
    var param_45_1: i32;
    var texel0_1_: vec4<i32>;
    var tile_info_index0_1_: u32;
    var param_55_1: u32;
    var tile_info0_1_: TileInfo;
    var param_56_1: TileInfo;
    var param_57_1: u32;
    var param_58_1: vec2<i32>;
    var param_59_1: bool;
    var param_60_1: bool;
    var param_61_1: bool;
    var param_62_1: bool;
    var param_63_1: bool = false;
    var param_64_1: bool;
    var param_65_1: vec4<i32>;
    var param_66_1: vec4<i32> = vec4(0i);
    var _7750_: vec4<i32>;
    var valid_line: bool;
    var long_span: bool;
    var _7776_: i32;
    var end_span: bool;
    var stw_7: vec3<i32>;
    var param_67_1: vec3<i32>;
    var st_overflow_3: bool;
    var param_68_1: bool;
    var _7817_: vec2<i32>;
    var param_69_1: vec3<i32>;
    var param_70_1: vec4<i32>;
    var param_71_1: vec4<i32>;
    var param_72_1: i32;
    var param_73_1: bool;
    var texel1_: vec4<i32>;
    var param_74_1: vec4<i32>;
    var param_75_1: vec4<i32>;
    var tile_info_index1_: u32;
    var param_76_1: u32;
    var tile_info1_: TileInfo;
    var param_77_1: TileInfo;
    var param_78_1: u32;
    var param_79_1: vec2<i32>;
    var param_80_1: bool;
    var param_81_1: bool;
    var param_82_1: bool;
    var param_83_1: bool;
    var param_84_1: bool;
    var param_85_1: bool;
    var param_86_1: vec4<i32>;
    var param_87_1: vec4<i32>;
    var _7889_: vec4<i32>;
    var param_88_1: i32;
    var param_89_1: i32;
    var param_90_1: i32;
    var param_91_1: i32;
    var param_92_1: i32;
    var param_93_1: i32;
    var rgb_dith: i32;
    var alpha_dith_4: i32;
    var alpha_reference: i32;
    var combined_2: vec4<i32>;
    var combined_inputs: CombinerInputs;
    var param_94_1: CombinerInputs;
    var param_95_1: vec4<i32>;
    var param_96_1: vec4<i32>;
    var param_97_1: i32;
    var param_98_1: i32;
    var param_99_1: bool;
    var param_100_1: bool;
    var param_101_1: bool;
    var param_102_1: i32;
    var _7946_: vec4<i32>;
    var tmp_texel: vec4<i32>;
    var param_103_1: u32;
    var param_104_1: u32;
    var param_105_1: u32;
    var param_106_1: CombinerInputs;
    var param_107_1: vec4<i32>;
    var param_108_1: vec4<i32>;
    var param_109_1: i32;
    var param_110_1: i32;
    var param_111_1: bool;
    var param_112_1: bool;
    var _8007_: vec4<i32>;
    var combined_inputs_1_: CombinerInputs;
    var param_113_1: CombinerInputs;
    var param_114_1: vec4<i32>;
    var param_115_1: vec4<i32>;
    var param_116_1: i32;
    var param_117_1: i32;
    var param_118_1: bool;
    var param_119_1: bool;
    var _8044_: vec4<i32>;
    var alpha_threshold: i32;

    x_9 = x_8;
    y_5 = y_4;
    primitive_index_1 = primitive_index;
    let _e75 = primitive_index_1;
    param_18 = _e75;
    let _e77 = param_18;
    let _e78 = load_span_offsets(_e77);
    span_offsets_1_ = _e78;
    let _e80 = y_5;
    let _e82 = span_offsets_1_;
    _7228_ = (_e80 < (1i * _e82.ylo));
    let _e88 = _7228_;
    if !(_e88) {
        {
            let _e90 = y_5;
            let _e91 = span_offsets_1_;
            _7239_ = (_e90 > ((_e91.yhi * 1i) + 0i));
        }
    } else {
        {
            let _e98 = _7228_;
            _7239_ = _e98;
        }
    }
    let _e99 = _7239_;
    if _e99 {
        {
            return false;
        }
    }
    let _e101 = primitive_index_1;
    let _e108 = triangle_setup.triangle_setup_raw[((_e101 * 8u) + 7u)];
    setup_flags = ((_e108 >> 16u) & 255u);
    let _e115 = span_offsets_1_;
    let _e118 = y_5;
    let _e120 = span_offsets_1_;
    param_1_13 = u32(((1i * _e115.offset) + (_e118 - (1i * _e120.ylo))));
    let _e127 = param_1_13;
    let _e128 = load_span_setup(_e127);
    span_setup = _e128;
    let _e130 = span_setup;
    if (_e130.valid_line == 0i) {
        {
            return false;
        }
    }
    let _e135 = primitive_index_1;
    let _e142 = triangle_setup.triangle_setup_raw[((_e135 * 8u) + 7u)];
    setup_tile = ((_e142 >> 24u) & 255u);
    let _e148 = primitive_index_1;
    param_2_10 = _e148;
    let _e150 = param_2_10;
    let _e151 = load_attribute_setup(_e150);
    attr = _e151;
    let _e153 = primitive_index_1;
    let _e160 = state_indices.state_indices_raw[((_e153 * 4u) + 0u)];
    let _e163 = primitive_index_1;
    let _e170 = state_indices.state_indices_raw[((_e163 * 4u) + 0u)];
    let _e175 = primitive_index_1;
    let _e182 = state_indices.state_indices_raw[((_e175 * 4u) + 0u)];
    let _e187 = primitive_index_1;
    let _e194 = state_indices.state_indices_raw[((_e187 * 4u) + 0u)];
    states = vec4<u32>((_e160 & 255u), ((_e170 >> 8u) & 255u), ((_e182 >> 16u) & 255u), (_e194 >> 24u));
    let _e199 = states;
    static_state_index = _e199.x;
    let _e202 = states;
    tmem_instance_index = _e202.z;
    let _e205 = static_state_index;
    param_3_7 = _e205;
    let _e207 = param_3_7;
    let _e208 = load_static_rasterization_state(_e207);
    static_state = _e208;
    let _e210 = static_state;
    static_state_flags = _e210.flags;
    let _e213 = static_state;
    static_state_dither = _e213.dither;
    let _e216 = static_state;
    combiner_inputs_rgb0_ = _e216.combiner_inputs_rgb0_;
    let _e219 = static_state;
    combiner_inputs_alpha0_ = _e219.combiner_inputs_alpha0_;
    let _e222 = static_state;
    combiner_inputs_rgb1_ = _e222.combiner_inputs_rgb1_;
    let _e225 = static_state;
    combiner_inputs_alpha1_ = _e225.combiner_inputs_alpha1_;
    let _e228 = static_state_flags;
    tlut_6 = ((_e228 & 16u) != 0u);
    let _e234 = static_state_flags;
    tlut_type_12 = ((_e234 & 32u) != 0u);
    let _e240 = static_state_flags;
    sample_quad_2 = ((_e240 & 16384u) != 0u);
    let _e246 = static_state_flags;
    cvg_times_alpha_4 = ((_e246 & 64u) != 0u);
    let _e252 = static_state_flags;
    alpha_cvg_select_4 = ((_e252 & 128u) != 0u);
    let _e258 = static_state_flags;
    perspective_6 = ((_e258 & 8u) != 0u);
    let _e264 = static_state_flags;
    tex_lod_en_2 = ((_e264 & 512u) != 0u);
    let _e270 = static_state_flags;
    sharpen_lod_en = ((_e270 & 1024u) != 0u);
    let _e276 = static_state_flags;
    detail_lod_en = ((_e276 & 2048u) != 0u);
    let _e282 = static_state_flags;
    aa_enable = ((_e282 & 4u) != 0u);
    let _e288 = static_state_flags;
    multi_cycle = ((_e288 & 256u) != 0u);
    let _e294 = static_state_flags;
    interlace_en = ((_e294 & 1u) != 0u);
    let _e300 = static_state_flags;
    fill_en = ((_e300 & 4096u) != 0u);
    let _e306 = static_state_flags;
    copy_en = ((_e306 & 8192u) != 0u);
    let _e312 = static_state_flags;
    alpha_test_2 = ((_e312 & 32768u) != 0u);
    let _e318 = static_state_flags;
    alpha_test_dither = ((_e318 & 65536u) != 0u);
    let _e324 = static_state_flags;
    mid_texel_1 = ((_e324 & 131072u) != 0u);
    let _e330 = static_state_flags;
    uses_texel0_ = ((_e330 & 262144u) != 0u);
    let _e336 = static_state_flags;
    uses_texel1_ = ((_e336 & 524288u) != 0u);
    let _e342 = static_state_flags;
    uses_pipelined_texel1_ = ((_e342 & 2097152u) != 0u);
    let _e348 = static_state_flags;
    uses_lod_2 = ((_e348 & 1048576u) != 0u);
    let _e354 = static_state_flags;
    convert_one_2 = ((_e354 & 4194304u) != 0u);
    let _e360 = static_state_flags;
    bilerp0_ = ((_e360 & 8388608u) != 0u);
    let _e366 = static_state_flags;
    bilerp1_ = ((_e366 & 16777216u) != 0u);
    let _e372 = static_state_flags;
    if ((_e372 & 268435456u) != 0u) {
        {
            let _e377 = x_9;
            param_4_6 = u32(_e377);
            let _e380 = y_5;
            param_5_6 = u32(_e380);
            let _e383 = primitive_index_1;
            let _e384 = global_constants;
            param_6_6 = (_e383 + _e384.fb_info.base_primitive_index);
            let _e389 = param_4_6;
            let _e390 = param_5_6;
            let _e391 = param_6_6;
            reseed_noise(_e389, _e390, _e391);
        }
    }
    let _e392 = setup_flags;
    flip_2 = ((_e392 & 1u) != 0u);
    let _e398 = copy_en;
    if _e398 {
        {
            let _e399 = x_9;
            let _e400 = span_setup;
            _7470_ = (_e399 >= _e400.start_x);
            let _e405 = _7470_;
            if _e405 {
                {
                    let _e406 = x_9;
                    let _e407 = span_setup;
                    _7477_ = (_e406 <= _e407.end_x);
                }
            } else {
                {
                    let _e410 = _7470_;
                    _7477_ = _e410;
                }
            }
            let _e411 = _7477_;
            valid = _e411;
            let _e413 = valid;
            if !(_e413) {
                {
                    return false;
                }
            }
            let _e416 = span_setup;
            param_7_6 = _e416;
            let _e418 = attr;
            param_8_5 = _e418.dstzw_dx;
            let _e421 = x_9;
            param_9_5 = _e421;
            let _e423 = perspective_6;
            param_10_4 = _e423;
            let _e425 = flip_2;
            param_11_4 = _e425;
            let _e429 = param_7_6;
            let _e430 = param_8_5;
            let _e431 = param_9_5;
            let _e432 = param_10_4;
            let _e433 = param_11_4;
            interpolate_st_copy(_e429, _e430, _e431, _e432, _e433, (&param_12_4), (&param_13_4));
            let _e438 = param_12_4;
            st_34 = _e438;
            let _e440 = param_13_4;
            s_offset_5 = _e440;
            let _e442 = setup_tile;
            tile0_1 = (_e442 & 7u);
            let _e446 = primitive_index_1;
            let _e452 = tile0_1;
            let _e459 = state_indices.state_indices_raw[(((u32(_e446) * 4u) + 2u) + (u32(_e452) / 4u))];
            let _e460 = tile0_1;
            tile_info_index0_ = ((_e459 >> ((u32(_e460) % 4u) * 8u)) & 255u);
            let _e470 = tile_info_index0_;
            param_14_4 = _e470;
            let _e472 = param_14_4;
            let _e473 = load_tile_info(_e472);
            tile_info0_ = _e473;
            let _e475 = tile_info0_;
            param_15_4 = _e475;
            let _e477 = tmem_instance_index;
            param_16_4 = _e477;
            let _e479 = st_34;
            param_17_2 = _e479;
            let _e481 = s_offset_5;
            param_18_1 = _e481;
            let _e483 = tlut_6;
            param_19_1 = _e483;
            let _e485 = tlut_type_12;
            param_20_1 = _e485;
            let _e487 = param_15_4;
            let _e488 = param_16_4;
            let _e490 = param_18_1;
            let _e491 = param_19_1;
            let _e492 = param_20_1;
            let _e494 = sample_texture_copy(_e487, _e488, (&param_17_2), _e490, _e491, _e492);
            _7527_ = _e494;
            let _e496 = _7527_;
            texel0_ = _e496;
            let _e499 = texel0_;
            (*shaded).z_dith = _e499;
            (*shaded).coverage_count = 32i;
            let _e503 = alpha_test_2;
            if _e503 {
                {
                    let _e504 = global_constants;
                    _7537_ = (_e504.fb_info.fb_size == 2i);
                }
            } else {
                {
                    let _e509 = alpha_test_2;
                    _7537_ = _e509;
                }
            }
            let _e511 = _7537_;
            if _e511 {
                {
                    let _e512 = texel0_;
                    _7543_ = ((_e512 & 1i) == 0i);
                }
            } else {
                {
                    let _e517 = _7537_;
                    _7543_ = _e517;
                }
            }
            let _e518 = _7543_;
            if _e518 {
                {
                    return false;
                }
            }
            return true;
        }
    } else {
        {
            let _e521 = fill_en;
            if _e521 {
                {
                    (*shaded).coverage_count = 64i;
                    let _e524 = x_9;
                    let _e525 = span_setup;
                    _7556_ = (_e524 >= _e525.start_x);
                    let _e530 = _7556_;
                    if _e530 {
                        {
                            let _e531 = x_9;
                            let _e532 = span_setup;
                            _7563_ = (_e531 <= _e532.end_x);
                        }
                    } else {
                        {
                            let _e535 = _7556_;
                            _7563_ = _e535;
                        }
                    }
                    let _e536 = _7563_;
                    return _e536;
                }
            }
        }
    }
    let _e537 = span_setup;
    param_21_1 = _e537.xleft;
    let _e540 = span_setup;
    param_22_1 = _e540.xright;
    let _e543 = x_9;
    param_23_1 = _e543;
    let _e545 = param_21_1;
    let _e546 = param_22_1;
    let _e547 = param_23_1;
    let _e548 = compute_coverage(_e545, _e546, _e547);
    coverage_7 = _e548;
    let _e550 = coverage_7;
    if (_e550 == 0i) {
        {
            return false;
        }
    }
    let _e554 = coverage_7;
    coverage_count = countOneBits(_e554);
    let _e557 = aa_enable;
    _7584_ = !(_e557);
    let _e561 = _7584_;
    if _e561 {
        {
            let _e562 = coverage_7;
            _7590_ = ((_e562 & 1i) == 0i);
        }
    } else {
        {
            let _e567 = _7584_;
            _7590_ = _e567;
        }
    }
    let _e568 = _7590_;
    if _e568 {
        {
            return false;
        }
    }
    let _e570 = primitive_index_1;
    param_24_1 = _e570;
    let _e572 = param_24_1;
    let _e573 = load_derived_setup(_e572);
    derived = _e573;
    let _e575 = x_9;
    let _e576 = span_setup;
    dx_8 = (_e575 - _e576.interpolation_base_x);
    let _e580 = flip_2;
    if _e580 {
        local_13 = 1i;
    } else {
        local_13 = -1i;
    }
    let _e585 = local_13;
    interpolation_direction = _e585;
    let _e587 = span_setup;
    param_25_1 = _e587.rgba;
    let _e590 = attr;
    param_26_1 = _e590.drgba_dx;
    let _e593 = attr;
    param_27_1 = _e593.drgba_dy;
    let _e596 = dx_8;
    param_28_1 = _e596;
    let _e598 = coverage_7;
    param_29_1 = _e598;
    let _e601 = param_26_1;
    let _e602 = param_27_1;
    let _e603 = param_28_1;
    let _e604 = param_29_1;
    let _e606 = interpolate_rgba((&param_25_1), _e601, _e602, _e603, _e604);
    _7620_ = _e606;
    let _e608 = _7620_;
    shade = _e608;
    let _e612 = interpolation_direction;
    tex_interpolation_direction = _e612;
    let _e615 = uses_lod_2;
    if (false && _e615) {
        {
            let _e617 = setup_flags;
            if ((_e617 & 64u) != 0u) {
                {
                    let _e622 = tex_interpolation_direction;
                    tex_interpolation_direction = (_e622 * 1i);
                }
            }
        }
    }
    let _e625 = span_setup;
    param_30_1 = _e625.stzw;
    let _e628 = attr;
    param_31_1 = _e628.dstzw_dx;
    let _e631 = attr;
    param_32_1 = _e631.dstzw_dy;
    let _e634 = dx_8;
    param_33_1 = _e634;
    let _e636 = coverage_7;
    param_34_1 = _e636;
    let _e638 = perspective_6;
    param_35_1 = _e638;
    let _e640 = uses_lod_2;
    param_36_1 = _e640;
    let _e642 = tex_interpolation_direction;
    param_37_1 = _e642;
    let _e644 = perspective_overflow_2;
    param_42_1 = _e644;
    let _e650 = param_30_1;
    let _e651 = param_31_1;
    let _e652 = param_32_1;
    let _e653 = param_33_1;
    let _e654 = param_34_1;
    let _e655 = param_35_1;
    let _e656 = param_36_1;
    let _e657 = param_37_1;
    interpolate_stz(_e650, _e651, _e652, _e653, _e654, _e655, _e656, _e657, (&param_38_1), (&param_39_1), (&param_40_1), (&param_41_1), (&param_42_1));
    let _e668 = param_38_1;
    st_1_ = _e668;
    let _e670 = param_39_1;
    st_dx_3 = _e670;
    let _e672 = param_40_1;
    st_dy_3 = _e672;
    let _e674 = param_41_1;
    z_2 = _e674;
    let _e676 = param_42_1;
    perspective_overflow_2 = _e676;
    let _e677 = setup_tile;
    tile0_1_ = (_e677 & 7u);
    let _e681 = tile0_1_;
    tile1_1 = ((_e681 + 1u) & 7u);
    let _e687 = setup_tile;
    max_level_2 = (_e687 >> 3u);
    let _e691 = derived;
    min_lod_2 = _e691.min_lod;
    let _e695 = uses_lod_2;
    if _e695 {
        {
            let _e696 = tile0_1_;
            param_43_1 = _e696;
            let _e698 = tile1_1;
            param_44_1 = _e698;
            let _e700 = max_level_2;
            param_46_1 = _e700;
            let _e702 = min_lod_2;
            param_47_1 = _e702;
            let _e704 = st_1_;
            param_48_1 = _e704;
            let _e706 = st_dx_3;
            param_49_1 = _e706;
            let _e708 = st_dy_3;
            param_50_1 = _e708;
            let _e710 = perspective_overflow_2;
            param_51_1 = _e710;
            let _e712 = tex_lod_en_2;
            param_52_1 = _e712;
            let _e714 = sharpen_lod_en;
            param_53_1 = _e714;
            let _e716 = detail_lod_en;
            param_54_1 = _e716;
            let _e722 = param_46_1;
            let _e723 = param_47_1;
            let _e724 = param_48_1;
            let _e725 = param_49_1;
            let _e726 = param_50_1;
            let _e727 = param_51_1;
            let _e728 = param_52_1;
            let _e729 = param_53_1;
            let _e730 = param_54_1;
            compute_lod_2cycle((&param_43_1), (&param_44_1), (&param_45_1), _e722, _e723, _e724, _e725, _e726, _e727, _e728, _e729, _e730);
            let _e734 = param_43_1;
            tile0_1_ = _e734;
            let _e735 = param_44_1;
            tile1_1 = _e735;
            let _e736 = param_45_1;
            lod_frac_1 = _e736;
        }
    }
    let _e738 = uses_texel0_;
    if _e738 {
        {
            let _e739 = primitive_index_1;
            let _e745 = tile0_1_;
            let _e752 = state_indices.state_indices_raw[(((u32(_e739) * 4u) + 2u) + (u32(_e745) / 4u))];
            let _e753 = tile0_1_;
            tile_info_index0_1_ = ((_e752 >> ((u32(_e753) % 4u) * 8u)) & 255u);
            let _e763 = tile_info_index0_1_;
            param_55_1 = _e763;
            let _e765 = param_55_1;
            let _e766 = load_tile_info(_e765);
            tile_info0_1_ = _e766;
            let _e768 = tile_info0_1_;
            param_56_1 = _e768;
            let _e770 = tmem_instance_index;
            param_57_1 = _e770;
            let _e772 = st_1_;
            param_58_1 = _e772;
            let _e774 = tlut_6;
            param_59_1 = _e774;
            let _e776 = tlut_type_12;
            param_60_1 = _e776;
            let _e778 = sample_quad_2;
            param_61_1 = _e778;
            let _e780 = mid_texel_1;
            param_62_1 = _e780;
            let _e784 = bilerp0_;
            param_64_1 = _e784;
            let _e786 = derived;
            param_65_1 = _e786.factors;
            let _e792 = param_56_1;
            let _e793 = param_57_1;
            let _e795 = param_59_1;
            let _e796 = param_60_1;
            let _e797 = param_61_1;
            let _e798 = param_62_1;
            let _e799 = param_63_1;
            let _e800 = param_64_1;
            let _e801 = param_65_1;
            let _e802 = param_66_1;
            let _e804 = sample_texture(_e792, _e793, (&param_58_1), _e795, _e796, _e797, _e798, _e799, _e800, _e801, _e802);
            _7750_ = _e804;
            let _e806 = _7750_;
            texel0_1_ = _e806;
        }
    }
    let _e807 = uses_pipelined_texel1_;
    if _e807 {
        {
            let _e809 = span_offsets_1_;
            let _e812 = y_5;
            let _e814 = span_offsets_1_;
            let _e828 = span_setups.span_setups_raw[((u32(((1i * _e809.offset) + ((_e812 - (1i * _e814.ylo)) + 1i))) * 16u) + 15u)];
            valid_line = ((_e828 >> 16u) != 0u);
            let _e834 = span_setup;
            long_span = (_e834.lodlength >= 8i);
            let _e840 = flip_2;
            if _e840 {
                {
                    let _e841 = span_setup;
                    _7776_ = _e841.end_x;
                }
            } else {
                {
                    let _e843 = span_setup;
                    _7776_ = _e843.start_x;
                }
            }
            let _e845 = x_9;
            let _e846 = _7776_;
            end_span = (_e845 == _e846);
            let _e849 = end_span;
            let _e850 = long_span;
            let _e852 = valid_line;
            if ((_e849 && _e850) && _e852) {
                {
                    let _e855 = span_offsets_1_;
                    let _e858 = y_5;
                    let _e860 = span_offsets_1_;
                    let _e874 = span_setups.span_setups_raw[((u32(((1i * _e855.offset) + ((_e858 - (1i * _e860.ylo)) + 1i))) * 16u) + 4u)];
                    let _e877 = span_offsets_1_;
                    let _e880 = y_5;
                    let _e882 = span_offsets_1_;
                    let _e898 = span_setups.span_setups_raw[(((u32(((1i * _e877.offset) + ((_e880 - (1i * _e882.ylo)) + 1i))) * 16u) + 4u) + 1u)];
                    let _e901 = span_offsets_1_;
                    let _e904 = y_5;
                    let _e906 = span_offsets_1_;
                    let _e922 = span_setups.span_setups_raw[(((u32(((1i * _e901.offset) + ((_e904 - (1i * _e906.ylo)) + 1i))) * 16u) + 4u) + 2u)];
                    let _e925 = span_offsets_1_;
                    let _e928 = y_5;
                    let _e930 = span_offsets_1_;
                    let _e946 = span_setups.span_setups_raw[(((u32(((1i * _e925.offset) + ((_e928 - (1i * _e930.ylo)) + 1i))) * 16u) + 4u) + 3u)];
                    stw_7 = (vec4<i32>(i32(_e874), i32(_e898), i32(_e922), i32(_e946)).xyw >> vec3(16u));
                    let _e956 = perspective_6;
                    if _e956 {
                        {
                            let _e957 = stw_7;
                            param_67_1 = _e957;
                            let _e960 = st_overflow_3;
                            param_68_1 = _e960;
                            let _e962 = param_67_1;
                            let _e965 = perspective_divide(_e962, (&param_68_1));
                            _7817_ = _e965;
                            let _e967 = param_68_1;
                            st_overflow_3 = _e967;
                            let _e968 = _7817_;
                            st_1_ = _e968;
                        }
                    } else {
                        {
                            let _e969 = stw_7;
                            param_69_1 = _e969;
                            let _e971 = param_69_1;
                            let _e972 = no_perspective_divide(_e971);
                            st_1_ = _e972;
                        }
                    }
                }
            } else {
                {
                    let _e973 = span_setup;
                    param_70_1 = _e973.stzw;
                    let _e976 = attr;
                    param_71_1 = _e976.dstzw_dx;
                    let _e979 = dx_8;
                    let _e980 = interpolation_direction;
                    param_72_1 = (_e979 + (_e980 * 1i));
                    let _e985 = perspective_6;
                    param_73_1 = _e985;
                    let _e987 = param_70_1;
                    let _e988 = param_71_1;
                    let _e989 = param_72_1;
                    let _e990 = param_73_1;
                    let _e991 = interpolate_st_single(_e987, _e988, _e989, _e990);
                    st_1_ = _e991;
                }
            }
            let _e992 = tile0_1_;
            tile1_1 = _e992;
            uses_texel1_ = true;
        }
    }
    let _e995 = uses_texel1_;
    if _e995 {
        {
            let _e996 = convert_one_2;
            let _e997 = bilerp1_;
            if (_e996 && !(_e997)) {
                {
                    let _e1000 = texel0_1_;
                    param_74_1 = _e1000;
                    let _e1002 = derived;
                    param_75_1 = _e1002.factors;
                    let _e1005 = param_74_1;
                    let _e1006 = param_75_1;
                    let _e1007 = texture_convert_factors(_e1005, _e1006);
                    texel1_ = _e1007;
                }
            } else {
                {
                    let _e1008 = primitive_index_1;
                    let _e1014 = tile1_1;
                    let _e1021 = state_indices.state_indices_raw[(((u32(_e1008) * 4u) + 2u) + (u32(_e1014) / 4u))];
                    let _e1022 = tile1_1;
                    tile_info_index1_ = ((_e1021 >> ((u32(_e1022) % 4u) * 8u)) & 255u);
                    let _e1032 = tile_info_index1_;
                    param_76_1 = _e1032;
                    let _e1034 = param_76_1;
                    let _e1035 = load_tile_info(_e1034);
                    tile_info1_ = _e1035;
                    let _e1037 = tile_info1_;
                    param_77_1 = _e1037;
                    let _e1039 = tmem_instance_index;
                    param_78_1 = _e1039;
                    let _e1041 = st_1_;
                    param_79_1 = _e1041;
                    let _e1043 = tlut_6;
                    param_80_1 = _e1043;
                    let _e1045 = tlut_type_12;
                    param_81_1 = _e1045;
                    let _e1047 = sample_quad_2;
                    param_82_1 = _e1047;
                    let _e1049 = mid_texel_1;
                    param_83_1 = _e1049;
                    let _e1051 = convert_one_2;
                    param_84_1 = _e1051;
                    let _e1053 = bilerp1_;
                    param_85_1 = _e1053;
                    let _e1055 = derived;
                    param_86_1 = _e1055.factors;
                    let _e1058 = texel0_1_;
                    param_87_1 = _e1058;
                    let _e1060 = param_77_1;
                    let _e1061 = param_78_1;
                    let _e1063 = param_80_1;
                    let _e1064 = param_81_1;
                    let _e1065 = param_82_1;
                    let _e1066 = param_83_1;
                    let _e1067 = param_84_1;
                    let _e1068 = param_85_1;
                    let _e1069 = param_86_1;
                    let _e1070 = param_87_1;
                    let _e1072 = sample_texture(_e1060, _e1061, (&param_79_1), _e1063, _e1064, _e1065, _e1066, _e1067, _e1068, _e1069, _e1070);
                    _7889_ = _e1072;
                    let _e1074 = _7889_;
                    texel1_ = _e1074;
                }
            }
        }
    }
    let _e1075 = x_9;
    param_88_1 = _e1075;
    let _e1077 = y_5;
    let _e1078 = interlace_en;
    param_89_1 = (_e1077 >> u32(select(0i, 1i, _e1078)));
    let _e1085 = static_state_dither;
    param_90_1 = (_e1085 >> 2u);
    let _e1090 = static_state_dither;
    param_91_1 = (_e1090 & 3i);
    let _e1096 = param_88_1;
    let _e1097 = param_89_1;
    let _e1098 = param_90_1;
    let _e1099 = param_91_1;
    dither_coefficients(_e1096, _e1097, _e1098, _e1099, (&param_92_1), (&param_93_1));
    let _e1104 = param_92_1;
    rgb_dith = _e1104;
    let _e1106 = param_93_1;
    alpha_dith_4 = _e1106;
    let _e1110 = multi_cycle;
    if _e1110 {
        {
            let _e1111 = derived;
            let _e1113 = derived;
            let _e1115 = derived;
            let _e1117 = derived;
            let _e1119 = shade;
            let _e1122 = texel0_1_;
            let _e1123 = texel1_;
            let _e1124 = lod_frac_1;
            let _e1125 = noise_get_combiner();
            combined_inputs = CombinerInputs(_e1111.constant_muladd0_, _e1113.constant_mulsub0_, _e1115.constant_mul0_, _e1117.constant_add0_, _e1119, vec4(0i), _e1122, _e1123, _e1124, _e1125);
            let _e1128 = combined_inputs;
            param_94_1 = _e1128;
            let _e1130 = combiner_inputs_rgb0_;
            param_95_1 = _e1130;
            let _e1132 = combiner_inputs_alpha0_;
            param_96_1 = _e1132;
            let _e1134 = alpha_dith_4;
            param_97_1 = _e1134;
            let _e1136 = coverage_count;
            param_98_1 = _e1136;
            let _e1138 = cvg_times_alpha_4;
            param_99_1 = _e1138;
            let _e1140 = alpha_cvg_select_4;
            param_100_1 = _e1140;
            let _e1142 = alpha_test_2;
            param_101_1 = _e1142;
            let _e1145 = param_94_1;
            let _e1146 = param_95_1;
            let _e1147 = param_96_1;
            let _e1148 = param_97_1;
            let _e1149 = param_98_1;
            let _e1150 = param_99_1;
            let _e1151 = param_100_1;
            let _e1152 = param_101_1;
            let _e1155 = combiner_cycle0_(_e1145, _e1146, _e1147, _e1148, _e1149, _e1150, _e1151, _e1152, (&param_102_1));
            _7946_ = _e1155;
            let _e1157 = param_102_1;
            alpha_reference = _e1157;
            let _e1159 = _7946_;
            combined_inputs.combined = _e1159;
            let _e1161 = derived;
            combined_inputs.constant_muladd = _e1161.constant_muladd1_;
            let _e1164 = derived;
            combined_inputs.constant_mulsub = _e1164.constant_mulsub1_;
            let _e1167 = derived;
            combined_inputs.constant_mul = _e1167.constant_mul1_;
            let _e1170 = derived;
            combined_inputs.constant_add = _e1170.constant_add1_;
            let _e1172 = combined_inputs;
            tmp_texel = _e1172.texel0_;
            let _e1176 = combined_inputs;
            combined_inputs.texel0_ = _e1176.texel1_;
            let _e1179 = tmp_texel;
            combined_inputs.texel1_ = _e1179;
            let _e1180 = static_state_flags;
            if ((_e1180 & 33554432u) != 0u) {
                {
                    let _e1185 = x_9;
                    param_103_1 = u32((_e1185 + 1023i));
                    let _e1190 = y_5;
                    param_104_1 = u32((_e1190 + 7i));
                    let _e1195 = primitive_index_1;
                    let _e1196 = global_constants;
                    param_105_1 = ((_e1195 + _e1196.fb_info.base_primitive_index) + 11u);
                    let _e1203 = param_103_1;
                    let _e1204 = param_104_1;
                    let _e1205 = param_105_1;
                    reseed_noise(_e1203, _e1204, _e1205);
                    let _e1207 = noise_get_combiner();
                    combined_inputs._noise = _e1207;
                }
            }
            let _e1208 = combined_inputs;
            param_106_1 = _e1208;
            let _e1210 = combiner_inputs_rgb1_;
            param_107_1 = _e1210;
            let _e1212 = combiner_inputs_alpha1_;
            param_108_1 = _e1212;
            let _e1214 = alpha_dith_4;
            param_109_1 = _e1214;
            let _e1216 = coverage_count;
            param_110_1 = _e1216;
            let _e1218 = cvg_times_alpha_4;
            param_111_1 = _e1218;
            let _e1220 = alpha_cvg_select_4;
            param_112_1 = _e1220;
            let _e1222 = param_106_1;
            let _e1223 = param_107_1;
            let _e1224 = param_108_1;
            let _e1225 = param_109_1;
            let _e1227 = param_111_1;
            let _e1228 = param_112_1;
            let _e1230 = combiner_cycle1_(_e1222, _e1223, _e1224, _e1225, (&param_110_1), _e1227, _e1228);
            _8007_ = _e1230;
            let _e1232 = param_110_1;
            coverage_count = _e1232;
            let _e1233 = _8007_;
            combined_2 = vec4<i32>(_e1233);
        }
    } else {
        {
            let _e1235 = derived;
            let _e1237 = derived;
            let _e1239 = derived;
            let _e1241 = derived;
            let _e1243 = shade;
            let _e1246 = texel0_1_;
            let _e1247 = texel1_;
            let _e1248 = lod_frac_1;
            let _e1249 = noise_get_combiner();
            combined_inputs_1_ = CombinerInputs(_e1235.constant_muladd1_, _e1237.constant_mulsub1_, _e1239.constant_mul1_, _e1241.constant_add1_, _e1243, vec4(0i), _e1246, _e1247, _e1248, _e1249);
            let _e1252 = combined_inputs_1_;
            param_113_1 = _e1252;
            let _e1254 = combiner_inputs_rgb1_;
            param_114_1 = _e1254;
            let _e1256 = combiner_inputs_alpha1_;
            param_115_1 = _e1256;
            let _e1258 = alpha_dith_4;
            param_116_1 = _e1258;
            let _e1260 = coverage_count;
            param_117_1 = _e1260;
            let _e1262 = cvg_times_alpha_4;
            param_118_1 = _e1262;
            let _e1264 = alpha_cvg_select_4;
            param_119_1 = _e1264;
            let _e1266 = param_113_1;
            let _e1267 = param_114_1;
            let _e1268 = param_115_1;
            let _e1269 = param_116_1;
            let _e1271 = param_118_1;
            let _e1272 = param_119_1;
            let _e1274 = combiner_cycle1_(_e1266, _e1267, _e1268, _e1269, (&param_117_1), _e1271, _e1272);
            _8044_ = _e1274;
            let _e1276 = param_117_1;
            coverage_count = _e1276;
            let _e1277 = _8044_;
            combined_2 = vec4<i32>(_e1277);
            let _e1279 = combined_2;
            alpha_reference = _e1279.w;
        }
    }
    let _e1281 = aa_enable;
    let _e1282 = coverage_count;
    if (_e1281 && (_e1282 == 0i)) {
        {
            return false;
        }
    }
    let _e1287 = alpha_test_2;
    if _e1287 {
        {
            let _e1289 = alpha_test_dither;
            if _e1289 {
                {
                    let _e1290 = noise_get_blend_threshold();
                    alpha_threshold = _e1290;
                }
            } else {
                {
                    let _e1291 = derived;
                    alpha_threshold = _e1291.blend_color.w;
                }
            }
            let _e1294 = alpha_reference;
            let _e1295 = alpha_threshold;
            if (_e1294 < _e1295) {
                {
                    return false;
                }
            }
        }
    }
    let _e1299 = combined_2;
    (*shaded).combined = _e1299;
    let _e1301 = z_2;
    let _e1305 = rgb_dith;
    (*shaded).z_dith = ((_e1301 << 9u) | _e1305);
    let _e1308 = coverage_count;
    (*shaded).coverage_count = _e1308;
    let _e1310 = shade;
    let _e1312 = alpha_dith_4;
    (*shaded).shade_alpha = min((_e1310.w + _e1312), 255i);
    return true;
}

fn load_depth_blend_state(index_28: u32) -> DepthBlendState {
    var index_29: u32;

    index_29 = index_28;
    let _e70 = index_29;
    let _e77 = depth_blend_state.depth_blend_state_raw[((_e70 * 4u) + 0u)];
    let _e80 = index_29;
    let _e87 = depth_blend_state.depth_blend_state_raw[((_e80 * 4u) + 0u)];
    let _e92 = index_29;
    let _e99 = depth_blend_state.depth_blend_state_raw[((_e92 * 4u) + 0u)];
    let _e104 = index_29;
    let _e111 = depth_blend_state.depth_blend_state_raw[((_e104 * 4u) + 0u)];
    let _e116 = index_29;
    let _e123 = depth_blend_state.depth_blend_state_raw[((_e116 * 4u) + 1u)];
    let _e126 = index_29;
    let _e133 = depth_blend_state.depth_blend_state_raw[((_e126 * 4u) + 1u)];
    let _e138 = index_29;
    let _e145 = depth_blend_state.depth_blend_state_raw[((_e138 * 4u) + 1u)];
    let _e150 = index_29;
    let _e157 = depth_blend_state.depth_blend_state_raw[((_e150 * 4u) + 1u)];
    let _e162 = index_29;
    let _e169 = depth_blend_state.depth_blend_state_raw[((_e162 * 4u) + 2u)];
    let _e170 = index_29;
    let _e177 = depth_blend_state.depth_blend_state_raw[((_e170 * 4u) + 3u)];
    let _e181 = index_29;
    let _e188 = depth_blend_state.depth_blend_state_raw[((_e181 * 4u) + 3u)];
    return DepthBlendState(vec4<i32>(vec4<u32>((_e77 & 255u), ((_e87 >> 8u) & 255u), ((_e99 >> 16u) & 255u), (_e111 >> 24u))), vec4<i32>(vec4<u32>((_e123 & 255u), ((_e133 >> 8u) & 255u), ((_e145 >> 16u) & 255u), (_e157 >> 24u))), _e169, i32((_e177 & 255u)), i32(((_e188 >> 8u) & 255u)), 0i, 0i);
}

fn decode_memory_color(image_read_en: bool) -> vec4<i32> {
    var image_read_en_1: bool;
    var _2358_: i32;
    var memory_coverage: i32;
    var color_6: vec3<i32> = vec3(0i);

    image_read_en_1 = image_read_en;
    let _e71 = image_read_en_1;
    if _e71 {
        {
            let _e72 = current_color;
            _2358_ = (_e72.w & 224i);
        }
    } else {
        {
            _2358_ = 224i;
        }
    }
    let _e77 = _2358_;
    memory_coverage = _e77;
    memory_coverage = 224i;
    let _e83 = color_6;
    let _e84 = memory_coverage;
    return vec4<i32>(_e83.x, _e83.y, _e83.z, _e84);
}

fn z_decompress(z_3: i32) -> i32 {
    var z_4: i32;
    var z_5: i32;
    var exponent: i32;
    var mantissa: i32;
    var shift_10: i32;
    var base: i32;

    z_4 = z_3;
    let _e70 = z_4;
    z_5 = _e70;
    let _e72 = z_5;
    exponent = (_e72 >> 11u);
    let _e77 = z_5;
    mantissa = (_e77 & 2047i);
    let _e82 = exponent;
    shift_10 = max((6i - _e82), 0i);
    let _e89 = exponent;
    base = (262144i - (262144i >> u32(_e89)));
    let _e94 = mantissa;
    let _e95 = shift_10;
    let _e98 = base;
    return ((_e94 << u32(_e95)) + _e98);
}

fn dz_decompress(dz: i32) -> i32 {
    var dz_1: i32;

    dz_1 = dz;
    let _e71 = dz_1;
    return (1i << u32(_e71));
}

fn combine_dz(dz_2: ptr<function, i32>) -> i32 {
    let _e69 = (*dz_2);
    if (_e69 != 0i) {
        {
            let _e73 = (*dz_2);
            (*dz_2) = (1i << u32(firstLeadingBit(_e73)));
        }
    }
    let _e77 = (*dz_2);
    return _e77;
}

fn dz_compress(dz_3: i32) -> i32 {
    var dz_4: i32;

    dz_4 = dz_3;
    let _e70 = dz_4;
    return max(firstLeadingBit(_e70), 0i);
}

fn depth_test(z_6: i32, dz_5: i32, dz_compressed: i32, current_depth_1_: i32, current_dz_1_: i32, coverage_count_1: ptr<function, i32>, current_coverage_count: i32, z_compare: bool, z_mode: i32, force_blend: bool, aa_enable_1: bool, blend_en: ptr<function, bool>, coverage_wrap: ptr<function, bool>, blend_shift: ptr<function, vec2<i32>>) -> bool {
    var z_7: i32;
    var dz_6: i32;
    var dz_compressed_1: i32;
    var current_depth_1_1: i32;
    var current_dz_1_1: i32;
    var current_coverage_count_1: i32;
    var z_compare_1: bool;
    var z_mode_1: i32;
    var force_blend_1: bool;
    var aa_enable_2: bool;
    var depth_pass: bool;
    var param_19: i32;
    var memory_z: i32;
    var param_1_14: i32;
    var memory_dz: i32;
    var precision_factor: i32;
    var coplanar: bool = false;
    var param_2_11: i32;
    var _1386_: i32;
    var combined_dz: i32;
    var combined_dz_interpenetrate: i32;
    var _1401_: bool;
    var farther: bool;
    var overflow_1: bool;
    var _1417_: bool;
    var max_z: bool;
    var front: bool;
    var z_closest_possible: i32;
    var nearer: bool;
    var _1451_: bool;
    var local_14: bool;
    var _1471_: bool;
    var local_15: bool;
    var param_3_8: i32;
    var cvg_coeff: i32;
    var overflow_1_: bool;
    var _1523_: bool;

    z_7 = z_6;
    dz_6 = dz_5;
    dz_compressed_1 = dz_compressed;
    current_depth_1_1 = current_depth_1_;
    current_dz_1_1 = current_dz_1_;
    current_coverage_count_1 = current_coverage_count;
    z_compare_1 = z_compare;
    z_mode_1 = z_mode;
    force_blend_1 = force_blend;
    aa_enable_2 = aa_enable_1;
    let _e93 = z_compare_1;
    if _e93 {
        {
            let _e94 = current_depth_1_1;
            param_19 = _e94;
            let _e96 = param_19;
            let _e97 = z_decompress(_e96);
            memory_z = _e97;
            let _e99 = current_dz_1_1;
            param_1_14 = _e99;
            let _e101 = param_1_14;
            let _e102 = dz_decompress(_e101);
            memory_dz = _e102;
            let _e104 = current_depth_1_1;
            precision_factor = ((_e104 >> 11u) & 15i);
            let _e114 = dz_compressed_1;
            let _e115 = current_dz_1_1;
            (*blend_shift).x = clamp((_e114 - _e115), 0i, 4i);
            let _e121 = current_dz_1_1;
            let _e122 = dz_compressed_1;
            (*blend_shift).y = clamp((_e121 - _e122), 0i, 4i);
            let _e127 = precision_factor;
            if (_e127 < 3i) {
                {
                    let _e130 = memory_dz;
                    if (_e130 != 32768i) {
                        {
                            let _e133 = memory_dz;
                            let _e138 = precision_factor;
                            memory_dz = max((_e133 << 1u), (16i >> u32(_e138)));
                        }
                    } else {
                        {
                            coplanar = true;
                            memory_dz = 65535i;
                        }
                    }
                }
            }
            let _e144 = dz_6;
            let _e145 = memory_dz;
            param_2_11 = (_e144 | _e145);
            let _e150 = combine_dz((&param_2_11));
            _1386_ = _e150;
            let _e152 = _1386_;
            combined_dz = _e152;
            let _e154 = combined_dz;
            combined_dz_interpenetrate = _e154;
            let _e156 = combined_dz;
            combined_dz = (_e156 << 3u);
            let _e161 = coplanar;
            if !(_e161) {
                {
                    let _e163 = z_7;
                    let _e164 = combined_dz;
                    let _e166 = memory_z;
                    _1401_ = ((_e163 + _e164) >= _e166);
                }
            } else {
                {
                    let _e168 = coplanar;
                    _1401_ = _e168;
                }
            }
            let _e169 = _1401_;
            farther = _e169;
            let _e171 = (*coverage_count_1);
            let _e172 = current_coverage_count_1;
            overflow_1 = ((_e171 + _e172) >= 8i);
            let _e178 = force_blend_1;
            if !(_e178) {
                {
                    let _e180 = overflow_1;
                    let _e182 = aa_enable_2;
                    let _e184 = farther;
                    _1417_ = ((!(_e180) && _e182) && _e184);
                }
            } else {
                {
                    let _e186 = force_blend_1;
                    _1417_ = _e186;
                }
            }
            let _e187 = _1417_;
            (*blend_en) = _e187;
            let _e188 = overflow_1;
            (*coverage_wrap) = _e188;
            depth_pass = false;
            let _e190 = memory_z;
            max_z = (_e190 == 262143i);
            let _e194 = z_7;
            let _e195 = memory_z;
            front = (_e194 < _e195);
            let _e198 = z_7;
            let _e199 = combined_dz;
            z_closest_possible = (_e198 - _e199);
            let _e202 = coplanar;
            let _e203 = z_closest_possible;
            let _e204 = memory_z;
            nearer = (_e202 || (_e203 <= _e204));
            let _e208 = z_mode_1;
            switch _e208 {
                case 0: {
                    let _e210 = max_z;
                    if !(_e210) {
                        {
                            let _e212 = overflow_1;
                            if _e212 {
                                let _e213 = front;
                                local_14 = _e213;
                            } else {
                                let _e214 = nearer;
                                local_14 = _e214;
                            }
                            let _e216 = local_14;
                            _1451_ = _e216;
                        }
                    } else {
                        {
                            let _e217 = max_z;
                            _1451_ = _e217;
                        }
                    }
                    let _e218 = _1451_;
                    depth_pass = _e218;
                }
                case 1: {
                    let _e219 = front;
                    let _e221 = farther;
                    let _e224 = overflow_1;
                    if ((!(_e219) || !(_e221)) || !(_e224)) {
                        {
                            let _e228 = max_z;
                            if !(_e228) {
                                {
                                    let _e230 = overflow_1;
                                    if _e230 {
                                        let _e231 = front;
                                        local_15 = _e231;
                                    } else {
                                        let _e232 = nearer;
                                        local_15 = _e232;
                                    }
                                    let _e234 = local_15;
                                    _1471_ = _e234;
                                }
                            } else {
                                {
                                    let _e235 = max_z;
                                    _1471_ = _e235;
                                }
                            }
                            let _e236 = _1471_;
                            depth_pass = _e236;
                        }
                    } else {
                        {
                            let _e237 = combined_dz_interpenetrate;
                            param_3_8 = (_e237 & 65535i);
                            let _e241 = param_3_8;
                            let _e242 = dz_compress(_e241);
                            combined_dz_interpenetrate = _e242;
                            let _e243 = memory_z;
                            let _e244 = combined_dz_interpenetrate;
                            let _e247 = z_7;
                            let _e248 = combined_dz_interpenetrate;
                            cvg_coeff = (((_e243 >> u32(_e244)) - (_e247 >> u32(_e248))) & 15i);
                            let _e255 = cvg_coeff;
                            let _e256 = (*coverage_count_1);
                            (*coverage_count_1) = min(((_e255 * _e256) >> 3u), 8i);
                            depth_pass = true;
                        }
                    }
                }
                case 2: {
                    let _e264 = front;
                    let _e265 = max_z;
                    depth_pass = (_e264 || _e265);
                }
                case 3: {
                    let _e267 = farther;
                    let _e268 = nearer;
                    let _e270 = max_z;
                    depth_pass = ((_e267 && _e268) && !(_e270));
                }
                default: {
                }
            }
        }
    } else {
        {
            (*blend_shift).x = 0i;
            let _e277 = dz_compressed_1;
            (*blend_shift).y = min((15i - _e277), 4i);
            let _e281 = (*coverage_count_1);
            let _e282 = current_coverage_count_1;
            overflow_1_ = ((_e281 + _e282) >= 8i);
            let _e288 = force_blend_1;
            if !(_e288) {
                {
                    let _e290 = overflow_1_;
                    let _e292 = aa_enable_2;
                    _1523_ = (!(_e290) && _e292);
                }
            } else {
                {
                    let _e294 = force_blend_1;
                    _1523_ = _e294;
                }
            }
            let _e295 = _1523_;
            (*blend_en) = _e295;
            let _e296 = overflow_1_;
            (*coverage_wrap) = _e296;
            depth_pass = true;
        }
    }
    let _e298 = depth_pass;
    return _e298;
}

fn blender(inputs_12: BlendInputs, blend_modes: vec4<i32>, force_blend_2: bool, blend_en_1: bool, color_on_coverage: bool, coverage_wrap_1: bool, blend_shift_1: vec2<i32>, final_cycle: bool) -> vec3<i32> {
    var inputs_13: BlendInputs;
    var blend_modes_1: vec4<i32>;
    var force_blend_3: bool;
    var blend_en_2: bool;
    var color_on_coverage_1: bool;
    var coverage_wrap_2: bool;
    var blend_shift_2: vec2<i32>;
    var final_cycle_1: bool;
    var rgb1_: vec3<i32>;
    var rgb0_: vec3<i32>;
    var _1158_: bool;
    var _1179_: bool;
    var _1165_: bool;
    var _1172_: bool;
    var _1178_: bool;
    var a0_: i32;
    var a1_: i32;
    var blended: vec3<i32>;
    var blend_sum: i32;

    inputs_13 = inputs_12;
    blend_modes_1 = blend_modes;
    force_blend_3 = force_blend_2;
    blend_en_2 = blend_en_1;
    color_on_coverage_1 = color_on_coverage;
    coverage_wrap_2 = coverage_wrap_1;
    blend_shift_2 = blend_shift_1;
    final_cycle_1 = final_cycle;
    let _e85 = blend_modes_1;
    switch _e85.z {
        case 0: {
            let _e87 = inputs_13;
            rgb1_ = _e87.pixel_color.xyz;
        }
        case 1: {
            let _e90 = inputs_13;
            rgb1_ = _e90.memory_color.xyz;
        }
        case 2: {
            let _e93 = inputs_13;
            rgb1_ = _e93.blend_color.xyz;
        }
        case 3: {
            let _e96 = inputs_13;
            rgb1_ = _e96.fog_color.xyz;
        }
        default: {
        }
    }
    let _e99 = final_cycle_1;
    if _e99 {
        {
            let _e100 = color_on_coverage_1;
            let _e101 = coverage_wrap_2;
            if (_e100 && !(_e101)) {
                {
                    let _e104 = rgb1_;
                    return _e104;
                }
            }
        }
    }
    let _e106 = blend_modes_1;
    switch _e106.x {
        case 0: {
            let _e108 = inputs_13;
            rgb0_ = _e108.pixel_color.xyz;
        }
        case 1: {
            let _e111 = inputs_13;
            rgb0_ = _e111.memory_color.xyz;
        }
        case 2: {
            let _e114 = inputs_13;
            rgb0_ = _e114.blend_color.xyz;
        }
        case 3: {
            let _e117 = inputs_13;
            rgb0_ = _e117.fog_color.xyz;
        }
        default: {
        }
    }
    let _e120 = final_cycle_1;
    if _e120 {
        {
            let _e121 = blend_en_2;
            _1158_ = !(_e121);
            let _e125 = _1158_;
            if !(_e125) {
                {
                    let _e127 = blend_modes_1;
                    _1165_ = (_e127.y == 0i);
                    let _e133 = _1165_;
                    if _e133 {
                        {
                            let _e134 = blend_modes_1;
                            _1172_ = (_e134.w == 0i);
                        }
                    } else {
                        {
                            let _e138 = _1165_;
                            _1172_ = _e138;
                        }
                    }
                    let _e140 = _1172_;
                    if _e140 {
                        {
                            let _e141 = inputs_13;
                            _1178_ = (_e141.pixel_color.w == 255i);
                        }
                    } else {
                        {
                            let _e146 = _1172_;
                            _1178_ = _e146;
                        }
                    }
                    let _e147 = _1178_;
                    _1179_ = _e147;
                }
            } else {
                {
                    let _e148 = _1158_;
                    _1179_ = _e148;
                }
            }
            let _e149 = _1179_;
            if _e149 {
                {
                    let _e150 = rgb0_;
                    return _e150;
                }
            }
        }
    }
    let _e152 = blend_modes_1;
    switch _e152.y {
        case 0: {
            let _e154 = inputs_13;
            a0_ = _e154.pixel_color.w;
        }
        case 1: {
            let _e157 = inputs_13;
            a0_ = _e157.fog_color.w;
        }
        case 2: {
            let _e160 = inputs_13;
            a0_ = _e160.shade_alpha;
        }
        case 3: {
            a0_ = 0i;
        }
        default: {
        }
    }
    let _e164 = blend_modes_1;
    switch _e164.w {
        case 0: {
            let _e166 = a0_;
            a1_ = (~(_e166) & 255i);
        }
        case 1: {
            let _e170 = inputs_13;
            a1_ = _e170.memory_color.w;
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
    let _e175 = a0_;
    a0_ = (_e175 >> 3u);
    let _e179 = a1_;
    a1_ = (_e179 >> 3u);
    let _e183 = blend_modes_1;
    if (_e183.w == 1i) {
        {
            let _e187 = a0_;
            let _e188 = blend_shift_2;
            a0_ = ((_e187 >> u32(_e188.x)) & 60i);
            let _e194 = a1_;
            let _e195 = blend_shift_2;
            a1_ = ((_e194 >> u32(_e195.y)) | 3i);
        }
    }
    let _e201 = rgb0_;
    let _e203 = a0_;
    let _e206 = rgb1_;
    let _e208 = a1_;
    blended = ((vec3<i32>(_e201) * vec3(_e203)) + (vec3<i32>(_e206) * vec3((_e208 + 1i))));
    let _e215 = final_cycle_1;
    let _e217 = force_blend_3;
    if (!(_e215) || _e217) {
        {
            let _e219 = blended;
            rgb0_ = vec3<i32>((_e219 >> vec3(5u)));
        }
    } else {
        {
            let _e226 = a0_;
            let _e230 = a1_;
            blend_sum = (((_e226 >> 2u) + (_e230 >> 2u)) + 1i);
            let _e238 = blended;
            blended = (_e238 >> vec3(2u));
            let _e244 = blended;
            blended = (_e244 & vec3(2047i));
            let _e249 = blend_sum;
            let _e253 = blended;
            let _e258 = uBlenderDividerLUT_blk.uBlenderDividerLUT_raw[((_e249 << 11u) | _e253.x)];
            rgb0_.x = i32(_e258.x);
            let _e262 = blend_sum;
            let _e266 = blended;
            let _e271 = uBlenderDividerLUT_blk.uBlenderDividerLUT_raw[((_e262 << 11u) | _e266.y)];
            rgb0_.y = i32(_e271.x);
            let _e275 = blend_sum;
            let _e279 = blended;
            let _e284 = uBlenderDividerLUT_blk.uBlenderDividerLUT_raw[((_e275 << 11u) | _e279.z)];
            rgb0_.z = i32(_e284.x);
        }
    }
    let _e287 = rgb0_;
    return (_e287 & vec3(255i));
}

fn rgb_dither_1(orig_rgb: vec3<i32>, dith: i32) -> vec3<i32> {
    var orig_rgb_1: vec3<i32>;
    var dith_1: i32;
    var rgb_dith_1: vec3<i32>;
    var rgb_1: vec3<i32>;
    var replace_sign: vec3<i32>;
    var dither_diff: vec3<i32>;

    orig_rgb_1 = orig_rgb;
    dith_1 = dith;
    let _e72 = dith_1;
    rgb_dith_1 = ((vec3(_e72) >> vec3<u32>(0u, 3u, 6u)) & vec3(7i));
    let _e87 = orig_rgb_1;
    let _e96 = orig_rgb_1;
    rgb_1 = select(((_e87 & vec3(248i)) + vec3(8i)), vec3(255i), (_e96 > vec3(247i)));
    let _e102 = rgb_dith_1;
    let _e103 = orig_rgb_1;
    replace_sign = ((_e102 - (_e103 & vec3(7i))) >> vec3(31u));
    let _e114 = rgb_1;
    let _e115 = orig_rgb_1;
    dither_diff = (_e114 - _e115);
    let _e118 = orig_rgb_1;
    let _e119 = dither_diff;
    let _e120 = replace_sign;
    rgb_1 = (_e118 + (_e119 & _e120));
    let _e123 = rgb_1;
    return vec3<i32>((_e123 & vec3(255i)));
}

fn blend_coverage(coverage_8: i32, memory_coverage_1: i32, blend_en_3: bool, mode: i32) -> i32 {
    var coverage_9: i32;
    var memory_coverage_2: i32;
    var blend_en_4: bool;
    var mode_1: i32;
    var res_4: i32 = 0i;

    coverage_9 = coverage_8;
    memory_coverage_2 = memory_coverage_1;
    blend_en_4 = blend_en_3;
    mode_1 = mode;
    let _e78 = mode_1;
    switch _e78 {
        case 0: {
            let _e79 = blend_en_4;
            if _e79 {
                {
                    let _e81 = memory_coverage_2;
                    let _e82 = coverage_9;
                    res_4 = min(7i, (_e81 + _e82));
                }
            } else {
                {
                    let _e85 = coverage_9;
                    res_4 = ((_e85 - 1i) & 7i);
                }
            }
        }
        case 1: {
            let _e90 = coverage_9;
            let _e91 = memory_coverage_2;
            res_4 = ((_e90 + _e91) & 7i);
        }
        case 2: {
            res_4 = 7i;
        }
        case 3: {
            let _e96 = memory_coverage_2;
            res_4 = _e96;
        }
        default: {
        }
    }
    let _e97 = res_4;
    return _e97;
}

fn write_color(col: vec4<i32>) {
    var col_1: vec4<i32>;

    col_1 = col;
    let _e71 = col_1;
    current_color.x = _e71.x;
    let _e75 = col_1;
    current_color.y = _e75.y;
    let _e79 = col_1;
    current_color.z = _e79.z;
    current_color_dirty = true;
    return;
}

fn z_compress(z_8: i32) -> i32 {
    var z_9: i32;
    var inv_z: i32;
    var exponent_1: i32;
    var shift_11: i32;
    var mantissa_1: i32;

    z_9 = z_8;
    let _e71 = z_9;
    inv_z = max((262143i - _e71), 1i);
    let _e77 = inv_z;
    exponent_1 = (17i - firstLeadingBit(_e77));
    let _e81 = exponent_1;
    exponent_1 = clamp(_e81, 0i, 7i);
    let _e86 = exponent_1;
    shift_11 = max((6i - _e86), 0i);
    let _e91 = z_9;
    let _e92 = shift_11;
    mantissa_1 = ((_e91 >> u32(_e92)) & 2047i);
    let _e98 = exponent_1;
    let _e102 = mantissa_1;
    return ((_e98 << 11u) + _e102);
}

fn depth_blend(x_10: i32, y_6: i32, primitive_index_2: u32, shaded_1: ShadedData) {
    var x_11: i32;
    var y_7: i32;
    var primitive_index_3: u32;
    var shaded_2: ShadedData;
    var z_10: i32;
    var dith_2: i32;
    var coverage_count_2: i32;
    var combined_3: vec4<i32>;
    var shade_alpha: i32;
    var blend_state_index: u32;
    var param_20: u32;
    var derived_1: DerivedSetup;
    var param_1_15: u32;
    var depth_blend_1_: DepthBlendState;
    var force_blend_4: bool;
    var z_compare_2: bool;
    var z_update: bool;
    var image_read_enable: bool;
    var color_on_coverage_2: bool;
    var blend_multicycle: bool;
    var aa_enable_3: bool;
    var dither_en: bool;
    var param_2_12: bool;
    var memory_color: vec4<i32>;
    var memory_coverage_3: i32;
    var param_3_9: i32;
    var param_4_7: i32;
    var param_5_7: i32;
    var param_6_7: i32;
    var param_7_7: i32;
    var param_8_6: i32;
    var param_9_6: i32;
    var param_10_5: bool;
    var param_11_5: i32;
    var param_12_5: bool;
    var param_13_5: bool;
    var param_14_5: bool;
    var param_15_5: bool;
    var param_16_5: vec2<i32>;
    var _2693_: bool;
    var blend_en_5: bool;
    var coverage_wrap_3: bool;
    var blend_shift_3: vec2<i32>;
    var z_pass: bool;
    var _2706_: bool;
    var blender_inputs: BlendInputs;
    var blend_modes_2: vec4<i32>;
    var param_17_3: BlendInputs;
    var param_18_2: vec4<i32>;
    var param_19_2: bool;
    var param_20_2: bool;
    var param_21_2: bool;
    var param_22_2: bool;
    var param_23_2: vec2<i32>;
    var param_24_2: bool = false;
    var _2739_: vec3<i32>;
    var param_25_2: BlendInputs;
    var param_26_2: vec4<i32>;
    var param_27_2: bool;
    var param_28_2: bool;
    var param_29_2: bool;
    var param_30_2: bool;
    var param_31_2: vec2<i32>;
    var param_32_2: bool = true;
    var rgb_2: vec3<i32>;
    var param_33_2: vec3<i32>;
    var param_34_2: i32;
    var param_35_2: i32;
    var param_36_2: i32;
    var param_37_2: bool;
    var param_38_2: i32;
    var new_coverage: i32;
    var param_39_2: vec4<i32>;
    var param_40_2: i32;

    x_11 = x_10;
    y_7 = y_6;
    primitive_index_3 = primitive_index_2;
    shaded_2 = shaded_1;
    let _e76 = shaded_2;
    z_10 = (_e76.z_dith >> 9u);
    let _e82 = shaded_2;
    dith_2 = (_e82.z_dith & 511i);
    let _e87 = shaded_2;
    coverage_count_2 = _e87.coverage_count;
    let _e90 = shaded_2;
    combined_3 = _e90.combined;
    let _e93 = shaded_2;
    shade_alpha = _e93.shade_alpha;
    let _e96 = primitive_index_3;
    let _e103 = state_indices.state_indices_raw[((_e96 * 4u) + 0u)];
    let _e106 = primitive_index_3;
    let _e113 = state_indices.state_indices_raw[((_e106 * 4u) + 0u)];
    let _e118 = primitive_index_3;
    let _e125 = state_indices.state_indices_raw[((_e118 * 4u) + 0u)];
    let _e130 = primitive_index_3;
    let _e137 = state_indices.state_indices_raw[((_e130 * 4u) + 0u)];
    blend_state_index = u32(vec4<u32>((_e103 & 255u), ((_e113 >> 8u) & 255u), ((_e125 >> 16u) & 255u), (_e137 >> 24u)).y);
    let _e144 = primitive_index_3;
    param_20 = _e144;
    let _e146 = param_20;
    let _e147 = load_derived_setup(_e146);
    derived_1 = _e147;
    let _e149 = blend_state_index;
    param_1_15 = _e149;
    let _e151 = param_1_15;
    let _e152 = load_depth_blend_state(_e151);
    depth_blend_1_ = _e152;
    let _e154 = depth_blend_1_;
    force_blend_4 = ((_e154.flags & 8u) != 0u);
    let _e161 = depth_blend_1_;
    z_compare_2 = ((_e161.flags & 1u) != 0u);
    let _e168 = depth_blend_1_;
    z_update = ((_e168.flags & 2u) != 0u);
    let _e175 = depth_blend_1_;
    image_read_enable = ((_e175.flags & 16u) != 0u);
    let _e182 = depth_blend_1_;
    color_on_coverage_2 = ((_e182.flags & 32u) != 0u);
    let _e189 = depth_blend_1_;
    blend_multicycle = ((_e189.flags & 64u) != 0u);
    let _e196 = depth_blend_1_;
    aa_enable_3 = ((_e196.flags & 128u) != 0u);
    let _e203 = depth_blend_1_;
    dither_en = ((_e203.flags & 256u) != 0u);
    let _e210 = image_read_enable;
    param_2_12 = _e210;
    let _e212 = param_2_12;
    let _e213 = decode_memory_color(_e212);
    memory_color = _e213;
    let _e215 = memory_color;
    memory_coverage_3 = (_e215.w >> 5u);
    let _e221 = z_10;
    param_3_9 = _e221;
    let _e223 = derived_1;
    param_4_7 = _e223.dz;
    let _e226 = derived_1;
    param_5_7 = _e226.dz_compressed;
    let _e229 = current_depth;
    param_6_7 = _e229;
    let _e231 = current_dz;
    param_7_7 = _e231;
    let _e233 = coverage_count_2;
    param_8_6 = _e233;
    let _e235 = memory_coverage_3;
    param_9_6 = _e235;
    let _e237 = z_compare_2;
    param_10_5 = _e237;
    let _e239 = depth_blend_1_;
    param_11_5 = _e239.z_mode;
    let _e242 = force_blend_4;
    param_12_5 = _e242;
    let _e244 = aa_enable_3;
    param_13_5 = _e244;
    let _e249 = param_3_9;
    let _e250 = param_4_7;
    let _e251 = param_5_7;
    let _e252 = param_6_7;
    let _e253 = param_7_7;
    let _e255 = param_9_6;
    let _e256 = param_10_5;
    let _e257 = param_11_5;
    let _e258 = param_12_5;
    let _e259 = param_13_5;
    let _e267 = depth_test(_e249, _e250, _e251, _e252, _e253, (&param_8_6), _e255, _e256, _e257, _e258, _e259, (&param_14_5), (&param_15_5), (&param_16_5));
    _2693_ = _e267;
    let _e269 = param_8_6;
    coverage_count_2 = _e269;
    let _e270 = param_14_5;
    blend_en_5 = _e270;
    let _e272 = param_15_5;
    coverage_wrap_3 = _e272;
    let _e274 = param_16_5;
    blend_shift_3 = _e274;
    let _e276 = _2693_;
    z_pass = _e276;
    let _e279 = z_pass;
    if _e279 {
        {
            let _e280 = aa_enable_3;
            let _e282 = coverage_count_2;
            _2706_ = (!(_e280) || (_e282 != 0i));
        }
    } else {
        {
            let _e286 = z_pass;
            _2706_ = _e286;
        }
    }
    let _e287 = _2706_;
    if _e287 {
        {
            let _e288 = combined_3;
            let _e289 = memory_color;
            let _e290 = derived_1;
            let _e292 = derived_1;
            let _e294 = shade_alpha;
            blender_inputs = BlendInputs(_e288, _e289, _e290.fog_color, _e292.blend_color, _e294);
            let _e297 = depth_blend_1_;
            blend_modes_2 = _e297.blend_modes0_;
            let _e300 = blend_multicycle;
            if _e300 {
                {
                    let _e301 = blender_inputs;
                    param_17_3 = _e301;
                    let _e303 = blend_modes_2;
                    param_18_2 = _e303;
                    let _e305 = force_blend_4;
                    param_19_2 = _e305;
                    let _e307 = blend_en_5;
                    param_20_2 = _e307;
                    let _e309 = color_on_coverage_2;
                    param_21_2 = _e309;
                    let _e311 = coverage_wrap_3;
                    param_22_2 = _e311;
                    let _e313 = blend_shift_3;
                    param_23_2 = _e313;
                    let _e317 = param_17_3;
                    let _e318 = param_18_2;
                    let _e319 = param_19_2;
                    let _e320 = param_20_2;
                    let _e321 = param_21_2;
                    let _e322 = param_22_2;
                    let _e323 = param_23_2;
                    let _e324 = param_24_2;
                    let _e325 = blender(_e317, _e318, _e319, _e320, _e321, _e322, _e323, _e324);
                    _2739_ = _e325;
                    let _e329 = _2739_;
                    blender_inputs.pixel_color.x = _e329.x;
                    let _e333 = _2739_;
                    blender_inputs.pixel_color.y = _e333.y;
                    let _e337 = _2739_;
                    blender_inputs.pixel_color.z = _e337.z;
                    let _e339 = depth_blend_1_;
                    blend_modes_2 = _e339.blend_modes1_;
                }
            }
            let _e341 = blender_inputs;
            param_25_2 = _e341;
            let _e343 = blend_modes_2;
            param_26_2 = _e343;
            let _e345 = force_blend_4;
            param_27_2 = _e345;
            let _e347 = blend_en_5;
            param_28_2 = _e347;
            let _e349 = color_on_coverage_2;
            param_29_2 = _e349;
            let _e351 = coverage_wrap_3;
            param_30_2 = _e351;
            let _e353 = blend_shift_3;
            param_31_2 = _e353;
            let _e357 = param_25_2;
            let _e358 = param_26_2;
            let _e359 = param_27_2;
            let _e360 = param_28_2;
            let _e361 = param_29_2;
            let _e362 = param_30_2;
            let _e363 = param_31_2;
            let _e364 = param_32_2;
            let _e365 = blender(_e357, _e358, _e359, _e360, _e361, _e362, _e363, _e364);
            rgb_2 = _e365;
            let _e367 = dither_en;
            if _e367 {
                {
                    let _e368 = rgb_2;
                    param_33_2 = _e368;
                    let _e370 = dith_2;
                    param_34_2 = _e370;
                    let _e372 = param_33_2;
                    let _e373 = param_34_2;
                    let _e374 = rgb_dither_1(_e372, _e373);
                    rgb_2 = _e374;
                }
            }
            let _e375 = coverage_count_2;
            param_35_2 = _e375;
            let _e377 = memory_coverage_3;
            param_36_2 = _e377;
            let _e379 = blend_en_5;
            param_37_2 = _e379;
            let _e381 = depth_blend_1_;
            param_38_2 = _e381.coverage_mode;
            let _e384 = param_35_2;
            let _e385 = param_36_2;
            let _e386 = param_37_2;
            let _e387 = param_38_2;
            let _e388 = blend_coverage(_e384, _e385, _e386, _e387);
            new_coverage = _e388;
            let _e390 = rgb_2;
            let _e391 = new_coverage;
            param_39_2 = vec4<i32>(_e390.x, _e390.y, _e390.z, (_e391 << 5u));
            let _e400 = param_39_2;
            write_color(_e400);
            let _e401 = z_update;
            if _e401 {
                {
                    let _e402 = z_10;
                    param_40_2 = _e402;
                    let _e404 = param_40_2;
                    let _e405 = z_compress(_e404);
                    current_depth = _e405;
                    let _e406 = derived_1;
                    current_dz = _e406.dz_compressed;
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

fn copy_pipeline(word_17: u32, primitive_index_4: u32) {
    var word_18: u32;
    var primitive_index_5: u32;

    word_18 = word_17;
    primitive_index_5 = primitive_index_4;
    current_color = vec4(0i);
    current_color_dirty = true;
    return;
}

fn fill_color(col_2: u32) {
    var col_3: u32;

    col_3 = col_2;
    return;
}

fn store_vram_color(index_30: ptr<function, u32>, slice_5: u32) {
    var slice_6: u32;

    slice_6 = slice_5;
    let _e71 = current_color_dirty;
    if _e71 {
        {
            let _e72 = (*index_30);
            (*index_30) = (_e72 & 8388607u);
            let _e75 = (*index_30);
            let _e76 = slice_6;
            (*index_30) = (_e75 + (_e76 * 8388608u));
            let _e80 = (*index_30);
            let _e87 = (*index_30);
            let _e94 = vram8_.data[((_e87 ^ 3u) >> 2u)];
            let _e96 = (*index_30);
            let _e109 = (*index_30);
            vram8_.data[((_e80 ^ 3u) >> 2u)] = ((_e94 & ~((255u << (((_e96 ^ 3u) & 3u) * 8u)))) | (0u << (((_e109 ^ 3u) & 3u) * 8u)));
            let _e118 = (*index_30);
            if ((_e118 & 1u) != 0u) {
                {
                    let _e123 = (*index_30);
                    let _e130 = (*index_30);
                    let _e137 = hidden_vram.data[((_e130 >> 1u) >> 2u)];
                    let _e139 = (*index_30);
                    let _e149 = current_color;
                    let _e154 = (*index_30);
                    hidden_vram.data[((_e123 >> 1u) >> 2u)] = ((_e137 & ~((255u << (((_e139 >> 1u) & 3u) * 8u)))) | ((u32(_e149.w) & 255u) << (((_e154 >> 1u) & 3u) * 8u)));
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

fn store_vram_depth(index_31: ptr<function, u32>, slice_7: u32) {
    var slice_8: u32;

    slice_8 = slice_7;
    let _e71 = current_depth_dirty;
    if _e71 {
        {
            let _e72 = (*index_31);
            (*index_31) = (_e72 & 4194303u);
            let _e75 = (*index_31);
            let _e76 = slice_8;
            (*index_31) = (_e75 + (_e76 * 4194304u));
            let _e80 = (*index_31);
            let _e85 = current_depth;
            let _e93 = current_dz;
            vram8_.data[(_e80 ^ 1u)] = (u32((u32((_e85 << 2u)) & 65535u)) | u32((_e93 >> 2u)));
            let _e99 = (*index_31);
            let _e104 = (*index_31);
            let _e109 = hidden_vram.data[(_e104 >> 2u)];
            let _e111 = (*index_31);
            let _e119 = current_dz;
            let _e125 = (*index_31);
            hidden_vram.data[(_e99 >> 2u)] = ((_e109 & ~((255u << ((_e111 & 3u) * 8u)))) | ((u32((_e119 & 3i)) & 255u) << ((_e125 & 3u) * 8u)));
            return;
        }
    } else {
        return;
    }
}

fn finish_tile(coord_3: ptr<function, vec2<u32>>, fb_width_2: u32, fb_height_2: u32, fb_addr_index_2: u32, fb_depth_addr_index_2: u32) {
    var fb_width_3: u32;
    var fb_height_3: u32;
    var fb_addr_index_3: u32;
    var fb_depth_addr_index_3: u32;
    var unscaled_fb_width: u32;
    var slice2d_1: vec2<u32>;
    var slice_9: u32;
    var index_32: u32;
    var param_21: u32;
    var param_1_16: u32;
    var param_2_13: u32;
    var param_3_10: u32;

    fb_width_3 = fb_width_2;
    fb_height_3 = fb_height_2;
    fb_addr_index_3 = fb_addr_index_2;
    fb_depth_addr_index_3 = fb_depth_addr_index_2;
    let _e77 = (*coord_3);
    let _e78 = fb_width_3;
    let _e79 = fb_height_3;
    if any((_e77 >= vec2<u32>(_e78, _e79))) {
        {
            current_color_dirty = false;
            current_depth_dirty = false;
        }
    }
    let _e85 = fb_width_3;
    unscaled_fb_width = (_e85 >> 0u);
    let _e90 = (*coord_3);
    slice2d_1 = (_e90 & vec2(0u));
    let _e95 = (*coord_3);
    (*coord_3) = (_e95 >> vec2(0u));
    let _e101 = slice2d_1;
    let _e105 = slice2d_1;
    slice_9 = ((_e101.y * 1u) + _e105.x);
    let _e109 = fb_addr_index_3;
    let _e110 = unscaled_fb_width;
    let _e111 = (*coord_3);
    let _e115 = (*coord_3);
    index_32 = ((_e109 + (_e110 * _e111.y)) + _e115.x);
    let _e119 = index_32;
    param_21 = _e119;
    let _e121 = slice_9;
    param_1_16 = _e121;
    let _e124 = param_1_16;
    store_vram_color((&param_21), _e124);
    let _e126 = fb_depth_addr_index_3;
    let _e127 = unscaled_fb_width;
    let _e128 = (*coord_3);
    let _e132 = (*coord_3);
    index_32 = ((_e126 + (_e127 * _e128.y)) + _e132.x);
    let _e135 = index_32;
    param_2_13 = _e135;
    let _e137 = slice_9;
    param_3_10 = _e137;
    let _e140 = param_3_10;
    store_vram_depth((&param_2_13), _e140);
    return;
}

fn main_1() {
    var x_12: i32;
    var y_8: i32;
    var tile_38: vec2<i32>;
    var linear_tile: i32;
    var linear_tile_base: i32;
    var coarse_binned: u32;
    var param_22: vec2<u32>;
    var param_1_17: u32;
    var param_2_14: u32;
    var param_3_11: u32;
    var param_4_8: u32;
    var param_8_7: ShadedData;
    var mask_index: i32;
    var binned: u32;
    var i: i32;
    var primitive_index_6: u32;
    var param_5_8: i32;
    var param_6_8: i32;
    var param_7_8: u32;
    var _8221_: bool;
    var shaded_3: ShadedData;
    var param_9_7: u32;
    var param_10_6: u32;
    var param_11_6: u32;
    var param_12_6: i32;
    var param_13_6: i32;
    var param_14_6: u32;
    var param_15_6: ShadedData;
    var param_16_6: vec2<u32>;
    var param_17_4: u32;
    var param_18_3: u32;
    var param_19_3: u32;
    var param_20_3: u32;

    seeded_noise = 0i;
    let _e70 = gl_GlobalInvocationID_1;
    x_12 = i32(_e70.x);
    let _e74 = gl_GlobalInvocationID_1;
    y_8 = i32(_e74.y);
    let _e79 = gl_WorkGroupID_1;
    tile_38 = vec2<i32>(_e79.xy);
    let _e83 = tile_38;
    let _e85 = tile_38;
    linear_tile = (_e83.x + (_e85.y * 0i));
    let _e91 = linear_tile;
    linear_tile_base = (_e91 * 0i);
    let _e95 = linear_tile;
    let _e98 = tile_binning_coarse.elems[_e95];
    let _e99 = registers;
    coarse_binned = (_e98 & _e99.group_mask);
    let _e103 = coarse_binned;
    if (_e103 == 0u) {
        {
            return;
        }
    }
    let _e106 = gl_GlobalInvocationID_1;
    param_22 = _e106.xy;
    let _e109 = registers;
    param_1_17 = _e109.fb_width;
    let _e112 = registers;
    param_2_14 = _e112.fb_height;
    let _e115 = registers;
    param_3_11 = _e115.fb_addr_index;
    let _e118 = registers;
    param_4_8 = _e118.fb_depth_addr_index;
    let _e122 = param_1_17;
    let _e123 = param_2_14;
    let _e124 = param_3_11;
    let _e125 = param_4_8;
    init_tile((&param_22), _e122, _e123, _e124, _e125);
    loop {
        let _e128 = coarse_binned;
        if !((_e128 != 0u)) {
            break;
        }
        {
            let _e132 = coarse_binned;
            mask_index = i32(firstTrailingBit(_e132));
            let _e136 = coarse_binned;
            let _e138 = mask_index;
            coarse_binned = (_e136 & ~(u32((1i << u32(_e138)))));
            let _e144 = linear_tile_base;
            let _e145 = mask_index;
            let _e149 = tile_binning.elems[(_e144 + _e145)];
            binned = _e149;
            loop {
                let _e151 = binned;
                if !((_e151 != 0u)) {
                    break;
                }
                {
                    let _e155 = binned;
                    i = i32(firstTrailingBit(_e155));
                    let _e159 = binned;
                    let _e161 = i;
                    binned = (_e159 & ~(u32((1i << u32(_e161)))));
                    let _e167 = i;
                    let _e169 = mask_index;
                    primitive_index_6 = u32((_e167 + (32i * _e169)));
                    let _e174 = x_12;
                    param_5_8 = _e174;
                    let _e176 = y_8;
                    param_6_8 = _e176;
                    let _e178 = primitive_index_6;
                    param_7_8 = _e178;
                    let _e180 = param_5_8;
                    let _e181 = param_6_8;
                    let _e182 = param_7_8;
                    let _e185 = shade_pixel(_e180, _e181, _e182, (&param_8_7));
                    _8221_ = _e185;
                    let _e187 = param_8_7;
                    shaded_3 = _e187;
                    let _e189 = _8221_;
                    if _e189 {
                        {
                            let _e190 = shaded_3;
                            if ((_e190.coverage_count & 64i) != 0i) {
                                {
                                    let _e196 = primitive_index_6;
                                    let _e203 = derived_setup.derived_setup_raw[((_e196 * 14u) + 10u)];
                                    param_9_7 = _e203;
                                    let _e205 = param_9_7;
                                    fill_color(_e205);
                                }
                            } else {
                                {
                                    let _e206 = shaded_3;
                                    if ((_e206.coverage_count & 32i) != 0i) {
                                        {
                                            let _e212 = shaded_3;
                                            param_10_6 = u32(_e212.z_dith);
                                            let _e216 = primitive_index_6;
                                            param_11_6 = _e216;
                                            let _e218 = param_10_6;
                                            let _e219 = param_11_6;
                                            copy_pipeline(_e218, _e219);
                                        }
                                    } else {
                                        {
                                            let _e220 = x_12;
                                            param_12_6 = _e220;
                                            let _e222 = y_8;
                                            param_13_6 = _e222;
                                            let _e224 = primitive_index_6;
                                            param_14_6 = _e224;
                                            let _e226 = shaded_3;
                                            param_15_6 = _e226;
                                            let _e228 = param_12_6;
                                            let _e229 = param_13_6;
                                            let _e230 = param_14_6;
                                            let _e231 = param_15_6;
                                            depth_blend(_e228, _e229, _e230, _e231);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    let _e232 = gl_GlobalInvocationID_1;
    param_16_6 = _e232.xy;
    let _e235 = registers;
    param_17_4 = _e235.fb_width;
    let _e238 = registers;
    param_18_3 = _e238.fb_height;
    let _e241 = registers;
    param_19_3 = _e241.fb_addr_index;
    let _e244 = registers;
    param_20_3 = _e244.fb_depth_addr_index;
    let _e248 = param_17_4;
    let _e249 = param_18_3;
    let _e250 = param_19_3;
    let _e251 = param_20_3;
    finish_tile((&param_16_6), _e248, _e249, _e250, _e251);
    return;
}

@compute @workgroup_size(8, 8, 1) 
fn main(@builtin(global_invocation_id) gl_GlobalInvocationID: vec3<u32>, @builtin(workgroup_id) gl_WorkGroupID: vec3<u32>) {
    gl_GlobalInvocationID_1 = gl_GlobalInvocationID;
    gl_WorkGroupID_1 = gl_WorkGroupID;
    main_1();
    return;
}
