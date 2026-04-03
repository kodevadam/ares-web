// Skeleton for update_upscaled_domain_pre.comp (paraLLEl-RDP)
// Only used when internal upscaling factor > 1x.
// TODO: Naga-transpile from update_upscaled_domain_pre.comp
@group(0) @binding(0) var<storage, read_write> rdram: array<u32>;
@compute @workgroup_size(64, 1, 1)
fn main(@builtin(global_invocation_id) gid: vec3<u32>) { _ = gid; }
