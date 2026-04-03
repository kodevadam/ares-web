// Translated from masked_rdram_resolve.comp (paraLLEl-RDP)
// Merges staging_rdram into rdram using per-word write masks.
// mask==0xFFFFFFFF → skip (pixel unchanged), mask==0 → full overwrite, else blend.

@group(0) @binding(0) var<storage, read_write> rdram         : array<u32>;
@group(0) @binding(1) var<storage, read>        staging_rdram: array<u32>;
@group(0) @binding(2) var<storage, read>        writemask    : array<u32>;

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

    let mask = writemask[offset];

    if (mask == 0xFFFFFFFFu) {
        // All bits masked: pixel was not written by the RDP — leave rdram unchanged.
        return;
    } else if (mask == 0u) {
        // No bits masked: full overwrite.
        rdram[offset] = staging_rdram[offset];
    } else {
        // Partial: blend per-bit.
        let word    = rdram[offset];
        let staging = staging_rdram[offset];
        rdram[offset] = (word & mask) | (staging & ~mask);
    }
}
