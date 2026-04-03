struct RDRAMSingleSampled8_ {
    elems: array<u32>,
}

struct RDRAMUpscalingReference8_ {
    elems: array<u32>,
}

struct Registers {
    num_pixels: u32,
    fb_addr: u32,
    fb_depth_addr: u32,
}

@group(0) @binding(0) 
var<storage, read_write> vram8_: RDRAMSingleSampled8_;
@group(0) @binding(2) 
var<storage, read_write> vram_reference8_: RDRAMUpscalingReference8_;
@group(2) @binding(0) 
var<uniform> registers: Registers;
var<private> gl_GlobalInvocationID_1: vec3<u32>;

fn copy_rdram_8_(index: ptr<function, u32>) {
    var real_word: u32;

    let _e14 = (*index);
    (*index) = (_e14 & 8388607u);
    let _e17 = (*index);
    let _e22 = vram8_.elems[(_e17 >> 2u)];
    let _e23 = (*index);
    real_word = ((_e22 >> ((_e23 & 3u) * 8u)) & 255u);
    let _e32 = (*index);
    let _e37 = (*index);
    let _e42 = vram_reference8_.elems[(_e37 >> 2u)];
    let _e44 = (*index);
    let _e52 = real_word;
    let _e55 = (*index);
    vram_reference8_.elems[(_e32 >> 2u)] = ((_e42 & ~((255u << ((_e44 & 3u) * 8u)))) | ((_e52 & 255u) << ((_e55 & 3u) * 8u)));
    return;
}

fn copy_rdram_16_(index_1: ptr<function, u32>) {
    var real_word_1: u32;

    let _e14 = (*index_1);
    (*index_1) = (_e14 & 4194303u);
    let _e17 = (*index_1);
    let _e22 = vram8_.elems[(_e17 >> 1u)];
    let _e23 = (*index_1);
    real_word_1 = ((_e22 >> ((_e23 & 1u) * 16u)) & 65535u);
    let _e32 = (*index_1);
    let _e37 = (*index_1);
    let _e42 = vram_reference8_.elems[(_e37 >> 1u)];
    let _e44 = (*index_1);
    let _e52 = real_word_1;
    let _e55 = (*index_1);
    vram_reference8_.elems[(_e32 >> 1u)] = ((_e42 & ~((65535u << ((_e44 & 1u) * 16u)))) | ((_e52 & 65535u) << ((_e55 & 1u) * 16u)));
    return;
}

fn main_1() {
    var index_2: u32;
    var depth_index: u32;
    var color_index: u32;
    var param: u32;
    var param_1_: u32;

    let _e14 = gl_GlobalInvocationID_1;
    index_2 = _e14.x;
    let _e17 = index_2;
    let _e18 = registers;
    if (_e17 >= _e18.num_pixels) {
        {
            return;
        }
    }
    let _e21 = index_2;
    let _e22 = registers;
    depth_index = (_e21 + _e22.fb_depth_addr);
    let _e26 = index_2;
    let _e27 = registers;
    color_index = (_e26 + _e27.fb_addr);
    let _e31 = color_index;
    param = _e31;
    copy_rdram_8_((&param));
    let _e35 = depth_index;
    param_1_ = _e35;
    copy_rdram_16_((&param_1_));
    return;
}

@compute @workgroup_size(64, 1, 1) 
fn main(@builtin(global_invocation_id) gl_GlobalInvocationID: vec3<u32>) {
    gl_GlobalInvocationID_1 = gl_GlobalInvocationID;
    main_1();
    return;
}
