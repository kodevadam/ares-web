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

struct SpanInfoOffsetsMem {
    offset: i32,
    ylo: i32,
    yhi: i32,
    padding: i32,
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

struct ShadedData {
    combined: vec4<i32>,
    z_dith: i32,
    coverage_count: i32,
    shade_alpha: i32,
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

struct SpanInfoOffsetBuffer {
    elems: array<SpanInfoOffsetsMem>,
}

struct SpanSetups {
    span_setups_raw: array<u32>,
}

struct TileInfoBuffer {
    tile_infos_raw: array<u32>,
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

struct StateIndicesBuffer {
    state_indices_raw: array<u32>,
}

struct TileWorkList {
    elems: array<vec4<u32>>,
}

struct ColorBuffer {
    elems: array<u32>,
}

struct ShadeAlpha {
    elems: array<u32>,
}

struct DepthBuffer {
    elems: array<i32>,
}

struct Coverage {
    elems: array<u32>,
}

const _1084_: array<vec2<i32>, 64> = array<vec2<i32>, 64>(vec2<i32>(16384i, -1008i), vec2<i32>(16132i, -976i), vec2<i32>(15888i, -952i), vec2<i32>(15650i, -920i), vec2<i32>(15420i, -892i), vec2<i32>(15197i, -872i), vec2<i32>(14979i, -840i), vec2<i32>(14769i, -820i), vec2<i32>(14564i, -800i), vec2<i32>(14364i, -776i), vec2<i32>(14170i, -756i), vec2<i32>(13981i, -736i), vec2<i32>(13797i, -716i), vec2<i32>(13618i, -700i), vec2<i32>(13443i, -680i), vec2<i32>(13273i, -664i), vec2<i32>(13107i, -648i), vec2<i32>(12945i, -628i), vec2<i32>(12788i, -620i), vec2<i32>(12633i, -600i), vec2<i32>(12483i, -588i), vec2<i32>(12336i, -572i), vec2<i32>(12193i, -560i), vec2<i32>(12053i, -548i), vec2<i32>(11916i, -536i), vec2<i32>(11782i, -524i), vec2<i32>(11651i, -512i), vec2<i32>(11523i, -500i), vec2<i32>(11398i, -492i), vec2<i32>(11275i, -480i), vec2<i32>(11155i, -468i), vec2<i32>(11038i, -460i), vec2<i32>(10923i, -452i), vec2<i32>(10810i, -440i), vec2<i32>(10700i, -432i), vec2<i32>(10592i, -424i), vec2<i32>(10486i, -416i), vec2<i32>(10382i, -408i), vec2<i32>(10280i, -400i), vec2<i32>(10180i, -392i), vec2<i32>(10082i, -384i), vec2<i32>(9986i, -376i), vec2<i32>(9892i, -368i), vec2<i32>(9800i, -364i), vec2<i32>(9709i, -356i), vec2<i32>(9620i, -348i), vec2<i32>(9533i, -344i), vec2<i32>(9447i, -340i), vec2<i32>(9362i, -332i), vec2<i32>(9279i, -324i), vec2<i32>(9198i, -320i), vec2<i32>(9118i, -316i), vec2<i32>(9039i, -308i), vec2<i32>(8962i, -304i), vec2<i32>(8886i, -296i), vec2<i32>(8812i, -296i), vec2<i32>(8738i, -288i), vec2<i32>(8666i, -284i), vec2<i32>(8595i, -280i), vec2<i32>(8525i, -276i), vec2<i32>(8456i, -268i), vec2<i32>(8389i, -268i), vec2<i32>(8322i, -260i), vec2<i32>(8257i, -260i));
const _4741_: array<i32, 32> = array<i32, 32>(0i, 6i, 1i, 7i, 4i, 2i, 5i, 3i, 3i, 5i, 2i, 4i, 7i, 1i, 6i, 0i, 0i, 4i, 1i, 5i, 4i, 0i, 5i, 1i, 3i, 7i, 2i, 6i, 7i, 3i, 6i, 2i);

@group(0) @binding(1) 
var<storage, read_write> attribute_setup: AttributeSetupBuffer;
@group(0) @binding(2) 
var<storage, read_write> derived_setup: DerivedSetupBuffer;
@group(0) @binding(3) 
var<storage, read_write> static_raster_state: StaticRasterStateBuffer;
@group(0) @binding(5) 
var<storage, read_write> span_offsets: SpanInfoOffsetBuffer;
@group(0) @binding(6) 
var<storage, read_write> span_setups: SpanSetups;
@group(0) @binding(8) 
var<storage, read_write> tile_infos: TileInfoBuffer;
@group(2) @binding(0) 
var<uniform> global_constants: GlobalConstants;
@group(0) @binding(7) 
var<storage, read_write> tmem8_: TMEM8_;
@group(0) @binding(0) 
var<storage, read_write> triangle_setup: TriangleSetupBuffer;
@group(0) @binding(4) 
var<storage, read_write> state_indices: StateIndicesBuffer;
@group(1) @binding(0) 
var<storage, read_write> tile_work_list: TileWorkList;
@group(0) @binding(9) 
var<storage, read_write> color: ColorBuffer;
@group(0) @binding(11) 
var<storage, read_write> shade_alpha: ShadeAlpha;
@group(0) @binding(10) 
var<storage, read_write> depth: DepthBuffer;
@group(0) @binding(12) 
var<storage, read_write> coverage: Coverage;
var<private> seeded_noise: i32;
var<private> gl_WorkGroupID_1: vec3<u32>;
var<private> gl_LocalInvocationID_1: vec3<u32>;
var<private> gl_LocalInvocationIndex_1: u32;

fn load_span_offsets(index: u32) -> SpanInfoOffsetsMem {
    var index_1: u32;
    var _572_: SpanInfoOffsetsMem;

    index_1 = index;
    let _e52 = index_1;
    let _e55 = span_offsets.elems[_e52];
    _572_.offset = _e55.offset;
    let _e58 = index_1;
    let _e61 = span_offsets.elems[_e58];
    _572_.ylo = _e61.ylo;
    let _e64 = index_1;
    let _e67 = span_offsets.elems[_e64];
    _572_.yhi = _e67.yhi;
    let _e70 = index_1;
    let _e73 = span_offsets.elems[_e70];
    _572_.padding = _e73.padding;
    let _e75 = _572_;
    return _e75;
}

fn load_span_setup(index_2: u32) -> SpanSetup {
    var index_3: u32;

    index_3 = index_2;
    let _e50 = index_3;
    let _e57 = span_setups.span_setups_raw[((_e50 * 16u) + 0u)];
    let _e59 = index_3;
    let _e68 = span_setups.span_setups_raw[(((_e59 * 16u) + 0u) + 1u)];
    let _e70 = index_3;
    let _e79 = span_setups.span_setups_raw[(((_e70 * 16u) + 0u) + 2u)];
    let _e81 = index_3;
    let _e90 = span_setups.span_setups_raw[(((_e81 * 16u) + 0u) + 3u)];
    let _e93 = index_3;
    let _e100 = span_setups.span_setups_raw[((_e93 * 16u) + 4u)];
    let _e102 = index_3;
    let _e111 = span_setups.span_setups_raw[(((_e102 * 16u) + 4u) + 1u)];
    let _e113 = index_3;
    let _e122 = span_setups.span_setups_raw[(((_e113 * 16u) + 4u) + 2u)];
    let _e124 = index_3;
    let _e133 = span_setups.span_setups_raw[(((_e124 * 16u) + 4u) + 3u)];
    let _e136 = index_3;
    let _e143 = span_setups.span_setups_raw[((_e136 * 16u) + 8u)];
    let _e146 = index_3;
    let _e153 = span_setups.span_setups_raw[((_e146 * 16u) + 8u)];
    let _e156 = index_3;
    let _e165 = span_setups.span_setups_raw[(((_e156 * 16u) + 8u) + 1u)];
    let _e168 = index_3;
    let _e177 = span_setups.span_setups_raw[(((_e168 * 16u) + 8u) + 1u)];
    let _e182 = index_3;
    let _e189 = span_setups.span_setups_raw[((_e182 * 16u) + 10u)];
    let _e192 = index_3;
    let _e199 = span_setups.span_setups_raw[((_e192 * 16u) + 10u)];
    let _e202 = index_3;
    let _e211 = span_setups.span_setups_raw[(((_e202 * 16u) + 10u) + 1u)];
    let _e214 = index_3;
    let _e223 = span_setups.span_setups_raw[(((_e214 * 16u) + 10u) + 1u)];
    let _e228 = index_3;
    let _e235 = span_setups.span_setups_raw[((_e228 * 16u) + 12u)];
    let _e237 = index_3;
    let _e244 = span_setups.span_setups_raw[((_e237 * 16u) + 13u)];
    let _e246 = index_3;
    let _e253 = span_setups.span_setups_raw[((_e246 * 16u) + 14u)];
    let _e255 = index_3;
    let _e262 = span_setups.span_setups_raw[((_e255 * 16u) + 15u)];
    let _e271 = index_3;
    let _e278 = span_setups.span_setups_raw[((_e271 * 16u) + 15u)];
    return SpanSetup(vec4<i32>(i32(_e57), i32(_e68), i32(_e79), i32(_e90)), vec4<i32>(i32(_e100), i32(_e111), i32(_e122), i32(_e133)), vec4<i32>(vec4<u32>((_e143 & 65535u), (_e153 >> 16u), (_e165 & 65535u), (_e177 >> 16u))), vec4<i32>(vec4<u32>((_e189 & 65535u), (_e199 >> 16u), (_e211 & 65535u), (_e223 >> 16u))), i32(_e235), i32(_e244), i32(_e253), i32(((i32(_e262) << 16u) >> 16u)), i32((_e278 >> 16u)));
}

fn load_attribute_setup(index_4: u32) -> AttributeSetupMem {
    var index_5: u32;
    var _402_: AttributeSetupMem;

    index_5 = index_4;
    let _e52 = index_5;
    let _e55 = attribute_setup.elems[_e52];
    _402_.rgba = _e55.rgba;
    let _e58 = index_5;
    let _e61 = attribute_setup.elems[_e58];
    _402_.drgba_dx = _e61.drgba_dx;
    let _e64 = index_5;
    let _e67 = attribute_setup.elems[_e64];
    _402_.drgba_de = _e67.drgba_de;
    let _e70 = index_5;
    let _e73 = attribute_setup.elems[_e70];
    _402_.drgba_dy = _e73.drgba_dy;
    let _e76 = index_5;
    let _e79 = attribute_setup.elems[_e76];
    _402_.stzw = _e79.stzw;
    let _e82 = index_5;
    let _e85 = attribute_setup.elems[_e82];
    _402_.dstzw_dx = _e85.dstzw_dx;
    let _e88 = index_5;
    let _e91 = attribute_setup.elems[_e88];
    _402_.dstzw_de = _e91.dstzw_de;
    let _e94 = index_5;
    let _e97 = attribute_setup.elems[_e94];
    _402_.dstzw_dy = _e97.dstzw_dy;
    let _e99 = _402_;
    return _e99;
}

fn load_static_rasterization_state(index_6: u32) -> StaticRasterizationState {
    var index_7: u32;

    index_7 = index_6;
    let _e50 = index_7;
    let _e53 = static_raster_state.elems[_e50];
    let _e57 = index_7;
    let _e60 = static_raster_state.elems[_e57];
    let _e64 = index_7;
    let _e67 = static_raster_state.elems[_e64];
    let _e71 = index_7;
    let _e74 = static_raster_state.elems[_e71];
    let _e78 = index_7;
    let _e81 = static_raster_state.elems[_e78];
    let _e83 = index_7;
    let _e86 = static_raster_state.elems[_e83];
    return StaticRasterizationState(vec4<i32>(vec4<u32>(_e53.combiner_inputs_rgb0_)), vec4<i32>(vec4<u32>(_e60.combiner_inputs_alpha0_)), vec4<i32>(vec4<u32>(_e67.combiner_inputs_rgb1_)), vec4<i32>(vec4<u32>(_e74.combiner_inputs_alpha1_)), _e81.flags, _e86.dither, 0i, 0i);
}

fn reseed_noise(x: u32, y: u32, primitive_offset: u32) {
    var x_1: u32;
    var y_1: u32;
    var primitive_offset_1: u32;
    var seed: vec3<u32>;

    x_1 = x;
    y_1 = y;
    primitive_offset_1 = primitive_offset;
    let _e54 = x_1;
    let _e55 = y_1;
    let _e56 = primitive_offset_1;
    seed = vec3<u32>(_e54, _e55, _e56);
    let _e59 = seed;
    let _e63 = seed;
    seed = (((_e59 >> vec3(8u)) ^ _e63.yzx) * vec3(1103515245u));
    let _e69 = seed;
    let _e73 = seed;
    seed = (((_e69 >> vec3(8u)) ^ _e73.yzx) * vec3(1103515245u));
    let _e79 = seed;
    let _e83 = seed;
    seed = (((_e79 >> vec3(8u)) ^ _e83.yzx) * vec3(1103515245u));
    let _e89 = seed;
    seeded_noise = i32((_e89.x >> 16u));
    return;
}

fn no_perspective_divide(stw: vec3<i32>) -> vec2<i32> {
    var stw_1: vec3<i32>;

    stw_1 = stw;
    let _e50 = stw_1;
    return _e50.xy;
}

fn perspective_get_lut(w: i32) -> vec2<i32> {
    var w_1: i32;
    var shift: i32;
    var normout: i32;
    var wnorm: i32;
    var local: array<vec2<i32>, 64> = _1084_;
    var table: vec2<i32>;
    var rcp: i32;

    w_1 = w;
    let _e51 = w_1;
    shift = min((14i - firstLeadingBit(_e51)), 14i);
    let _e57 = w_1;
    let _e58 = shift;
    normout = ((_e57 << u32(_e58)) & 16383i);
    let _e64 = normout;
    wnorm = (_e64 & 255i);
    let _e68 = normout;
    let _e75 = local[(_e68 >> 8u)];
    table = vec2<i32>(_e75);
    let _e78 = table;
    let _e80 = wnorm;
    let _e85 = table;
    rcp = (((_e78.y * _e80) >> 10u) + _e85.x);
    let _e89 = rcp;
    let _e90 = shift;
    return vec2<i32>(_e89, _e90);
}

fn perspective_divide(stw_2: vec3<i32>, overflow: ptr<function, bool>) -> vec2<i32> {
    var stw_3: vec3<i32>;
    var w_2: i32;
    var w_carry: bool;
    var param: i32;
    var table_1: vec2<i32>;
    var shift_1: i32;
    var prod: vec2<i32>;
    var temp_mask: i32;
    var out_of_bounds: vec2<i32>;
    var temp: vec2<i32>;
    var _1152_: vec2<i32>;
    var _1156_: vec2<i32>;
    var _1171_: bool;
    var _1177_: bool;
    var _1194_: bool;
    var _1200_: bool;

    stw_3 = stw_2;
    let _e51 = stw_3;
    w_2 = _e51.z;
    let _e54 = w_2;
    w_carry = (_e54 <= 0i);
    let _e58 = w_2;
    w_2 = (_e58 & 32767i);
    let _e61 = w_2;
    param = _e61;
    let _e63 = param;
    let _e64 = perspective_get_lut(_e63);
    table_1 = _e64;
    let _e66 = table_1;
    shift_1 = _e66.y;
    let _e69 = stw_3;
    let _e71 = table_1;
    prod = (_e69.xy * vec2(_e71.x));
    let _e78 = shift_1;
    temp_mask = (1073741823i & -((536870912i >> u32(_e78))));
    let _e84 = prod;
    let _e85 = temp_mask;
    out_of_bounds = (_e84 & vec2(_e85));
    let _e90 = shift_1;
    if (_e90 != 14i) {
        {
            let _e93 = prod;
            _1152_ = _e93;
            let _e95 = _1152_;
            let _e97 = shift_1;
            _1156_ = (_e95 >> vec2<u32>(vec2((13i - _e97))));
            let _e103 = _1156_;
            prod = _e103;
            let _e104 = _1156_;
            temp = _e104;
        }
    } else {
        {
            let _e105 = prod;
            temp = (_e105 << vec2(1u));
        }
    }
    let _e111 = out_of_bounds;
    if any((_e111 != vec2(0i))) {
        {
            let _e116 = out_of_bounds;
            let _e118 = temp_mask;
            _1171_ = (_e116.x != _e118);
            let _e122 = _1171_;
            if _e122 {
                {
                    let _e123 = out_of_bounds;
                    _1177_ = (_e123.x != 0i);
                }
            } else {
                {
                    let _e127 = _1171_;
                    _1177_ = _e127;
                }
            }
            let _e128 = _1177_;
            if _e128 {
                {
                    let _e129 = prod;
                    if ((_e129.x & 536870912i) == 0i) {
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
            let _e141 = out_of_bounds;
            let _e143 = temp_mask;
            _1194_ = (_e141.y != _e143);
            let _e147 = _1194_;
            if _e147 {
                {
                    let _e148 = out_of_bounds;
                    _1200_ = (_e148.y != 0i);
                }
            } else {
                {
                    let _e152 = _1194_;
                    _1200_ = _e152;
                }
            }
            let _e153 = _1200_;
            if _e153 {
                {
                    let _e154 = prod;
                    if ((_e154.y & 536870912i) == 0i) {
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
    let _e166 = w_carry;
    if _e166 {
        {
            temp = vec2(32767i);
            (*overflow) = true;
        }
    }
    let _e170 = temp;
    return clamp(_e170, vec2(-65536i), vec2(65535i));
}

fn interpolate_st_copy(span: SpanSetup, dstzw_dx: vec4<i32>, x_2: i32, perspective: bool, flip: bool, st: ptr<function, vec2<i32>>, s_offset: ptr<function, i32>) {
    var span_1: SpanSetup;
    var dstzw_dx_1: vec4<i32>;
    var x_3: i32;
    var perspective_1: bool;
    var flip_1: bool;
    var _1301_: i32;
    var dx: i32;
    var snapped_dx: i32;
    var local_1: i32;
    var lerp_dx: i32;
    var stw_4: vec3<i32>;
    var param_1: vec3<i32>;
    var st_overflow: bool;
    var param_1_: bool;
    var _1360_: vec2<i32>;
    var param_2_: vec3<i32>;

    span_1 = span;
    dstzw_dx_1 = dstzw_dx;
    x_3 = x_2;
    perspective_1 = perspective;
    flip_1 = flip;
    let _e61 = flip_1;
    if _e61 {
        {
            let _e62 = x_3;
            let _e63 = span_1;
            _1301_ = (_e62 - _e63.start_x);
        }
    } else {
        {
            let _e66 = span_1;
            let _e68 = x_3;
            _1301_ = (_e66.end_x - _e68);
        }
    }
    let _e70 = _1301_;
    dx = _e70;
    let _e72 = dx;
    dx = (_e72 >> 0u);
    let _e76 = dx;
    let _e77 = global_constants;
    snapped_dx = (_e76 & _e77.fb_info.dx_mask);
    let _e82 = dx;
    let _e83 = snapped_dx;
    (*s_offset) = (_e82 - _e83);
    let _e85 = dx;
    let _e86 = global_constants;
    let _e91 = flip_1;
    if _e91 {
        local_1 = 1i;
    } else {
        local_1 = -1i;
    }
    let _e96 = local_1;
    lerp_dx = ((_e85 >> u32(_e86.fb_info.dx_shift)) * _e96);
    let _e99 = span_1;
    let _e102 = dstzw_dx_1;
    let _e108 = lerp_dx;
    stw_4 = (_e99.stzw.xyw + ((_e102.xyw & vec3(-32i)) * vec3(_e108)));
    let _e113 = perspective_1;
    if _e113 {
        {
            let _e114 = stw_4;
            param_1 = (_e114 >> vec3(16u));
            let _e122 = st_overflow;
            param_1_ = _e122;
            let _e124 = param_1;
            let _e127 = perspective_divide(_e124, (&param_1_));
            _1360_ = _e127;
            let _e129 = param_1_;
            st_overflow = _e129;
            let _e130 = _1360_;
            (*st) = _e130;
            return;
        }
    } else {
        {
            let _e131 = stw_4;
            param_2_ = (_e131 >> vec3(16u));
            let _e138 = param_2_;
            let _e139 = no_perspective_divide(_e138);
            (*st) = _e139;
            return;
        }
    }
}

fn load_tile_info(index_8: u32) -> TileInfo {
    var index_9: u32;

    index_9 = index_8;
    let _e50 = index_9;
    let _e57 = tile_infos.tile_infos_raw[((_e50 * 8u) + 0u)];
    let _e58 = index_9;
    let _e65 = tile_infos.tile_infos_raw[((_e58 * 8u) + 1u)];
    let _e66 = index_9;
    let _e73 = tile_infos.tile_infos_raw[((_e66 * 8u) + 2u)];
    let _e74 = index_9;
    let _e81 = tile_infos.tile_infos_raw[((_e74 * 8u) + 3u)];
    let _e82 = index_9;
    let _e89 = tile_infos.tile_infos_raw[((_e82 * 8u) + 4u)];
    let _e90 = index_9;
    let _e97 = tile_infos.tile_infos_raw[((_e90 * 8u) + 5u)];
    let _e98 = index_9;
    let _e105 = tile_infos.tile_infos_raw[((_e98 * 8u) + 6u)];
    let _e109 = index_9;
    let _e116 = tile_infos.tile_infos_raw[((_e109 * 8u) + 6u)];
    let _e122 = index_9;
    let _e129 = tile_infos.tile_infos_raw[((_e122 * 8u) + 6u)];
    let _e135 = index_9;
    let _e142 = tile_infos.tile_infos_raw[((_e135 * 8u) + 6u)];
    let _e148 = index_9;
    let _e155 = tile_infos.tile_infos_raw[((_e148 * 8u) + 7u)];
    let _e159 = index_9;
    let _e166 = tile_infos.tile_infos_raw[((_e159 * 8u) + 7u)];
    let _e172 = index_9;
    let _e179 = tile_infos.tile_infos_raw[((_e172 * 8u) + 7u)];
    let _e185 = index_9;
    let _e192 = tile_infos.tile_infos_raw[((_e185 * 8u) + 7u)];
    return TileInfo(_e57, _e65, _e73, _e81, _e89, _e97, i32((_e105 & 255u)), i32(((_e116 >> 8u) & 255u)), i32(((_e129 >> 16u) & 255u)), i32(((_e142 >> 24u) & 255u)), i32((_e155 & 255u)), i32(((_e166 >> 8u) & 255u)), i32(((_e179 >> 16u) & 255u)), i32(((_e192 >> 24u) & 255u)));
}

fn shift_coord(coord: ptr<function, i32>, lo: i32, shift_2: i32) -> i32 {
    var lo_1: i32;
    var shift_3: i32;

    lo_1 = lo;
    shift_3 = shift_2;
    let _e53 = (*coord);
    (*coord) = clamp(_e53, -32768i, 32767i);
    let _e58 = shift_3;
    if (_e58 < 11i) {
        {
            let _e61 = (*coord);
            let _e62 = shift_3;
            (*coord) = (_e61 >> u32(_e62));
        }
    } else {
        {
            let _e65 = (*coord);
            let _e67 = shift_3;
            (*coord) = (_e65 << u32((32i - _e67)));
            let _e71 = (*coord);
            (*coord) = (_e71 >> 16u);
        }
    }
    let _e75 = (*coord);
    let _e76 = lo_1;
    (*coord) = (_e75 - (_e76 << 3u));
    let _e81 = (*coord);
    return _e81;
}

fn texel_mask_s(tile: TileInfo, s: ptr<function, i32>) -> i32 {
    var tile_1: TileInfo;
    var mask: i32;

    tile_1 = tile;
    let _e51 = tile_1;
    if (_e51.mask_s != 0i) {
        {
            let _e56 = tile_1;
            mask = (1i << u32(_e56.mask_s));
            let _e61 = tile_1;
            if ((_e61.flags & 2i) != 0i) {
                {
                    let _e67 = (*s);
                    let _e68 = (*s);
                    let _e69 = mask;
                    (*s) = (_e67 ^ max(((_e68 & _e69) - 1i), 0i));
                }
            }
            let _e76 = (*s);
            let _e77 = mask;
            (*s) = (_e76 & (_e77 - 1i));
        }
    }
    let _e81 = (*s);
    return _e81;
}

fn texel_mask_t(tile_2: TileInfo, t: ptr<function, i32>) -> i32 {
    var tile_3: TileInfo;
    var mask_1: i32;

    tile_3 = tile_2;
    let _e51 = tile_3;
    if (_e51.mask_t != 0i) {
        {
            let _e56 = tile_3;
            mask_1 = (1i << u32(_e56.mask_t));
            let _e61 = tile_3;
            if ((_e61.flags & 8i) != 0i) {
                {
                    let _e67 = (*t);
                    let _e68 = (*t);
                    let _e69 = mask_1;
                    (*t) = (_e67 ^ max(((_e68 & _e69) - 1i), 0i));
                }
            }
            let _e76 = (*t);
            let _e77 = mask_1;
            (*t) = (_e76 & (_e77 - 1i));
        }
    }
    let _e81 = (*t);
    return _e81;
}

fn texel_mask_s_copy(tile_4: TileInfo, s_1: i32) -> vec2<i32> {
    var tile_5: TileInfo;
    var s_2: i32;
    var multi_s: vec2<i32>;
    var mask_2: i32;

    tile_5 = tile_4;
    s_2 = s_1;
    let _e52 = s_2;
    multi_s = (vec2(_e52) + vec2<i32>(0i, 1i));
    let _e59 = tile_5;
    if (_e59.mask_s != 0i) {
        {
            let _e64 = tile_5;
            mask_2 = (1i << u32(_e64.mask_s));
            let _e69 = tile_5;
            if ((_e69.flags & 2i) != 0i) {
                {
                    let _e75 = multi_s;
                    let _e76 = multi_s;
                    let _e77 = mask_2;
                    multi_s = (_e75 ^ max(((_e76 & vec2(_e77)) - vec2(1i)), vec2(0i)));
                }
            }
            let _e87 = multi_s;
            let _e88 = mask_2;
            multi_s = (_e87 & vec2((_e88 - 1i)));
        }
    }
    let _e93 = multi_s;
    return _e93;
}

fn sample_texture_copy_word(tile_6: TileInfo, tmem_instance: u32, st_1: ptr<function, vec2<i32>>, s_offset_1: i32, tlut: bool, tlut_type: bool) -> i32 {
    var tile_7: TileInfo;
    var tmem_instance_1: u32;
    var s_offset_2: i32;
    var tlut_1: bool;
    var tlut_type_1: bool;
    var high_word: bool;
    var _2512_: bool;
    var replicate_8bpp: bool;
    var s_shamt: i32;
    var large_texel: bool;
    var local_2: i32;
    var idx_mask: i32;
    var samp: i32;
    var param_2: TileInfo;
    var param_1_1: i32;
    var s_3: vec2<i32>;
    var param_2_1: TileInfo;
    var param_3_: i32;
    var _2552_: i32;
    var t_1: i32;
    var tbase: u32;
    var nibble_offset: vec2<u32>;
    var index_10: vec2<u32>;
    var samp0_: i32;
    var samp1_: i32;
    var param_4_: TileInfo;
    var param_5_: i32;
    var _2686_: i32;
    var s_1_: i32;
    var param_6_: TileInfo;
    var param_7_: i32;
    var _2693_: i32;
    var t_1_: i32;
    var tbase_1_: u32;
    var nibble_offset_1_: u32;
    var index_1_: u32;

    tile_7 = tile_6;
    tmem_instance_1 = tmem_instance;
    s_offset_2 = s_offset_1;
    tlut_1 = tlut;
    tlut_type_1 = tlut_type;
    let _e59 = s_offset_2;
    high_word = (_e59 < 2i);
    let _e64 = high_word;
    if _e64 {
        {
            let _e65 = tile_7;
            _2512_ = (_e65.size != 2i);
        }
    } else {
        {
            let _e69 = high_word;
            _2512_ = _e69;
        }
    }
    let _e70 = _2512_;
    let _e71 = tlut_1;
    replicate_8bpp = (_e70 && !(_e71));
    let _e75 = tile_7;
    s_shamt = min(_e75.size, 2i);
    let _e80 = tile_7;
    large_texel = (_e80.size == 3i);
    let _e85 = large_texel;
    let _e86 = tlut_1;
    if (_e85 || _e86) {
        local_2 = 1023i;
    } else {
        local_2 = 2047i;
    }
    let _e91 = local_2;
    idx_mask = _e91;
    let _e94 = replicate_8bpp;
    if _e94 {
        {
            let _e96 = (*st_1);
            let _e99 = s_offset_2;
            (*st_1).x = (_e96.x + (2i * _e99));
            let _e102 = tile_7;
            param_2 = _e102;
            let _e104 = (*st_1);
            param_1_1 = _e104.x;
            let _e107 = param_2;
            let _e108 = param_1_1;
            let _e109 = texel_mask_s_copy(_e107, _e108);
            s_3 = _e109;
            let _e111 = tile_7;
            param_2_1 = _e111;
            let _e113 = (*st_1);
            param_3_ = _e113.y;
            let _e116 = param_2_1;
            let _e119 = texel_mask_t(_e116, (&param_3_));
            _2552_ = _e119;
            let _e121 = _2552_;
            t_1 = _e121;
            let _e123 = tile_7;
            let _e125 = tile_7;
            let _e127 = t_1;
            tbase = (_e123.offset + (_e125.stride * u32(_e127)));
            let _e132 = tbase;
            let _e136 = s_3;
            let _e137 = s_shamt;
            nibble_offset = ((vec2((_e132 * 2u)) + vec2<u32>((_e136 << vec2<u32>(vec2(_e137))))) & vec2(8191u));
            let _e147 = nibble_offset;
            let _e148 = t_1;
            nibble_offset = (_e147 ^ vec2(((u32(_e148) & 1u) * 8u)));
            let _e156 = nibble_offset;
            index_10 = (_e156 >> vec2(2u));
            let _e161 = index_10;
            let _e162 = idx_mask;
            index_10 = (_e161 & vec2(u32(_e162)));
            let _e166 = tmem_instance_1;
            let _e170 = index_10;
            let _e180 = tmem8_.raw[((u32(_e166) * 1024u) + (u32((_e170.x ^ 1u)) / 2u))];
            let _e181 = index_10;
            samp0_ = i32(((_e180 >> ((u32((_e181.x ^ 1u)) & 1u) * 16u)) & 65535u));
            let _e195 = tmem_instance_1;
            let _e199 = index_10;
            let _e209 = tmem8_.raw[((u32(_e195) * 1024u) + (u32((_e199.y ^ 1u)) / 2u))];
            let _e210 = index_10;
            samp1_ = i32(((_e209 >> ((u32((_e210.y ^ 1u)) & 1u) * 16u)) & 65535u));
            let _e224 = tile_7;
            if (_e224.size == 1i) {
                {
                    let _e228 = samp0_;
                    let _e231 = nibble_offset;
                    samp0_ = (_e228 >> u32((8i - (4i * i32((_e231.x & 2u))))));
                    let _e240 = samp1_;
                    let _e243 = nibble_offset;
                    samp1_ = (_e240 >> u32((8i - (4i * i32((_e243.y & 2u))))));
                    let _e252 = samp0_;
                    samp0_ = (_e252 & 255i);
                    let _e255 = samp1_;
                    samp1_ = (_e255 & 255i);
                }
            } else {
                {
                    let _e258 = tile_7;
                    if (_e258.size == 0i) {
                        {
                            let _e262 = samp0_;
                            let _e265 = nibble_offset;
                            samp0_ = (_e262 >> u32((12i - (4i * i32((_e265.x & 3u))))));
                            let _e274 = samp1_;
                            let _e277 = nibble_offset;
                            samp1_ = (_e274 >> u32((12i - (4i * i32((_e277.y & 3u))))));
                            let _e286 = samp0_;
                            samp0_ = ((_e286 & 15i) * 17i);
                            let _e291 = samp1_;
                            samp1_ = ((_e291 & 15i) * 17i);
                        }
                    } else {
                        {
                            let _e296 = samp0_;
                            samp0_ = (_e296 >> 8u);
                            let _e300 = samp1_;
                            samp1_ = (_e300 >> 8u);
                        }
                    }
                }
            }
            let _e304 = samp0_;
            let _e308 = samp1_;
            samp = ((_e304 << 8u) | _e308);
        }
    } else {
        {
            let _e311 = (*st_1);
            let _e313 = s_offset_2;
            (*st_1).x = (_e311.x + _e313);
            let _e315 = tile_7;
            param_4_ = _e315;
            let _e317 = (*st_1);
            param_5_ = _e317.x;
            let _e320 = param_4_;
            let _e323 = texel_mask_s(_e320, (&param_5_));
            _2686_ = _e323;
            let _e325 = _2686_;
            s_1_ = _e325;
            let _e327 = tile_7;
            param_6_ = _e327;
            let _e329 = (*st_1);
            param_7_ = _e329.y;
            let _e332 = param_6_;
            let _e335 = texel_mask_t(_e332, (&param_7_));
            _2693_ = _e335;
            let _e337 = _2693_;
            t_1_ = _e337;
            let _e339 = tile_7;
            let _e341 = tile_7;
            let _e343 = t_1_;
            tbase_1_ = (_e339.offset + (_e341.stride * u32(_e343)));
            let _e348 = tbase_1_;
            let _e351 = s_1_;
            let _e352 = s_shamt;
            nibble_offset_1_ = (((_e348 * 2u) + u32((_e351 << u32(_e352)))) & 8191u);
            let _e360 = nibble_offset_1_;
            let _e361 = t_1_;
            nibble_offset_1_ = (_e360 ^ ((u32(_e361) & 1u) * 8u));
            let _e368 = nibble_offset_1_;
            index_1_ = (_e368 >> 2u);
            let _e372 = index_1_;
            let _e373 = idx_mask;
            index_1_ = (_e372 & u32(_e373));
            let _e376 = tmem_instance_1;
            let _e380 = index_1_;
            let _e389 = tmem8_.raw[((u32(_e376) * 1024u) + (u32((_e380 ^ 1u)) / 2u))];
            let _e390 = index_1_;
            samp = i32(((_e389 >> ((u32((_e390 ^ 1u)) & 1u) * 16u)) & 65535u));
            let _e402 = tlut_1;
            if _e402 {
                {
                    let _e403 = tile_7;
                    if (_e403.size == 0i) {
                        {
                            let _e407 = samp;
                            let _e410 = nibble_offset_1_;
                            samp = (_e407 >> u32(i32((12u - (4u * (_e410 & 3u))))));
                            let _e418 = samp;
                            samp = (_e418 & 15i);
                            let _e421 = samp;
                            let _e422 = tile_7;
                            samp = (_e421 | (_e422.palette << 4u));
                            let _e428 = samp;
                            samp = (_e428 << 2u);
                            let _e432 = samp;
                            let _e433 = s_offset_2;
                            samp = (_e432 + _e433);
                        }
                    } else {
                        {
                            let _e435 = samp;
                            let _e438 = nibble_offset_1_;
                            samp = (_e435 >> u32(i32((8u - (4u * (_e438 & 2u))))));
                            let _e446 = samp;
                            samp = (_e446 & 255i);
                            let _e449 = samp;
                            samp = (_e449 << 2u);
                            let _e453 = samp;
                            let _e454 = s_offset_2;
                            samp = (_e453 + _e454);
                        }
                    }
                    let _e456 = tmem_instance_1;
                    let _e460 = samp;
                    let _e471 = tmem8_.raw[((u32(_e456) * 1024u) + (u32(((_e460 | 1024i) ^ 1i)) / 2u))];
                    let _e472 = samp;
                    samp = i32(((_e471 >> ((u32(((_e472 | 1024i) ^ 1i)) & 1u) * 16u)) & 65535u));
                }
            }
        }
    }
    let _e486 = samp;
    return _e486;
}

fn sample_texture_copy(tile_8: TileInfo, tmem_instance_2: u32, st_2: ptr<function, vec2<i32>>, s_offset_3: i32, tlut_2: bool, tlut_type_2: bool) -> i32 {
    var tile_9: TileInfo;
    var tmem_instance_3: u32;
    var s_offset_4: i32;
    var tlut_3: bool;
    var tlut_type_3: bool;
    var param_3: i32;
    var param_1_2: i32;
    var param_2_2: i32;
    var _2795_: i32;
    var param_3_1: i32;
    var param_4_1: i32;
    var param_5_1: i32;
    var _2807_: i32;
    var samp_1: i32;
    var param_6_1: TileInfo;
    var param_7_1: u32;
    var param_8_: vec2<i32>;
    var param_9_: i32;
    var param_10_: bool;
    var param_11_: bool;
    var _2837_: i32;
    var param_12_: TileInfo;
    var param_13_: u32;
    var param_14_: vec2<i32>;
    var param_15_: i32;
    var param_16_: bool;
    var param_17_: bool;
    var _2859_: i32;

    tile_9 = tile_8;
    tmem_instance_3 = tmem_instance_2;
    s_offset_4 = s_offset_3;
    tlut_3 = tlut_2;
    tlut_type_3 = tlut_type_2;
    let _e59 = (*st_2);
    param_3 = _e59.x;
    let _e62 = tile_9;
    param_1_2 = i32(_e62.slo);
    let _e66 = tile_9;
    param_2_2 = _e66.shift_s;
    let _e70 = param_1_2;
    let _e71 = param_2_2;
    let _e73 = shift_coord((&param_3), _e70, _e71);
    _2795_ = _e73;
    let _e76 = _2795_;
    (*st_2).x = _e76;
    let _e77 = (*st_2);
    param_3_1 = _e77.y;
    let _e80 = tile_9;
    param_4_1 = i32(_e80.tlo);
    let _e84 = tile_9;
    param_5_1 = _e84.shift_t;
    let _e88 = param_4_1;
    let _e89 = param_5_1;
    let _e91 = shift_coord((&param_3_1), _e88, _e89);
    _2807_ = _e91;
    let _e94 = _2807_;
    (*st_2).y = _e94;
    let _e95 = (*st_2);
    (*st_2) = (_e95 >> vec2(5u));
    let _e102 = global_constants;
    if (_e102.fb_info.fb_size == 0i) {
        {
            samp_1 = 0i;
        }
    } else {
        {
            let _e108 = global_constants;
            if (_e108.fb_info.fb_size == 1i) {
                {
                    let _e113 = tile_9;
                    param_6_1 = _e113;
                    let _e115 = tmem_instance_3;
                    param_7_1 = _e115;
                    let _e117 = (*st_2);
                    param_8_ = _e117;
                    let _e119 = s_offset_4;
                    param_9_ = (_e119 >> 1u);
                    let _e124 = tlut_3;
                    param_10_ = _e124;
                    let _e126 = tlut_type_3;
                    param_11_ = _e126;
                    let _e128 = param_6_1;
                    let _e129 = param_7_1;
                    let _e131 = param_9_;
                    let _e132 = param_10_;
                    let _e133 = param_11_;
                    let _e135 = sample_texture_copy_word(_e128, _e129, (&param_8_), _e131, _e132, _e133);
                    _2837_ = _e135;
                    let _e137 = _2837_;
                    samp_1 = _e137;
                    let _e138 = samp_1;
                    let _e141 = s_offset_4;
                    samp_1 = (_e138 >> u32((8i - (8i * (_e141 & 1i)))));
                    let _e148 = samp_1;
                    samp_1 = (_e148 & 255i);
                }
            } else {
                {
                    let _e151 = tile_9;
                    param_12_ = _e151;
                    let _e153 = tmem_instance_3;
                    param_13_ = _e153;
                    let _e155 = (*st_2);
                    param_14_ = _e155;
                    let _e157 = s_offset_4;
                    param_15_ = _e157;
                    let _e159 = tlut_3;
                    param_16_ = _e159;
                    let _e161 = tlut_type_3;
                    param_17_ = _e161;
                    let _e163 = param_12_;
                    let _e164 = param_13_;
                    let _e166 = param_15_;
                    let _e167 = param_16_;
                    let _e168 = param_17_;
                    let _e170 = sample_texture_copy_word(_e163, _e164, (&param_14_), _e166, _e167, _e168);
                    _2859_ = _e170;
                    let _e172 = _2859_;
                    samp_1 = _e172;
                }
            }
        }
    }
    let _e173 = samp_1;
    return _e173;
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
    let _e59 = x_5;
    xshift = (vec4<i32>(0i, 4i, 2i, 6i) + vec4((_e59 << 3u)));
    let _e66 = xshift;
    let _e67 = xleft_1;
    clip_lo_x01_ = (_e66 < _e67.xxyy);
    let _e71 = xshift;
    let _e72 = xleft_1;
    clip_lo_x23_ = (_e71 < _e72.zzww);
    let _e76 = xshift;
    let _e77 = xright_1;
    clip_hi_x01_ = (_e76 >= _e77.xxyy);
    let _e81 = xshift;
    let _e82 = xright_1;
    clip_hi_x23_ = (_e81 >= _e82.zzww);
    let _e86 = clip_lo_x01_;
    let _e92 = clip_hi_x01_;
    clip_x0_ = (select(vec4(0i), vec4(1i), _e86) | select(vec4(0i), vec4(1i), _e92));
    let _e100 = clip_lo_x23_;
    let _e106 = clip_hi_x23_;
    clip_x1_ = (select(vec4(0i), vec4(1i), _e100) | select(vec4(0i), vec4(1i), _e106));
    let _e114 = clip_x0_;
    let _e121 = clip_x1_;
    clip_x = ((_e114 * vec4<i32>(1i, 2i, 4i, 8i)) + (_e121 * vec4<i32>(16i, 32i, 64i, 128i)));
    let _e130 = clip_x;
    let _e132 = clip_x;
    let _e135 = clip_x;
    let _e137 = clip_x;
    clip_coverage = ((_e130.x | _e132.y) | (_e135.z | _e137.w));
    let _e142 = clip_coverage;
    return (~(_e142) & 255i);
}

fn load_derived_setup(index_11: u32) -> DerivedSetup {
    var index_12: u32;

    index_12 = index_11;
    let _e50 = index_12;
    let _e57 = derived_setup.derived_setup_raw[((_e50 * 14u) + 0u)];
    let _e60 = index_12;
    let _e67 = derived_setup.derived_setup_raw[((_e60 * 14u) + 0u)];
    let _e72 = index_12;
    let _e79 = derived_setup.derived_setup_raw[((_e72 * 14u) + 0u)];
    let _e84 = index_12;
    let _e91 = derived_setup.derived_setup_raw[((_e84 * 14u) + 0u)];
    let _e96 = index_12;
    let _e103 = derived_setup.derived_setup_raw[((_e96 * 14u) + 1u)];
    let _e106 = index_12;
    let _e113 = derived_setup.derived_setup_raw[((_e106 * 14u) + 1u)];
    let _e118 = index_12;
    let _e125 = derived_setup.derived_setup_raw[((_e118 * 14u) + 1u)];
    let _e130 = index_12;
    let _e137 = derived_setup.derived_setup_raw[((_e130 * 14u) + 1u)];
    let _e142 = index_12;
    let _e149 = derived_setup.derived_setup_raw[((_e142 * 14u) + 2u)];
    let _e152 = index_12;
    let _e159 = derived_setup.derived_setup_raw[((_e152 * 14u) + 2u)];
    let _e164 = index_12;
    let _e171 = derived_setup.derived_setup_raw[((_e164 * 14u) + 2u)];
    let _e176 = index_12;
    let _e183 = derived_setup.derived_setup_raw[((_e176 * 14u) + 2u)];
    let _e188 = index_12;
    let _e195 = derived_setup.derived_setup_raw[((_e188 * 14u) + 3u)];
    let _e198 = index_12;
    let _e205 = derived_setup.derived_setup_raw[((_e198 * 14u) + 3u)];
    let _e210 = index_12;
    let _e217 = derived_setup.derived_setup_raw[((_e210 * 14u) + 3u)];
    let _e222 = index_12;
    let _e229 = derived_setup.derived_setup_raw[((_e222 * 14u) + 3u)];
    let _e234 = index_12;
    let _e241 = derived_setup.derived_setup_raw[((_e234 * 14u) + 4u)];
    let _e244 = index_12;
    let _e251 = derived_setup.derived_setup_raw[((_e244 * 14u) + 4u)];
    let _e256 = index_12;
    let _e263 = derived_setup.derived_setup_raw[((_e256 * 14u) + 4u)];
    let _e268 = index_12;
    let _e275 = derived_setup.derived_setup_raw[((_e268 * 14u) + 4u)];
    let _e280 = index_12;
    let _e287 = derived_setup.derived_setup_raw[((_e280 * 14u) + 5u)];
    let _e290 = index_12;
    let _e297 = derived_setup.derived_setup_raw[((_e290 * 14u) + 5u)];
    let _e302 = index_12;
    let _e309 = derived_setup.derived_setup_raw[((_e302 * 14u) + 5u)];
    let _e314 = index_12;
    let _e321 = derived_setup.derived_setup_raw[((_e314 * 14u) + 5u)];
    let _e326 = index_12;
    let _e333 = derived_setup.derived_setup_raw[((_e326 * 14u) + 6u)];
    let _e336 = index_12;
    let _e343 = derived_setup.derived_setup_raw[((_e336 * 14u) + 6u)];
    let _e348 = index_12;
    let _e355 = derived_setup.derived_setup_raw[((_e348 * 14u) + 6u)];
    let _e360 = index_12;
    let _e367 = derived_setup.derived_setup_raw[((_e360 * 14u) + 6u)];
    let _e372 = index_12;
    let _e379 = derived_setup.derived_setup_raw[((_e372 * 14u) + 7u)];
    let _e382 = index_12;
    let _e389 = derived_setup.derived_setup_raw[((_e382 * 14u) + 7u)];
    let _e394 = index_12;
    let _e401 = derived_setup.derived_setup_raw[((_e394 * 14u) + 7u)];
    let _e406 = index_12;
    let _e413 = derived_setup.derived_setup_raw[((_e406 * 14u) + 7u)];
    let _e418 = index_12;
    let _e425 = derived_setup.derived_setup_raw[((_e418 * 14u) + 8u)];
    let _e428 = index_12;
    let _e435 = derived_setup.derived_setup_raw[((_e428 * 14u) + 8u)];
    let _e440 = index_12;
    let _e447 = derived_setup.derived_setup_raw[((_e440 * 14u) + 8u)];
    let _e452 = index_12;
    let _e459 = derived_setup.derived_setup_raw[((_e452 * 14u) + 8u)];
    let _e464 = index_12;
    let _e471 = derived_setup.derived_setup_raw[((_e464 * 14u) + 9u)];
    let _e474 = index_12;
    let _e481 = derived_setup.derived_setup_raw[((_e474 * 14u) + 9u)];
    let _e486 = index_12;
    let _e493 = derived_setup.derived_setup_raw[((_e486 * 14u) + 9u)];
    let _e498 = index_12;
    let _e505 = derived_setup.derived_setup_raw[((_e498 * 14u) + 9u)];
    let _e510 = index_12;
    let _e517 = derived_setup.derived_setup_raw[((_e510 * 14u) + 10u)];
    let _e518 = index_12;
    let _e525 = derived_setup.derived_setup_raw[((_e518 * 14u) + 11u)];
    let _e529 = index_12;
    let _e536 = derived_setup.derived_setup_raw[((_e529 * 14u) + 11u)];
    let _e542 = index_12;
    let _e549 = derived_setup.derived_setup_raw[((_e542 * 14u) + 11u)];
    let _e555 = index_12;
    let _e562 = derived_setup.derived_setup_raw[((_e555 * 14u) + 12u)];
    let _e570 = index_12;
    let _e577 = derived_setup.derived_setup_raw[((_e570 * 14u) + 12u)];
    let _e582 = index_12;
    let _e591 = derived_setup.derived_setup_raw[(((_e582 * 14u) + 12u) + 1u)];
    let _e599 = index_12;
    let _e608 = derived_setup.derived_setup_raw[(((_e599 * 14u) + 12u) + 1u)];
    return DerivedSetup(vec4<i32>(vec4<u32>((_e57 & 255u), ((_e67 >> 8u) & 255u), ((_e79 >> 16u) & 255u), (_e91 >> 24u))), vec4<i32>(vec4<u32>((_e103 & 255u), ((_e113 >> 8u) & 255u), ((_e125 >> 16u) & 255u), (_e137 >> 24u))), vec4<i32>(vec4<u32>((_e149 & 255u), ((_e159 >> 8u) & 255u), ((_e171 >> 16u) & 255u), (_e183 >> 24u))), vec4<i32>(vec4<u32>((_e195 & 255u), ((_e205 >> 8u) & 255u), ((_e217 >> 16u) & 255u), (_e229 >> 24u))), vec4<i32>(vec4<u32>((_e241 & 255u), ((_e251 >> 8u) & 255u), ((_e263 >> 16u) & 255u), (_e275 >> 24u))), vec4<i32>(vec4<u32>((_e287 & 255u), ((_e297 >> 8u) & 255u), ((_e309 >> 16u) & 255u), (_e321 >> 24u))), vec4<i32>(vec4<u32>((_e333 & 255u), ((_e343 >> 8u) & 255u), ((_e355 >> 16u) & 255u), (_e367 >> 24u))), vec4<i32>(vec4<u32>((_e379 & 255u), ((_e389 >> 8u) & 255u), ((_e401 >> 16u) & 255u), (_e413 >> 24u))), vec4<i32>(vec4<u32>((_e425 & 255u), ((_e435 >> 8u) & 255u), ((_e447 >> 16u) & 255u), (_e459 >> 24u))), vec4<i32>(vec4<u32>((_e471 & 255u), ((_e481 >> 8u) & 255u), ((_e493 >> 16u) & 255u), (_e505 >> 24u))), _e517, i32((_e525 & 65535u)), i32(((_e536 >> 16u) & 255u)), i32(((_e549 >> 24u) & 255u)), vec4<i32>(((i32(_e562) << 16u) >> 16u), (i32(_e577) >> 16u), ((i32(_e591) << 16u) >> 16u), (i32(_e608) >> 16u)));
}

fn clamp_9bit_notrunc(color_1_: ptr<function, vec4<i32>>) -> vec4<i32> {
    let _e49 = (*color_1_);
    (*color_1_) = (_e49 - vec4(128i));
    let _e53 = (*color_1_);
    (*color_1_) = extractBits(_e53, 0u, 9u);
    let _e59 = (*color_1_);
    (*color_1_) = (_e59 + vec4(128i));
    let _e63 = (*color_1_);
    return vec4<i32>(clamp(_e63, vec4(0i), vec4(255i)));
}

fn clamp_9bit(color_1_1: vec4<i32>) -> vec4<i32> {
    var color_1_2: vec4<i32>;
    var param_4: vec4<i32>;
    var _849_: vec4<i32>;

    color_1_2 = color_1_1;
    let _e50 = color_1_2;
    param_4 = _e50;
    let _e54 = clamp_9bit_notrunc((&param_4));
    _849_ = _e54;
    let _e56 = _849_;
    return vec4<i32>(_e56);
}

fn interpolate_rgba(rgba: ptr<function, vec4<i32>>, drgba_dx: vec4<i32>, drgba_dy: vec4<i32>, dx_1: i32, coverage_1_: i32) -> vec4<i32> {
    var drgba_dx_1: vec4<i32>;
    var drgba_dy_1: vec4<i32>;
    var dx_2: i32;
    var coverage_1_1: i32;
    var snapped_rgba: vec4<i32>;
    var first_coverage: i32;
    var yoff: i32;
    var xoff: i32;
    var param_5: vec4<i32>;

    drgba_dx_1 = drgba_dx;
    drgba_dy_1 = drgba_dy;
    dx_2 = dx_1;
    coverage_1_1 = coverage_1_;
    let _e57 = (*rgba);
    let _e58 = drgba_dx_1;
    let _e68 = dx_2;
    (*rgba) = (_e57 + (((_e58 & vec4(-32i)) >> vec4(0u)) * vec4(_e68)));
    let _e72 = (*rgba);
    snapped_rgba = vec4<i32>((_e72 >> vec4(14u)));
    let _e80 = coverage_1_1;
    first_coverage = firstTrailingBit(_e80);
    let _e83 = first_coverage;
    yoff = (_e83 >> 1u);
    let _e88 = first_coverage;
    let _e94 = yoff;
    xoff = (((_e88 & 1i) << 1u) + (_e94 & 1i));
    let _e99 = snapped_rgba;
    snapped_rgba = (_e99 << vec4(2u));
    let _e105 = snapped_rgba;
    let _e106 = xoff;
    let _e108 = drgba_dx_1;
    let _e116 = yoff;
    let _e118 = drgba_dy_1;
    snapped_rgba = (_e105 + ((vec4(_e106) * vec4<i32>((_e108 >> vec4(14u)))) + (vec4(_e116) * vec4<i32>((_e118 >> vec4(14u))))));
    let _e128 = snapped_rgba;
    snapped_rgba = (_e128 >> vec4(4u));
    let _e134 = snapped_rgba;
    param_5 = _e134;
    let _e136 = param_5;
    let _e137 = clamp_9bit(_e136);
    return _e137;
}

fn clamp_z(z: ptr<function, i32>) -> i32 {
    let _e49 = (*z);
    (*z) = (_e49 - 131072i);
    let _e52 = (*z);
    (*z) = (_e52 << 13u);
    let _e56 = (*z);
    (*z) = (_e56 >> 13u);
    let _e60 = (*z);
    (*z) = (_e60 + 131072i);
    let _e63 = (*z);
    return clamp(_e63, 0i, 262143i);
}

fn interpolate_stz(stzw: vec4<i32>, dstzw_dx_2: vec4<i32>, dstzw_dy: vec4<i32>, dx_3: i32, coverage_1_2: i32, perspective_2: bool, uses_lod: bool, flip_direction: i32, st_3: ptr<function, vec2<i32>>, st_dx: ptr<function, vec2<i32>>, st_dy: ptr<function, vec2<i32>>, z_1: ptr<function, i32>, st_overflow_1: ptr<function, bool>) {
    var stzw_1: vec4<i32>;
    var dstzw_dx_3: vec4<i32>;
    var dstzw_dy_1: vec4<i32>;
    var dx_4: i32;
    var coverage_1_3: i32;
    var perspective_3: bool;
    var uses_lod_1: bool;
    var flip_direction_1: i32;
    var stw_5: vec3<i32>;
    var stw_dx: vec3<i32>;
    var stw_dy: vec3<i32>;
    var param_6: vec3<i32>;
    var param_1_3: bool;
    var _1465_: vec2<i32>;
    var param_2_3: vec3<i32>;
    var param_3_2: bool;
    var _1476_: vec2<i32>;
    var param_4_2: vec3<i32>;
    var param_5_2: bool;
    var _1484_: vec2<i32>;
    var param_6_2: vec3<i32>;
    var param_7_2: vec3<i32>;
    var param_8_1: vec3<i32>;
    var snapped_z: i32;
    var first_coverage_1: i32;
    var yoff_1: i32;
    var xoff_1: i32;
    var param_9_1: i32;
    var _1558_: i32;

    stzw_1 = stzw;
    dstzw_dx_3 = dstzw_dx_2;
    dstzw_dy_1 = dstzw_dy;
    dx_4 = dx_3;
    coverage_1_3 = coverage_1_2;
    perspective_3 = perspective_2;
    uses_lod_1 = uses_lod;
    flip_direction_1 = flip_direction;
    let _e69 = stzw_1;
    let _e71 = dstzw_dx_3;
    let _e82 = dx_4;
    stw_5 = (_e69.xyw + (((_e71.xyw & vec3(-32i)) >> vec3(0u)) * vec3(_e82)));
    let _e89 = uses_lod_1;
    if _e89 {
        {
            let _e90 = stw_5;
            let _e91 = flip_direction_1;
            let _e93 = dstzw_dx_3;
            stw_dx = (_e90 + (vec3(_e91) * ((_e93.xyw & vec3(-32i)) >> vec3(0u))));
            let _e106 = stw_5;
            let _e107 = dstzw_dy_1;
            stw_dy = (_e106 + ((_e107.xyw & vec3(-32768i)) >> vec3(0u)));
        }
    }
    let _e119 = perspective_3;
    if _e119 {
        {
            let _e120 = stw_5;
            param_6 = (_e120 >> vec3(16u));
            let _e127 = (*st_overflow_1);
            param_1_3 = _e127;
            let _e129 = param_6;
            let _e132 = perspective_divide(_e129, (&param_1_3));
            _1465_ = _e132;
            let _e134 = param_1_3;
            (*st_overflow_1) = _e134;
            let _e135 = _1465_;
            (*st_3) = _e135;
            let _e136 = uses_lod_1;
            if _e136 {
                {
                    let _e137 = stw_dx;
                    param_2_3 = (_e137 >> vec3(16u));
                    let _e144 = (*st_overflow_1);
                    param_3_2 = _e144;
                    let _e146 = param_2_3;
                    let _e149 = perspective_divide(_e146, (&param_3_2));
                    _1476_ = _e149;
                    let _e151 = param_3_2;
                    (*st_overflow_1) = _e151;
                    let _e152 = _1476_;
                    (*st_dx) = _e152;
                    let _e153 = stw_dy;
                    param_4_2 = (_e153 >> vec3(16u));
                    let _e160 = (*st_overflow_1);
                    param_5_2 = _e160;
                    let _e162 = param_4_2;
                    let _e165 = perspective_divide(_e162, (&param_5_2));
                    _1484_ = _e165;
                    let _e167 = param_5_2;
                    (*st_overflow_1) = _e167;
                    let _e168 = _1484_;
                    (*st_dy) = _e168;
                }
            }
        }
    } else {
        {
            let _e169 = stw_5;
            param_6_2 = (_e169 >> vec3(16u));
            let _e176 = param_6_2;
            let _e177 = no_perspective_divide(_e176);
            (*st_3) = _e177;
            let _e178 = uses_lod_1;
            if _e178 {
                {
                    let _e179 = stw_dx;
                    param_7_2 = (_e179 >> vec3(16u));
                    let _e186 = param_7_2;
                    let _e187 = no_perspective_divide(_e186);
                    (*st_dx) = _e187;
                    let _e188 = stw_dy;
                    param_8_1 = (_e188 >> vec3(16u));
                    let _e195 = param_8_1;
                    let _e196 = no_perspective_divide(_e195);
                    (*st_dy) = _e196;
                }
            }
        }
    }
    let _e197 = stzw_1;
    let _e199 = dstzw_dx_3;
    let _e201 = dx_4;
    let _e207 = dstzw_dx_3;
    let _e212 = dx_4;
    (*z_1) = ((_e197.z + (_e199.z * (_e201 >> 0u))) + ((_e207.z >> 0u) * (_e212 & 0i)));
    let _e217 = (*z_1);
    snapped_z = (_e217 >> 10u);
    let _e222 = coverage_1_3;
    first_coverage_1 = firstTrailingBit(_e222);
    let _e225 = first_coverage_1;
    yoff_1 = (_e225 >> 1u);
    let _e230 = first_coverage_1;
    let _e236 = yoff_1;
    xoff_1 = (((_e230 & 1i) << 1u) + (_e236 & 1i));
    let _e241 = snapped_z;
    snapped_z = (_e241 << 2u);
    let _e245 = snapped_z;
    let _e246 = xoff_1;
    let _e247 = dstzw_dx_3;
    let _e253 = yoff_1;
    let _e254 = dstzw_dy_1;
    snapped_z = (_e245 + ((_e246 * (_e247.z >> 10u)) + (_e253 * (_e254.z >> 10u))));
    let _e262 = snapped_z;
    snapped_z = (_e262 >> 5u);
    let _e266 = snapped_z;
    param_9_1 = _e266;
    let _e270 = clamp_z((&param_9_1));
    _1558_ = _e270;
    let _e272 = _1558_;
    (*z_1) = _e272;
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
    var _4706_: bool;
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
    let _e75 = perspective_overflow_1;
    if _e75 {
        {
            distant = true;
            (*lod_frac) = 255i;
        }
    } else {
        {
            let _e78 = st_dx_2;
            let _e79 = st_5;
            dx_5 = (_e78 - _e79);
            let _e82 = dx_5;
            let _e83 = dx_5;
            dx_5 = (_e82 ^ (_e83 >> vec2(31u)));
            let _e90 = st_dy_2;
            let _e91 = st_5;
            dy = (_e90 - _e91);
            let _e94 = dy;
            let _e95 = dy;
            dy = (_e94 ^ (_e95 >> vec2(31u)));
            let _e102 = dx_5;
            let _e103 = dy;
            max_d2_ = max(_e102, _e103);
            let _e106 = max_d2_;
            let _e108 = max_d2_;
            max_d = max(_e106.x, _e108.y);
            let _e112 = max_d;
            if (_e112 >= 16384i) {
                {
                    distant = true;
                    (*lod_frac) = 255i;
                    let _e117 = max_level_1;
                    tile_offset = _e117;
                }
            } else {
                {
                    let _e118 = max_d;
                    if (_e118 < 32i) {
                        {
                            let _e121 = max_level_1;
                            distant = (_e121 == 0u);
                            magnify = true;
                            let _e125 = sharpen_tex_en_1;
                            let _e127 = detail_tex_en_1;
                            if (!(_e125) && !(_e127)) {
                                {
                                    let _e130 = distant;
                                    if _e130 {
                                        local_3 = 255i;
                                    } else {
                                        local_3 = 0i;
                                    }
                                    let _e134 = local_3;
                                    (*lod_frac) = _e134;
                                }
                            } else {
                                {
                                    let _e135 = min_lod_1;
                                    let _e136 = max_d;
                                    let _e141 = sharpen_tex_en_1;
                                    if _e141 {
                                        local_4 = -256i;
                                    } else {
                                        local_4 = 0i;
                                    }
                                    let _e146 = local_4;
                                    (*lod_frac) = ((max(_e135, _e136) << 3u) + _e146);
                                }
                            }
                        }
                    } else {
                        {
                            let _e148 = max_d;
                            mip_base = max(firstLeadingBit((_e148 >> 5u)), 0i);
                            let _e156 = mip_base;
                            let _e158 = max_level_1;
                            distant = (u32(_e156) >= _e158);
                            let _e160 = distant;
                            let _e161 = sharpen_tex_en_1;
                            let _e164 = detail_tex_en_1;
                            if ((_e160 && !(_e161)) && !(_e164)) {
                                {
                                    (*lod_frac) = 255i;
                                }
                            } else {
                                {
                                    let _e168 = max_d;
                                    let _e172 = mip_base;
                                    (*lod_frac) = (((_e168 << 3u) >> u32(_e172)) & 255i);
                                    let _e177 = mip_base;
                                    tile_offset = u32(_e177);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    let _e179 = tex_lod_en_1;
    if _e179 {
        {
            let _e180 = distant;
            if _e180 {
                {
                    let _e181 = max_level_1;
                    tile_offset = _e181;
                }
            }
            let _e182 = detail_tex_en_1;
            if !(_e182) {
                {
                    let _e184 = (*tile0_);
                    let _e185 = tile_offset;
                    (*tile0_) = ((_e184 + _e185) & 7u);
                    let _e190 = distant;
                    if !(_e190) {
                        {
                            let _e192 = sharpen_tex_en_1;
                            let _e194 = magnify;
                            _4706_ = (!(_e192) && _e194);
                        }
                    } else {
                        {
                            let _e196 = distant;
                            _4706_ = _e196;
                        }
                    }
                    let _e197 = _4706_;
                    if _e197 {
                        {
                            let _e198 = (*tile0_);
                            (*tile1_) = _e198;
                            return;
                        }
                    } else {
                        {
                            let _e199 = (*tile0_);
                            (*tile1_) = ((_e199 + 1u) & 7u);
                            return;
                        }
                    }
                }
            } else {
                {
                    let _e204 = (*tile0_);
                    let _e205 = tile_offset;
                    let _e207 = distant;
                    let _e208 = magnify;
                    if (_e207 || _e208) {
                        local_5 = 1i;
                    } else {
                        local_5 = 2i;
                    }
                    let _e213 = local_5;
                    (*tile1_) = (((_e204 + _e205) + u32(_e213)) & 7u);
                    let _e218 = (*tile0_);
                    let _e219 = tile_offset;
                    let _e221 = magnify;
                    if _e221 {
                        local_6 = 0i;
                    } else {
                        local_6 = 1i;
                    }
                    let _e225 = local_6;
                    (*tile0_) = (((_e218 + _e219) + u32(_e225)) & 7u);
                    return;
                }
            }
        }
    } else {
        return;
    }
}

fn clamp_and_shift_coord(clamp_bit: bool, coord_1: ptr<function, i32>, lo_2: i32, hi: i32, shift_4: i32) -> i32 {
    var clamp_bit_1: bool;
    var lo_3: i32;
    var hi_1: i32;
    var shift_5: i32;
    var clamp_hi: bool;

    clamp_bit_1 = clamp_bit;
    lo_3 = lo_2;
    hi_1 = hi;
    shift_5 = shift_4;
    let _e57 = (*coord_1);
    (*coord_1) = clamp(_e57, -32768i, 32767i);
    let _e62 = shift_5;
    if (_e62 < 11i) {
        {
            let _e65 = (*coord_1);
            let _e66 = shift_5;
            (*coord_1) = (_e65 >> u32(_e66));
        }
    } else {
        {
            let _e69 = (*coord_1);
            let _e71 = shift_5;
            (*coord_1) = (_e69 << u32((32i - _e71)));
            let _e75 = (*coord_1);
            (*coord_1) = (_e75 >> 16u);
        }
    }
    let _e79 = clamp_bit_1;
    if _e79 {
        {
            let _e80 = (*coord_1);
            let _e84 = hi_1;
            clamp_hi = ((_e80 >> 3u) >= _e84);
            let _e87 = clamp_hi;
            if _e87 {
                {
                    let _e88 = hi_1;
                    let _e92 = lo_3;
                    (*coord_1) = ((((_e88 >> 2u) - (_e92 >> 2u)) & 1023i) << 5u);
                }
            } else {
                {
                    let _e102 = (*coord_1);
                    let _e103 = lo_3;
                    (*coord_1) = max((_e102 - (_e103 << 3u)), 0i);
                }
            }
        }
    } else {
        {
            let _e110 = (*coord_1);
            let _e111 = lo_3;
            (*coord_1) = (_e110 - (_e111 << 3u));
        }
    }
    let _e116 = (*coord_1);
    return _e116;
}

fn sample_texel_rgba8_(tile_10: TileInfo, tmem_instance_4: u32, st_6: vec2<u32>) -> vec4<i32> {
    var tile_11: TileInfo;
    var tmem_instance_5: u32;
    var st_7: vec2<u32>;
    var byte_offset: u32;
    var index_13: u32;
    var word: u32;

    tile_11 = tile_10;
    tmem_instance_5 = tmem_instance_4;
    st_7 = st_6;
    let _e54 = tile_11;
    let _e56 = tile_11;
    let _e58 = st_7;
    byte_offset = (_e54.offset + (_e56.stride * _e58.y));
    let _e63 = byte_offset;
    let _e64 = st_7;
    byte_offset = (_e63 + _e64.x);
    let _e67 = byte_offset;
    byte_offset = (_e67 & 4095u);
    let _e70 = byte_offset;
    index_13 = _e70;
    let _e72 = index_13;
    let _e73 = st_7;
    index_13 = (_e72 ^ ((_e73.y & 1u) << 2u));
    let _e81 = index_13;
    index_13 = (_e81 ^ 3u);
    let _e84 = tmem_instance_5;
    let _e88 = index_13;
    let _e95 = tmem8_.raw[((u32(_e84) * 1024u) + (u32(_e88) / 4u))];
    let _e96 = index_13;
    word = ((_e95 >> ((u32(_e96) % 4u) * 8u)) & 255u);
    let _e106 = word;
    return vec4(i32(_e106));
}

fn sample_texel_rgba4_(tile_12: TileInfo, tmem_instance_6: u32, st_8: vec2<u32>) -> vec4<i32> {
    var tile_13: TileInfo;
    var tmem_instance_7: u32;
    var st_9: vec2<u32>;
    var byte_offset_1: u32;
    var shift_6: u32;
    var index_14: u32;
    var word_1: u32;

    tile_13 = tile_12;
    tmem_instance_7 = tmem_instance_6;
    st_9 = st_8;
    let _e54 = tile_13;
    let _e56 = tile_13;
    let _e58 = st_9;
    byte_offset_1 = (_e54.offset + (_e56.stride * _e58.y));
    let _e63 = byte_offset_1;
    let _e64 = st_9;
    byte_offset_1 = (_e63 + (_e64.x >> 1u));
    let _e70 = byte_offset_1;
    byte_offset_1 = (_e70 & 4095u);
    let _e73 = st_9;
    shift_6 = ((~(_e73.x) & 1u) * 4u);
    let _e81 = byte_offset_1;
    index_14 = _e81;
    let _e83 = index_14;
    let _e84 = st_9;
    index_14 = (_e83 ^ ((_e84.y & 1u) << 2u));
    let _e92 = index_14;
    index_14 = (_e92 ^ 3u);
    let _e95 = tmem_instance_7;
    let _e99 = index_14;
    let _e106 = tmem8_.raw[((u32(_e95) * 1024u) + (u32(_e99) / 4u))];
    let _e107 = index_14;
    word_1 = ((_e106 >> ((u32(_e107) % 4u) * 8u)) & 255u);
    let _e117 = word_1;
    let _e118 = shift_6;
    word_1 = ((_e117 >> _e118) & 15u);
    let _e122 = word_1;
    let _e123 = word_1;
    word_1 = (_e122 | (_e123 << 4u));
    let _e128 = word_1;
    return vec4(i32(_e128));
}

fn sample_texel_ci32_(tile_14: TileInfo, tmem_instance_8: u32, st_10: vec2<u32>) -> vec4<i32> {
    var tile_15: TileInfo;
    var tmem_instance_9: u32;
    var st_11: vec2<u32>;
    var byte_offset_2: u32;
    var index_15: u32;
    var word_2: u32;

    tile_15 = tile_14;
    tmem_instance_9 = tmem_instance_8;
    st_11 = st_10;
    let _e54 = tile_15;
    let _e56 = tile_15;
    let _e58 = st_11;
    byte_offset_2 = (_e54.offset + (_e56.stride * _e58.y));
    let _e63 = byte_offset_2;
    let _e64 = st_11;
    byte_offset_2 = (_e63 + (_e64.x * 2u));
    let _e69 = byte_offset_2;
    byte_offset_2 = (_e69 & 4095u);
    let _e72 = byte_offset_2;
    index_15 = (_e72 >> 1u);
    let _e77 = index_15;
    let _e78 = st_11;
    index_15 = (_e77 ^ ((_e78.y & 1u) << 1u));
    let _e86 = index_15;
    index_15 = (_e86 ^ 1u);
    let _e89 = tmem_instance_9;
    let _e93 = index_15;
    let _e100 = tmem8_.raw[((u32(_e89) * 1024u) + (u32(_e93) / 2u))];
    let _e101 = index_15;
    word_2 = ((_e100 >> ((u32(_e101) & 1u) * 16u)) & 65535u);
    let _e111 = word_2;
    let _e116 = word_2;
    return vec2<i32>(i32((_e111 >> 8u)), i32((_e116 & 255u))).xyxy;
}

fn convert_ia16_(word_3: u32) -> vec4<i32> {
    var word_4: u32;
    var intensity: u32;
    var alpha: u32;

    word_4 = word_3;
    let _e50 = word_4;
    intensity = (_e50 >> 8u);
    let _e55 = word_4;
    alpha = (_e55 & 255u);
    let _e59 = intensity;
    let _e61 = intensity;
    let _e63 = intensity;
    let _e65 = alpha;
    return vec4<i32>(i32(_e59), i32(_e61), i32(_e63), i32(_e65));
}

fn sample_texel_ia16_(tile_16: TileInfo, tmem_instance_10: u32, st_12: vec2<u32>) -> vec4<i32> {
    var tile_17: TileInfo;
    var tmem_instance_11: u32;
    var st_13: vec2<u32>;
    var byte_offset_3: u32;
    var index_16: u32;
    var word_5: u32;
    var param_7: u32;

    tile_17 = tile_16;
    tmem_instance_11 = tmem_instance_10;
    st_13 = st_12;
    let _e54 = tile_17;
    let _e56 = tile_17;
    let _e58 = st_13;
    byte_offset_3 = (_e54.offset + (_e56.stride * _e58.y));
    let _e63 = byte_offset_3;
    let _e64 = st_13;
    byte_offset_3 = (_e63 + (_e64.x * 2u));
    let _e69 = byte_offset_3;
    byte_offset_3 = (_e69 & 4095u);
    let _e72 = byte_offset_3;
    index_16 = (_e72 >> 1u);
    let _e77 = index_16;
    let _e78 = st_13;
    index_16 = (_e77 ^ ((_e78.y & 1u) << 1u));
    let _e86 = index_16;
    index_16 = (_e86 ^ 1u);
    let _e89 = tmem_instance_11;
    let _e93 = index_16;
    let _e100 = tmem8_.raw[((u32(_e89) * 1024u) + (u32(_e93) / 2u))];
    let _e101 = index_16;
    word_5 = ((_e100 >> ((u32(_e101) & 1u) * 16u)) & 65535u);
    let _e111 = word_5;
    param_7 = _e111;
    let _e113 = param_7;
    let _e114 = convert_ia16_(_e113);
    return _e114;
}

fn sample_texel_ia8_(tile_18: TileInfo, tmem_instance_12: u32, st_14: vec2<u32>) -> vec4<i32> {
    var tile_19: TileInfo;
    var tmem_instance_13: u32;
    var st_15: vec2<u32>;
    var byte_offset_4: u32;
    var index_17: u32;
    var word_6: u32;
    var intensity_1: u32;
    var alpha_1: u32;

    tile_19 = tile_18;
    tmem_instance_13 = tmem_instance_12;
    st_15 = st_14;
    let _e54 = tile_19;
    let _e56 = tile_19;
    let _e58 = st_15;
    byte_offset_4 = (_e54.offset + (_e56.stride * _e58.y));
    let _e63 = byte_offset_4;
    let _e64 = st_15;
    byte_offset_4 = (_e63 + _e64.x);
    let _e67 = byte_offset_4;
    byte_offset_4 = (_e67 & 4095u);
    let _e70 = byte_offset_4;
    index_17 = _e70;
    let _e72 = index_17;
    let _e73 = st_15;
    index_17 = (_e72 ^ ((_e73.y & 1u) << 2u));
    let _e81 = index_17;
    index_17 = (_e81 ^ 3u);
    let _e84 = tmem_instance_13;
    let _e88 = index_17;
    let _e95 = tmem8_.raw[((u32(_e84) * 1024u) + (u32(_e88) / 4u))];
    let _e96 = index_17;
    word_6 = ((_e95 >> ((u32(_e96) % 4u) * 8u)) & 255u);
    let _e106 = word_6;
    intensity_1 = (_e106 >> 4u);
    let _e111 = word_6;
    alpha_1 = (_e111 & 15u);
    let _e115 = alpha_1;
    let _e116 = alpha_1;
    alpha_1 = (_e115 | (_e116 << 4u));
    let _e121 = intensity_1;
    let _e122 = intensity_1;
    intensity_1 = (_e121 | (_e122 << 4u));
    let _e127 = intensity_1;
    let _e129 = intensity_1;
    let _e131 = intensity_1;
    let _e133 = alpha_1;
    return vec4<i32>(i32(_e127), i32(_e129), i32(_e131), i32(_e133));
}

fn sample_texel_ia4_(tile_20: TileInfo, tmem_instance_14: u32, st_16: vec2<u32>) -> vec4<i32> {
    var tile_21: TileInfo;
    var tmem_instance_15: u32;
    var st_17: vec2<u32>;
    var byte_offset_5: u32;
    var shift_7: u32;
    var index_18: u32;
    var word_7: u32;
    var intensity_2: u32;

    tile_21 = tile_20;
    tmem_instance_15 = tmem_instance_14;
    st_17 = st_16;
    let _e54 = tile_21;
    let _e56 = tile_21;
    let _e58 = st_17;
    byte_offset_5 = (_e54.offset + (_e56.stride * _e58.y));
    let _e63 = byte_offset_5;
    let _e64 = st_17;
    byte_offset_5 = (_e63 + (_e64.x >> 1u));
    let _e70 = byte_offset_5;
    byte_offset_5 = (_e70 & 4095u);
    let _e73 = st_17;
    shift_7 = ((~(_e73.x) & 1u) * 4u);
    let _e81 = byte_offset_5;
    index_18 = _e81;
    let _e83 = index_18;
    let _e84 = st_17;
    index_18 = (_e83 ^ ((_e84.y & 1u) << 2u));
    let _e92 = index_18;
    index_18 = (_e92 ^ 3u);
    let _e95 = tmem_instance_15;
    let _e99 = index_18;
    let _e106 = tmem8_.raw[((u32(_e95) * 1024u) + (u32(_e99) / 4u))];
    let _e107 = index_18;
    word_7 = ((_e106 >> ((u32(_e107) % 4u) * 8u)) & 255u);
    let _e117 = word_7;
    let _e118 = shift_7;
    word_7 = ((_e117 >> _e118) & 15u);
    let _e122 = word_7;
    intensity_2 = (_e122 & 14u);
    let _e126 = intensity_2;
    let _e130 = intensity_2;
    let _e135 = intensity_2;
    intensity_2 = (((_e126 << 4u) | (_e130 << 1u)) | (_e135 >> 2u));
    let _e140 = intensity_2;
    let _e142 = intensity_2;
    let _e144 = intensity_2;
    let _e146 = word_7;
    return vec4<i32>(i32(_e140), i32(_e142), i32(_e144), i32(((_e146 & 1u) * 255u)));
}

fn sample_texel_ci4_(tile_22: TileInfo, tmem_instance_16: u32, st_18: vec2<u32>, pal: u32) -> vec4<i32> {
    var tile_23: TileInfo;
    var tmem_instance_17: u32;
    var st_19: vec2<u32>;
    var pal_1: u32;
    var byte_offset_6: u32;
    var shift_8: u32;
    var index_19: u32;
    var word_8: u32;

    tile_23 = tile_22;
    tmem_instance_17 = tmem_instance_16;
    st_19 = st_18;
    pal_1 = pal;
    let _e56 = tile_23;
    let _e58 = tile_23;
    let _e60 = st_19;
    byte_offset_6 = (_e56.offset + (_e58.stride * _e60.y));
    let _e65 = byte_offset_6;
    let _e66 = st_19;
    byte_offset_6 = (_e65 + (_e66.x >> 1u));
    let _e72 = byte_offset_6;
    byte_offset_6 = (_e72 & 4095u);
    let _e75 = st_19;
    shift_8 = ((~(_e75.x) & 1u) * 4u);
    let _e83 = byte_offset_6;
    index_19 = _e83;
    let _e85 = index_19;
    let _e86 = st_19;
    index_19 = (_e85 ^ ((_e86.y & 1u) << 2u));
    let _e94 = index_19;
    index_19 = (_e94 ^ 3u);
    let _e97 = tmem_instance_17;
    let _e101 = index_19;
    let _e108 = tmem8_.raw[((u32(_e97) * 1024u) + (u32(_e101) / 4u))];
    let _e109 = index_19;
    word_8 = ((_e108 >> ((u32(_e109) % 4u) * 8u)) & 255u);
    let _e119 = word_8;
    let _e120 = shift_8;
    word_8 = ((_e119 >> _e120) & 15u);
    let _e124 = word_8;
    let _e125 = pal_1;
    word_8 = (_e124 | (_e125 << 4u));
    let _e130 = word_8;
    return vec4(i32(_e130));
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
    let _e56 = tile_25;
    let _e58 = tile_25;
    let _e60 = st_21;
    byte_offset_7 = (_e56.offset + (_e58.stride * _e60.y));
    let _e65 = byte_offset_7;
    let _e66 = st_21;
    byte_offset_luma = (_e65 + _e66.x);
    let _e70 = byte_offset_luma;
    byte_offset_luma = (_e70 & 2047u);
    let _e73 = byte_offset_7;
    let _e74 = chroma_x_1;
    byte_offset_chroma = (_e73 + (_e74 * 2u));
    let _e79 = byte_offset_chroma;
    byte_offset_chroma = (_e79 & 2047u);
    let _e82 = byte_offset_luma;
    index_luma = _e82;
    let _e84 = index_luma;
    let _e85 = st_21;
    index_luma = (_e84 ^ ((_e85.y & 1u) << 2u));
    let _e93 = index_luma;
    index_luma = (_e93 ^ 3u);
    let _e96 = byte_offset_chroma;
    index_chroma = (_e96 >> 1u);
    let _e101 = index_chroma;
    let _e102 = st_21;
    index_chroma = (_e101 ^ ((_e102.y & 1u) << 1u));
    let _e110 = index_chroma;
    index_chroma = (_e110 ^ 1u);
    let _e113 = tmem_instance_19;
    let _e117 = index_luma;
    let _e126 = tmem8_.raw[((u32(_e113) * 1024u) + (u32((_e117 | 2048u)) / 4u))];
    let _e127 = index_luma;
    luma = i32(((_e126 >> ((u32((_e127 | 2048u)) % 4u) * 8u)) & 255u));
    let _e140 = tmem_instance_19;
    let _e144 = index_chroma;
    let _e151 = tmem8_.raw[((u32(_e140) * 1024u) + (u32(_e144) / 2u))];
    let _e152 = index_chroma;
    chroma = i32(((_e151 >> ((u32(_e152) & 1u) * 16u)) & 65535u));
    let _e163 = chroma;
    u = ((_e163 >> 8u) & 255i);
    let _e170 = chroma;
    v = ((_e170 >> 0u) & 255i);
    let _e177 = u;
    let _e180 = v;
    let _e183 = luma;
    let _e184 = luma;
    return vec4<i32>((_e177 - 128i), (_e180 - 128i), _e183, _e184);
}

fn sample_texel_rgba32_(tile_26: TileInfo, tmem_instance_20: u32, st_22: vec2<u32>) -> vec4<i32> {
    var tile_27: TileInfo;
    var tmem_instance_21: u32;
    var st_23: vec2<u32>;
    var byte_offset_8: u32;
    var index_20: u32;
    var lower_word: u32;
    var upper_word: u32;

    tile_27 = tile_26;
    tmem_instance_21 = tmem_instance_20;
    st_23 = st_22;
    let _e54 = tile_27;
    let _e56 = tile_27;
    let _e58 = st_23;
    byte_offset_8 = (_e54.offset + (_e56.stride * _e58.y));
    let _e63 = byte_offset_8;
    let _e64 = st_23;
    byte_offset_8 = (_e63 + (_e64.x * 2u));
    let _e69 = byte_offset_8;
    byte_offset_8 = (_e69 & 2047u);
    let _e72 = byte_offset_8;
    index_20 = (_e72 >> 1u);
    let _e77 = index_20;
    let _e78 = st_23;
    index_20 = (_e77 ^ ((_e78.y & 1u) << 1u));
    let _e86 = index_20;
    index_20 = (_e86 ^ 1u);
    let _e89 = tmem_instance_21;
    let _e93 = index_20;
    let _e100 = tmem8_.raw[((u32(_e89) * 1024u) + (u32(_e93) / 2u))];
    let _e101 = index_20;
    lower_word = ((_e100 >> ((u32(_e101) & 1u) * 16u)) & 65535u);
    let _e111 = tmem_instance_21;
    let _e115 = index_20;
    let _e124 = tmem8_.raw[((u32(_e111) * 1024u) + (u32((_e115 | 1024u)) / 2u))];
    let _e125 = index_20;
    upper_word = ((_e124 >> ((u32((_e125 | 1024u)) & 1u) * 16u)) & 65535u);
    let _e137 = lower_word;
    let _e142 = lower_word;
    let _e146 = upper_word;
    let _e151 = upper_word;
    return vec4<i32>(i32((_e137 >> 8u)), i32((_e142 & 255u)), i32((_e146 >> 8u)), i32((_e151 & 255u)));
}

fn convert_rgba16_(word_9: u32) -> vec4<i32> {
    var word_10: u32;
    var rgb: vec3<u32>;
    var alpha_2: u32;

    word_10 = word_9;
    let _e50 = word_10;
    rgb = ((vec3(_e50) >> vec3<u32>(11u, 6u, 1u)) & vec3(31u));
    let _e61 = rgb;
    let _e65 = rgb;
    rgb = ((_e61 << vec3(3u)) | (_e65 >> vec3(2u)));
    let _e70 = word_10;
    alpha_2 = ((_e70 & 1u) * 255u);
    let _e76 = rgb;
    let _e77 = vec3<i32>(_e76);
    let _e78 = alpha_2;
    return vec4<i32>(_e77.x, _e77.y, _e77.z, i32(_e78));
}

fn sample_texel_rgba16_(tile_28: TileInfo, tmem_instance_22: u32, st_24: vec2<u32>) -> vec4<i32> {
    var tile_29: TileInfo;
    var tmem_instance_23: u32;
    var st_25: vec2<u32>;
    var byte_offset_9: u32;
    var index_21: u32;
    var word_11: u32;
    var param_8: u32;

    tile_29 = tile_28;
    tmem_instance_23 = tmem_instance_22;
    st_25 = st_24;
    let _e54 = tile_29;
    let _e56 = tile_29;
    let _e58 = st_25;
    byte_offset_9 = (_e54.offset + (_e56.stride * _e58.y));
    let _e63 = byte_offset_9;
    let _e64 = st_25;
    byte_offset_9 = (_e63 + (_e64.x * 2u));
    let _e69 = byte_offset_9;
    byte_offset_9 = (_e69 & 4095u);
    let _e72 = byte_offset_9;
    index_21 = (_e72 >> 1u);
    let _e77 = index_21;
    let _e78 = st_25;
    index_21 = (_e77 ^ ((_e78.y & 1u) << 1u));
    let _e86 = index_21;
    index_21 = (_e86 ^ 1u);
    let _e89 = tmem_instance_23;
    let _e93 = index_21;
    let _e100 = tmem8_.raw[((u32(_e89) * 1024u) + (u32(_e93) / 2u))];
    let _e101 = index_21;
    word_11 = ((_e100 >> ((u32(_e101) & 1u) * 16u)) & 65535u);
    let _e111 = word_11;
    param_8 = _e111;
    let _e113 = param_8;
    let _e114 = convert_rgba16_(_e113);
    return _e114;
}

fn sample_texel_ci8_tlut(tile_30: TileInfo, tmem_instance_24: u32, st_26: vec2<u32>, lut_offset: u32, addr_xor: u32, tlut_type_4: bool) -> vec4<i32> {
    var tile_31: TileInfo;
    var tmem_instance_25: u32;
    var st_27: vec2<u32>;
    var lut_offset_1: u32;
    var addr_xor_1: u32;
    var tlut_type_5: bool;
    var byte_offset_10: u32;
    var index_22: u32;
    var word_12: u32;
    var lut_entry: u32;
    var _2012_: vec4<i32>;
    var param_9: u32;
    var param_1_4: u32;

    tile_31 = tile_30;
    tmem_instance_25 = tmem_instance_24;
    st_27 = st_26;
    lut_offset_1 = lut_offset;
    addr_xor_1 = addr_xor;
    tlut_type_5 = tlut_type_4;
    let _e60 = tile_31;
    let _e62 = tile_31;
    let _e64 = st_27;
    byte_offset_10 = (_e60.offset + (_e62.stride * _e64.y));
    let _e69 = byte_offset_10;
    let _e70 = st_27;
    byte_offset_10 = (_e69 + _e70.x);
    let _e73 = byte_offset_10;
    byte_offset_10 = (_e73 & 2047u);
    let _e76 = byte_offset_10;
    index_22 = _e76;
    let _e78 = index_22;
    let _e79 = st_27;
    index_22 = (_e78 ^ ((_e79.y & 1u) << 2u));
    let _e87 = index_22;
    index_22 = (_e87 ^ 3u);
    let _e90 = tmem_instance_25;
    let _e94 = index_22;
    let _e101 = tmem8_.raw[((u32(_e90) * 1024u) + (u32(_e94) / 4u))];
    let _e102 = index_22;
    word_12 = ((_e101 >> ((u32(_e102) % 4u) * 8u)) & 255u);
    let _e112 = word_12;
    let _e116 = lut_offset_1;
    lut_entry = ((_e112 << 2u) + _e116);
    let _e119 = lut_entry;
    let _e120 = addr_xor_1;
    lut_entry = (_e119 ^ _e120);
    let _e122 = tmem_instance_25;
    let _e127 = lut_entry;
    let _e135 = tmem8_.raw[((u32(_e122) * 1024u) + (u32((1024u | _e127)) / 2u))];
    let _e137 = lut_entry;
    word_12 = ((_e135 >> ((u32((1024u | _e137)) & 1u) * 16u)) & 65535u);
    let _e148 = tlut_type_5;
    if _e148 {
        {
            let _e149 = word_12;
            param_9 = _e149;
            let _e151 = param_9;
            let _e152 = convert_ia16_(_e151);
            _2012_ = _e152;
        }
    } else {
        {
            let _e153 = word_12;
            param_1_4 = _e153;
            let _e155 = param_1_4;
            let _e156 = convert_rgba16_(_e155);
            _2012_ = _e156;
        }
    }
    let _e157 = _2012_;
    return _e157;
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
    var index_23: u32;
    var word_13: u32;
    var lut_entry_1: u32;
    var _1953_: vec4<i32>;
    var param_10: u32;
    var param_1_5: u32;

    tile_33 = tile_32;
    tmem_instance_27 = tmem_instance_26;
    st_29 = st_28;
    pal_3 = pal_2;
    lut_offset_3 = lut_offset_2;
    addr_xor_3 = addr_xor_2;
    tlut_type_7 = tlut_type_6;
    let _e62 = tile_33;
    let _e64 = tile_33;
    let _e66 = st_29;
    byte_offset_11 = (_e62.offset + (_e64.stride * _e66.y));
    let _e71 = byte_offset_11;
    let _e72 = st_29;
    byte_offset_11 = (_e71 + (_e72.x >> 1u));
    let _e78 = byte_offset_11;
    byte_offset_11 = (_e78 & 2047u);
    let _e81 = st_29;
    shift_9 = ((~(_e81.x) & 1u) * 4u);
    let _e89 = byte_offset_11;
    index_23 = _e89;
    let _e91 = index_23;
    let _e92 = st_29;
    index_23 = (_e91 ^ ((_e92.y & 1u) << 2u));
    let _e100 = index_23;
    index_23 = (_e100 ^ 3u);
    let _e103 = tmem_instance_27;
    let _e107 = index_23;
    let _e114 = tmem8_.raw[((u32(_e103) * 1024u) + (u32(_e107) / 4u))];
    let _e115 = index_23;
    word_13 = ((_e114 >> ((u32(_e115) % 4u) * 8u)) & 255u);
    let _e125 = word_13;
    let _e126 = shift_9;
    word_13 = ((_e125 >> _e126) & 15u);
    let _e130 = word_13;
    let _e131 = pal_3;
    word_13 = (_e130 | (_e131 << 4u));
    let _e136 = word_13;
    let _e140 = lut_offset_3;
    lut_entry_1 = ((_e136 << 2u) + _e140);
    let _e143 = lut_entry_1;
    let _e144 = addr_xor_3;
    lut_entry_1 = (_e143 ^ _e144);
    let _e146 = tmem_instance_27;
    let _e151 = lut_entry_1;
    let _e159 = tmem8_.raw[((u32(_e146) * 1024u) + (u32((1024u | _e151)) / 2u))];
    let _e161 = lut_entry_1;
    word_13 = ((_e159 >> ((u32((1024u | _e161)) & 1u) * 16u)) & 65535u);
    let _e172 = tlut_type_7;
    if _e172 {
        {
            let _e173 = word_13;
            param_10 = _e173;
            let _e175 = param_10;
            let _e176 = convert_ia16_(_e175);
            _1953_ = _e176;
        }
    } else {
        {
            let _e177 = word_13;
            param_1_5 = _e177;
            let _e179 = param_1_5;
            let _e180 = convert_rgba16_(_e179);
            _1953_ = _e180;
        }
    }
    let _e181 = _1953_;
    return _e181;
}

fn sample_texel_ci32_tlut(tile_34: TileInfo, tmem_instance_28: u32, st_30: vec2<u32>, lut_offset_4: u32, addr_xor_4: u32, tlut_type_8: bool) -> vec4<i32> {
    var tile_35: TileInfo;
    var tmem_instance_29: u32;
    var st_31: vec2<u32>;
    var lut_offset_5: u32;
    var addr_xor_5: u32;
    var tlut_type_9: bool;
    var byte_offset_12: u32;
    var index_24: u32;
    var word_14: u32;
    var lut_entry_2: u32;
    var _2118_: vec4<i32>;
    var param_11: u32;
    var param_1_6: u32;

    tile_35 = tile_34;
    tmem_instance_29 = tmem_instance_28;
    st_31 = st_30;
    lut_offset_5 = lut_offset_4;
    addr_xor_5 = addr_xor_4;
    tlut_type_9 = tlut_type_8;
    let _e60 = tile_35;
    let _e62 = tile_35;
    let _e64 = st_31;
    byte_offset_12 = (_e60.offset + (_e62.stride * _e64.y));
    let _e69 = byte_offset_12;
    let _e70 = st_31;
    byte_offset_12 = (_e69 + (_e70.x * 2u));
    let _e75 = byte_offset_12;
    byte_offset_12 = (_e75 & 2047u);
    let _e78 = byte_offset_12;
    index_24 = (_e78 >> 1u);
    let _e83 = index_24;
    let _e84 = st_31;
    index_24 = (_e83 ^ ((_e84.y & 1u) << 1u));
    let _e92 = index_24;
    index_24 = (_e92 ^ 1u);
    let _e95 = tmem_instance_29;
    let _e99 = index_24;
    let _e106 = tmem8_.raw[((u32(_e95) * 1024u) + (u32(_e99) / 2u))];
    let _e107 = index_24;
    word_14 = ((_e106 >> ((u32(_e107) & 1u) * 16u)) & 65535u);
    let _e117 = word_14;
    let _e123 = lut_offset_5;
    lut_entry_2 = (((_e117 >> 6u) & 4294967292u) + _e123);
    let _e126 = lut_entry_2;
    let _e127 = addr_xor_5;
    lut_entry_2 = (_e126 ^ _e127);
    let _e129 = tmem_instance_29;
    let _e134 = lut_entry_2;
    let _e142 = tmem8_.raw[((u32(_e129) * 1024u) + (u32((1024u | _e134)) / 2u))];
    let _e144 = lut_entry_2;
    word_14 = ((_e142 >> ((u32((1024u | _e144)) & 1u) * 16u)) & 65535u);
    let _e155 = tlut_type_9;
    if _e155 {
        {
            let _e156 = word_14;
            param_11 = _e156;
            let _e158 = param_11;
            let _e159 = convert_ia16_(_e158);
            _2118_ = _e159;
        }
    } else {
        {
            let _e160 = word_14;
            param_1_6 = _e160;
            let _e162 = param_1_6;
            let _e163 = convert_rgba16_(_e162);
            _2118_ = _e163;
        }
    }
    let _e164 = _2118_;
    return _e164;
}

fn bilinear_3tap(t00_: vec2<i32>, t10_: vec2<i32>, t01_: vec2<i32>, t11_: vec2<i32>, frac: vec2<i32>) -> vec2<i32> {
    var t00_1: vec2<i32>;
    var t10_1: vec2<i32>;
    var t01_1: vec2<i32>;
    var t11_1: vec2<i32>;
    var frac_1: vec2<i32>;
    var sum_frac: i32;
    var t_base: vec2<i32>;
    var _2879_: vec2<i32>;
    var flip_frac: vec2<i32>;
    var accum: vec2<i32>;

    t00_1 = t00_;
    t10_1 = t10_;
    t01_1 = t01_;
    t11_1 = t11_;
    frac_1 = frac;
    let _e58 = frac_1;
    let _e60 = frac_1;
    sum_frac = (_e58.x + _e60.y);
    let _e64 = t00_1;
    let _e65 = t11_1;
    let _e66 = sum_frac;
    t_base = select(_e64, _e65, vec2((_e66 >= 32i)));
    let _e73 = sum_frac;
    if (_e73 >= 32i) {
        {
            let _e78 = frac_1;
            _2879_ = (vec2(32i) - _e78.yx);
        }
    } else {
        {
            let _e81 = frac_1;
            _2879_ = _e81;
        }
    }
    let _e82 = _2879_;
    flip_frac = vec2<i32>(_e82);
    let _e85 = t10_1;
    let _e86 = t_base;
    let _e88 = flip_frac;
    accum = ((_e85 - _e86) * vec2(_e88.x));
    let _e93 = accum;
    let _e94 = t01_1;
    let _e95 = t_base;
    let _e97 = flip_frac;
    accum = (_e93 + ((_e94 - _e95) * vec2(_e97.y)));
    let _e102 = accum;
    accum = (_e102 + vec2(16i));
    let _e106 = accum;
    accum = (_e106 >> vec2(5u));
    let _e112 = accum;
    let _e113 = t_base;
    accum = (_e112 + _e113);
    let _e115 = accum;
    return _e115;
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
    let _e52 = texel_in_1;
    texel = extractBits(vec4<i32>(_e52), 0u, 9u);
    let _e60 = texel;
    let _e62 = factors_1;
    let _e64 = texel;
    r = (_e60.z + (((_e62.x * _e64.y) + 128i) >> 8u));
    let _e74 = texel;
    let _e76 = factors_1;
    let _e78 = texel;
    let _e81 = factors_1;
    let _e83 = texel;
    g = (_e74.z + ((((_e76.y * _e78.x) + (_e81.z * _e83.y)) + 128i) >> 8u));
    let _e94 = texel;
    let _e96 = factors_1;
    let _e98 = texel;
    b = (_e94.z + (((_e96.w * _e98.x) + 128i) >> 8u));
    let _e108 = texel;
    a = _e108.z;
    let _e111 = r;
    let _e112 = g;
    let _e113 = b;
    let _e114 = a;
    return vec4<i32>(_e111, _e112, _e113, _e114);
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
    var param_12: bool;
    var param_1_7: i32;
    var param_2_4: i32;
    var param_3_3: i32;
    var param_4_3: i32;
    var _2997_: i32;
    var param_5_3: bool;
    var param_6_3: i32;
    var param_7_3: i32;
    var param_8_2: i32;
    var param_9_2: i32;
    var _3018_: i32;
    var frac_2: vec2<i32>;
    var sum_frac_1: i32;
    var param_10_1: TileInfo;
    var param_11_1: i32;
    var _3046_: i32;
    var s0_: i32;
    var param_12_1: TileInfo;
    var param_13_1: i32;
    var _3053_: i32;
    var t0_: i32;
    var param_14_1: TileInfo;
    var param_15_1: i32;
    var _3061_: i32;
    var s1_: i32;
    var param_16_1: TileInfo;
    var param_17_1: i32;
    var _3069_: i32;
    var t1_: i32;
    var tdiff: i32;
    var mid_texel: bool;
    var upper_lut: bool;
    var yuv: bool;
    var _3105_: vec2<i32>;
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
    var _4150_: bool;
    var mid_rg: bool;
    var mid_ba: bool;
    var upper_ba: bool;
    var _4174_: bool;
    var upper_rg: bool;
    var _4190_: vec2<i32>;
    var factors_rg: vec2<i32>;
    var _4201_: vec2<i32>;
    var factors_ba: vec2<i32>;
    var converted_rg: vec2<i32>;
    var _4248_: vec2<i32>;
    var base_rg: vec2<i32>;
    var converted_ba: vec2<i32>;
    var _4314_: vec2<i32>;
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
    var _4474_: vec2<i32>;
    var _4488_: vec2<i32>;
    var _4528_: bool;
    var _4534_: vec2<i32>;
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
    let _e69 = tile_37;
    param_12 = ((_e69.flags & 1i) != 0i);
    let _e76 = (*st_32);
    param_1_7 = _e76.x;
    let _e79 = tile_37;
    param_2_4 = i32(_e79.slo);
    let _e83 = tile_37;
    param_3_3 = i32(_e83.shi);
    let _e87 = tile_37;
    param_4_3 = _e87.shift_s;
    let _e90 = param_12;
    let _e92 = param_2_4;
    let _e93 = param_3_3;
    let _e94 = param_4_3;
    let _e96 = clamp_and_shift_coord(_e90, (&param_1_7), _e92, _e93, _e94);
    _2997_ = _e96;
    let _e99 = _2997_;
    (*st_32).x = _e99;
    let _e100 = tile_37;
    param_5_3 = ((_e100.flags & 4i) != 0i);
    let _e107 = (*st_32);
    param_6_3 = _e107.y;
    let _e110 = tile_37;
    param_7_3 = i32(_e110.tlo);
    let _e114 = tile_37;
    param_8_2 = i32(_e114.thi);
    let _e118 = tile_37;
    param_9_2 = _e118.shift_t;
    let _e121 = param_5_3;
    let _e123 = param_7_3;
    let _e124 = param_8_2;
    let _e125 = param_9_2;
    let _e127 = clamp_and_shift_coord(_e121, (&param_6_3), _e123, _e124, _e125);
    _3018_ = _e127;
    let _e130 = _3018_;
    (*st_32).y = _e130;
    let _e132 = sample_quad_1;
    let _e133 = tlut_5;
    if (_e132 || _e133) {
        {
            let _e135 = (*st_32);
            frac_2 = (_e135 & vec2(31i));
        }
    } else {
        {
            frac_2 = vec2(0i);
        }
    }
    let _e141 = frac_2;
    let _e143 = frac_2;
    sum_frac_1 = (_e141.x + _e143.y);
    let _e147 = (*st_32);
    (*st_32) = (_e147 >> vec2(5u));
    let _e153 = tile_37;
    param_10_1 = _e153;
    let _e155 = (*st_32);
    param_11_1 = _e155.x;
    let _e158 = param_10_1;
    let _e161 = texel_mask_s(_e158, (&param_11_1));
    _3046_ = _e161;
    let _e163 = _3046_;
    s0_ = _e163;
    let _e165 = tile_37;
    param_12_1 = _e165;
    let _e167 = (*st_32);
    param_13_1 = _e167.y;
    let _e170 = param_12_1;
    let _e173 = texel_mask_t(_e170, (&param_13_1));
    _3053_ = _e173;
    let _e175 = _3053_;
    t0_ = _e175;
    let _e177 = tile_37;
    param_14_1 = _e177;
    let _e179 = (*st_32);
    param_15_1 = (_e179.x + 1i);
    let _e184 = param_14_1;
    let _e187 = texel_mask_s(_e184, (&param_15_1));
    _3061_ = _e187;
    let _e189 = _3061_;
    s1_ = _e189;
    let _e191 = tile_37;
    param_16_1 = _e191;
    let _e193 = (*st_32);
    param_17_1 = (_e193.y + 1i);
    let _e198 = param_16_1;
    let _e201 = texel_mask_t(_e198, (&param_17_1));
    _3069_ = _e201;
    let _e203 = _3069_;
    t1_ = _e203;
    let _e205 = t1_;
    let _e206 = t0_;
    tdiff = max((_e205 - _e206), -255i);
    let _e212 = t0_;
    let _e215 = tdiff;
    t1_ = ((_e212 & 255i) + _e215);
    let _e217 = t0_;
    t0_ = (_e217 & 255i);
    let _e220 = mid_texel_state_1;
    let _e221 = bilerp_1;
    let _e222 = frac_2;
    let _e225 = (_e222 == vec2(16i));
    mid_texel = all(vec4<bool>(_e220, _e221, _e225.x, _e225.y));
    let _e231 = sum_frac_1;
    upper_lut = (_e231 >= 32i);
    let _e235 = mid_texel;
    if _e235 {
        {
            sum_frac_1 = 0i;
        }
    }
    let _e237 = tile_37;
    yuv = (_e237.fmt == 1i);
    let _e243 = sum_frac_1;
    if (_e243 >= 32i) {
        {
            let _e246 = s1_;
            let _e247 = t1_;
            _3105_ = vec2<i32>(_e246, _e247);
        }
    } else {
        {
            let _e249 = s0_;
            let _e250 = t0_;
            _3105_ = vec2<i32>(_e249, _e250);
        }
    }
    let _e252 = _3105_;
    base_st = _e252;
    let _e254 = s0_;
    let _e260 = frac_2;
    chroma_frac = (((_e254 & 1i) << 4u) | (_e260.x >> 1u));
    let _e271 = tlut_5;
    if _e271 {
        {
            let _e272 = sample_quad_1;
            if !(_e272) {
                {
                    let _e274 = s0_;
                    let _e275 = t0_;
                    base_st = vec2<i32>(_e274, _e275);
                    let _e277 = s0_;
                    s1_ = _e277;
                    let _e278 = t0_;
                    t1_ = _e278;
                }
            }
            let _e279 = tile_37;
            switch _e279.fmt {
                case 0, 2, 3, 4: {
                    let _e281 = sum_frac_1;
                    upper = (_e281 >= 32i);
                    let _e285 = upper_lut;
                    if _e285 {
                        local_7 = 2i;
                    } else {
                        local_7 = 1i;
                    }
                    let _e289 = local_7;
                    addr_xor_6 = u32(_e289);
                    let _e292 = tile_37;
                    switch _e292.size {
                        case 0: {
                            let _e294 = tile_37;
                            param_18_ = _e294;
                            let _e296 = tmem_instance_31;
                            param_19_ = _e296;
                            let _e298 = base_st;
                            param_20_ = vec2<u32>(_e298);
                            let _e301 = tile_37;
                            param_21_ = u32(_e301.palette);
                            let _e305 = upper;
                            if _e305 {
                                local_8 = 3i;
                            } else {
                                local_8 = 0i;
                            }
                            let _e309 = local_8;
                            param_22_ = u32(_e309);
                            let _e312 = addr_xor_6;
                            param_23_ = _e312;
                            let _e314 = tlut_type_11;
                            param_24_ = _e314;
                            let _e316 = param_18_;
                            let _e317 = param_19_;
                            let _e318 = param_20_;
                            let _e319 = param_21_;
                            let _e320 = param_22_;
                            let _e321 = param_23_;
                            let _e322 = param_24_;
                            let _e323 = sample_texel_ci4_tlut(_e316, _e317, _e318, _e319, _e320, _e321, _e322);
                            t_base_1 = _e323;
                            let _e324 = bilerp_1;
                            if _e324 {
                                {
                                    let _e325 = tile_37;
                                    param_25_ = _e325;
                                    let _e327 = tmem_instance_31;
                                    param_26_ = _e327;
                                    let _e329 = s1_;
                                    let _e330 = t0_;
                                    param_27_ = vec2<u32>(vec2<i32>(_e329, _e330));
                                    let _e334 = tile_37;
                                    param_28_ = u32(_e334.palette);
                                    let _e340 = addr_xor_6;
                                    param_30_ = _e340;
                                    let _e342 = tlut_type_11;
                                    param_31_ = _e342;
                                    let _e344 = param_25_;
                                    let _e345 = param_26_;
                                    let _e346 = param_27_;
                                    let _e347 = param_28_;
                                    let _e348 = param_29_;
                                    let _e349 = param_30_;
                                    let _e350 = param_31_;
                                    let _e351 = sample_texel_ci4_tlut(_e344, _e345, _e346, _e347, _e348, _e349, _e350);
                                    t10_2 = _e351;
                                    let _e352 = tile_37;
                                    param_32_ = _e352;
                                    let _e354 = tmem_instance_31;
                                    param_33_ = _e354;
                                    let _e356 = s0_;
                                    let _e357 = t1_;
                                    param_34_ = vec2<u32>(vec2<i32>(_e356, _e357));
                                    let _e361 = tile_37;
                                    param_35_ = u32(_e361.palette);
                                    let _e367 = addr_xor_6;
                                    param_37_ = _e367;
                                    let _e369 = tlut_type_11;
                                    param_38_ = _e369;
                                    let _e371 = param_32_;
                                    let _e372 = param_33_;
                                    let _e373 = param_34_;
                                    let _e374 = param_35_;
                                    let _e375 = param_36_;
                                    let _e376 = param_37_;
                                    let _e377 = param_38_;
                                    let _e378 = sample_texel_ci4_tlut(_e371, _e372, _e373, _e374, _e375, _e376, _e377);
                                    t01_2 = _e378;
                                }
                            }
                            let _e379 = mid_texel;
                            if _e379 {
                                {
                                    let _e380 = tile_37;
                                    param_39_ = _e380;
                                    let _e382 = tmem_instance_31;
                                    param_40_ = _e382;
                                    let _e384 = s1_;
                                    let _e385 = t1_;
                                    param_41_ = vec2<u32>(vec2<i32>(_e384, _e385));
                                    let _e389 = tile_37;
                                    param_42_ = u32(_e389.palette);
                                    let _e395 = addr_xor_6;
                                    param_44_ = _e395;
                                    let _e397 = tlut_type_11;
                                    param_45_ = _e397;
                                    let _e399 = param_39_;
                                    let _e400 = param_40_;
                                    let _e401 = param_41_;
                                    let _e402 = param_42_;
                                    let _e403 = param_43_;
                                    let _e404 = param_44_;
                                    let _e405 = param_45_;
                                    let _e406 = sample_texel_ci4_tlut(_e399, _e400, _e401, _e402, _e403, _e404, _e405);
                                    t11_2 = _e406;
                                }
                            }
                        }
                        case 1: {
                            let _e407 = tile_37;
                            param_46_ = _e407;
                            let _e409 = tmem_instance_31;
                            param_47_ = _e409;
                            let _e411 = base_st;
                            param_48_ = vec2<u32>(_e411);
                            let _e414 = upper;
                            if _e414 {
                                local_9 = 3i;
                            } else {
                                local_9 = 0i;
                            }
                            let _e418 = local_9;
                            param_49_ = u32(_e418);
                            let _e421 = addr_xor_6;
                            param_50_ = _e421;
                            let _e423 = tlut_type_11;
                            param_51_ = _e423;
                            let _e425 = param_46_;
                            let _e426 = param_47_;
                            let _e427 = param_48_;
                            let _e428 = param_49_;
                            let _e429 = param_50_;
                            let _e430 = param_51_;
                            let _e431 = sample_texel_ci8_tlut(_e425, _e426, _e427, _e428, _e429, _e430);
                            t_base_1 = _e431;
                            let _e432 = bilerp_1;
                            if _e432 {
                                {
                                    let _e433 = tile_37;
                                    param_52_ = _e433;
                                    let _e435 = tmem_instance_31;
                                    param_53_ = _e435;
                                    let _e437 = s1_;
                                    let _e438 = t0_;
                                    param_54_ = vec2<u32>(vec2<i32>(_e437, _e438));
                                    let _e444 = addr_xor_6;
                                    param_56_ = _e444;
                                    let _e446 = tlut_type_11;
                                    param_57_ = _e446;
                                    let _e448 = param_52_;
                                    let _e449 = param_53_;
                                    let _e450 = param_54_;
                                    let _e451 = param_55_;
                                    let _e452 = param_56_;
                                    let _e453 = param_57_;
                                    let _e454 = sample_texel_ci8_tlut(_e448, _e449, _e450, _e451, _e452, _e453);
                                    t10_2 = _e454;
                                    let _e455 = tile_37;
                                    param_58_ = _e455;
                                    let _e457 = tmem_instance_31;
                                    param_59_ = _e457;
                                    let _e459 = s0_;
                                    let _e460 = t1_;
                                    param_60_ = vec2<u32>(vec2<i32>(_e459, _e460));
                                    let _e466 = addr_xor_6;
                                    param_62_ = _e466;
                                    let _e468 = tlut_type_11;
                                    param_63_ = _e468;
                                    let _e470 = param_58_;
                                    let _e471 = param_59_;
                                    let _e472 = param_60_;
                                    let _e473 = param_61_;
                                    let _e474 = param_62_;
                                    let _e475 = param_63_;
                                    let _e476 = sample_texel_ci8_tlut(_e470, _e471, _e472, _e473, _e474, _e475);
                                    t01_2 = _e476;
                                }
                            }
                            let _e477 = mid_texel;
                            if _e477 {
                                {
                                    let _e478 = tile_37;
                                    param_64_ = _e478;
                                    let _e480 = tmem_instance_31;
                                    param_65_ = _e480;
                                    let _e482 = s1_;
                                    let _e483 = t1_;
                                    param_66_ = vec2<u32>(vec2<i32>(_e482, _e483));
                                    let _e489 = addr_xor_6;
                                    param_68_ = _e489;
                                    let _e491 = tlut_type_11;
                                    param_69_ = _e491;
                                    let _e493 = param_64_;
                                    let _e494 = param_65_;
                                    let _e495 = param_66_;
                                    let _e496 = param_67_;
                                    let _e497 = param_68_;
                                    let _e498 = param_69_;
                                    let _e499 = sample_texel_ci8_tlut(_e493, _e494, _e495, _e496, _e497, _e498);
                                    t11_2 = _e499;
                                }
                            }
                        }
                        default: {
                            let _e500 = tile_37;
                            param_70_ = _e500;
                            let _e502 = tmem_instance_31;
                            param_71_ = _e502;
                            let _e504 = base_st;
                            param_72_ = vec2<u32>(_e504);
                            let _e507 = upper;
                            if _e507 {
                                local_10 = 3i;
                            } else {
                                local_10 = 0i;
                            }
                            let _e511 = local_10;
                            param_73_ = u32(_e511);
                            let _e514 = addr_xor_6;
                            param_74_ = _e514;
                            let _e516 = tlut_type_11;
                            param_75_ = _e516;
                            let _e518 = param_70_;
                            let _e519 = param_71_;
                            let _e520 = param_72_;
                            let _e521 = param_73_;
                            let _e522 = param_74_;
                            let _e523 = param_75_;
                            let _e524 = sample_texel_ci32_tlut(_e518, _e519, _e520, _e521, _e522, _e523);
                            t_base_1 = _e524;
                            let _e525 = bilerp_1;
                            if _e525 {
                                {
                                    let _e526 = tile_37;
                                    param_76_ = _e526;
                                    let _e528 = tmem_instance_31;
                                    param_77_ = _e528;
                                    let _e530 = s1_;
                                    let _e531 = t0_;
                                    param_78_ = vec2<u32>(vec2<i32>(_e530, _e531));
                                    let _e537 = addr_xor_6;
                                    param_80_ = _e537;
                                    let _e539 = tlut_type_11;
                                    param_81_ = _e539;
                                    let _e541 = param_76_;
                                    let _e542 = param_77_;
                                    let _e543 = param_78_;
                                    let _e544 = param_79_;
                                    let _e545 = param_80_;
                                    let _e546 = param_81_;
                                    let _e547 = sample_texel_ci32_tlut(_e541, _e542, _e543, _e544, _e545, _e546);
                                    t10_2 = _e547;
                                    let _e548 = tile_37;
                                    param_82_ = _e548;
                                    let _e550 = tmem_instance_31;
                                    param_83_ = _e550;
                                    let _e552 = s0_;
                                    let _e553 = t1_;
                                    param_84_ = vec2<u32>(vec2<i32>(_e552, _e553));
                                    let _e559 = addr_xor_6;
                                    param_86_ = _e559;
                                    let _e561 = tlut_type_11;
                                    param_87_ = _e561;
                                    let _e563 = param_82_;
                                    let _e564 = param_83_;
                                    let _e565 = param_84_;
                                    let _e566 = param_85_;
                                    let _e567 = param_86_;
                                    let _e568 = param_87_;
                                    let _e569 = sample_texel_ci32_tlut(_e563, _e564, _e565, _e566, _e567, _e568);
                                    t01_2 = _e569;
                                }
                            }
                            let _e570 = mid_texel;
                            if _e570 {
                                {
                                    let _e571 = tile_37;
                                    param_88_ = _e571;
                                    let _e573 = tmem_instance_31;
                                    param_89_ = _e573;
                                    let _e575 = s1_;
                                    let _e576 = t1_;
                                    param_90_ = vec2<u32>(vec2<i32>(_e575, _e576));
                                    let _e582 = addr_xor_6;
                                    param_92_ = _e582;
                                    let _e584 = tlut_type_11;
                                    param_93_ = _e584;
                                    let _e586 = param_88_;
                                    let _e587 = param_89_;
                                    let _e588 = param_90_;
                                    let _e589 = param_91_;
                                    let _e590 = param_92_;
                                    let _e591 = param_93_;
                                    let _e592 = sample_texel_ci32_tlut(_e586, _e587, _e588, _e589, _e590, _e591);
                                    t11_2 = _e592;
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
            let _e593 = tile_37;
            switch _e593.fmt {
                case 0: {
                    let _e595 = tile_37;
                    switch _e595.size {
                        case 0: {
                            let _e597 = tile_37;
                            param_94_ = _e597;
                            let _e599 = tmem_instance_31;
                            param_95_ = _e599;
                            let _e601 = base_st;
                            param_96_ = vec2<u32>(_e601);
                            let _e604 = param_94_;
                            let _e605 = param_95_;
                            let _e606 = param_96_;
                            let _e607 = sample_texel_rgba4_(_e604, _e605, _e606);
                            t_base_1 = _e607;
                            let _e608 = sample_quad_1;
                            if _e608 {
                                {
                                    let _e609 = tile_37;
                                    param_97_ = _e609;
                                    let _e611 = tmem_instance_31;
                                    param_98_ = _e611;
                                    let _e613 = s1_;
                                    let _e614 = t0_;
                                    param_99_ = vec2<u32>(vec2<i32>(_e613, _e614));
                                    let _e618 = param_97_;
                                    let _e619 = param_98_;
                                    let _e620 = param_99_;
                                    let _e621 = sample_texel_rgba4_(_e618, _e619, _e620);
                                    t10_2 = _e621;
                                    let _e622 = tile_37;
                                    param_100_ = _e622;
                                    let _e624 = tmem_instance_31;
                                    param_101_ = _e624;
                                    let _e626 = s0_;
                                    let _e627 = t1_;
                                    param_102_ = vec2<u32>(vec2<i32>(_e626, _e627));
                                    let _e631 = param_100_;
                                    let _e632 = param_101_;
                                    let _e633 = param_102_;
                                    let _e634 = sample_texel_rgba4_(_e631, _e632, _e633);
                                    t01_2 = _e634;
                                }
                            }
                            let _e635 = mid_texel;
                            if _e635 {
                                {
                                    let _e636 = tile_37;
                                    param_103_ = _e636;
                                    let _e638 = tmem_instance_31;
                                    param_104_ = _e638;
                                    let _e640 = s1_;
                                    let _e641 = t1_;
                                    param_105_ = vec2<u32>(vec2<i32>(_e640, _e641));
                                    let _e645 = param_103_;
                                    let _e646 = param_104_;
                                    let _e647 = param_105_;
                                    let _e648 = sample_texel_rgba4_(_e645, _e646, _e647);
                                    t11_2 = _e648;
                                }
                            }
                        }
                        case 1: {
                            let _e649 = tile_37;
                            param_106_ = _e649;
                            let _e651 = tmem_instance_31;
                            param_107_ = _e651;
                            let _e653 = base_st;
                            param_108_ = vec2<u32>(_e653);
                            let _e656 = param_106_;
                            let _e657 = param_107_;
                            let _e658 = param_108_;
                            let _e659 = sample_texel_rgba8_(_e656, _e657, _e658);
                            t_base_1 = _e659;
                            let _e660 = sample_quad_1;
                            if _e660 {
                                {
                                    let _e661 = tile_37;
                                    param_109_ = _e661;
                                    let _e663 = tmem_instance_31;
                                    param_110_ = _e663;
                                    let _e665 = s1_;
                                    let _e666 = t0_;
                                    param_111_ = vec2<u32>(vec2<i32>(_e665, _e666));
                                    let _e670 = param_109_;
                                    let _e671 = param_110_;
                                    let _e672 = param_111_;
                                    let _e673 = sample_texel_rgba8_(_e670, _e671, _e672);
                                    t10_2 = _e673;
                                    let _e674 = tile_37;
                                    param_112_ = _e674;
                                    let _e676 = tmem_instance_31;
                                    param_113_ = _e676;
                                    let _e678 = s0_;
                                    let _e679 = t1_;
                                    param_114_ = vec2<u32>(vec2<i32>(_e678, _e679));
                                    let _e683 = param_112_;
                                    let _e684 = param_113_;
                                    let _e685 = param_114_;
                                    let _e686 = sample_texel_rgba8_(_e683, _e684, _e685);
                                    t01_2 = _e686;
                                }
                            }
                            let _e687 = mid_texel;
                            if _e687 {
                                {
                                    let _e688 = tile_37;
                                    param_115_ = _e688;
                                    let _e690 = tmem_instance_31;
                                    param_116_ = _e690;
                                    let _e692 = s1_;
                                    let _e693 = t1_;
                                    param_117_ = vec2<u32>(vec2<i32>(_e692, _e693));
                                    let _e697 = param_115_;
                                    let _e698 = param_116_;
                                    let _e699 = param_117_;
                                    let _e700 = sample_texel_rgba8_(_e697, _e698, _e699);
                                    t11_2 = _e700;
                                }
                            }
                        }
                        case 2: {
                            let _e701 = tile_37;
                            param_118_ = _e701;
                            let _e703 = tmem_instance_31;
                            param_119_ = _e703;
                            let _e705 = base_st;
                            param_120_ = vec2<u32>(_e705);
                            let _e708 = param_118_;
                            let _e709 = param_119_;
                            let _e710 = param_120_;
                            let _e711 = sample_texel_rgba16_(_e708, _e709, _e710);
                            t_base_1 = _e711;
                            let _e712 = sample_quad_1;
                            if _e712 {
                                {
                                    let _e713 = tile_37;
                                    param_121_ = _e713;
                                    let _e715 = tmem_instance_31;
                                    param_122_ = _e715;
                                    let _e717 = s1_;
                                    let _e718 = t0_;
                                    param_123_ = vec2<u32>(vec2<i32>(_e717, _e718));
                                    let _e722 = param_121_;
                                    let _e723 = param_122_;
                                    let _e724 = param_123_;
                                    let _e725 = sample_texel_rgba16_(_e722, _e723, _e724);
                                    t10_2 = _e725;
                                    let _e726 = tile_37;
                                    param_124_ = _e726;
                                    let _e728 = tmem_instance_31;
                                    param_125_ = _e728;
                                    let _e730 = s0_;
                                    let _e731 = t1_;
                                    param_126_ = vec2<u32>(vec2<i32>(_e730, _e731));
                                    let _e735 = param_124_;
                                    let _e736 = param_125_;
                                    let _e737 = param_126_;
                                    let _e738 = sample_texel_rgba16_(_e735, _e736, _e737);
                                    t01_2 = _e738;
                                }
                            }
                            let _e739 = mid_texel;
                            if _e739 {
                                {
                                    let _e740 = tile_37;
                                    param_127_ = _e740;
                                    let _e742 = tmem_instance_31;
                                    param_128_ = _e742;
                                    let _e744 = s1_;
                                    let _e745 = t1_;
                                    param_129_ = vec2<u32>(vec2<i32>(_e744, _e745));
                                    let _e749 = param_127_;
                                    let _e750 = param_128_;
                                    let _e751 = param_129_;
                                    let _e752 = sample_texel_rgba16_(_e749, _e750, _e751);
                                    t11_2 = _e752;
                                }
                            }
                        }
                        case 3: {
                            let _e753 = tile_37;
                            param_130_ = _e753;
                            let _e755 = tmem_instance_31;
                            param_131_ = _e755;
                            let _e757 = base_st;
                            param_132_ = vec2<u32>(_e757);
                            let _e760 = param_130_;
                            let _e761 = param_131_;
                            let _e762 = param_132_;
                            let _e763 = sample_texel_rgba32_(_e760, _e761, _e762);
                            t_base_1 = _e763;
                            let _e764 = sample_quad_1;
                            if _e764 {
                                {
                                    let _e765 = tile_37;
                                    param_133_ = _e765;
                                    let _e767 = tmem_instance_31;
                                    param_134_ = _e767;
                                    let _e769 = s1_;
                                    let _e770 = t0_;
                                    param_135_ = vec2<u32>(vec2<i32>(_e769, _e770));
                                    let _e774 = param_133_;
                                    let _e775 = param_134_;
                                    let _e776 = param_135_;
                                    let _e777 = sample_texel_rgba32_(_e774, _e775, _e776);
                                    t10_2 = _e777;
                                    let _e778 = tile_37;
                                    param_136_ = _e778;
                                    let _e780 = tmem_instance_31;
                                    param_137_ = _e780;
                                    let _e782 = s0_;
                                    let _e783 = t1_;
                                    param_138_ = vec2<u32>(vec2<i32>(_e782, _e783));
                                    let _e787 = param_136_;
                                    let _e788 = param_137_;
                                    let _e789 = param_138_;
                                    let _e790 = sample_texel_rgba32_(_e787, _e788, _e789);
                                    t01_2 = _e790;
                                }
                            }
                            let _e791 = mid_texel;
                            if _e791 {
                                {
                                    let _e792 = tile_37;
                                    param_139_ = _e792;
                                    let _e794 = tmem_instance_31;
                                    param_140_ = _e794;
                                    let _e796 = s1_;
                                    let _e797 = t1_;
                                    param_141_ = vec2<u32>(vec2<i32>(_e796, _e797));
                                    let _e801 = param_139_;
                                    let _e802 = param_140_;
                                    let _e803 = param_141_;
                                    let _e804 = sample_texel_rgba32_(_e801, _e802, _e803);
                                    t11_2 = _e804;
                                }
                            }
                        }
                        default: {
                        }
                    }
                }
                case 1: {
                    let _e805 = s0_;
                    chroma_x0_ = u32((_e805 >> 1u));
                    let _e811 = s1_;
                    let _e812 = s1_;
                    let _e813 = s0_;
                    chroma_x1_ = u32(((_e811 + (_e812 - _e813)) >> 1u));
                    let _e821 = tile_37;
                    param_142_ = _e821;
                    let _e823 = tmem_instance_31;
                    param_143_ = _e823;
                    let _e825 = s0_;
                    let _e826 = t0_;
                    param_144_ = vec2<u32>(vec2<i32>(_e825, _e826));
                    let _e830 = chroma_x0_;
                    param_145_ = _e830;
                    let _e832 = param_142_;
                    let _e833 = param_143_;
                    let _e834 = param_144_;
                    let _e835 = param_145_;
                    let _e836 = sample_texel_yuv16_(_e832, _e833, _e834, _e835);
                    t_base_1 = _e836;
                    let _e837 = sample_quad_1;
                    if _e837 {
                        {
                            let _e838 = tile_37;
                            param_146_ = _e838;
                            let _e840 = tmem_instance_31;
                            param_147_ = _e840;
                            let _e842 = s1_;
                            let _e843 = t0_;
                            param_148_ = vec2<u32>(vec2<i32>(_e842, _e843));
                            let _e847 = chroma_x1_;
                            param_149_ = _e847;
                            let _e849 = param_146_;
                            let _e850 = param_147_;
                            let _e851 = param_148_;
                            let _e852 = param_149_;
                            let _e853 = sample_texel_yuv16_(_e849, _e850, _e851, _e852);
                            t10_2 = _e853;
                            let _e854 = tile_37;
                            param_150_ = _e854;
                            let _e856 = tmem_instance_31;
                            param_151_ = _e856;
                            let _e858 = s0_;
                            let _e859 = t1_;
                            param_152_ = vec2<u32>(vec2<i32>(_e858, _e859));
                            let _e863 = chroma_x0_;
                            param_153_ = _e863;
                            let _e865 = param_150_;
                            let _e866 = param_151_;
                            let _e867 = param_152_;
                            let _e868 = param_153_;
                            let _e869 = sample_texel_yuv16_(_e865, _e866, _e867, _e868);
                            t01_2 = _e869;
                            let _e870 = tile_37;
                            param_154_ = _e870;
                            let _e872 = tmem_instance_31;
                            param_155_ = _e872;
                            let _e874 = s1_;
                            let _e875 = t1_;
                            param_156_ = vec2<u32>(vec2<i32>(_e874, _e875));
                            let _e879 = chroma_x1_;
                            param_157_ = _e879;
                            let _e881 = param_154_;
                            let _e882 = param_155_;
                            let _e883 = param_156_;
                            let _e884 = param_157_;
                            let _e885 = sample_texel_yuv16_(_e881, _e882, _e883, _e884);
                            t11_2 = _e885;
                        }
                    }
                }
                case 2: {
                    let _e886 = tile_37;
                    switch _e886.size {
                        case 0: {
                            let _e888 = tile_37;
                            param_158_ = _e888;
                            let _e890 = tmem_instance_31;
                            param_159_ = _e890;
                            let _e892 = base_st;
                            param_160_ = vec2<u32>(_e892);
                            let _e895 = tile_37;
                            param_161_ = u32(_e895.palette);
                            let _e899 = param_158_;
                            let _e900 = param_159_;
                            let _e901 = param_160_;
                            let _e902 = param_161_;
                            let _e903 = sample_texel_ci4_(_e899, _e900, _e901, _e902);
                            t_base_1 = _e903;
                            let _e904 = sample_quad_1;
                            if _e904 {
                                {
                                    let _e905 = tile_37;
                                    param_162_ = _e905;
                                    let _e907 = tmem_instance_31;
                                    param_163_ = _e907;
                                    let _e909 = s1_;
                                    let _e910 = t0_;
                                    param_164_ = vec2<u32>(vec2<i32>(_e909, _e910));
                                    let _e914 = tile_37;
                                    param_165_ = u32(_e914.palette);
                                    let _e918 = param_162_;
                                    let _e919 = param_163_;
                                    let _e920 = param_164_;
                                    let _e921 = param_165_;
                                    let _e922 = sample_texel_ci4_(_e918, _e919, _e920, _e921);
                                    t10_2 = _e922;
                                    let _e923 = tile_37;
                                    param_166_ = _e923;
                                    let _e925 = tmem_instance_31;
                                    param_167_ = _e925;
                                    let _e927 = s0_;
                                    let _e928 = t1_;
                                    param_168_ = vec2<u32>(vec2<i32>(_e927, _e928));
                                    let _e932 = tile_37;
                                    param_169_ = u32(_e932.palette);
                                    let _e936 = param_166_;
                                    let _e937 = param_167_;
                                    let _e938 = param_168_;
                                    let _e939 = param_169_;
                                    let _e940 = sample_texel_ci4_(_e936, _e937, _e938, _e939);
                                    t01_2 = _e940;
                                }
                            }
                            let _e941 = mid_texel;
                            if _e941 {
                                {
                                    let _e942 = tile_37;
                                    param_170_ = _e942;
                                    let _e944 = tmem_instance_31;
                                    param_171_ = _e944;
                                    let _e946 = s1_;
                                    let _e947 = t1_;
                                    param_172_ = vec2<u32>(vec2<i32>(_e946, _e947));
                                    let _e951 = tile_37;
                                    param_173_ = u32(_e951.palette);
                                    let _e955 = param_170_;
                                    let _e956 = param_171_;
                                    let _e957 = param_172_;
                                    let _e958 = param_173_;
                                    let _e959 = sample_texel_ci4_(_e955, _e956, _e957, _e958);
                                    t11_2 = _e959;
                                }
                            }
                        }
                        case 1: {
                            let _e960 = tile_37;
                            param_174_ = _e960;
                            let _e962 = tmem_instance_31;
                            param_175_ = _e962;
                            let _e964 = base_st;
                            param_176_ = vec2<u32>(_e964);
                            let _e967 = param_174_;
                            let _e968 = param_175_;
                            let _e969 = param_176_;
                            let _e970 = sample_texel_rgba8_(_e967, _e968, _e969);
                            t_base_1 = _e970;
                            let _e971 = sample_quad_1;
                            if _e971 {
                                {
                                    let _e972 = tile_37;
                                    param_177_ = _e972;
                                    let _e974 = tmem_instance_31;
                                    param_178_ = _e974;
                                    let _e976 = s1_;
                                    let _e977 = t0_;
                                    param_179_ = vec2<u32>(vec2<i32>(_e976, _e977));
                                    let _e981 = param_177_;
                                    let _e982 = param_178_;
                                    let _e983 = param_179_;
                                    let _e984 = sample_texel_rgba8_(_e981, _e982, _e983);
                                    t10_2 = _e984;
                                    let _e985 = tile_37;
                                    param_180_ = _e985;
                                    let _e987 = tmem_instance_31;
                                    param_181_ = _e987;
                                    let _e989 = s0_;
                                    let _e990 = t1_;
                                    param_182_ = vec2<u32>(vec2<i32>(_e989, _e990));
                                    let _e994 = param_180_;
                                    let _e995 = param_181_;
                                    let _e996 = param_182_;
                                    let _e997 = sample_texel_rgba8_(_e994, _e995, _e996);
                                    t01_2 = _e997;
                                }
                            }
                            let _e998 = mid_texel;
                            if _e998 {
                                {
                                    let _e999 = tile_37;
                                    param_183_ = _e999;
                                    let _e1001 = tmem_instance_31;
                                    param_184_ = _e1001;
                                    let _e1003 = s1_;
                                    let _e1004 = t1_;
                                    param_185_ = vec2<u32>(vec2<i32>(_e1003, _e1004));
                                    let _e1008 = param_183_;
                                    let _e1009 = param_184_;
                                    let _e1010 = param_185_;
                                    let _e1011 = sample_texel_rgba8_(_e1008, _e1009, _e1010);
                                    t11_2 = _e1011;
                                }
                            }
                        }
                        default: {
                            let _e1012 = tile_37;
                            param_186_ = _e1012;
                            let _e1014 = tmem_instance_31;
                            param_187_ = _e1014;
                            let _e1016 = base_st;
                            param_188_ = vec2<u32>(_e1016);
                            let _e1019 = param_186_;
                            let _e1020 = param_187_;
                            let _e1021 = param_188_;
                            let _e1022 = sample_texel_ci32_(_e1019, _e1020, _e1021);
                            t_base_1 = _e1022;
                            let _e1023 = sample_quad_1;
                            if _e1023 {
                                {
                                    let _e1024 = tile_37;
                                    param_189_ = _e1024;
                                    let _e1026 = tmem_instance_31;
                                    param_190_ = _e1026;
                                    let _e1028 = s1_;
                                    let _e1029 = t0_;
                                    param_191_ = vec2<u32>(vec2<i32>(_e1028, _e1029));
                                    let _e1033 = param_189_;
                                    let _e1034 = param_190_;
                                    let _e1035 = param_191_;
                                    let _e1036 = sample_texel_ci32_(_e1033, _e1034, _e1035);
                                    t10_2 = _e1036;
                                    let _e1037 = tile_37;
                                    param_192_ = _e1037;
                                    let _e1039 = tmem_instance_31;
                                    param_193_ = _e1039;
                                    let _e1041 = s0_;
                                    let _e1042 = t1_;
                                    param_194_ = vec2<u32>(vec2<i32>(_e1041, _e1042));
                                    let _e1046 = param_192_;
                                    let _e1047 = param_193_;
                                    let _e1048 = param_194_;
                                    let _e1049 = sample_texel_ci32_(_e1046, _e1047, _e1048);
                                    t01_2 = _e1049;
                                }
                            }
                            let _e1050 = mid_texel;
                            if _e1050 {
                                {
                                    let _e1051 = tile_37;
                                    param_195_ = _e1051;
                                    let _e1053 = tmem_instance_31;
                                    param_196_ = _e1053;
                                    let _e1055 = s1_;
                                    let _e1056 = t1_;
                                    param_197_ = vec2<u32>(vec2<i32>(_e1055, _e1056));
                                    let _e1060 = param_195_;
                                    let _e1061 = param_196_;
                                    let _e1062 = param_197_;
                                    let _e1063 = sample_texel_ci32_(_e1060, _e1061, _e1062);
                                    t11_2 = _e1063;
                                }
                            }
                        }
                    }
                }
                case 3: {
                    let _e1064 = tile_37;
                    switch _e1064.size {
                        case 0: {
                            let _e1066 = tile_37;
                            param_198_ = _e1066;
                            let _e1068 = tmem_instance_31;
                            param_199_ = _e1068;
                            let _e1070 = base_st;
                            param_200_ = vec2<u32>(_e1070);
                            let _e1073 = param_198_;
                            let _e1074 = param_199_;
                            let _e1075 = param_200_;
                            let _e1076 = sample_texel_ia4_(_e1073, _e1074, _e1075);
                            t_base_1 = _e1076;
                            let _e1077 = sample_quad_1;
                            if _e1077 {
                                {
                                    let _e1078 = tile_37;
                                    param_201_ = _e1078;
                                    let _e1080 = tmem_instance_31;
                                    param_202_ = _e1080;
                                    let _e1082 = s1_;
                                    let _e1083 = t0_;
                                    param_203_ = vec2<u32>(vec2<i32>(_e1082, _e1083));
                                    let _e1087 = param_201_;
                                    let _e1088 = param_202_;
                                    let _e1089 = param_203_;
                                    let _e1090 = sample_texel_ia4_(_e1087, _e1088, _e1089);
                                    t10_2 = _e1090;
                                    let _e1091 = tile_37;
                                    param_204_ = _e1091;
                                    let _e1093 = tmem_instance_31;
                                    param_205_ = _e1093;
                                    let _e1095 = s0_;
                                    let _e1096 = t1_;
                                    param_206_ = vec2<u32>(vec2<i32>(_e1095, _e1096));
                                    let _e1100 = param_204_;
                                    let _e1101 = param_205_;
                                    let _e1102 = param_206_;
                                    let _e1103 = sample_texel_ia4_(_e1100, _e1101, _e1102);
                                    t01_2 = _e1103;
                                }
                            }
                            let _e1104 = mid_texel;
                            if _e1104 {
                                {
                                    let _e1105 = tile_37;
                                    param_207_ = _e1105;
                                    let _e1107 = tmem_instance_31;
                                    param_208_ = _e1107;
                                    let _e1109 = s1_;
                                    let _e1110 = t1_;
                                    param_209_ = vec2<u32>(vec2<i32>(_e1109, _e1110));
                                    let _e1114 = param_207_;
                                    let _e1115 = param_208_;
                                    let _e1116 = param_209_;
                                    let _e1117 = sample_texel_ia4_(_e1114, _e1115, _e1116);
                                    t11_2 = _e1117;
                                }
                            }
                        }
                        case 1: {
                            let _e1118 = tile_37;
                            param_210_ = _e1118;
                            let _e1120 = tmem_instance_31;
                            param_211_ = _e1120;
                            let _e1122 = base_st;
                            param_212_ = vec2<u32>(_e1122);
                            let _e1125 = param_210_;
                            let _e1126 = param_211_;
                            let _e1127 = param_212_;
                            let _e1128 = sample_texel_ia8_(_e1125, _e1126, _e1127);
                            t_base_1 = _e1128;
                            let _e1129 = sample_quad_1;
                            if _e1129 {
                                {
                                    let _e1130 = tile_37;
                                    param_213_ = _e1130;
                                    let _e1132 = tmem_instance_31;
                                    param_214_ = _e1132;
                                    let _e1134 = s1_;
                                    let _e1135 = t0_;
                                    param_215_ = vec2<u32>(vec2<i32>(_e1134, _e1135));
                                    let _e1139 = param_213_;
                                    let _e1140 = param_214_;
                                    let _e1141 = param_215_;
                                    let _e1142 = sample_texel_ia8_(_e1139, _e1140, _e1141);
                                    t10_2 = _e1142;
                                    let _e1143 = tile_37;
                                    param_216_ = _e1143;
                                    let _e1145 = tmem_instance_31;
                                    param_217_ = _e1145;
                                    let _e1147 = s0_;
                                    let _e1148 = t1_;
                                    param_218_ = vec2<u32>(vec2<i32>(_e1147, _e1148));
                                    let _e1152 = param_216_;
                                    let _e1153 = param_217_;
                                    let _e1154 = param_218_;
                                    let _e1155 = sample_texel_ia8_(_e1152, _e1153, _e1154);
                                    t01_2 = _e1155;
                                }
                            }
                            let _e1156 = mid_texel;
                            if _e1156 {
                                {
                                    let _e1157 = tile_37;
                                    param_219_ = _e1157;
                                    let _e1159 = tmem_instance_31;
                                    param_220_ = _e1159;
                                    let _e1161 = s1_;
                                    let _e1162 = t1_;
                                    param_221_ = vec2<u32>(vec2<i32>(_e1161, _e1162));
                                    let _e1166 = param_219_;
                                    let _e1167 = param_220_;
                                    let _e1168 = param_221_;
                                    let _e1169 = sample_texel_ia8_(_e1166, _e1167, _e1168);
                                    t11_2 = _e1169;
                                }
                            }
                        }
                        case 2: {
                            let _e1170 = tile_37;
                            param_222_ = _e1170;
                            let _e1172 = tmem_instance_31;
                            param_223_ = _e1172;
                            let _e1174 = base_st;
                            param_224_ = vec2<u32>(_e1174);
                            let _e1177 = param_222_;
                            let _e1178 = param_223_;
                            let _e1179 = param_224_;
                            let _e1180 = sample_texel_ia16_(_e1177, _e1178, _e1179);
                            t_base_1 = _e1180;
                            let _e1181 = sample_quad_1;
                            if _e1181 {
                                {
                                    let _e1182 = tile_37;
                                    param_225_ = _e1182;
                                    let _e1184 = tmem_instance_31;
                                    param_226_ = _e1184;
                                    let _e1186 = s1_;
                                    let _e1187 = t0_;
                                    param_227_ = vec2<u32>(vec2<i32>(_e1186, _e1187));
                                    let _e1191 = param_225_;
                                    let _e1192 = param_226_;
                                    let _e1193 = param_227_;
                                    let _e1194 = sample_texel_ia16_(_e1191, _e1192, _e1193);
                                    t10_2 = _e1194;
                                    let _e1195 = tile_37;
                                    param_228_ = _e1195;
                                    let _e1197 = tmem_instance_31;
                                    param_229_ = _e1197;
                                    let _e1199 = s0_;
                                    let _e1200 = t1_;
                                    param_230_ = vec2<u32>(vec2<i32>(_e1199, _e1200));
                                    let _e1204 = param_228_;
                                    let _e1205 = param_229_;
                                    let _e1206 = param_230_;
                                    let _e1207 = sample_texel_ia16_(_e1204, _e1205, _e1206);
                                    t01_2 = _e1207;
                                }
                            }
                            let _e1208 = mid_texel;
                            if _e1208 {
                                {
                                    let _e1209 = tile_37;
                                    param_231_ = _e1209;
                                    let _e1211 = tmem_instance_31;
                                    param_232_ = _e1211;
                                    let _e1213 = s1_;
                                    let _e1214 = t1_;
                                    param_233_ = vec2<u32>(vec2<i32>(_e1213, _e1214));
                                    let _e1218 = param_231_;
                                    let _e1219 = param_232_;
                                    let _e1220 = param_233_;
                                    let _e1221 = sample_texel_ia16_(_e1218, _e1219, _e1220);
                                    t11_2 = _e1221;
                                }
                            }
                        }
                        case 3: {
                            let _e1222 = tile_37;
                            param_234_ = _e1222;
                            let _e1224 = tmem_instance_31;
                            param_235_ = _e1224;
                            let _e1226 = base_st;
                            param_236_ = vec2<u32>(_e1226);
                            let _e1229 = param_234_;
                            let _e1230 = param_235_;
                            let _e1231 = param_236_;
                            let _e1232 = sample_texel_ci32_(_e1229, _e1230, _e1231);
                            t_base_1 = _e1232;
                            let _e1233 = sample_quad_1;
                            if _e1233 {
                                {
                                    let _e1234 = tile_37;
                                    param_237_ = _e1234;
                                    let _e1236 = tmem_instance_31;
                                    param_238_ = _e1236;
                                    let _e1238 = s1_;
                                    let _e1239 = t0_;
                                    param_239_ = vec2<u32>(vec2<i32>(_e1238, _e1239));
                                    let _e1243 = param_237_;
                                    let _e1244 = param_238_;
                                    let _e1245 = param_239_;
                                    let _e1246 = sample_texel_ci32_(_e1243, _e1244, _e1245);
                                    t10_2 = _e1246;
                                    let _e1247 = tile_37;
                                    param_240_ = _e1247;
                                    let _e1249 = tmem_instance_31;
                                    param_241_ = _e1249;
                                    let _e1251 = s0_;
                                    let _e1252 = t1_;
                                    param_242_ = vec2<u32>(vec2<i32>(_e1251, _e1252));
                                    let _e1256 = param_240_;
                                    let _e1257 = param_241_;
                                    let _e1258 = param_242_;
                                    let _e1259 = sample_texel_ci32_(_e1256, _e1257, _e1258);
                                    t01_2 = _e1259;
                                }
                            }
                            let _e1260 = mid_texel;
                            if _e1260 {
                                {
                                    let _e1261 = tile_37;
                                    param_243_ = _e1261;
                                    let _e1263 = tmem_instance_31;
                                    param_244_ = _e1263;
                                    let _e1265 = s1_;
                                    let _e1266 = t1_;
                                    param_245_ = vec2<u32>(vec2<i32>(_e1265, _e1266));
                                    let _e1270 = param_243_;
                                    let _e1271 = param_244_;
                                    let _e1272 = param_245_;
                                    let _e1273 = sample_texel_ci32_(_e1270, _e1271, _e1272);
                                    t11_2 = _e1273;
                                }
                            }
                        }
                        default: {
                        }
                    }
                }
                case 4: {
                    let _e1274 = tile_37;
                    switch _e1274.size {
                        case 0: {
                            let _e1276 = tile_37;
                            param_246_ = _e1276;
                            let _e1278 = tmem_instance_31;
                            param_247_ = _e1278;
                            let _e1280 = base_st;
                            param_248_ = vec2<u32>(_e1280);
                            let _e1283 = param_246_;
                            let _e1284 = param_247_;
                            let _e1285 = param_248_;
                            let _e1286 = sample_texel_rgba4_(_e1283, _e1284, _e1285);
                            t_base_1 = _e1286;
                            let _e1287 = sample_quad_1;
                            if _e1287 {
                                {
                                    let _e1288 = tile_37;
                                    param_249_ = _e1288;
                                    let _e1290 = tmem_instance_31;
                                    param_250_ = _e1290;
                                    let _e1292 = s1_;
                                    let _e1293 = t0_;
                                    param_251_ = vec2<u32>(vec2<i32>(_e1292, _e1293));
                                    let _e1297 = param_249_;
                                    let _e1298 = param_250_;
                                    let _e1299 = param_251_;
                                    let _e1300 = sample_texel_rgba4_(_e1297, _e1298, _e1299);
                                    t10_2 = _e1300;
                                    let _e1301 = tile_37;
                                    param_252_ = _e1301;
                                    let _e1303 = tmem_instance_31;
                                    param_253_ = _e1303;
                                    let _e1305 = s0_;
                                    let _e1306 = t1_;
                                    param_254_ = vec2<u32>(vec2<i32>(_e1305, _e1306));
                                    let _e1310 = param_252_;
                                    let _e1311 = param_253_;
                                    let _e1312 = param_254_;
                                    let _e1313 = sample_texel_rgba4_(_e1310, _e1311, _e1312);
                                    t01_2 = _e1313;
                                }
                            }
                            let _e1314 = mid_texel;
                            if _e1314 {
                                {
                                    let _e1315 = tile_37;
                                    param_255_ = _e1315;
                                    let _e1317 = tmem_instance_31;
                                    param_256_ = _e1317;
                                    let _e1319 = s1_;
                                    let _e1320 = t1_;
                                    param_257_ = vec2<u32>(vec2<i32>(_e1319, _e1320));
                                    let _e1324 = param_255_;
                                    let _e1325 = param_256_;
                                    let _e1326 = param_257_;
                                    let _e1327 = sample_texel_rgba4_(_e1324, _e1325, _e1326);
                                    t11_2 = _e1327;
                                }
                            }
                        }
                        case 1: {
                            let _e1328 = tile_37;
                            param_258_ = _e1328;
                            let _e1330 = tmem_instance_31;
                            param_259_ = _e1330;
                            let _e1332 = base_st;
                            param_260_ = vec2<u32>(_e1332);
                            let _e1335 = param_258_;
                            let _e1336 = param_259_;
                            let _e1337 = param_260_;
                            let _e1338 = sample_texel_rgba8_(_e1335, _e1336, _e1337);
                            t_base_1 = _e1338;
                            let _e1339 = sample_quad_1;
                            if _e1339 {
                                {
                                    let _e1340 = tile_37;
                                    param_261_ = _e1340;
                                    let _e1342 = tmem_instance_31;
                                    param_262_ = _e1342;
                                    let _e1344 = s1_;
                                    let _e1345 = t0_;
                                    param_263_ = vec2<u32>(vec2<i32>(_e1344, _e1345));
                                    let _e1349 = param_261_;
                                    let _e1350 = param_262_;
                                    let _e1351 = param_263_;
                                    let _e1352 = sample_texel_rgba8_(_e1349, _e1350, _e1351);
                                    t10_2 = _e1352;
                                    let _e1353 = tile_37;
                                    param_264_ = _e1353;
                                    let _e1355 = tmem_instance_31;
                                    param_265_ = _e1355;
                                    let _e1357 = s0_;
                                    let _e1358 = t1_;
                                    param_266_ = vec2<u32>(vec2<i32>(_e1357, _e1358));
                                    let _e1362 = param_264_;
                                    let _e1363 = param_265_;
                                    let _e1364 = param_266_;
                                    let _e1365 = sample_texel_rgba8_(_e1362, _e1363, _e1364);
                                    t01_2 = _e1365;
                                }
                            }
                            let _e1366 = mid_texel;
                            if _e1366 {
                                {
                                    let _e1367 = tile_37;
                                    param_267_ = _e1367;
                                    let _e1369 = tmem_instance_31;
                                    param_268_ = _e1369;
                                    let _e1371 = s1_;
                                    let _e1372 = t1_;
                                    param_269_ = vec2<u32>(vec2<i32>(_e1371, _e1372));
                                    let _e1376 = param_267_;
                                    let _e1377 = param_268_;
                                    let _e1378 = param_269_;
                                    let _e1379 = sample_texel_rgba8_(_e1376, _e1377, _e1378);
                                    t11_2 = _e1379;
                                }
                            }
                        }
                        default: {
                            let _e1380 = tile_37;
                            param_270_ = _e1380;
                            let _e1382 = tmem_instance_31;
                            param_271_ = _e1382;
                            let _e1384 = base_st;
                            param_272_ = vec2<u32>(_e1384);
                            let _e1387 = param_270_;
                            let _e1388 = param_271_;
                            let _e1389 = param_272_;
                            let _e1390 = sample_texel_ci32_(_e1387, _e1388, _e1389);
                            t_base_1 = _e1390;
                            let _e1391 = sample_quad_1;
                            if _e1391 {
                                {
                                    let _e1392 = tile_37;
                                    param_273_ = _e1392;
                                    let _e1394 = tmem_instance_31;
                                    param_274_ = _e1394;
                                    let _e1396 = s1_;
                                    let _e1397 = t0_;
                                    param_275_ = vec2<u32>(vec2<i32>(_e1396, _e1397));
                                    let _e1401 = param_273_;
                                    let _e1402 = param_274_;
                                    let _e1403 = param_275_;
                                    let _e1404 = sample_texel_ci32_(_e1401, _e1402, _e1403);
                                    t10_2 = _e1404;
                                    let _e1405 = tile_37;
                                    param_276_ = _e1405;
                                    let _e1407 = tmem_instance_31;
                                    param_277_ = _e1407;
                                    let _e1409 = s0_;
                                    let _e1410 = t1_;
                                    param_278_ = vec2<u32>(vec2<i32>(_e1409, _e1410));
                                    let _e1414 = param_276_;
                                    let _e1415 = param_277_;
                                    let _e1416 = param_278_;
                                    let _e1417 = sample_texel_ci32_(_e1414, _e1415, _e1416);
                                    t01_2 = _e1417;
                                }
                            }
                            let _e1418 = mid_texel;
                            if _e1418 {
                                {
                                    let _e1419 = tile_37;
                                    param_279_ = _e1419;
                                    let _e1421 = tmem_instance_31;
                                    param_280_ = _e1421;
                                    let _e1423 = s1_;
                                    let _e1424 = t1_;
                                    param_281_ = vec2<u32>(vec2<i32>(_e1423, _e1424));
                                    let _e1428 = param_279_;
                                    let _e1429 = param_280_;
                                    let _e1430 = param_281_;
                                    let _e1431 = sample_texel_ci32_(_e1428, _e1429, _e1430);
                                    t11_2 = _e1431;
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
    let _e1433 = convert_one_1;
    if _e1433 {
        {
            let _e1434 = prev_cycle_1;
            prev_sext = extractBits(vec4<i32>(_e1434), 0u, 9u);
            let _e1442 = sample_quad_1;
            if _e1442 {
                {
                    let _e1444 = yuv;
                    if _e1444 {
                        {
                            let _e1445 = mid_texel_state_1;
                            let _e1446 = chroma_frac;
                            let _e1447 = frac_2;
                            let _e1452 = (vec2<i32>(_e1446, _e1447.y) == vec2(16i));
                            _4150_ = all(vec3<bool>(_e1445, _e1452.x, _e1452.y));
                        }
                    } else {
                        {
                            let _e1457 = mid_texel;
                            _4150_ = _e1457;
                        }
                    }
                    let _e1458 = _4150_;
                    mid_rg = _e1458;
                    let _e1460 = mid_texel;
                    mid_ba = _e1460;
                    let _e1462 = sum_frac_1;
                    upper_ba = (_e1462 >= 32i);
                    let _e1467 = yuv;
                    if _e1467 {
                        {
                            let _e1468 = chroma_frac;
                            let _e1469 = frac_2;
                            let _e1474 = mid_rg;
                            _4174_ = (((_e1468 + _e1469.y) >= 32i) && !(_e1474));
                        }
                    } else {
                        {
                            let _e1477 = upper_ba;
                            _4174_ = _e1477;
                        }
                    }
                    let _e1478 = _4174_;
                    upper_rg = _e1478;
                    let _e1481 = upper_rg;
                    if _e1481 {
                        {
                            let _e1482 = prev_sext;
                            _4190_ = _e1482.yx;
                        }
                    } else {
                        {
                            let _e1484 = prev_sext;
                            _4190_ = _e1484.xy;
                        }
                    }
                    let _e1486 = _4190_;
                    factors_rg = _e1486;
                    let _e1489 = upper_ba;
                    if _e1489 {
                        {
                            let _e1490 = prev_sext;
                            _4201_ = _e1490.yx;
                        }
                    } else {
                        {
                            let _e1492 = prev_sext;
                            _4201_ = _e1492.xy;
                        }
                    }
                    let _e1494 = _4201_;
                    factors_ba = _e1494;
                    let _e1497 = mid_rg;
                    if _e1497 {
                        {
                            let _e1498 = factors_rg;
                            let _e1501 = t01_2;
                            let _e1503 = t11_2;
                            let _e1507 = factors_rg;
                            let _e1510 = t10_2;
                            let _e1512 = t11_2;
                            let _e1517 = t_base_1;
                            let _e1519 = t11_2;
                            converted_rg = ((((vec2(_e1498.x) * (_e1501.xy - _e1503.xy)) + (vec2(_e1507.y) * (_e1510.xy - _e1512.xy))) + ((_e1517.xy - _e1519.xy) << vec2(6u))) + vec2(128i));
                        }
                    } else {
                        {
                            let _e1532 = upper_rg;
                            let _e1533 = yuv;
                            if (_e1532 && _e1533) {
                                {
                                    let _e1535 = t11_2;
                                    _4248_ = _e1535.xy;
                                }
                            } else {
                                {
                                    let _e1537 = t_base_1;
                                    _4248_ = _e1537.xy;
                                }
                            }
                            let _e1539 = _4248_;
                            base_rg = _e1539;
                            let _e1541 = factors_rg;
                            let _e1544 = t10_2;
                            let _e1546 = base_rg;
                            let _e1549 = factors_rg;
                            let _e1552 = t01_2;
                            let _e1554 = base_rg;
                            converted_rg = (((vec2(_e1541.x) * (_e1544.xy - _e1546)) + (vec2(_e1549.y) * (_e1552.xy - _e1554))) + vec2(128i));
                        }
                    }
                    let _e1562 = mid_ba;
                    if _e1562 {
                        {
                            let _e1563 = factors_ba;
                            let _e1566 = t01_2;
                            let _e1568 = t11_2;
                            let _e1572 = factors_ba;
                            let _e1575 = t10_2;
                            let _e1577 = t11_2;
                            let _e1582 = t_base_1;
                            let _e1584 = t11_2;
                            converted_ba = ((((vec2(_e1563.x) * (_e1566.zw - _e1568.zw)) + (vec2(_e1572.y) * (_e1575.zw - _e1577.zw))) + ((_e1582.zw - _e1584.zw) << vec2(6u))) + vec2(128i));
                        }
                    } else {
                        {
                            let _e1597 = upper_ba;
                            let _e1598 = yuv;
                            if (_e1597 && _e1598) {
                                {
                                    let _e1600 = t11_2;
                                    _4314_ = _e1600.zw;
                                }
                            } else {
                                {
                                    let _e1602 = t_base_1;
                                    _4314_ = _e1602.zw;
                                }
                            }
                            let _e1604 = _4314_;
                            base_ba = _e1604;
                            let _e1606 = factors_ba;
                            let _e1609 = t10_2;
                            let _e1611 = base_ba;
                            let _e1614 = factors_ba;
                            let _e1617 = t01_2;
                            let _e1619 = base_ba;
                            converted_ba = (((vec2(_e1606.x) * (_e1609.zw - _e1611)) + (vec2(_e1614.y) * (_e1617.zw - _e1619))) + vec2(128i));
                        }
                    }
                    let _e1626 = converted_rg;
                    let _e1627 = converted_ba;
                    converted = vec4<i32>(_e1626.x, _e1626.y, _e1627.x, _e1627.y);
                    let _e1634 = converted;
                    converted = (_e1634 >> vec4(8u));
                    let _e1640 = converted;
                    let _e1641 = prev_sext;
                    converted = (_e1640 + vec4(_e1641.z));
                    let _e1645 = converted;
                    accum_1 = vec4<i32>(_e1645);
                }
            } else {
                {
                    let _e1647 = prev_sext;
                    accum_1 = vec4<i32>(_e1647.zzzz);
                }
            }
        }
    } else {
        {
            let _e1650 = yuv;
            if _e1650 {
                {
                    let _e1651 = sample_quad_1;
                    if _e1651 {
                        {
                            let _e1654 = bilerp_1;
                            if _e1654 {
                                {
                                    let _e1655 = mid_texel_state_1;
                                    let _e1656 = chroma_frac;
                                    let _e1657 = frac_2;
                                    let _e1662 = (vec2<i32>(_e1656, _e1657.y) == vec2(16i));
                                    mid_chroma = all(vec3<bool>(_e1655, _e1662.x, _e1662.y));
                                    let _e1668 = mid_chroma;
                                    if _e1668 {
                                        {
                                            let _e1669 = t_base_1;
                                            let _e1671 = t10_2;
                                            let _e1674 = t11_2;
                                            let _e1677 = t01_2;
                                            accum_chroma = (((((_e1669.xy + _e1671.xy) + _e1674.xy) + _e1677.xy) + vec2(2i)) >> vec2(2u));
                                        }
                                    } else {
                                        {
                                            let _e1688 = t_base_1;
                                            param_282_ = _e1688.xy;
                                            let _e1691 = t10_2;
                                            param_283_ = _e1691.xy;
                                            let _e1694 = t01_2;
                                            param_284_ = _e1694.xy;
                                            let _e1697 = t11_2;
                                            param_285_ = _e1697.xy;
                                            let _e1700 = chroma_frac;
                                            let _e1701 = frac_2;
                                            param_286_ = vec2<i32>(_e1700, _e1701.y);
                                            let _e1705 = param_282_;
                                            let _e1706 = param_283_;
                                            let _e1707 = param_284_;
                                            let _e1708 = param_285_;
                                            let _e1709 = param_286_;
                                            let _e1710 = bilinear_3tap(_e1705, _e1706, _e1707, _e1708, _e1709);
                                            accum_chroma = _e1710;
                                        }
                                    }
                                    let _e1711 = mid_texel;
                                    if _e1711 {
                                        {
                                            let _e1712 = t_base_1;
                                            let _e1714 = t10_2;
                                            let _e1717 = t11_2;
                                            let _e1720 = t01_2;
                                            accum_luma = (((((_e1712.zw + _e1714.zw) + _e1717.zw) + _e1720.zw) + vec2(2i)) >> vec2(2u));
                                        }
                                    } else {
                                        {
                                            let _e1731 = t_base_1;
                                            param_287_ = _e1731.zw;
                                            let _e1734 = t10_2;
                                            param_288_ = _e1734.zw;
                                            let _e1737 = t01_2;
                                            param_289_ = _e1737.zw;
                                            let _e1740 = t11_2;
                                            param_290_ = _e1740.zw;
                                            let _e1743 = frac_2;
                                            param_291_ = _e1743;
                                            let _e1745 = param_287_;
                                            let _e1746 = param_288_;
                                            let _e1747 = param_289_;
                                            let _e1748 = param_290_;
                                            let _e1749 = param_291_;
                                            let _e1750 = bilinear_3tap(_e1745, _e1746, _e1747, _e1748, _e1749);
                                            accum_luma = _e1750;
                                        }
                                    }
                                }
                            } else {
                                {
                                    let _e1752 = frac_2;
                                    let _e1754 = frac_2;
                                    if ((_e1752.x + _e1754.y) >= 32i) {
                                        {
                                            let _e1759 = t11_2;
                                            _4474_ = _e1759.zw;
                                        }
                                    } else {
                                        {
                                            let _e1761 = t_base_1;
                                            _4474_ = _e1761.zw;
                                        }
                                    }
                                    let _e1763 = _4474_;
                                    accum_luma = _e1763;
                                    let _e1765 = chroma_frac;
                                    let _e1766 = frac_2;
                                    if ((_e1765 + _e1766.y) >= 32i) {
                                        {
                                            let _e1771 = t11_2;
                                            _4488_ = _e1771.xy;
                                        }
                                    } else {
                                        {
                                            let _e1773 = t_base_1;
                                            _4488_ = _e1773.xy;
                                        }
                                    }
                                    let _e1775 = _4488_;
                                    accum_chroma = _e1775;
                                }
                            }
                            let _e1776 = accum_chroma;
                            let _e1777 = accum_luma;
                            accum_1 = vec4<i32>(_e1776.x, _e1776.y, _e1777.x, _e1777.y);
                        }
                    } else {
                        {
                            let _e1783 = t_base_1;
                            accum_1 = _e1783;
                        }
                    }
                }
            } else {
                {
                    let _e1784 = mid_texel;
                    if _e1784 {
                        {
                            let _e1785 = t_base_1;
                            let _e1786 = t01_2;
                            let _e1788 = t10_2;
                            let _e1790 = t11_2;
                            accum_1 = (((((_e1785 + _e1786) + _e1788) + _e1790) + vec4(2i)) >> vec4(2u));
                        }
                    } else {
                        {
                            let _e1801 = bilerp_1;
                            if _e1801 {
                                {
                                    let _e1802 = sample_quad_1;
                                    let _e1803 = tlut_5;
                                    _4528_ = (_e1802 || _e1803);
                                }
                            } else {
                                {
                                    let _e1805 = bilerp_1;
                                    _4528_ = _e1805;
                                }
                            }
                            let _e1806 = _4528_;
                            if _e1806 {
                                {
                                    let _e1808 = sum_frac_1;
                                    if (_e1808 >= 32i) {
                                        {
                                            let _e1813 = frac_2;
                                            _4534_ = (vec2(32i) - _e1813.yx);
                                        }
                                    } else {
                                        {
                                            let _e1816 = frac_2;
                                            _4534_ = _e1816;
                                        }
                                    }
                                    let _e1817 = _4534_;
                                    flip_frac_1 = vec2<i32>(_e1817);
                                    let _e1820 = t10_2;
                                    let _e1821 = t_base_1;
                                    let _e1823 = flip_frac_1;
                                    accum_1 = ((_e1820 - _e1821) * vec4(_e1823.x));
                                    let _e1827 = accum_1;
                                    let _e1828 = t01_2;
                                    let _e1829 = t_base_1;
                                    let _e1831 = flip_frac_1;
                                    accum_1 = (_e1827 + ((_e1828 - _e1829) * vec4(_e1831.y)));
                                    let _e1836 = accum_1;
                                    accum_1 = (_e1836 + vec4(16i));
                                    let _e1840 = accum_1;
                                    accum_1 = (_e1840 >> vec4(5u));
                                    let _e1846 = accum_1;
                                    let _e1847 = t_base_1;
                                    accum_1 = (_e1846 + _e1847);
                                }
                            } else {
                                {
                                    let _e1849 = t_base_1;
                                    accum_1 = _e1849;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    let _e1850 = bilerp_1;
    let _e1852 = convert_one_1;
    if (!(_e1850) && !(_e1852)) {
        {
            let _e1855 = accum_1;
            param_292_ = _e1855;
            let _e1857 = conversion_factors_1;
            param_293_ = _e1857;
            let _e1859 = param_292_;
            let _e1860 = param_293_;
            let _e1861 = texture_convert_factors(_e1859, _e1860);
            accum_1 = _e1861;
        }
    }
    let _e1862 = accum_1;
    return _e1862;
}

fn interpolate_st_single(stzw_2: vec4<i32>, dstzw_dx_4: vec4<i32>, dx_6: i32, perspective_4: bool) -> vec2<i32> {
    var stzw_3: vec4<i32>;
    var dstzw_dx_5: vec4<i32>;
    var dx_7: i32;
    var perspective_5: bool;
    var stw_6: vec3<i32>;
    var st_33: vec2<i32>;
    var param_13: vec3<i32>;
    var st_overflow_2: bool;
    var param_1_8: bool;
    var _1393_: vec2<i32>;
    var param_2_5: vec3<i32>;

    stzw_3 = stzw_2;
    dstzw_dx_5 = dstzw_dx_4;
    dx_7 = dx_6;
    perspective_5 = perspective_4;
    let _e56 = stzw_3;
    let _e58 = dstzw_dx_5;
    let _e69 = dx_7;
    stw_6 = (_e56.xyw + (((_e58.xyw & vec3(-32i)) >> vec3(0u)) * vec3(_e69)));
    let _e74 = stw_6;
    stw_6 = (_e74 >> vec3(16u));
    let _e81 = perspective_5;
    if _e81 {
        {
            let _e82 = stw_6;
            param_13 = _e82;
            let _e85 = st_overflow_2;
            param_1_8 = _e85;
            let _e87 = param_13;
            let _e90 = perspective_divide(_e87, (&param_1_8));
            _1393_ = _e90;
            let _e92 = param_1_8;
            st_overflow_2 = _e92;
            let _e93 = _1393_;
            st_33 = _e93;
        }
    } else {
        {
            let _e94 = stw_6;
            param_2_5 = _e94;
            let _e96 = param_2_5;
            let _e97 = no_perspective_divide(_e96);
            st_33 = _e97;
        }
    }
    let _e98 = st_33;
    return _e98;
}

fn noise_get_dither_color() -> i32 {
    let _e48 = seeded_noise;
    return (_e48 & 511i);
}

fn noise_get_dither_alpha() -> i32 {
    let _e48 = seeded_noise;
    return (_e48 & 7i);
}

fn dither_coefficients(x_6: i32, y_2: i32, dither_mode_rgb: i32, dither_mode_alpha: i32, rgb_dither: ptr<function, i32>, alpha_dither: ptr<function, i32>) {
    var x_7: i32;
    var y_3: i32;
    var dither_mode_rgb_1: i32;
    var dither_mode_alpha_1: i32;
    var local_11: array<i32, 32> = _4741_;
    var _4775_: i32;
    var local_12: array<i32, 32> = _4741_;

    x_7 = x_6;
    y_3 = y_2;
    dither_mode_rgb_1 = dither_mode_rgb;
    dither_mode_alpha_1 = dither_mode_alpha;
    let _e58 = dither_mode_rgb_1;
    if (_e58 < 2i) {
        {
            let _e61 = dither_mode_rgb_1;
            let _e64 = y_3;
            let _e69 = x_7;
            let _e77 = local_11[((_e61 * 16i) + (((_e64 & 3i) * 4i) + (_e69 & 3i)))];
            (*rgb_dither) = (_e77 * 73i);
        }
    } else {
        {
            let _e80 = dither_mode_rgb_1;
            if (_e80 == 2i) {
                {
                    let _e83 = noise_get_dither_color();
                    (*rgb_dither) = _e83;
                }
            } else {
                {
                    (*rgb_dither) = 0i;
                }
            }
        }
    }
    let _e85 = dither_mode_alpha_1;
    if (_e85 == 3i) {
        {
            (*alpha_dither) = 0i;
            return;
        }
    } else {
        {
            let _e89 = dither_mode_alpha_1;
            if (_e89 == 2i) {
                {
                    let _e92 = noise_get_dither_alpha();
                    (*alpha_dither) = _e92;
                    return;
                }
            } else {
                {
                    let _e94 = dither_mode_rgb_1;
                    if (_e94 >= 2i) {
                        {
                            let _e97 = dither_mode_rgb_1;
                            let _e102 = y_3;
                            let _e107 = x_7;
                            let _e115 = local_12[(((_e97 & 1i) * 16i) + (((_e102 & 3i) * 4i) + (_e107 & 3i)))];
                            _4775_ = _e115;
                        }
                    } else {
                        {
                            let _e116 = (*rgb_dither);
                            _4775_ = (_e116 & 7i);
                        }
                    }
                    let _e119 = _4775_;
                    (*alpha_dither) = _e119;
                    let _e120 = dither_mode_alpha_1;
                    if (_e120 == 1i) {
                        {
                            let _e123 = (*alpha_dither);
                            (*alpha_dither) = (~(_e123) & 7i);
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
    let _e48 = seeded_noise;
    return (((_e48 & 7i) << 6u) | 32i);
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
    let _e55 = selector_rgb_1;
    switch _e55 {
        case 0: {
            let _e56 = inputs_1;
            res = _e56.combined.xyz;
        }
        case 1: {
            let _e59 = inputs_1;
            res = _e59.texel0_.xyz;
        }
        case 2: {
            let _e62 = inputs_1;
            res = _e62.texel1_.xyz;
        }
        case 4: {
            let _e65 = inputs_1;
            res = _e65.shade.xyz;
        }
        case 7: {
            let _e68 = inputs_1;
            res = vec3(_e68._noise);
        }
        case 6: {
            res = vec3(256i);
        }
        default: {
            let _e73 = inputs_1;
            res = _e73.constant_muladd.xyz;
        }
    }
    let _e77 = selector_alpha_1;
    switch _e77 {
        case 0: {
            let _e78 = inputs_1;
            alpha_3 = _e78.combined.w;
        }
        case 1: {
            let _e81 = inputs_1;
            alpha_3 = _e81.texel0_.w;
        }
        case 2: {
            let _e84 = inputs_1;
            alpha_3 = _e84.texel1_.w;
        }
        case 4: {
            let _e87 = inputs_1;
            alpha_3 = _e87.shade.w;
        }
        case 6: {
            alpha_3 = 256i;
        }
        default: {
            let _e91 = inputs_1;
            alpha_3 = _e91.constant_muladd.w;
        }
    }
    let _e94 = res;
    let _e95 = alpha_3;
    return vec4<i32>(_e94.x, _e94.y, _e94.z, _e95);
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
    let _e55 = selector_rgb_3;
    switch _e55 {
        case 0: {
            let _e56 = inputs_3;
            res_1 = _e56.combined.xyz;
        }
        case 1: {
            let _e59 = inputs_3;
            res_1 = _e59.texel0_.xyz;
        }
        case 2: {
            let _e62 = inputs_3;
            res_1 = _e62.texel1_.xyz;
        }
        case 4: {
            let _e65 = inputs_3;
            res_1 = _e65.shade.xyz;
        }
        case 7: {
            let _e68 = inputs_3;
            let _e74 = inputs_3;
            res_1 = vec3(((_e68.constant_mulsub.y << 8u) | _e74.constant_mulsub.z));
        }
        default: {
            let _e79 = inputs_3;
            res_1 = _e79.constant_mulsub.xyz;
        }
    }
    let _e83 = selector_alpha_3;
    switch _e83 {
        case 0: {
            let _e84 = inputs_3;
            alpha_4 = _e84.combined.w;
        }
        case 1: {
            let _e87 = inputs_3;
            alpha_4 = _e87.texel0_.w;
        }
        case 2: {
            let _e90 = inputs_3;
            alpha_4 = _e90.texel1_.w;
        }
        case 4: {
            let _e93 = inputs_3;
            alpha_4 = _e93.shade.w;
        }
        case 6: {
            alpha_4 = 256i;
        }
        default: {
            let _e97 = inputs_3;
            alpha_4 = _e97.constant_mulsub.w;
        }
    }
    let _e100 = res_1;
    let _e101 = alpha_4;
    return vec4<i32>(_e100.x, _e100.y, _e100.z, _e101);
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
    let _e55 = selector_rgb_5;
    switch _e55 {
        case 0: {
            let _e56 = inputs_5;
            res_2 = _e56.combined.xyz;
        }
        case 7: {
            let _e59 = inputs_5;
            res_2 = _e59.combined.www;
        }
        case 1: {
            let _e62 = inputs_5;
            res_2 = _e62.texel0_.xyz;
        }
        case 2: {
            let _e65 = inputs_5;
            res_2 = _e65.texel1_.xyz;
        }
        case 4: {
            let _e68 = inputs_5;
            res_2 = _e68.shade.xyz;
        }
        case 8: {
            let _e71 = inputs_5;
            res_2 = _e71.texel0_.www;
        }
        case 9: {
            let _e74 = inputs_5;
            res_2 = _e74.texel1_.www;
        }
        case 11: {
            let _e77 = inputs_5;
            res_2 = _e77.shade.www;
        }
        case 13: {
            let _e80 = inputs_5;
            res_2 = vec3(_e80.lod_frac);
        }
        case 15: {
            let _e83 = inputs_5;
            let _e89 = inputs_5;
            res_2 = vec3(((_e83.constant_mul.y << 8u) | _e89.constant_mul.z));
        }
        default: {
            let _e94 = inputs_5;
            res_2 = _e94.constant_mul.xyz;
        }
    }
    let _e98 = selector_alpha_5;
    switch _e98 {
        case 0: {
            let _e99 = inputs_5;
            alpha_5 = _e99.lod_frac;
        }
        case 1: {
            let _e101 = inputs_5;
            alpha_5 = _e101.texel0_.w;
        }
        case 2: {
            let _e104 = inputs_5;
            alpha_5 = _e104.texel1_.w;
        }
        case 4: {
            let _e107 = inputs_5;
            alpha_5 = _e107.shade.w;
        }
        default: {
            let _e110 = inputs_5;
            alpha_5 = _e110.constant_mul.w;
        }
    }
    let _e113 = res_2;
    let _e114 = alpha_5;
    return vec4<i32>(_e113.x, _e113.y, _e113.z, _e114);
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
    let _e55 = selector_rgb_7;
    switch _e55 {
        case 0: {
            let _e56 = inputs_7;
            res_3 = _e56.combined.xyz;
        }
        case 1: {
            let _e59 = inputs_7;
            res_3 = _e59.texel0_.xyz;
        }
        case 2: {
            let _e62 = inputs_7;
            res_3 = _e62.texel1_.xyz;
        }
        case 4: {
            let _e65 = inputs_7;
            res_3 = _e65.shade.xyz;
        }
        case 6: {
            res_3 = vec3(256i);
        }
        default: {
            let _e70 = inputs_7;
            res_3 = _e70.constant_add.xyz;
        }
    }
    let _e74 = selector_alpha_7;
    switch _e74 {
        case 0: {
            let _e75 = inputs_7;
            alpha_6 = _e75.combined.w;
        }
        case 1: {
            let _e78 = inputs_7;
            alpha_6 = _e78.texel0_.w;
        }
        case 2: {
            let _e81 = inputs_7;
            alpha_6 = _e81.texel1_.w;
        }
        case 4: {
            let _e84 = inputs_7;
            alpha_6 = _e84.shade.w;
        }
        case 6: {
            alpha_6 = 256i;
        }
        default: {
            let _e88 = inputs_7;
            alpha_6 = _e88.constant_add.w;
        }
    }
    let _e91 = res_3;
    let _e92 = alpha_6;
    return vec4<i32>(_e91.x, _e91.y, _e91.z, _e92);
}

fn special_expand(value: vec4<i32>) -> vec4<i32> {
    var value_1: vec4<i32>;

    value_1 = value;
    let _e50 = value_1;
    return (extractBits((_e50 - vec4(128i)), 0u, 9u) + vec4(128i));
}

fn combiner_equation(a_1: ptr<function, vec4<i32>>, b_1: ptr<function, vec4<i32>>, c: ptr<function, vec4<i32>>, d: ptr<function, vec4<i32>>) -> vec4<i32> {
    var param_14: vec4<i32>;
    var param_1_9: vec4<i32>;
    var param_2_6: vec4<i32>;
    var color_1_3: vec4<i32>;

    let _e52 = (*c);
    (*c) = extractBits(_e52, 0u, 9u);
    let _e58 = (*a_1);
    param_14 = _e58;
    let _e60 = param_14;
    let _e61 = special_expand(_e60);
    (*a_1) = _e61;
    let _e62 = (*b_1);
    param_1_9 = _e62;
    let _e64 = param_1_9;
    let _e65 = special_expand(_e64);
    (*b_1) = _e65;
    let _e66 = (*d);
    param_2_6 = _e66;
    let _e68 = param_2_6;
    let _e69 = special_expand(_e68);
    (*d) = _e69;
    let _e70 = (*a_1);
    let _e71 = (*b_1);
    let _e73 = (*c);
    color_1_3 = ((_e70 - _e71) * _e73);
    let _e76 = color_1_3;
    color_1_3 = (_e76 + vec4(128i));
    let _e80 = color_1_3;
    let _e87 = (*d);
    return (vec4<i32>((_e80 >> vec4(8u))) + vec4<i32>(_e87));
}

fn combiner_cycle1_(inputs_8: CombinerInputs, combiner_inputs_rgb: vec4<i32>, combiner_inputs_alpha: vec4<i32>, alpha_dith: i32, coverage_1_4: ptr<function, i32>, cvg_times_alpha: bool, alpha_cvg_select: bool) -> vec4<i32> {
    var inputs_9: CombinerInputs;
    var combiner_inputs_rgb_1: vec4<i32>;
    var combiner_inputs_alpha_1: vec4<i32>;
    var alpha_dith_1: i32;
    var cvg_times_alpha_1: bool;
    var alpha_cvg_select_1: bool;
    var param_15: CombinerInputs;
    var param_1_10: i32;
    var param_2_7: i32;
    var muladd: vec4<i32>;
    var param_3_4: CombinerInputs;
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
    var _5288_: vec4<i32>;
    var combined: vec4<i32>;
    var param_16_2: vec4<i32>;
    var _5291_: vec4<i32>;
    var expanded_alpha: i32;
    var modulated_alpha: i32;

    inputs_9 = inputs_8;
    combiner_inputs_rgb_1 = combiner_inputs_rgb;
    combiner_inputs_alpha_1 = combiner_inputs_alpha;
    alpha_dith_1 = alpha_dith;
    cvg_times_alpha_1 = cvg_times_alpha;
    alpha_cvg_select_1 = alpha_cvg_select;
    let _e61 = inputs_9;
    param_15 = _e61;
    let _e63 = combiner_inputs_rgb_1;
    param_1_10 = _e63.x;
    let _e66 = combiner_inputs_alpha_1;
    param_2_7 = _e66.x;
    let _e69 = param_15;
    let _e70 = param_1_10;
    let _e71 = param_2_7;
    let _e72 = select_muladd(_e69, _e70, _e71);
    muladd = _e72;
    let _e74 = inputs_9;
    param_3_4 = _e74;
    let _e76 = combiner_inputs_rgb_1;
    param_4_4 = _e76.y;
    let _e79 = combiner_inputs_alpha_1;
    param_5_4 = _e79.y;
    let _e82 = param_3_4;
    let _e83 = param_4_4;
    let _e84 = param_5_4;
    let _e85 = select_mulsub(_e82, _e83, _e84);
    mulsub = _e85;
    let _e87 = inputs_9;
    param_6_4 = _e87;
    let _e89 = combiner_inputs_rgb_1;
    param_7_4 = _e89.z;
    let _e92 = combiner_inputs_alpha_1;
    param_8_3 = _e92.z;
    let _e95 = param_6_4;
    let _e96 = param_7_4;
    let _e97 = param_8_3;
    let _e98 = select_mul(_e95, _e96, _e97);
    mul = _e98;
    let _e100 = inputs_9;
    param_9_3 = _e100;
    let _e102 = combiner_inputs_rgb_1;
    param_10_2 = _e102.w;
    let _e105 = combiner_inputs_alpha_1;
    param_11_2 = _e105.w;
    let _e108 = param_9_3;
    let _e109 = param_10_2;
    let _e110 = param_11_2;
    let _e111 = select_add(_e108, _e109, _e110);
    add = _e111;
    let _e113 = muladd;
    param_12_2 = _e113;
    let _e115 = mulsub;
    param_13_2 = _e115;
    let _e117 = mul;
    param_14_2 = _e117;
    let _e119 = add;
    param_15_2 = _e119;
    let _e129 = combiner_equation((&param_12_2), (&param_13_2), (&param_14_2), (&param_15_2));
    _5288_ = _e129;
    let _e131 = _5288_;
    combined = _e131;
    let _e133 = combined;
    param_16_2 = _e133;
    let _e137 = clamp_9bit_notrunc((&param_16_2));
    _5291_ = _e137;
    let _e139 = _5291_;
    combined = _e139;
    let _e140 = combined;
    let _e142 = combined;
    expanded_alpha = (_e140.w + ((_e142.w + 1i) >> 8u));
    let _e152 = cvg_times_alpha_1;
    if _e152 {
        {
            let _e153 = expanded_alpha;
            let _e154 = (*coverage_1_4);
            modulated_alpha = (((_e153 * _e154) + 4i) >> 3u);
            let _e161 = modulated_alpha;
            (*coverage_1_4) = (_e161 >> 5u);
        }
    } else {
        {
            let _e165 = (*coverage_1_4);
            modulated_alpha = (_e165 << 5u);
        }
    }
    let _e169 = alpha_cvg_select_1;
    if _e169 {
        {
            let _e170 = modulated_alpha;
            expanded_alpha = _e170;
        }
    } else {
        {
            let _e171 = expanded_alpha;
            let _e172 = alpha_dith_1;
            expanded_alpha = (_e171 + _e172);
        }
    }
    let _e175 = expanded_alpha;
    combined.w = clamp(_e175, 0i, 255i);
    let _e179 = combined;
    return _e179;
}

fn clamp_9bit_1(color_1_4: i32) -> i32 {
    var color_1_5: i32;

    color_1_5 = color_1_4;
    let _e50 = color_1_5;
    return clamp((extractBits((_e50 - 128i), 0u, 9u) + 128i), 0i, 255i);
}

fn combiner_cycle0_(inputs_10: CombinerInputs, combiner_inputs_rgb_2: vec4<i32>, combiner_inputs_alpha_2: vec4<i32>, alpha_dith_2: i32, coverage_1_5: i32, cvg_times_alpha_2: bool, alpha_cvg_select_2: bool, alpha_test: bool, alpha_test_reference: ptr<function, i32>) -> vec4<i32> {
    var inputs_11: CombinerInputs;
    var combiner_inputs_rgb_3: vec4<i32>;
    var combiner_inputs_alpha_3: vec4<i32>;
    var alpha_dith_3: i32;
    var coverage_1_6: i32;
    var cvg_times_alpha_3: bool;
    var alpha_cvg_select_3: bool;
    var alpha_test_1: bool;
    var param_16: CombinerInputs;
    var param_1_11: i32;
    var param_2_8: i32;
    var muladd_1: vec4<i32>;
    var param_3_5: CombinerInputs;
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
    var _5198_: vec4<i32>;
    var combined_1: vec4<i32>;
    var param_16_3: i32;
    var clamped_alpha: i32;
    var expanded_alpha_1: i32;
    var modulated_alpha_1: i32;

    inputs_11 = inputs_10;
    combiner_inputs_rgb_3 = combiner_inputs_rgb_2;
    combiner_inputs_alpha_3 = combiner_inputs_alpha_2;
    alpha_dith_3 = alpha_dith_2;
    coverage_1_6 = coverage_1_5;
    cvg_times_alpha_3 = cvg_times_alpha_2;
    alpha_cvg_select_3 = alpha_cvg_select_2;
    alpha_test_1 = alpha_test;
    let _e65 = inputs_11;
    param_16 = _e65;
    let _e67 = combiner_inputs_rgb_3;
    param_1_11 = _e67.x;
    let _e70 = combiner_inputs_alpha_3;
    param_2_8 = _e70.x;
    let _e73 = param_16;
    let _e74 = param_1_11;
    let _e75 = param_2_8;
    let _e76 = select_muladd(_e73, _e74, _e75);
    muladd_1 = _e76;
    let _e78 = inputs_11;
    param_3_5 = _e78;
    let _e80 = combiner_inputs_rgb_3;
    param_4_5 = _e80.y;
    let _e83 = combiner_inputs_alpha_3;
    param_5_5 = _e83.y;
    let _e86 = param_3_5;
    let _e87 = param_4_5;
    let _e88 = param_5_5;
    let _e89 = select_mulsub(_e86, _e87, _e88);
    mulsub_1 = _e89;
    let _e91 = inputs_11;
    param_6_5 = _e91;
    let _e93 = combiner_inputs_rgb_3;
    param_7_5 = _e93.z;
    let _e96 = combiner_inputs_alpha_3;
    param_8_4 = _e96.z;
    let _e99 = param_6_5;
    let _e100 = param_7_5;
    let _e101 = param_8_4;
    let _e102 = select_mul(_e99, _e100, _e101);
    mul_1 = _e102;
    let _e104 = inputs_11;
    param_9_4 = _e104;
    let _e106 = combiner_inputs_rgb_3;
    param_10_3 = _e106.w;
    let _e109 = combiner_inputs_alpha_3;
    param_11_3 = _e109.w;
    let _e112 = param_9_4;
    let _e113 = param_10_3;
    let _e114 = param_11_3;
    let _e115 = select_add(_e112, _e113, _e114);
    add_1 = _e115;
    let _e117 = muladd_1;
    param_12_3 = _e117;
    let _e119 = mulsub_1;
    param_13_3 = _e119;
    let _e121 = mul_1;
    param_14_3 = _e121;
    let _e123 = add_1;
    param_15_3 = _e123;
    let _e133 = combiner_equation((&param_12_3), (&param_13_3), (&param_14_3), (&param_15_3));
    _5198_ = _e133;
    let _e135 = _5198_;
    combined_1 = _e135;
    let _e137 = alpha_test_1;
    if _e137 {
        {
            let _e138 = combined_1;
            param_16_3 = _e138.w;
            let _e141 = param_16_3;
            let _e142 = clamp_9bit_1(_e141);
            clamped_alpha = _e142;
            let _e144 = clamped_alpha;
            let _e145 = clamped_alpha;
            expanded_alpha_1 = (_e144 + ((_e145 + 1i) >> 8u));
            let _e153 = alpha_cvg_select_3;
            if _e153 {
                {
                    let _e155 = cvg_times_alpha_3;
                    if _e155 {
                        {
                            let _e156 = expanded_alpha_1;
                            let _e157 = coverage_1_6;
                            modulated_alpha_1 = (((_e156 * _e157) + 4i) >> 3u);
                        }
                    } else {
                        {
                            let _e164 = coverage_1_6;
                            modulated_alpha_1 = (_e164 << 5u);
                        }
                    }
                    let _e168 = modulated_alpha_1;
                    expanded_alpha_1 = _e168;
                }
            } else {
                {
                    let _e169 = expanded_alpha_1;
                    let _e170 = alpha_dith_3;
                    expanded_alpha_1 = (_e169 + _e170);
                }
            }
            let _e172 = expanded_alpha_1;
            (*alpha_test_reference) = clamp(_e172, 0i, 255i);
        }
    } else {
        {
            (*alpha_test_reference) = 0i;
        }
    }
    let _e177 = combined_1;
    return _e177;
}

fn noise_get_blend_threshold() -> i32 {
    let _e48 = seeded_noise;
    return (_e48 & 255i);
}

fn shade_pixel(x_8: i32, y_4: i32, primitive_index: u32, shaded: ptr<function, ShadedData>) -> bool {
    var x_9: i32;
    var y_5: i32;
    var primitive_index_1: u32;
    var param_17: u32;
    var span_offsets_1_: SpanInfoOffsetsMem;
    var _5336_: bool;
    var _5347_: bool;
    var setup_flags: u32;
    var param_1_12: u32;
    var span_setup: SpanSetup;
    var setup_tile: u32;
    var param_2_9: u32;
    var attr: AttributeSetupMem;
    var states: vec4<u32>;
    var static_state_index: u32;
    var tmem_instance_index: u32;
    var param_3_6: u32;
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
    var _5650_: bool;
    var _5657_: bool;
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
    var _5717_: i32;
    var texel0_: i32;
    var _5727_: bool;
    var _5733_: bool;
    var _5746_: bool;
    var _5753_: bool;
    var param_21_1: vec4<i32>;
    var param_22_1: vec4<i32>;
    var param_23_1: i32;
    var coverage_1_7: i32;
    var coverage_count: i32;
    var _5774_: bool;
    var _5780_: bool;
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
    var _5811_: vec4<i32>;
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
    var _5947_: vec4<i32>;
    var valid_line: bool;
    var long_span: bool;
    var _5973_: i32;
    var end_span: bool;
    var stw_7: vec3<i32>;
    var param_67_1: vec3<i32>;
    var st_overflow_3: bool;
    var param_68_1: bool;
    var _6014_: vec2<i32>;
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
    var _6092_: vec4<i32>;
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
    var _6149_: vec4<i32>;
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
    var _6210_: vec4<i32>;
    var combined_inputs_1_: CombinerInputs;
    var param_113_1: CombinerInputs;
    var param_114_1: vec4<i32>;
    var param_115_1: vec4<i32>;
    var param_116_1: i32;
    var param_117_1: i32;
    var param_118_1: bool;
    var param_119_1: bool;
    var _6247_: vec4<i32>;
    var alpha_threshold: i32;

    x_9 = x_8;
    y_5 = y_4;
    primitive_index_1 = primitive_index;
    let _e55 = primitive_index_1;
    param_17 = _e55;
    let _e57 = param_17;
    let _e58 = load_span_offsets(_e57);
    span_offsets_1_ = _e58;
    let _e60 = y_5;
    let _e62 = span_offsets_1_;
    _5336_ = (_e60 < (1i * _e62.ylo));
    let _e68 = _5336_;
    if !(_e68) {
        {
            let _e70 = y_5;
            let _e71 = span_offsets_1_;
            _5347_ = (_e70 > ((_e71.yhi * 1i) + 0i));
        }
    } else {
        {
            let _e78 = _5336_;
            _5347_ = _e78;
        }
    }
    let _e79 = _5347_;
    if _e79 {
        {
            return false;
        }
    }
    let _e81 = primitive_index_1;
    let _e88 = triangle_setup.triangle_setup_raw[((_e81 * 8u) + 7u)];
    setup_flags = ((_e88 >> 16u) & 255u);
    let _e95 = span_offsets_1_;
    let _e98 = y_5;
    let _e100 = span_offsets_1_;
    param_1_12 = u32(((1i * _e95.offset) + (_e98 - (1i * _e100.ylo))));
    let _e107 = param_1_12;
    let _e108 = load_span_setup(_e107);
    span_setup = _e108;
    let _e110 = span_setup;
    if (_e110.valid_line == 0i) {
        {
            return false;
        }
    }
    let _e115 = primitive_index_1;
    let _e122 = triangle_setup.triangle_setup_raw[((_e115 * 8u) + 7u)];
    setup_tile = ((_e122 >> 24u) & 255u);
    let _e128 = primitive_index_1;
    param_2_9 = _e128;
    let _e130 = param_2_9;
    let _e131 = load_attribute_setup(_e130);
    attr = _e131;
    let _e133 = primitive_index_1;
    let _e140 = state_indices.state_indices_raw[((_e133 * 4u) + 0u)];
    let _e143 = primitive_index_1;
    let _e150 = state_indices.state_indices_raw[((_e143 * 4u) + 0u)];
    let _e155 = primitive_index_1;
    let _e162 = state_indices.state_indices_raw[((_e155 * 4u) + 0u)];
    let _e167 = primitive_index_1;
    let _e174 = state_indices.state_indices_raw[((_e167 * 4u) + 0u)];
    states = vec4<u32>((_e140 & 255u), ((_e150 >> 8u) & 255u), ((_e162 >> 16u) & 255u), (_e174 >> 24u));
    let _e179 = states;
    static_state_index = _e179.x;
    let _e182 = states;
    tmem_instance_index = _e182.z;
    let _e185 = static_state_index;
    param_3_6 = _e185;
    let _e187 = param_3_6;
    let _e188 = load_static_rasterization_state(_e187);
    static_state = _e188;
    let _e190 = static_state;
    static_state_flags = _e190.flags;
    let _e193 = static_state;
    static_state_dither = _e193.dither;
    let _e196 = static_state;
    combiner_inputs_rgb0_ = _e196.combiner_inputs_rgb0_;
    let _e199 = static_state;
    combiner_inputs_alpha0_ = _e199.combiner_inputs_alpha0_;
    let _e202 = static_state;
    combiner_inputs_rgb1_ = _e202.combiner_inputs_rgb1_;
    let _e205 = static_state;
    combiner_inputs_alpha1_ = _e205.combiner_inputs_alpha1_;
    let _e208 = static_state_flags;
    tlut_6 = ((_e208 & 16u) != 0u);
    let _e214 = static_state_flags;
    tlut_type_12 = ((_e214 & 32u) != 0u);
    let _e220 = static_state_flags;
    sample_quad_2 = ((_e220 & 16384u) != 0u);
    let _e226 = static_state_flags;
    cvg_times_alpha_4 = ((_e226 & 64u) != 0u);
    let _e232 = static_state_flags;
    alpha_cvg_select_4 = ((_e232 & 128u) != 0u);
    let _e238 = static_state_flags;
    perspective_6 = ((_e238 & 8u) != 0u);
    let _e244 = static_state_flags;
    tex_lod_en_2 = ((_e244 & 512u) != 0u);
    let _e250 = static_state_flags;
    sharpen_lod_en = ((_e250 & 1024u) != 0u);
    let _e256 = static_state_flags;
    detail_lod_en = ((_e256 & 2048u) != 0u);
    let _e262 = static_state_flags;
    aa_enable = ((_e262 & 4u) != 0u);
    let _e268 = static_state_flags;
    multi_cycle = ((_e268 & 256u) != 0u);
    let _e274 = static_state_flags;
    interlace_en = ((_e274 & 1u) != 0u);
    let _e280 = static_state_flags;
    fill_en = ((_e280 & 4096u) != 0u);
    let _e286 = static_state_flags;
    copy_en = ((_e286 & 8192u) != 0u);
    let _e292 = static_state_flags;
    alpha_test_2 = ((_e292 & 32768u) != 0u);
    let _e298 = static_state_flags;
    alpha_test_dither = ((_e298 & 65536u) != 0u);
    let _e304 = static_state_flags;
    mid_texel_1 = ((_e304 & 131072u) != 0u);
    let _e310 = static_state_flags;
    uses_texel0_ = ((_e310 & 262144u) != 0u);
    let _e316 = static_state_flags;
    uses_texel1_ = ((_e316 & 524288u) != 0u);
    let _e322 = static_state_flags;
    uses_pipelined_texel1_ = ((_e322 & 2097152u) != 0u);
    let _e328 = static_state_flags;
    uses_lod_2 = ((_e328 & 1048576u) != 0u);
    let _e334 = static_state_flags;
    convert_one_2 = ((_e334 & 4194304u) != 0u);
    let _e340 = static_state_flags;
    bilerp0_ = ((_e340 & 8388608u) != 0u);
    let _e346 = static_state_flags;
    bilerp1_ = ((_e346 & 16777216u) != 0u);
    let _e352 = static_state_flags;
    if ((_e352 & 268435456u) != 0u) {
        {
            let _e357 = x_9;
            param_4_6 = u32(_e357);
            let _e360 = y_5;
            param_5_6 = u32(_e360);
            let _e363 = primitive_index_1;
            let _e364 = global_constants;
            param_6_6 = (_e363 + _e364.fb_info.base_primitive_index);
            let _e369 = param_4_6;
            let _e370 = param_5_6;
            let _e371 = param_6_6;
            reseed_noise(_e369, _e370, _e371);
        }
    }
    let _e372 = setup_flags;
    flip_2 = ((_e372 & 1u) != 0u);
    let _e378 = copy_en;
    if _e378 {
        {
            let _e379 = x_9;
            let _e380 = span_setup;
            _5650_ = (_e379 >= _e380.start_x);
            let _e385 = _5650_;
            if _e385 {
                {
                    let _e386 = x_9;
                    let _e387 = span_setup;
                    _5657_ = (_e386 <= _e387.end_x);
                }
            } else {
                {
                    let _e390 = _5650_;
                    _5657_ = _e390;
                }
            }
            let _e391 = _5657_;
            valid = _e391;
            let _e393 = valid;
            if !(_e393) {
                {
                    return false;
                }
            }
            let _e396 = span_setup;
            param_7_6 = _e396;
            let _e398 = attr;
            param_8_5 = _e398.dstzw_dx;
            let _e401 = x_9;
            param_9_5 = _e401;
            let _e403 = perspective_6;
            param_10_4 = _e403;
            let _e405 = flip_2;
            param_11_4 = _e405;
            let _e409 = param_7_6;
            let _e410 = param_8_5;
            let _e411 = param_9_5;
            let _e412 = param_10_4;
            let _e413 = param_11_4;
            interpolate_st_copy(_e409, _e410, _e411, _e412, _e413, (&param_12_4), (&param_13_4));
            let _e418 = param_12_4;
            st_34 = _e418;
            let _e420 = param_13_4;
            s_offset_5 = _e420;
            let _e422 = setup_tile;
            tile0_1 = (_e422 & 7u);
            let _e426 = primitive_index_1;
            let _e432 = tile0_1;
            let _e439 = state_indices.state_indices_raw[(((u32(_e426) * 4u) + 2u) + (u32(_e432) / 4u))];
            let _e440 = tile0_1;
            tile_info_index0_ = ((_e439 >> ((u32(_e440) % 4u) * 8u)) & 255u);
            let _e450 = tile_info_index0_;
            param_14_4 = _e450;
            let _e452 = param_14_4;
            let _e453 = load_tile_info(_e452);
            tile_info0_ = _e453;
            let _e455 = tile_info0_;
            param_15_4 = _e455;
            let _e457 = tmem_instance_index;
            param_16_4 = _e457;
            let _e459 = st_34;
            param_17_2 = _e459;
            let _e461 = s_offset_5;
            param_18_1 = _e461;
            let _e463 = tlut_6;
            param_19_1 = _e463;
            let _e465 = tlut_type_12;
            param_20_1 = _e465;
            let _e467 = param_15_4;
            let _e468 = param_16_4;
            let _e470 = param_18_1;
            let _e471 = param_19_1;
            let _e472 = param_20_1;
            let _e474 = sample_texture_copy(_e467, _e468, (&param_17_2), _e470, _e471, _e472);
            _5717_ = _e474;
            let _e476 = _5717_;
            texel0_ = _e476;
            let _e479 = texel0_;
            (*shaded).z_dith = _e479;
            (*shaded).coverage_count = 32i;
            let _e483 = alpha_test_2;
            if _e483 {
                {
                    let _e484 = global_constants;
                    _5727_ = (_e484.fb_info.fb_size == 2i);
                }
            } else {
                {
                    let _e489 = alpha_test_2;
                    _5727_ = _e489;
                }
            }
            let _e491 = _5727_;
            if _e491 {
                {
                    let _e492 = texel0_;
                    _5733_ = ((_e492 & 1i) == 0i);
                }
            } else {
                {
                    let _e497 = _5727_;
                    _5733_ = _e497;
                }
            }
            let _e498 = _5733_;
            if _e498 {
                {
                    return false;
                }
            }
            return true;
        }
    } else {
        {
            let _e501 = fill_en;
            if _e501 {
                {
                    (*shaded).coverage_count = 64i;
                    let _e504 = x_9;
                    let _e505 = span_setup;
                    _5746_ = (_e504 >= _e505.start_x);
                    let _e510 = _5746_;
                    if _e510 {
                        {
                            let _e511 = x_9;
                            let _e512 = span_setup;
                            _5753_ = (_e511 <= _e512.end_x);
                        }
                    } else {
                        {
                            let _e515 = _5746_;
                            _5753_ = _e515;
                        }
                    }
                    let _e516 = _5753_;
                    return _e516;
                }
            }
        }
    }
    let _e517 = span_setup;
    param_21_1 = _e517.xleft;
    let _e520 = span_setup;
    param_22_1 = _e520.xright;
    let _e523 = x_9;
    param_23_1 = _e523;
    let _e525 = param_21_1;
    let _e526 = param_22_1;
    let _e527 = param_23_1;
    let _e528 = compute_coverage(_e525, _e526, _e527);
    coverage_1_7 = _e528;
    let _e530 = coverage_1_7;
    if (_e530 == 0i) {
        {
            return false;
        }
    }
    let _e534 = coverage_1_7;
    coverage_count = countOneBits(_e534);
    let _e537 = aa_enable;
    _5774_ = !(_e537);
    let _e541 = _5774_;
    if _e541 {
        {
            let _e542 = coverage_1_7;
            _5780_ = ((_e542 & 1i) == 0i);
        }
    } else {
        {
            let _e547 = _5774_;
            _5780_ = _e547;
        }
    }
    let _e548 = _5780_;
    if _e548 {
        {
            return false;
        }
    }
    let _e550 = primitive_index_1;
    param_24_1 = _e550;
    let _e552 = param_24_1;
    let _e553 = load_derived_setup(_e552);
    derived = _e553;
    let _e555 = x_9;
    let _e556 = span_setup;
    dx_8 = (_e555 - _e556.interpolation_base_x);
    let _e560 = flip_2;
    if _e560 {
        local_13 = 1i;
    } else {
        local_13 = -1i;
    }
    let _e565 = local_13;
    interpolation_direction = _e565;
    let _e567 = span_setup;
    param_25_1 = _e567.rgba;
    let _e570 = attr;
    param_26_1 = _e570.drgba_dx;
    let _e573 = attr;
    param_27_1 = _e573.drgba_dy;
    let _e576 = dx_8;
    param_28_1 = _e576;
    let _e578 = coverage_1_7;
    param_29_1 = _e578;
    let _e581 = param_26_1;
    let _e582 = param_27_1;
    let _e583 = param_28_1;
    let _e584 = param_29_1;
    let _e586 = interpolate_rgba((&param_25_1), _e581, _e582, _e583, _e584);
    _5811_ = _e586;
    let _e588 = _5811_;
    shade = _e588;
    let _e592 = interpolation_direction;
    tex_interpolation_direction = _e592;
    let _e595 = uses_lod_2;
    if (false && _e595) {
        {
            let _e597 = setup_flags;
            if ((_e597 & 64u) != 0u) {
                {
                    let _e602 = tex_interpolation_direction;
                    tex_interpolation_direction = (_e602 * 1i);
                }
            }
        }
    }
    let _e605 = span_setup;
    param_30_1 = _e605.stzw;
    let _e608 = attr;
    param_31_1 = _e608.dstzw_dx;
    let _e611 = attr;
    param_32_1 = _e611.dstzw_dy;
    let _e614 = dx_8;
    param_33_1 = _e614;
    let _e616 = coverage_1_7;
    param_34_1 = _e616;
    let _e618 = perspective_6;
    param_35_1 = _e618;
    let _e620 = uses_lod_2;
    param_36_1 = _e620;
    let _e622 = tex_interpolation_direction;
    param_37_1 = _e622;
    let _e624 = perspective_overflow_2;
    param_42_1 = _e624;
    let _e630 = param_30_1;
    let _e631 = param_31_1;
    let _e632 = param_32_1;
    let _e633 = param_33_1;
    let _e634 = param_34_1;
    let _e635 = param_35_1;
    let _e636 = param_36_1;
    let _e637 = param_37_1;
    interpolate_stz(_e630, _e631, _e632, _e633, _e634, _e635, _e636, _e637, (&param_38_1), (&param_39_1), (&param_40_1), (&param_41_1), (&param_42_1));
    let _e648 = param_38_1;
    st_1_ = _e648;
    let _e650 = param_39_1;
    st_dx_3 = _e650;
    let _e652 = param_40_1;
    st_dy_3 = _e652;
    let _e654 = param_41_1;
    z_2 = _e654;
    let _e656 = param_42_1;
    perspective_overflow_2 = _e656;
    let _e657 = setup_tile;
    tile0_1_ = (_e657 & 7u);
    let _e661 = tile0_1_;
    tile1_1 = ((_e661 + 1u) & 7u);
    let _e667 = setup_tile;
    max_level_2 = (_e667 >> 3u);
    let _e671 = derived;
    min_lod_2 = _e671.min_lod;
    let _e675 = uses_lod_2;
    if _e675 {
        {
            let _e676 = tile0_1_;
            param_43_1 = _e676;
            let _e678 = tile1_1;
            param_44_1 = _e678;
            let _e680 = max_level_2;
            param_46_1 = _e680;
            let _e682 = min_lod_2;
            param_47_1 = _e682;
            let _e684 = st_1_;
            param_48_1 = _e684;
            let _e686 = st_dx_3;
            param_49_1 = _e686;
            let _e688 = st_dy_3;
            param_50_1 = _e688;
            let _e690 = perspective_overflow_2;
            param_51_1 = _e690;
            let _e692 = tex_lod_en_2;
            param_52_1 = _e692;
            let _e694 = sharpen_lod_en;
            param_53_1 = _e694;
            let _e696 = detail_lod_en;
            param_54_1 = _e696;
            let _e702 = param_46_1;
            let _e703 = param_47_1;
            let _e704 = param_48_1;
            let _e705 = param_49_1;
            let _e706 = param_50_1;
            let _e707 = param_51_1;
            let _e708 = param_52_1;
            let _e709 = param_53_1;
            let _e710 = param_54_1;
            compute_lod_2cycle((&param_43_1), (&param_44_1), (&param_45_1), _e702, _e703, _e704, _e705, _e706, _e707, _e708, _e709, _e710);
            let _e714 = param_43_1;
            tile0_1_ = _e714;
            let _e715 = param_44_1;
            tile1_1 = _e715;
            let _e716 = param_45_1;
            lod_frac_1 = _e716;
        }
    }
    let _e718 = uses_texel0_;
    if _e718 {
        {
            let _e719 = primitive_index_1;
            let _e725 = tile0_1_;
            let _e732 = state_indices.state_indices_raw[(((u32(_e719) * 4u) + 2u) + (u32(_e725) / 4u))];
            let _e733 = tile0_1_;
            tile_info_index0_1_ = ((_e732 >> ((u32(_e733) % 4u) * 8u)) & 255u);
            let _e743 = tile_info_index0_1_;
            param_55_1 = _e743;
            let _e745 = param_55_1;
            let _e746 = load_tile_info(_e745);
            tile_info0_1_ = _e746;
            let _e748 = tile_info0_1_;
            param_56_1 = _e748;
            let _e750 = tmem_instance_index;
            param_57_1 = _e750;
            let _e752 = st_1_;
            param_58_1 = _e752;
            let _e754 = tlut_6;
            param_59_1 = _e754;
            let _e756 = tlut_type_12;
            param_60_1 = _e756;
            let _e758 = sample_quad_2;
            param_61_1 = _e758;
            let _e760 = mid_texel_1;
            param_62_1 = _e760;
            let _e764 = bilerp0_;
            param_64_1 = _e764;
            let _e766 = derived;
            param_65_1 = _e766.factors;
            let _e772 = param_56_1;
            let _e773 = param_57_1;
            let _e775 = param_59_1;
            let _e776 = param_60_1;
            let _e777 = param_61_1;
            let _e778 = param_62_1;
            let _e779 = param_63_1;
            let _e780 = param_64_1;
            let _e781 = param_65_1;
            let _e782 = param_66_1;
            let _e784 = sample_texture(_e772, _e773, (&param_58_1), _e775, _e776, _e777, _e778, _e779, _e780, _e781, _e782);
            _5947_ = _e784;
            let _e786 = _5947_;
            texel0_1_ = _e786;
        }
    }
    let _e787 = uses_pipelined_texel1_;
    if _e787 {
        {
            let _e789 = span_offsets_1_;
            let _e792 = y_5;
            let _e794 = span_offsets_1_;
            let _e808 = span_setups.span_setups_raw[((u32(((1i * _e789.offset) + ((_e792 - (1i * _e794.ylo)) + 1i))) * 16u) + 15u)];
            valid_line = ((_e808 >> 16u) != 0u);
            let _e814 = span_setup;
            long_span = (_e814.lodlength >= 8i);
            let _e820 = flip_2;
            if _e820 {
                {
                    let _e821 = span_setup;
                    _5973_ = _e821.end_x;
                }
            } else {
                {
                    let _e823 = span_setup;
                    _5973_ = _e823.start_x;
                }
            }
            let _e825 = x_9;
            let _e826 = _5973_;
            end_span = (_e825 == _e826);
            let _e829 = end_span;
            let _e830 = long_span;
            let _e832 = valid_line;
            if ((_e829 && _e830) && _e832) {
                {
                    let _e835 = span_offsets_1_;
                    let _e838 = y_5;
                    let _e840 = span_offsets_1_;
                    let _e854 = span_setups.span_setups_raw[((u32(((1i * _e835.offset) + ((_e838 - (1i * _e840.ylo)) + 1i))) * 16u) + 4u)];
                    let _e857 = span_offsets_1_;
                    let _e860 = y_5;
                    let _e862 = span_offsets_1_;
                    let _e878 = span_setups.span_setups_raw[(((u32(((1i * _e857.offset) + ((_e860 - (1i * _e862.ylo)) + 1i))) * 16u) + 4u) + 1u)];
                    let _e881 = span_offsets_1_;
                    let _e884 = y_5;
                    let _e886 = span_offsets_1_;
                    let _e902 = span_setups.span_setups_raw[(((u32(((1i * _e881.offset) + ((_e884 - (1i * _e886.ylo)) + 1i))) * 16u) + 4u) + 2u)];
                    let _e905 = span_offsets_1_;
                    let _e908 = y_5;
                    let _e910 = span_offsets_1_;
                    let _e926 = span_setups.span_setups_raw[(((u32(((1i * _e905.offset) + ((_e908 - (1i * _e910.ylo)) + 1i))) * 16u) + 4u) + 3u)];
                    stw_7 = (vec4<i32>(i32(_e854), i32(_e878), i32(_e902), i32(_e926)).xyw >> vec3(16u));
                    let _e936 = perspective_6;
                    if _e936 {
                        {
                            let _e937 = stw_7;
                            param_67_1 = _e937;
                            let _e940 = st_overflow_3;
                            param_68_1 = _e940;
                            let _e942 = param_67_1;
                            let _e945 = perspective_divide(_e942, (&param_68_1));
                            _6014_ = _e945;
                            let _e947 = param_68_1;
                            st_overflow_3 = _e947;
                            let _e948 = _6014_;
                            st_1_ = _e948;
                        }
                    } else {
                        {
                            let _e949 = stw_7;
                            param_69_1 = _e949;
                            let _e951 = param_69_1;
                            let _e952 = no_perspective_divide(_e951);
                            st_1_ = _e952;
                        }
                    }
                }
            } else {
                {
                    let _e953 = span_setup;
                    param_70_1 = _e953.stzw;
                    let _e956 = attr;
                    param_71_1 = _e956.dstzw_dx;
                    let _e959 = dx_8;
                    let _e960 = interpolation_direction;
                    param_72_1 = (_e959 + (_e960 * 1i));
                    let _e965 = perspective_6;
                    param_73_1 = _e965;
                    let _e967 = param_70_1;
                    let _e968 = param_71_1;
                    let _e969 = param_72_1;
                    let _e970 = param_73_1;
                    let _e971 = interpolate_st_single(_e967, _e968, _e969, _e970);
                    st_1_ = _e971;
                }
            }
            let _e972 = tile0_1_;
            tile1_1 = _e972;
            uses_texel1_ = true;
        }
    }
    let _e975 = uses_texel1_;
    if _e975 {
        {
            let _e976 = convert_one_2;
            let _e977 = bilerp1_;
            if (_e976 && !(_e977)) {
                {
                    let _e980 = texel0_1_;
                    param_74_1 = _e980;
                    let _e982 = derived;
                    param_75_1 = _e982.factors;
                    let _e985 = param_74_1;
                    let _e986 = param_75_1;
                    let _e987 = texture_convert_factors(_e985, _e986);
                    texel1_ = _e987;
                }
            } else {
                {
                    let _e988 = primitive_index_1;
                    let _e994 = tile1_1;
                    let _e1001 = state_indices.state_indices_raw[(((u32(_e988) * 4u) + 2u) + (u32(_e994) / 4u))];
                    let _e1002 = tile1_1;
                    tile_info_index1_ = ((_e1001 >> ((u32(_e1002) % 4u) * 8u)) & 255u);
                    let _e1012 = tile_info_index1_;
                    param_76_1 = _e1012;
                    let _e1014 = param_76_1;
                    let _e1015 = load_tile_info(_e1014);
                    tile_info1_ = _e1015;
                    let _e1017 = tile_info1_;
                    param_77_1 = _e1017;
                    let _e1019 = tmem_instance_index;
                    param_78_1 = _e1019;
                    let _e1021 = st_1_;
                    param_79_1 = _e1021;
                    let _e1023 = tlut_6;
                    param_80_1 = _e1023;
                    let _e1025 = tlut_type_12;
                    param_81_1 = _e1025;
                    let _e1027 = sample_quad_2;
                    param_82_1 = _e1027;
                    let _e1029 = mid_texel_1;
                    param_83_1 = _e1029;
                    let _e1031 = convert_one_2;
                    param_84_1 = _e1031;
                    let _e1033 = bilerp1_;
                    param_85_1 = _e1033;
                    let _e1035 = derived;
                    param_86_1 = _e1035.factors;
                    let _e1038 = texel0_1_;
                    param_87_1 = _e1038;
                    let _e1040 = param_77_1;
                    let _e1041 = param_78_1;
                    let _e1043 = param_80_1;
                    let _e1044 = param_81_1;
                    let _e1045 = param_82_1;
                    let _e1046 = param_83_1;
                    let _e1047 = param_84_1;
                    let _e1048 = param_85_1;
                    let _e1049 = param_86_1;
                    let _e1050 = param_87_1;
                    let _e1052 = sample_texture(_e1040, _e1041, (&param_79_1), _e1043, _e1044, _e1045, _e1046, _e1047, _e1048, _e1049, _e1050);
                    _6092_ = _e1052;
                    let _e1054 = _6092_;
                    texel1_ = _e1054;
                }
            }
        }
    }
    let _e1055 = x_9;
    param_88_1 = _e1055;
    let _e1057 = y_5;
    let _e1058 = interlace_en;
    param_89_1 = (_e1057 >> u32(select(0i, 1i, _e1058)));
    let _e1065 = static_state_dither;
    param_90_1 = (_e1065 >> 2u);
    let _e1070 = static_state_dither;
    param_91_1 = (_e1070 & 3i);
    let _e1076 = param_88_1;
    let _e1077 = param_89_1;
    let _e1078 = param_90_1;
    let _e1079 = param_91_1;
    dither_coefficients(_e1076, _e1077, _e1078, _e1079, (&param_92_1), (&param_93_1));
    let _e1084 = param_92_1;
    rgb_dith = _e1084;
    let _e1086 = param_93_1;
    alpha_dith_4 = _e1086;
    let _e1090 = multi_cycle;
    if _e1090 {
        {
            let _e1091 = derived;
            let _e1093 = derived;
            let _e1095 = derived;
            let _e1097 = derived;
            let _e1099 = shade;
            let _e1102 = texel0_1_;
            let _e1103 = texel1_;
            let _e1104 = lod_frac_1;
            let _e1105 = noise_get_combiner();
            combined_inputs = CombinerInputs(_e1091.constant_muladd0_, _e1093.constant_mulsub0_, _e1095.constant_mul0_, _e1097.constant_add0_, _e1099, vec4(0i), _e1102, _e1103, _e1104, _e1105);
            let _e1108 = combined_inputs;
            param_94_1 = _e1108;
            let _e1110 = combiner_inputs_rgb0_;
            param_95_1 = _e1110;
            let _e1112 = combiner_inputs_alpha0_;
            param_96_1 = _e1112;
            let _e1114 = alpha_dith_4;
            param_97_1 = _e1114;
            let _e1116 = coverage_count;
            param_98_1 = _e1116;
            let _e1118 = cvg_times_alpha_4;
            param_99_1 = _e1118;
            let _e1120 = alpha_cvg_select_4;
            param_100_1 = _e1120;
            let _e1122 = alpha_test_2;
            param_101_1 = _e1122;
            let _e1125 = param_94_1;
            let _e1126 = param_95_1;
            let _e1127 = param_96_1;
            let _e1128 = param_97_1;
            let _e1129 = param_98_1;
            let _e1130 = param_99_1;
            let _e1131 = param_100_1;
            let _e1132 = param_101_1;
            let _e1135 = combiner_cycle0_(_e1125, _e1126, _e1127, _e1128, _e1129, _e1130, _e1131, _e1132, (&param_102_1));
            _6149_ = _e1135;
            let _e1137 = param_102_1;
            alpha_reference = _e1137;
            let _e1139 = _6149_;
            combined_inputs.combined = _e1139;
            let _e1141 = derived;
            combined_inputs.constant_muladd = _e1141.constant_muladd1_;
            let _e1144 = derived;
            combined_inputs.constant_mulsub = _e1144.constant_mulsub1_;
            let _e1147 = derived;
            combined_inputs.constant_mul = _e1147.constant_mul1_;
            let _e1150 = derived;
            combined_inputs.constant_add = _e1150.constant_add1_;
            let _e1152 = combined_inputs;
            tmp_texel = _e1152.texel0_;
            let _e1156 = combined_inputs;
            combined_inputs.texel0_ = _e1156.texel1_;
            let _e1159 = tmp_texel;
            combined_inputs.texel1_ = _e1159;
            let _e1160 = static_state_flags;
            if ((_e1160 & 33554432u) != 0u) {
                {
                    let _e1165 = x_9;
                    param_103_1 = u32((_e1165 + 1023i));
                    let _e1170 = y_5;
                    param_104_1 = u32((_e1170 + 7i));
                    let _e1175 = primitive_index_1;
                    let _e1176 = global_constants;
                    param_105_1 = ((_e1175 + _e1176.fb_info.base_primitive_index) + 11u);
                    let _e1183 = param_103_1;
                    let _e1184 = param_104_1;
                    let _e1185 = param_105_1;
                    reseed_noise(_e1183, _e1184, _e1185);
                    let _e1187 = noise_get_combiner();
                    combined_inputs._noise = _e1187;
                }
            }
            let _e1188 = combined_inputs;
            param_106_1 = _e1188;
            let _e1190 = combiner_inputs_rgb1_;
            param_107_1 = _e1190;
            let _e1192 = combiner_inputs_alpha1_;
            param_108_1 = _e1192;
            let _e1194 = alpha_dith_4;
            param_109_1 = _e1194;
            let _e1196 = coverage_count;
            param_110_1 = _e1196;
            let _e1198 = cvg_times_alpha_4;
            param_111_1 = _e1198;
            let _e1200 = alpha_cvg_select_4;
            param_112_1 = _e1200;
            let _e1202 = param_106_1;
            let _e1203 = param_107_1;
            let _e1204 = param_108_1;
            let _e1205 = param_109_1;
            let _e1207 = param_111_1;
            let _e1208 = param_112_1;
            let _e1210 = combiner_cycle1_(_e1202, _e1203, _e1204, _e1205, (&param_110_1), _e1207, _e1208);
            _6210_ = _e1210;
            let _e1212 = param_110_1;
            coverage_count = _e1212;
            let _e1213 = _6210_;
            combined_2 = vec4<i32>(_e1213);
        }
    } else {
        {
            let _e1215 = derived;
            let _e1217 = derived;
            let _e1219 = derived;
            let _e1221 = derived;
            let _e1223 = shade;
            let _e1226 = texel0_1_;
            let _e1227 = texel1_;
            let _e1228 = lod_frac_1;
            let _e1229 = noise_get_combiner();
            combined_inputs_1_ = CombinerInputs(_e1215.constant_muladd1_, _e1217.constant_mulsub1_, _e1219.constant_mul1_, _e1221.constant_add1_, _e1223, vec4(0i), _e1226, _e1227, _e1228, _e1229);
            let _e1232 = combined_inputs_1_;
            param_113_1 = _e1232;
            let _e1234 = combiner_inputs_rgb1_;
            param_114_1 = _e1234;
            let _e1236 = combiner_inputs_alpha1_;
            param_115_1 = _e1236;
            let _e1238 = alpha_dith_4;
            param_116_1 = _e1238;
            let _e1240 = coverage_count;
            param_117_1 = _e1240;
            let _e1242 = cvg_times_alpha_4;
            param_118_1 = _e1242;
            let _e1244 = alpha_cvg_select_4;
            param_119_1 = _e1244;
            let _e1246 = param_113_1;
            let _e1247 = param_114_1;
            let _e1248 = param_115_1;
            let _e1249 = param_116_1;
            let _e1251 = param_118_1;
            let _e1252 = param_119_1;
            let _e1254 = combiner_cycle1_(_e1246, _e1247, _e1248, _e1249, (&param_117_1), _e1251, _e1252);
            _6247_ = _e1254;
            let _e1256 = param_117_1;
            coverage_count = _e1256;
            let _e1257 = _6247_;
            combined_2 = vec4<i32>(_e1257);
            let _e1259 = combined_2;
            alpha_reference = _e1259.w;
        }
    }
    let _e1261 = aa_enable;
    let _e1262 = coverage_count;
    if (_e1261 && (_e1262 == 0i)) {
        {
            return false;
        }
    }
    let _e1267 = alpha_test_2;
    if _e1267 {
        {
            let _e1269 = alpha_test_dither;
            if _e1269 {
                {
                    let _e1270 = noise_get_blend_threshold();
                    alpha_threshold = _e1270;
                }
            } else {
                {
                    let _e1271 = derived;
                    alpha_threshold = _e1271.blend_color.w;
                }
            }
            let _e1274 = alpha_reference;
            let _e1275 = alpha_threshold;
            if (_e1274 < _e1275) {
                {
                    return false;
                }
            }
        }
    }
    let _e1279 = combined_2;
    (*shaded).combined = _e1279;
    let _e1281 = z_2;
    let _e1285 = rgb_dith;
    (*shaded).z_dith = ((_e1281 << 9u) | _e1285);
    let _e1288 = coverage_count;
    (*shaded).coverage_count = _e1288;
    let _e1290 = shade;
    let _e1292 = alpha_dith_4;
    (*shaded).shade_alpha = min((_e1290.w + _e1292), 255i);
    return true;
}

fn main_1() {
    var work: vec4<u32>;
    var x_10: i32;
    var y_6: i32;
    var tile_instance: u32;
    var primitive_index_2: u32;
    var index_25: u32;
    var param_18: i32;
    var param_1_13: i32;
    var param_2_10: u32;
    var param_3_7: ShadedData;
    var _6355_: bool;
    var shaded_1: ShadedData;
    var coverage_value: i32;
    var _u8v4_: vec4<u32>;

    seeded_noise = 0i;
    let _e50 = gl_WorkGroupID_1;
    let _e54 = tile_work_list.elems[_e50.x];
    work = _e54;
    let _e57 = work;
    let _e61 = gl_LocalInvocationID_1;
    x_10 = i32(((_e57.x * 8u) + _e61.x));
    let _e66 = work;
    let _e70 = gl_LocalInvocationID_1;
    y_6 = i32(((_e66.y * 8u) + _e70.y));
    let _e75 = work;
    tile_instance = _e75.z;
    let _e78 = work;
    primitive_index_2 = _e78.w;
    let _e82 = tile_instance;
    let _e85 = gl_LocalInvocationIndex_1;
    index_25 = ((_e82 * 64u) + _e85);
    let _e88 = x_10;
    param_18 = _e88;
    let _e90 = y_6;
    param_1_13 = _e90;
    let _e92 = primitive_index_2;
    param_2_10 = _e92;
    let _e95 = param_18;
    let _e96 = param_1_13;
    let _e97 = param_2_10;
    let _e100 = shade_pixel(_e95, _e96, _e97, (&param_3_7));
    _6355_ = _e100;
    let _e102 = param_3_7;
    shaded_1 = _e102;
    let _e105 = _6355_;
    if _e105 {
        {
            let _e106 = shaded_1;
            coverage_value = _e106.coverage_count;
            let _e108 = coverage_value;
            if (_e108 <= 8i) {
                {
                    {
                        let _e111 = shaded_1;
                        _u8v4_ = vec4<u32>(vec4<u32>(_e111.combined));
                        let _e116 = index_25;
                        let _e119 = _u8v4_;
                        let _e123 = _u8v4_;
                        let _e130 = _u8v4_;
                        let _e137 = _u8v4_;
                        color.elems[_e116] = ((((_e119.x & 255u) | ((_e123.y & 255u) << 8u)) | ((_e130.z & 255u) << 16u)) | (_e137.w << 24u));
                    }
                    let _e142 = index_25;
                    let _e147 = index_25;
                    let _e152 = shade_alpha.elems[(_e147 >> 2u)];
                    let _e154 = index_25;
                    let _e162 = shaded_1;
                    let _e167 = index_25;
                    shade_alpha.elems[(_e142 >> 2u)] = ((_e152 & ~((255u << ((_e154 & 3u) * 8u)))) | ((u32(_e162.shade_alpha) & 255u) << ((_e167 & 3u) * 8u)));
                    let _e174 = index_25;
                    let _e177 = shaded_1;
                    depth.elems[_e174] = _e177.z_dith;
                }
            } else {
                {
                    let _e179 = coverage_value;
                    if ((_e179 & 32i) != 0i) {
                        {
                            let _e184 = index_25;
                            let _e187 = shaded_1;
                            color.elems[_e184] = u32(_e187.z_dith);
                        }
                    }
                }
            }
        }
    } else {
        {
            coverage_value = -1i;
        }
    }
    let _e192 = index_25;
    let _e195 = coverage_value;
    coverage.elems[_e192] = u32(i32(_e195));
    return;
}

@compute @workgroup_size(8, 8, 1) 
fn main(@builtin(workgroup_id) gl_WorkGroupID: vec3<u32>, @builtin(local_invocation_id) gl_LocalInvocationID: vec3<u32>, @builtin(local_invocation_index) gl_LocalInvocationIndex: u32) {
    gl_WorkGroupID_1 = gl_WorkGroupID;
    gl_LocalInvocationID_1 = gl_LocalInvocationID;
    gl_LocalInvocationIndex_1 = gl_LocalInvocationIndex;
    main_1();
    return;
}
