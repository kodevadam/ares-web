struct UBO {
    offsets: array<vec4<u32>, 1024>,
}

struct WriteMaskRDRAM {
    writemask: array<u32>,
}

struct StagingRDRAM {
    staging_rdram: array<u32>,
}

struct RDRAM {
    rdram: array<u32>,
}

@group(1) @binding(0) 
var<uniform> _14_: UBO;
@group(0) @binding(2) 
var<storage, read_write> _45_: WriteMaskRDRAM;
@group(0) @binding(1) 
var<storage, read_write> _66_: StagingRDRAM;
@group(0) @binding(0) 
var<storage, read_write> _73_: RDRAM;
var<private> gl_WorkGroupID_1: vec3<u32>;
var<private> gl_LocalInvocationIndex_1: u32;

fn main_1() {
    var offset: u32;
    var mask: u32;
    var staging: u32;
    var word: u32;
    var staging_1_: u32;

    let _e13 = gl_WorkGroupID_1;
    let _e17 = gl_WorkGroupID_1;
    let _e24 = _14_.offsets[(_e17.x >> 2u)][(_e13.x & 3u)];
    offset = _e24;
    let _e26 = offset;
    offset = (_e26 * 256u);
    let _e30 = offset;
    let _e31 = gl_LocalInvocationIndex_1;
    offset = (_e30 + _e31);
    let _e33 = offset;
    let _e36 = _45_.writemask[_e33];
    mask = _e36;
    let _e38 = mask;
    if (_e38 == 4294967295u) {
        {
            return;
        }
    } else {
        {
            let _e41 = mask;
            if (_e41 == 0u) {
                {
                    let _e44 = offset;
                    let _e47 = _66_.staging_rdram[_e44];
                    staging = _e47;
                    let _e49 = offset;
                    let _e52 = staging;
                    _73_.rdram[_e49] = _e52;
                    return;
                }
            } else {
                {
                    let _e53 = offset;
                    let _e56 = _73_.rdram[_e53];
                    word = _e56;
                    let _e58 = offset;
                    let _e61 = _66_.staging_rdram[_e58];
                    staging_1_ = _e61;
                    let _e63 = word;
                    let _e64 = mask;
                    let _e66 = staging_1_;
                    let _e67 = mask;
                    word = ((_e63 & _e64) | (_e66 & ~(_e67)));
                    let _e71 = offset;
                    let _e74 = word;
                    _73_.rdram[_e71] = _e74;
                    return;
                }
            }
        }
    }
}

@compute @workgroup_size(64, 1, 1) 
fn main(@builtin(workgroup_id) gl_WorkGroupID: vec3<u32>, @builtin(local_invocation_index) gl_LocalInvocationIndex: u32) {
    gl_WorkGroupID_1 = gl_WorkGroupID;
    gl_LocalInvocationIndex_1 = gl_LocalInvocationIndex;
    main_1();
    return;
}
