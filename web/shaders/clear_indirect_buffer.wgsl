struct ClearIndirectBuffer {
    indirects: array<vec4<u32>>,
}

@group(0) @binding(0) 
var<storage, read_write> _11_: ClearIndirectBuffer;
var<private> gl_GlobalInvocationID_1: vec3<u32>;

fn main_1() {
    let _e4 = gl_GlobalInvocationID_1;
    _11_.indirects[_e4.x] = vec4<u32>(0u, 1u, 1u, 0u);
    return;
}

@compute @workgroup_size(64, 1, 1) 
fn main(@builtin(global_invocation_id) gl_GlobalInvocationID: vec3<u32>) {
    gl_GlobalInvocationID_1 = gl_GlobalInvocationID;
    main_1();
    return;
}
