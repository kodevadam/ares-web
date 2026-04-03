// tile_binning.wgsl — complete port of paraLLEl-RDP tile_binning_combined.comp
//
// CPU→GPU interface
// -----------------
// TriangleSetupMem is a 32-byte packed struct with mixed i16/u8 fields.
// We declare its SSBO as array<u32> and unpack fields using bit operations,
// preserving the exact C-struct byte layout without changing the host side.
//
// TriangleSetupMem layout (8 u32 words per element, little-endian host):
//   word 0 : xh     (i32)
//   word 1 : xm     (i32)
//   word 2 : xl     (i32)
//   word 3 : yh (i16 @ bits 0-15) | ym (i16 @ bits 16-31)
//   word 4 : dxhdy  (i32)
//   word 5 : dxmdy  (i32)
//   word 6 : dxldy  (i32)
//   word 7 : yl (i16 @ bits 0-15) | flags (u8 @ bits 16-23) | tile (u8 @ bits 24-31)
//
// Spec constants frozen for non-upscaling:
//   TILE_WIDTH=8, TILE_HEIGHT=8, MAX_PRIMITIVES=256,
//   MAX_WIDTH=1024, SCALE_FACTOR=1, TILE_INSTANCE_STRIDE=32768

// ---------------------------------------------------------------------------
// Constants (spirv-opt frozen defaults for non-upscaling 1× render)
// ---------------------------------------------------------------------------
const SCALE_FACTOR       : i32 = 1;
const TILE_WIDTH         : i32 = 8;
const TILE_HEIGHT        : i32 = 8;
const MAX_PRIMITIVES     : i32 = 256;
const MAX_WIDTH          : i32 = 1024;
const MAX_TILES_X        : i32 = MAX_WIDTH / TILE_WIDTH;         // 128
const TILE_BINNING_STRIDE: i32 = MAX_PRIMITIVES / 32;            //   8
const META_W             : i32 = TILE_WIDTH  * 8;                //  64
const META_H             : i32 = TILE_HEIGHT * 4;                //  32
const TRI_STRIDE         : u32 = 8u;   // 32-byte struct / 4 bytes = 8 u32s

// ---------------------------------------------------------------------------
// Structs
// ---------------------------------------------------------------------------
struct TriangleSetup {
    xh: i32, xm: i32, xl: i32,
    yh: i32, ym: i32,
    dxhdy: i32, dxmdy: i32, dxldy: i32,
    yl: i32, flags: i32, tile: i32,
}

struct ScissorState { xlo: i32, ylo: i32, xhi: i32, yhi: i32 }

struct Registers {
    resolution     : vec2<u32>,
    primitive_count: i32,
    _pad           : i32,
}

// ---------------------------------------------------------------------------
// Bindings
// ---------------------------------------------------------------------------
// binding(0): TriangleSetupMem SSBO — raw u32 words (8 per element)
@group(0) @binding(0) var<storage, read>       triangle_setup_raw : array<u32>;
// binding(1): ScissorState SSBO — already 4×i32, no sub-word fields
@group(0) @binding(1) var<storage, read>       scissor_state_raw  : array<vec4<i32>>;
// binding(3): fine tile bitmask output
@group(0) @binding(3) var<storage, read_write> tile_bitmask       : array<u32>;
// binding(4): coarse tile bitmask (needs atomics)
@group(0) @binding(4) var<storage, read_write> tile_bitmask_coarse: array<atomic<u32>>;
// push-constant replacement
@group(2) @binding(0) var<uniform>             fb_info            : Registers;

// ---------------------------------------------------------------------------
// Workgroup shared memory
// ---------------------------------------------------------------------------
var<workgroup> merged_mask_shared: atomic<u32>;

// ---------------------------------------------------------------------------
// Loaders
// ---------------------------------------------------------------------------
fn load_triangle_setup(index: u32) -> TriangleSetup {
    let b  = index * TRI_STRIDE;
    let w3 = triangle_setup_raw[b + 3u];
    let w7 = triangle_setup_raw[b + 7u];
    return TriangleSetup(
        bitcast<i32>(triangle_setup_raw[b + 0u]),   // xh     (i32)
        bitcast<i32>(triangle_setup_raw[b + 1u]),   // xm     (i32)
        bitcast<i32>(triangle_setup_raw[b + 2u]),   // xl     (i32)
        (i32(w3) << 16) >> 16,                      // yh  = i16 @ bits  0-15 (sign-extend)
        i32(w3) >> 16,                               // ym  = i16 @ bits 16-31 (sign-extend)
        bitcast<i32>(triangle_setup_raw[b + 4u]),   // dxhdy  (i32)
        bitcast<i32>(triangle_setup_raw[b + 5u]),   // dxmdy  (i32)
        bitcast<i32>(triangle_setup_raw[b + 6u]),   // dxldy  (i32)
        (i32(w7) << 16) >> 16,                      // yl    = i16 @ bits  0-15
        i32((w7 >> 16u) & 0xFFu),                   // flags = u8  @ bits 16-23
        i32((w7 >> 24u) & 0xFFu),                   // tile  = u8  @ bits 24-31
    );
}

fn load_scissor_state(index: u32) -> ScissorState {
    let v = scissor_state_raw[index];
    return ScissorState(v.x, v.y, v.z, v.w);
}

// ---------------------------------------------------------------------------
// 64-bit arithmetic — emulate GLSL imulExtended + uaddCarry
// (WGSL has no i64, so we use 16-bit half-word decomposition)
// ---------------------------------------------------------------------------
struct MulExt4 { lo: vec4<i32>, hi: vec4<i32> }

// Upper 32 bits of signed 32×32 → 64-bit product
fn imul32_hi(a: i32, b: i32) -> i32 {
    let ua = u32(a);
    let ub = u32(b);
    let a0 = ua & 0xFFFFu;  let a1 = ua >> 16u;
    let b0 = ub & 0xFFFFu;  let b1 = ub >> 16u;
    let p00 = a0 * b0;
    let p01 = a0 * b1;
    let p10 = a1 * b0;
    let p11 = a1 * b1;
    let mid = (p00 >> 16u) + p01 + p10;
    let hi  = p11 + (mid >> 16u);
    // Signed correction: if a<0, subtract ub; if b<0, subtract ua
    return i32(hi - select(0u, ub, a < 0) - select(0u, ua, b < 0));
}

fn imul_extended_v4(a: vec4<i32>, b: i32) -> MulExt4 {
    return MulExt4(
        a * b,
        vec4<i32>(imul32_hi(a.x, b), imul32_hi(a.y, b),
                  imul32_hi(a.z, b), imul32_hi(a.w, b)),
    );
}

// uaddCarry for vec4<u32> + scalar; returns [0]=sum, [1]=carry
fn uadd_carry_v4(a: vec4<u32>, b: u32) -> array<vec4<u32>, 2> {
    let s = a + vec4<u32>(b);
    return array<vec4<u32>, 2>(
        s,
        vec4<u32>(select(0u, 1u, s.x < a.x), select(0u, 1u, s.y < a.y),
                  select(0u, 1u, s.z < a.z), select(0u, 1u, s.w < a.w)),
    );
}

// GLSL:  ivec4 lo = madd_32_64(a, b, c, /*out*/ hi_bits)
fn madd_32_64(a: vec4<i32>, b: i32, c: i32) -> MulExt4 {
    let mul = imul_extended_v4(a, b);
    let ac  = uadd_carry_v4(vec4<u32>(mul.lo), u32(c));
    return MulExt4(vec4<i32>(ac[0]), mul.hi + vec4<i32>(ac[1]));
}

// ---------------------------------------------------------------------------
// Geometry helpers
// ---------------------------------------------------------------------------
fn quantize_x(x: vec4<i32>) -> vec4<i32> { return x >> vec4<u32>(15u); }

fn maximum4(v: vec4<i32>) -> i32 {
    let m = max(v.xy, v.zw);
    return max(m.x, m.y);
}
fn minimum4(v: vec4<i32>) -> i32 {
    let m = min(v.xy, v.zw);
    return min(m.x, m.y);
}

fn interpolate_xs(setup: TriangleSetup, ys: vec4<i32>, flip: bool, scaling: i32) -> vec2<i32> {
    let yh_base = (setup.yh & -4) * scaling;
    let ym_base =  setup.ym      * scaling;

    let xh_res = madd_32_64(ys - vec4<i32>(yh_base), setup.dxhdy, scaling * setup.xh);
    var xh     = xh_res.lo;
    let xh_hi  = xh_res.hi;

    let xm_res = madd_32_64(ys - vec4<i32>(yh_base), setup.dxmdy, scaling * setup.xm);
    let xm_lo  = xm_res.lo;
    let xm_hi  = xm_res.hi;

    let xl_res = madd_32_64(ys - vec4<i32>(ym_base), setup.dxldy, scaling * setup.xl);
    var xl     = xl_res.lo;
    let xl_hi  = xl_res.hi;

    // Below ym: use xm branch
    let below_ym = vec4<bool>(ys.x < scaling * setup.ym, ys.y < scaling * setup.ym, ys.z < scaling * setup.ym, ys.w < scaling * setup.ym);
    xl = select(xl, xm_lo, below_ym);

    // Saturate overflowing values to INT_MAX / INT_MIN
    xh = select(xh, vec4<i32>( 2147483647),       xh_hi > vec4<i32>(0));
    xh = select(xh, vec4<i32>(i32(0x80000000u)), xh_hi < vec4<i32>(-1));
    xl = select(xl, vec4<i32>( 2147483647),       xl_hi > vec4<i32>(0));
    xl = select(xl, vec4<i32>(i32(0x80000000u)), xl_hi < vec4<i32>(-1));

    let xh_shifted = quantize_x(xh);
    let xl_shifted = quantize_x(xl);

    var xleft: vec4<i32>; var xright: vec4<i32>;
    if flip { xleft = xh_shifted; xright = xl_shifted; }
    else    { xleft = xl_shifted; xright = xh_shifted; }

    if maximum4(max(abs(xleft), abs(xright))) <= (2047 * scaling) {
        return vec2<i32>(minimum4(xleft), maximum4(xright));
    }
    return vec2<i32>(0, 2147483647);
}

fn bin_primitive(
    setup  : TriangleSetup,
    lo     : ptr<function, vec2<i32>>,
    hi     : ptr<function, vec2<i32>>,
    scaling: i32,
    scissor: ScissorState,
) -> bool {
    (*lo).y = max((*lo).y, scaling * (scissor.ylo >> 2));
    (*hi).y = min((*hi).y, scaling * ((scissor.yhi + 3) >> 2) - 1);

    var start_y = (*lo).y * 4;
    var end_y   = (*hi).y * 4 + 3;
    start_y = max(start_y, scaling * setup.yh);
    end_y   = min(end_y,   scaling * setup.yl - 1);
    if end_y < start_y { return false; }

    let flip = (setup.flags & 1) != 0;
    let ys   = vec4<i32>(
        start_y, end_y,
        clamp(setup.ym * scaling - 1, start_y, end_y),
        clamp(setup.ym * scaling,     start_y, end_y),
    );

    var x_range = interpolate_xs(setup, ys, flip, scaling);
    let x_bias   = select(3, 4, (setup.flags & 128) != 0);
    let sx       = vec2<i32>(
        scaling * (scissor.xlo >> 2),
        scaling * ((scissor.xhi + x_bias) >> 2) - 1,
    );
    x_range   = clamp(x_range, sx.xx, sx.yy);
    x_range.x = max(x_range.x, (*lo).x);
    x_range.y = min(x_range.y, (*hi).x);
    return x_range.x <= x_range.y;
}

// ---------------------------------------------------------------------------
// Entry point
// ---------------------------------------------------------------------------
@compute @workgroup_size(32, 1, 1)
fn main(
    @builtin(workgroup_id)           wg_id      : vec3<u32>,
    @builtin(local_invocation_index) local_index: u32,
) {
    let group_index = i32(wg_id.x);
    let meta_tile   = vec2<i32>(wg_id.yz);  // y→meta_tile.x, z→meta_tile.y

    // Map thread (0-31) to one fine tile within the 8×4 meta-tile
    let inner_x = i32(local_index & 7u);
    let inner_y = i32(local_index >> 3u);
    let tile     = meta_tile * vec2<i32>(8, 4) + vec2<i32>(inner_x, inner_y);
    let lin_tile = tile.y * MAX_TILES_X + tile.x;

    let base_meta = meta_tile * vec2<i32>(META_W, META_H);
    let end_meta  = min(base_meta + vec2<i32>(META_W, META_H),
                        vec2<i32>(fb_info.resolution)) - vec2<i32>(1);
    let base      = tile * vec2<i32>(TILE_WIDTH, TILE_HEIGHT);
    let end_tile  = min(base + vec2<i32>(TILE_WIDTH, TILE_HEIGHT),
                        vec2<i32>(fb_info.resolution)) - vec2<i32>(1);

    let prim_count = fb_info.primitive_count;

    // ── Phase 1: clear shared merge mask ─────────────────────────────────────
    if local_index == 0u { atomicStore(&merged_mask_shared, 0u); }
    workgroupBarrier();

    // ── Phase 2: each thread tests its assigned primitive vs. the META-tile ──
    var binned = false;
    if local_index < 32u {
        let prim_idx = u32(group_index * 32 + i32(local_index));
        if i32(prim_idx) < prim_count {
            let scissor = load_scissor_state(prim_idx);
            let setup   = load_triangle_setup(prim_idx);
            var lo_m    = base_meta;
            var hi_m    = end_meta;
            binned = bin_primitive(setup, &lo_m, &hi_m, SCALE_FACTOR, scissor);
        }
    }
    if binned { _ = atomicOr(&merged_mask_shared, 1u << local_index); }
    workgroupBarrier();

    // ── Phase 3: each thread (= one FINE tile) tests surviving primitives ────
    var merged_mask = atomicLoad(&merged_mask_shared);
    var binned_mask : u32 = 0u;

    while merged_mask != 0u {
        let bit      = i32(firstTrailingBit(merged_mask));
        merged_mask &= ~(1u << u32(bit));

        let prim_idx = u32(group_index * 32 + bit);
        let scissor  = load_scissor_state(prim_idx);
        let setup    = load_triangle_setup(prim_idx);
        var lo_f     = base;
        var hi_f     = end_tile;

        if bin_primitive(setup, &lo_f, &hi_f, SCALE_FACTOR, scissor) {
            binned_mask |= 1u << u32(bit);
        }
    }

    // Each thread writes to a unique linear_tile slot — no atomics needed
    tile_bitmask[u32(lin_tile * TILE_BINNING_STRIDE + group_index)] = binned_mask;

    // Update coarse bitmask atomically (multiple tiles share a coarse word)
    if binned_mask != 0u {
        _ = atomicOr( &tile_bitmask_coarse[u32(lin_tile)], 1u << u32(group_index));
    } else {
        _ = atomicAnd(&tile_bitmask_coarse[u32(lin_tile)], ~(1u << u32(group_index)));
    }
}
