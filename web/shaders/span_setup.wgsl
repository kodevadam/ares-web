struct TriangleSetup {
    xh: i32,
    xm: i32,
    xl: i32,
    yh: i32,
    ym: i32,
    dxhdy: i32,
    dxmdy: i32,
    dxldy: i32,
    yl: i32,
    flags: i32,
    tile: i32,
}

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

struct ScissorState {
    xlo: i32,
    ylo: i32,
    xhi: i32,
    yhi: i32,
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

struct TriangleSetupBuffer {
    triangle_setup_raw: array<u32>,
}

struct AttributeSetupBuffer {
    elems: array<AttributeSetupMem>,
}

struct ScissorStateBuffer {
    elems: array<vec4<i32>>,
}

struct SpanSetups {
    span_setups_raw: array<u32>,
}

struct UINTERPOLATIONJOBS_BUF {
    uInterpolationJobs_raw: array<vec4<u32>>,
}

@group(0) @binding(0) 
var<storage, read_write> triangle_setup: TriangleSetupBuffer;
@group(0) @binding(1) 
var<storage, read_write> attribute_setup: AttributeSetupBuffer;
@group(0) @binding(2) 
var<storage, read_write> scissor_state: ScissorStateBuffer;
@group(0) @binding(3) 
var<storage, read_write> span_setups: SpanSetups;
@group(1) @binding(0) 
var<storage> uInterpolationJobs_blk: UINTERPOLATIONJOBS_BUF;
var<private> gl_WorkGroupID_1: vec3<u32>;
var<private> gl_LocalInvocationIndex_1: u32;
var<private> gl_GlobalInvocationID_1: vec3<u32>;

fn load_triangle_setup(index: u32) -> TriangleSetup {
    var index_1: u32;

    index_1 = index;
    let _e17 = index_1;
    let _e24 = triangle_setup.triangle_setup_raw[((_e17 * 8u) + 0u)];
    let _e26 = index_1;
    let _e33 = triangle_setup.triangle_setup_raw[((_e26 * 8u) + 1u)];
    let _e35 = index_1;
    let _e42 = triangle_setup.triangle_setup_raw[((_e35 * 8u) + 2u)];
    let _e44 = index_1;
    let _e51 = triangle_setup.triangle_setup_raw[((_e44 * 8u) + 3u)];
    let _e60 = index_1;
    let _e67 = triangle_setup.triangle_setup_raw[((_e60 * 8u) + 3u)];
    let _e73 = index_1;
    let _e80 = triangle_setup.triangle_setup_raw[((_e73 * 8u) + 4u)];
    let _e82 = index_1;
    let _e89 = triangle_setup.triangle_setup_raw[((_e82 * 8u) + 5u)];
    let _e91 = index_1;
    let _e98 = triangle_setup.triangle_setup_raw[((_e91 * 8u) + 6u)];
    let _e100 = index_1;
    let _e107 = triangle_setup.triangle_setup_raw[((_e100 * 8u) + 7u)];
    let _e116 = index_1;
    let _e123 = triangle_setup.triangle_setup_raw[((_e116 * 8u) + 7u)];
    let _e129 = index_1;
    let _e136 = triangle_setup.triangle_setup_raw[((_e129 * 8u) + 7u)];
    return TriangleSetup(i32(_e24), i32(_e33), i32(_e42), i32(((i32(_e51) << 16u) >> 16u)), i32((i32(_e67) >> 16u)), i32(_e80), i32(_e89), i32(_e98), i32(((i32(_e107) << 16u) >> 16u)), i32(((_e123 >> 16u) & 255u)), i32(((_e136 >> 24u) & 255u)));
}

fn load_attribute_setup(index_2: u32) -> AttributeSetupMem {
    var index_3: u32;
    var _124_: AttributeSetupMem;

    index_3 = index_2;
    let _e19 = index_3;
    let _e22 = attribute_setup.elems[_e19];
    _124_.rgba = _e22.rgba;
    let _e25 = index_3;
    let _e28 = attribute_setup.elems[_e25];
    _124_.drgba_dx = _e28.drgba_dx;
    let _e31 = index_3;
    let _e34 = attribute_setup.elems[_e31];
    _124_.drgba_de = _e34.drgba_de;
    let _e37 = index_3;
    let _e40 = attribute_setup.elems[_e37];
    _124_.drgba_dy = _e40.drgba_dy;
    let _e43 = index_3;
    let _e46 = attribute_setup.elems[_e43];
    _124_.stzw = _e46.stzw;
    let _e49 = index_3;
    let _e52 = attribute_setup.elems[_e49];
    _124_.dstzw_dx = _e52.dstzw_dx;
    let _e55 = index_3;
    let _e58 = attribute_setup.elems[_e55];
    _124_.dstzw_de = _e58.dstzw_de;
    let _e61 = index_3;
    let _e64 = attribute_setup.elems[_e61];
    _124_.dstzw_dy = _e64.dstzw_dy;
    let _e66 = _124_;
    return _e66;
}

fn load_scissor_state(index_4: u32) -> ScissorState {
    var index_5: u32;
    var values: vec4<i32>;

    index_5 = index_4;
    let _e17 = index_5;
    let _e20 = scissor_state.elems[_e17];
    values = _e20;
    let _e22 = values;
    let _e24 = values;
    let _e26 = values;
    let _e28 = values;
    return ScissorState(_e22.x, _e24.y, _e26.z, _e28.w);
}

fn interpolate_snapped(dvalue: vec4<i32>, dy: i32) -> vec4<i32> {
    var dvalue_1: vec4<i32>;
    var dy_1: i32;
    var dy_shifted: i32;
    var dy_masked: i32;

    dvalue_1 = dvalue;
    dy_1 = dy;
    let _e19 = dy_1;
    dy_shifted = (_e19 >> 8u);
    let _e24 = dy_1;
    dy_masked = (_e24 & 255i);
    let _e28 = dy_shifted;
    let _e30 = dvalue_1;
    let _e32 = dy_masked;
    let _e34 = dvalue_1;
    return ((vec4(_e28) * _e30) + (vec4(_e32) * (_e34 >> vec4(8u))));
}

fn quantize_x(x: vec4<i32>) -> vec4<i32> {
    var x_1: vec4<i32>;
    var sticky: vec4<i32>;
    var snapped: vec4<i32>;

    x_1 = x;
    let _e17 = x_1;
    sticky = select(vec4(0i), vec4(1i), ((_e17 & vec4(4095i)) != vec4(0i)));
    let _e30 = x_1;
    let _e36 = sticky;
    snapped = vec4<i32>(((_e30 >> vec4(12u)) | _e36));
    let _e40 = snapped;
    return _e40;
}

fn min4_(v: vec4<i32>) -> i32 {
    var v_1: vec4<i32>;
    var v2_: vec2<i32>;

    v_1 = v;
    let _e17 = v_1;
    let _e19 = v_1;
    v2_ = min(_e17.xy, _e19.zw);
    let _e23 = v2_;
    let _e25 = v2_;
    return min(_e23.x, _e25.y);
}

fn max4_(v_2: vec4<i32>) -> i32 {
    var v_3: vec4<i32>;
    var v2_1: vec2<i32>;

    v_3 = v_2;
    let _e17 = v_3;
    let _e19 = v_3;
    v2_1 = max(_e17.xy, _e19.zw);
    let _e23 = v2_1;
    let _e25 = v2_1;
    return max(_e23.x, _e25.y);
}

fn store_span_setup(index_6: u32, setup: SpanSetup) {
    var index_7: u32;
    var setup_1: SpanSetup;
    var _v: vec4<u32>;
    var _v_1: vec4<u32>;

    index_7 = index_6;
    setup_1 = setup;
    let _e19 = index_7;
    let _e31 = setup_1.rgba.x;
    span_setups.span_setups_raw[(((_e19 * 16u) + 0u) + 0u)] = u32(_e31);
    let _e33 = index_7;
    let _e45 = setup_1.rgba.y;
    span_setups.span_setups_raw[(((_e33 * 16u) + 0u) + 1u)] = u32(_e45);
    let _e47 = index_7;
    let _e59 = setup_1.rgba.z;
    span_setups.span_setups_raw[(((_e47 * 16u) + 0u) + 2u)] = u32(_e59);
    let _e61 = index_7;
    let _e73 = setup_1.rgba.w;
    span_setups.span_setups_raw[(((_e61 * 16u) + 0u) + 3u)] = u32(_e73);
    let _e75 = index_7;
    let _e87 = setup_1.stzw.x;
    span_setups.span_setups_raw[(((_e75 * 16u) + 4u) + 0u)] = u32(_e87);
    let _e89 = index_7;
    let _e101 = setup_1.stzw.y;
    span_setups.span_setups_raw[(((_e89 * 16u) + 4u) + 1u)] = u32(_e101);
    let _e103 = index_7;
    let _e115 = setup_1.stzw.z;
    span_setups.span_setups_raw[(((_e103 * 16u) + 4u) + 2u)] = u32(_e115);
    let _e117 = index_7;
    let _e129 = setup_1.stzw.w;
    span_setups.span_setups_raw[(((_e117 * 16u) + 4u) + 3u)] = u32(_e129);
    {
        let _e131 = setup_1;
        _v = vec4<u32>(vec4<u32>(_e131.xleft));
        let _e136 = index_7;
        let _e143 = _v;
        let _e147 = _v;
        span_setups.span_setups_raw[((_e136 * 16u) + 8u)] = ((_e143.x & 65535u) | (_e147.y << 16u));
        let _e152 = index_7;
        let _e161 = _v;
        let _e165 = _v;
        span_setups.span_setups_raw[(((_e152 * 16u) + 8u) + 1u)] = ((_e161.z & 65535u) | (_e165.w << 16u));
    }
    {
        let _e170 = setup_1;
        _v_1 = vec4<u32>(vec4<u32>(_e170.xright));
        let _e175 = index_7;
        let _e182 = _v_1;
        let _e186 = _v_1;
        span_setups.span_setups_raw[((_e175 * 16u) + 10u)] = ((_e182.x & 65535u) | (_e186.y << 16u));
        let _e191 = index_7;
        let _e200 = _v_1;
        let _e204 = _v_1;
        span_setups.span_setups_raw[(((_e191 * 16u) + 10u) + 1u)] = ((_e200.z & 65535u) | (_e204.w << 16u));
    }
    let _e209 = index_7;
    let _e216 = setup_1;
    span_setups.span_setups_raw[((_e209 * 16u) + 12u)] = u32(_e216.interpolation_base_x);
    let _e219 = index_7;
    let _e226 = setup_1;
    span_setups.span_setups_raw[((_e219 * 16u) + 13u)] = u32(_e226.start_x);
    let _e229 = index_7;
    let _e236 = setup_1;
    span_setups.span_setups_raw[((_e229 * 16u) + 14u)] = u32(_e236.end_x);
    let _e239 = index_7;
    let _e246 = index_7;
    let _e253 = span_setups.span_setups_raw[((_e246 * 16u) + 15u)];
    let _e257 = setup_1;
    span_setups.span_setups_raw[((_e239 * 16u) + 15u)] = ((_e253 & 4294901760u) | (u32(_e257.lodlength) & 65535u));
    let _e263 = index_7;
    let _e270 = index_7;
    let _e277 = span_setups.span_setups_raw[((_e270 * 16u) + 15u)];
    let _e280 = setup_1;
    span_setups.span_setups_raw[((_e263 * 16u) + 15u)] = ((_e277 & 65535u) | ((u32(_e280.valid_line) & 65535u) << 16u));
    return;
}

fn main_1() {
    var job_indices: vec3<i32>;
    var primitive_index: i32;
    var base_y: i32;
    var max_y: i32;
    var y: i32;
    var param: u32;
    var setup_2: TriangleSetup;
    var param_1_: u32;
    var attr: AttributeSetupMem;
    var param_2_: u32;
    var scissor: ScissorState;
    var flip: bool;
    var interlace_en: bool;
    var keep_odd_field: bool;
    var do_offset: bool;
    var skip_xfrac: bool;
    var y_interpolation_base: i32;
    var dy_2: i32;
    var xh: i32;
    var drgba_diff: vec4<i32> = vec4(0i);
    var dstzw_diff: vec4<i32> = vec4(0i);
    var drgba_deh: vec4<i32>;
    var drgba_dyh: vec4<i32>;
    var dstzw_deh: vec4<i32>;
    var dstzw_dyh: vec4<i32>;
    var base_x: i32;
    var _462_: i32;
    var xfrac: i32;
    var param_3_: vec4<i32>;
    var param_4_: i32;
    var rgba: vec4<i32>;
    var param_5_: vec4<i32>;
    var param_6_: i32;
    var param_7_: vec4<i32>;
    var param_8_: i32;
    var stzw: vec4<i32>;
    var param_9_: vec4<i32>;
    var param_10_: i32;
    var span_setup: SpanSetup;
    var yh_interpolation_base: i32;
    var ym_interpolation_base: i32;
    var y_sub: i32;
    var y_subs: vec4<i32>;
    var ylo: i32;
    var yhi: i32;
    var clip_lo_y: vec4<bool>;
    var clip_hi_y: vec4<bool>;
    var clip_y: vec4<u32>;
    var xh_1_: vec4<i32>;
    var xm: vec4<i32>;
    var xl: vec4<i32>;
    var param_11_: vec4<i32>;
    var xh_shifted: vec4<i32>;
    var param_12_: vec4<i32>;
    var xl_shifted: vec4<i32>;
    var xleft: vec4<i32>;
    var xright: vec4<i32>;
    var invalid_line: vec4<bool>;
    var lo_scissor: vec4<i32>;
    var hi_scissor: vec4<i32>;
    var all_over: bool;
    var all_under: bool;
    var param_13_: vec4<i32>;
    var start_x: i32;
    var param_14_: vec4<i32>;
    var end_x: i32;
    var _767_: i32;
    var param_15_: u32;
    var param_16_: SpanSetup;

    let _e16 = gl_WorkGroupID_1;
    let _e21 = uInterpolationJobs_blk.uInterpolationJobs_raw[i32(_e16.x)];
    job_indices = vec3<i32>(_e21.xyz);
    let _e25 = job_indices;
    primitive_index = _e25.x;
    let _e28 = job_indices;
    base_y = (_e28.y * 256i);
    let _e33 = job_indices;
    max_y = ((_e33.z * 256i) + 255i);
    let _e41 = base_y;
    let _e42 = gl_LocalInvocationIndex_1;
    y = (_e41 + i32(_e42));
    let _e46 = y;
    let _e47 = max_y;
    if (_e46 > _e47) {
        {
            return;
        }
    }
    let _e49 = primitive_index;
    param = u32(_e49);
    let _e52 = param;
    let _e53 = load_triangle_setup(_e52);
    setup_2 = _e53;
    let _e55 = primitive_index;
    param_1_ = u32(_e55);
    let _e58 = param_1_;
    let _e59 = load_attribute_setup(_e58);
    attr = _e59;
    let _e61 = primitive_index;
    param_2_ = u32(_e61);
    let _e64 = param_2_;
    let _e65 = load_scissor_state(_e64);
    scissor = _e65;
    let _e67 = setup_2;
    flip = ((_e67.flags & 1i) != 0i);
    let _e74 = setup_2;
    interlace_en = ((_e74.flags & 8i) != 0i);
    let _e81 = setup_2;
    keep_odd_field = ((_e81.flags & 16i) != 0i);
    let _e88 = setup_2;
    do_offset = ((_e88.flags & 2i) != 0i);
    let _e95 = setup_2;
    skip_xfrac = ((_e95.flags & 4i) != 0i);
    let _e102 = setup_2;
    y_interpolation_base = (_e102.yh >> 2u);
    let _e108 = y_interpolation_base;
    y_interpolation_base = (_e108 * 256i);
    let _e111 = y;
    let _e112 = y_interpolation_base;
    dy_2 = (_e111 - _e112);
    let _e115 = setup_2;
    let _e119 = dy_2;
    let _e120 = setup_2;
    xh = ((_e115.xh * 256i) + (_e119 * (_e120.dxhdy << 2u)));
    let _e134 = do_offset;
    if _e134 {
        {
            let _e135 = xh;
            let _e137 = setup_2;
            xh = (_e135 + (768i * _e137.dxhdy));
            let _e141 = attr;
            drgba_deh = (_e141.drgba_de & vec4(-512i));
            let _e148 = attr;
            drgba_dyh = (_e148.drgba_dy & vec4(-512i));
            let _e155 = drgba_deh;
            let _e156 = drgba_deh;
            let _e163 = drgba_dyh;
            let _e165 = drgba_dyh;
            drgba_diff = (((_e155 - (_e156 >> vec4(2u))) - _e163) + (_e165 >> vec4(2u)));
            let _e172 = attr;
            dstzw_deh = (_e172.dstzw_de & vec4(-512i));
            let _e179 = attr;
            dstzw_dyh = (_e179.dstzw_dy & vec4(-512i));
            let _e186 = dstzw_deh;
            let _e187 = dstzw_deh;
            let _e194 = dstzw_dyh;
            let _e196 = dstzw_dyh;
            dstzw_diff = (((_e186 - (_e187 >> vec4(2u))) - _e194) + (_e196 >> vec4(2u)));
        }
    }
    let _e203 = xh;
    base_x = (_e203 >> 15u);
    let _e209 = skip_xfrac;
    if _e209 {
        {
            _462_ = 0i;
        }
    } else {
        {
            let _e211 = xh;
            _462_ = ((_e211 >> 7u) & 255i);
        }
    }
    let _e217 = _462_;
    xfrac = _e217;
    let _e219 = attr;
    param_3_ = _e219.drgba_de;
    let _e222 = dy_2;
    param_4_ = _e222;
    let _e224 = attr;
    let _e226 = param_3_;
    let _e227 = param_4_;
    let _e228 = interpolate_snapped(_e226, _e227);
    rgba = (_e224.rgba + _e228);
    let _e231 = attr;
    param_5_ = ((_e231.drgba_dx >> vec4(8u)) & vec4(-2i));
    let _e243 = xfrac;
    param_6_ = _e243;
    let _e245 = rgba;
    let _e250 = drgba_diff;
    let _e252 = param_5_;
    let _e253 = param_6_;
    let _e254 = interpolate_snapped(_e252, _e253);
    rgba = ((((_e245 & vec4(-512i)) + _e250) - _e254) & vec4(-1024i));
    let _e260 = attr;
    param_7_ = _e260.dstzw_de;
    let _e263 = dy_2;
    param_8_ = _e263;
    let _e265 = attr;
    let _e267 = param_7_;
    let _e268 = param_8_;
    let _e269 = interpolate_snapped(_e267, _e268);
    stzw = (_e265.stzw + _e269);
    let _e272 = attr;
    param_9_ = ((_e272.dstzw_dx >> vec4(8u)) & vec4(-2i));
    let _e284 = xfrac;
    param_10_ = _e284;
    let _e286 = stzw;
    let _e291 = dstzw_diff;
    let _e293 = param_9_;
    let _e294 = param_10_;
    let _e295 = interpolate_snapped(_e293, _e294);
    stzw = ((((_e286 & vec4(-512i)) + _e291) - _e295) & vec4(-1024i));
    let _e303 = rgba;
    span_setup.rgba = _e303;
    let _e305 = stzw;
    span_setup.stzw = _e305;
    let _e307 = base_x;
    span_setup.interpolation_base_x = _e307;
    let _e308 = setup_2;
    yh_interpolation_base = (_e308.yh & -4i);
    let _e314 = setup_2;
    ym_interpolation_base = _e314.ym;
    let _e317 = yh_interpolation_base;
    yh_interpolation_base = (_e317 * 256i);
    let _e320 = ym_interpolation_base;
    ym_interpolation_base = (_e320 * 256i);
    let _e323 = y;
    y_sub = (_e323 * 4i);
    let _e327 = y_sub;
    y_subs = (vec4(_e327) + vec4<i32>(0i, 1i, 2i, 3i));
    let _e336 = setup_2;
    let _e338 = scissor;
    ylo = (max(_e336.yh, _e338.ylo) * 256i);
    let _e344 = setup_2;
    let _e346 = scissor;
    yhi = (min(_e344.yl, _e346.yhi) * 256i);
    let _e352 = y_subs;
    let _e353 = ylo;
    clip_lo_y = (_e352 < vec4(_e353));
    let _e357 = y_subs;
    let _e358 = yhi;
    clip_hi_y = (_e357 >= vec4(_e358));
    let _e362 = clip_lo_y;
    let _e368 = clip_hi_y;
    clip_y = (select(vec4(0u), vec4(1u), _e362) | select(vec4(0u), vec4(1u), _e368));
    let _e376 = setup_2;
    let _e381 = y_subs;
    let _e382 = yh_interpolation_base;
    let _e385 = setup_2;
    xh_1_ = (vec4((_e376.xh * 256i)) + ((_e381 - vec4(_e382)) * vec4(_e385.dxhdy)));
    let _e391 = setup_2;
    let _e396 = y_subs;
    let _e397 = yh_interpolation_base;
    let _e400 = setup_2;
    xm = (vec4((_e391.xm * 256i)) + ((_e396 - vec4(_e397)) * vec4(_e400.dxmdy)));
    let _e406 = setup_2;
    let _e411 = y_subs;
    let _e412 = ym_interpolation_base;
    let _e415 = setup_2;
    xl = (vec4((_e406.xl * 256i)) + ((_e411 - vec4(_e412)) * vec4(_e415.dxldy)));
    let _e421 = xl;
    let _e422 = xm;
    let _e423 = y_subs;
    let _e425 = setup_2;
    xl = select(_e421, _e422, (_e423 < vec4((256i * _e425.ym))));
    let _e431 = xl;
    xl = extractBits(_e431, 0u, 32u);
    let _e437 = xh_1_;
    xh_1_ = extractBits(_e437, 0u, 32u);
    let _e443 = xh_1_;
    param_11_ = _e443;
    let _e445 = param_11_;
    let _e446 = quantize_x(_e445);
    xh_shifted = _e446;
    let _e448 = xl;
    param_12_ = _e448;
    let _e450 = param_12_;
    let _e451 = quantize_x(_e450);
    xl_shifted = _e451;
    let _e455 = flip;
    if _e455 {
        {
            let _e456 = xh_shifted;
            xleft = _e456;
            let _e457 = xl_shifted;
            xright = _e457;
        }
    } else {
        {
            let _e458 = xl_shifted;
            xleft = _e458;
            let _e459 = xh_shifted;
            xright = _e459;
        }
    }
    let _e460 = xleft;
    let _e466 = xright;
    invalid_line = ((_e460 >> vec4(1u)) > (_e466 >> vec4(1u)));
    let _e475 = scissor;
    lo_scissor = vec4((256i * (_e475.xlo << 1u)));
    let _e484 = scissor;
    hi_scissor = vec4((256i * (_e484.xhi << 1u)));
    let _e492 = xleft;
    let _e493 = xright;
    let _e495 = hi_scissor;
    all_over = all((min(_e492, _e493) >= _e495));
    let _e499 = xleft;
    let _e500 = xright;
    let _e502 = lo_scissor;
    all_under = all((max(_e499, _e500) < _e502));
    let _e506 = xleft;
    let _e507 = lo_scissor;
    xleft = max(_e506, _e507);
    let _e509 = xleft;
    let _e510 = hi_scissor;
    xleft = min(_e509, _e510);
    let _e512 = xright;
    let _e513 = lo_scissor;
    xright = max(_e512, _e513);
    let _e515 = xright;
    let _e516 = hi_scissor;
    xright = min(_e515, _e516);
    let _e518 = invalid_line;
    let _e524 = clip_y;
    invalid_line = ((select(vec4(0u), vec4(1u), _e518) | _e524) != vec4(0u));
    let _e529 = xleft;
    let _e532 = invalid_line;
    xleft = select(_e529, vec4(65535i), _e532);
    let _e534 = xright;
    let _e537 = invalid_line;
    xright = select(_e534, vec4(0i), _e537);
    let _e539 = xleft;
    param_13_ = _e539;
    let _e541 = param_13_;
    let _e542 = min4_(_e541);
    start_x = (_e542 >> 3u);
    let _e547 = xright;
    param_14_ = _e547;
    let _e549 = param_14_;
    let _e550 = max4_(_e549);
    end_x = (_e550 >> 3u);
    let _e556 = xleft;
    span_setup.xleft = _e556;
    let _e558 = xright;
    span_setup.xright = _e558;
    let _e560 = start_x;
    span_setup.start_x = _e560;
    let _e562 = end_x;
    span_setup.end_x = _e562;
    let _e564 = invalid_line;
    let _e567 = all_over;
    let _e570 = all_under;
    span_setup.valid_line = select(0i, 1i, ((!(all(_e564)) && !(_e567)) && !(_e570)));
    let _e576 = interlace_en;
    if _e576 {
        {
            let _e577 = y;
            let _e583 = keep_odd_field;
            if (((_e577 >> 8u) & 1i) != select(0i, 1i, _e583)) {
                {
                    span_setup.valid_line = 0i;
                }
            }
        }
    }
    let _e591 = flip;
    if _e591 {
        {
            let _e592 = end_x;
            let _e593 = span_setup;
            _767_ = (_e592 - _e593.interpolation_base_x);
        }
    } else {
        {
            let _e596 = span_setup;
            let _e598 = start_x;
            _767_ = (_e596.interpolation_base_x - _e598);
        }
    }
    let _e601 = _767_;
    span_setup.lodlength = _e601;
    let _e603 = gl_GlobalInvocationID_1;
    param_15_ = _e603.x;
    let _e606 = span_setup;
    param_16_ = _e606;
    let _e608 = param_15_;
    let _e609 = param_16_;
    store_span_setup(_e608, _e609);
    return;
}

@compute @workgroup_size(64, 1, 1) 
fn main(@builtin(workgroup_id) gl_WorkGroupID: vec3<u32>, @builtin(local_invocation_index) gl_LocalInvocationIndex: u32, @builtin(global_invocation_id) gl_GlobalInvocationID: vec3<u32>) {
    gl_WorkGroupID_1 = gl_WorkGroupID;
    gl_LocalInvocationIndex_1 = gl_LocalInvocationIndex;
    gl_GlobalInvocationID_1 = gl_GlobalInvocationID;
    main_1();
    return;
}
