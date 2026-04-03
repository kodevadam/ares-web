// Translated from clear_super_sampled_write_mask.comp (paraLLEl-RDP)
// Zeroes the supersampled write-mask buffer.

@group(0) @binding(0) var<storage, read_write> mask_ram: array<u32>;

@compute @workgroup_size(64, 1, 1)
fn main(@builtin(global_invocation_id) gid: vec3<u32>) {
    mask_ram[gid.x] = 0u;
}
