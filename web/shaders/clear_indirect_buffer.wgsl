// Translated from clear_indirect_buffer.comp (paraLLEl-RDP)
// Initialises the indirect dispatch buffer: each slot = uvec4(0,1,1,0).

@group(0) @binding(0) var<storage, read_write> indirects: array<vec4<u32>>;

@compute @workgroup_size(64, 1, 1)
fn main(@builtin(global_invocation_id) gid: vec3<u32>) {
    indirects[gid.x] = vec4<u32>(0u, 1u, 1u, 0u);
}
