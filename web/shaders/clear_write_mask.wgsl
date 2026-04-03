struct UBO {
    offsets: array<vec4<u32>, 1024>,
}

struct SSBO {
    write_mask: array<u32>,
}

@group(1) @binding(0) 
var<uniform> _14_: UBO;
@group(0) @binding(0) 
var<storage, read_write> _40_: SSBO;
var<private> gl_WorkGroupID_1: vec3<u32>;
var<private> gl_LocalInvocationIndex_1: u32;

fn main_1() {
    var offset: u32;

    let _e7 = gl_WorkGroupID_1;
    let _e11 = gl_WorkGroupID_1;
    let _e18 = _14_.offsets[(_e11.x >> 2u)][(_e7.x & 3u)];
    offset = _e18;
    let _e20 = offset;
    offset = (_e20 * 256u);
    let _e24 = offset;
    let _e25 = gl_LocalInvocationIndex_1;
    _40_.write_mask[(_e24 + _e25)] = 0u;
    return;
}

@compute @workgroup_size(64, 1, 1) 
fn main(@builtin(workgroup_id) gl_WorkGroupID: vec3<u32>, @builtin(local_invocation_index) gl_LocalInvocationIndex: u32) {
    gl_WorkGroupID_1 = gl_WorkGroupID;
    gl_LocalInvocationIndex_1 = gl_LocalInvocationIndex;
    main_1();
    return;
}
