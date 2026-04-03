// Translated from clear_write_mask.comp (paraLLEl-RDP)
// Clears write_mask entries for the given page offsets.
//
// GLSL original: layout(constant_id=0) local_size_x, layout(constant_id=1) PAGE_STRIDE=256
// WGSL: fixed workgroup size of 64; PAGE_STRIDE constant inlined.

@group(0) @binding(0) var<storage, read_write> write_mask: array<u32>;

struct Offsets {
    values: array<vec4<u32>, 1024>,
}
@group(1) @binding(0) var<uniform> ubo: Offsets;

@compute @workgroup_size(64, 1, 1)
fn main(
    @builtin(workgroup_id)            wg_id    : vec3<u32>,
    @builtin(local_invocation_index)  local_idx: u32,
) {
    let wg_x    = wg_id.x;
    let vec_idx = wg_x >> 2u;
    let comp    = wg_x & 3u;
    // PAGE_STRIDE = 256
    let offset  = ubo.values[vec_idx][comp] * 256u + local_idx;
    write_mask[offset] = 0u;
}
