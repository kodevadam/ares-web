struct RDRAMSingleSampled8_ {
    elems: array<u32>,
}

struct RDRAMUpscalingReference8_ {
    elems: array<u32>,
}

struct RDRAMHiddenSingleSampled {
    elems: array<u32>,
}

struct RDRAMUpscaling8_ {
    elems: array<u32>,
}

struct RDRAMHiddenUpscaling {
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
@group(0) @binding(1) 
var<storage, read_write> hidden_vram: RDRAMHiddenSingleSampled;
@group(0) @binding(3) 
var<storage, read_write> vram_upscaled8_: RDRAMUpscaling8_;
@group(0) @binding(4) 
var<storage, read_write> hidden_vram_upscaled: RDRAMHiddenUpscaling;
@group(2) @binding(0) 
var<uniform> registers: Registers;
var<private> gl_GlobalInvocationID_1: vec3<u32>;

fn update_rdram_8_(index: ptr<function, u32>) {
    var real_word: u32;
    var reference_word: u32;
    var mirrored_index: u32;
    var real_hidden_word: u32;
    var i: i32 = 0i;

    let _e23 = (*index);
    (*index) = (_e23 & 8388607u);
    let _e26 = (*index);
    let _e31 = vram8_.elems[(_e26 >> 2u)];
    let _e32 = (*index);
    real_word = ((_e31 >> ((_e32 & 3u) * 8u)) & 255u);
    let _e41 = (*index);
    let _e46 = vram_reference8_.elems[(_e41 >> 2u)];
    let _e47 = (*index);
    reference_word = ((_e46 >> ((_e47 & 3u) * 8u)) & 255u);
    let _e56 = real_word;
    let _e57 = reference_word;
    if (_e56 != _e57) {
        {
            let _e59 = (*index);
            mirrored_index = (_e59 ^ 3u);
            let _e63 = mirrored_index;
            let _e70 = hidden_vram.elems[((_e63 >> 1u) >> 2u)];
            let _e71 = mirrored_index;
            real_hidden_word = ((_e70 >> (((_e71 >> 1u) & 3u) * 8u)) & 255u);
            loop {
                let _e84 = i;
                if !((_e84 < 1i)) {
                    break;
                }
                {
                    let _e91 = (*index);
                    let _e92 = i;
                    let _e101 = (*index);
                    let _e102 = i;
                    let _e111 = vram_upscaled8_.elems[((_e101 + u32((_e102 * 8388608i))) >> 2u)];
                    let _e113 = (*index);
                    let _e114 = i;
                    let _e126 = real_word;
                    let _e129 = (*index);
                    let _e130 = i;
                    vram_upscaled8_.elems[((_e91 + u32((_e92 * 8388608i))) >> 2u)] = ((_e111 & ~((255u << (((_e113 + u32((_e114 * 8388608i))) & 3u) * 8u)))) | ((_e126 & 255u) << (((_e129 + u32((_e130 * 8388608i))) & 3u) * 8u)));
                    let _e141 = mirrored_index;
                    if ((_e141 & 1u) != 0u) {
                        {
                            let _e146 = mirrored_index;
                            let _e149 = i;
                            let _e158 = mirrored_index;
                            let _e161 = i;
                            let _e170 = hidden_vram_upscaled.elems[(((_e158 >> 1u) + u32((_e161 * 4194304i))) >> 2u)];
                            let _e172 = mirrored_index;
                            let _e175 = i;
                            let _e187 = real_hidden_word;
                            let _e190 = mirrored_index;
                            let _e193 = i;
                            hidden_vram_upscaled.elems[(((_e146 >> 1u) + u32((_e149 * 4194304i))) >> 2u)] = ((_e170 & ~((255u << ((((_e172 >> 1u) + u32((_e175 * 4194304i))) & 3u) * 8u)))) | ((_e187 & 255u) << ((((_e190 >> 1u) + u32((_e193 * 4194304i))) & 3u) * 8u)));
                        }
                    }
                }
                continuing {
                    let _e88 = i;
                    i = (_e88 + 1i);
                }
            }
            let _e204 = (*index);
            let _e209 = (*index);
            let _e214 = vram_reference8_.elems[(_e209 >> 2u)];
            let _e216 = (*index);
            let _e224 = real_word;
            let _e227 = (*index);
            vram_reference8_.elems[(_e204 >> 2u)] = ((_e214 & ~((255u << ((_e216 & 3u) * 8u)))) | ((_e224 & 255u) << ((_e227 & 3u) * 8u)));
            return;
        }
    } else {
        return;
    }
}

fn update_rdram_16_(index_1: ptr<function, u32>) {
    var real_word_1: u32;
    var reference_word_1: u32;
    var mirrored_index_1: u32;
    var real_hidden_word_1: u32;
    var i_1: i32 = 0i;

    let _e23 = (*index_1);
    (*index_1) = (_e23 & 4194303u);
    let _e26 = (*index_1);
    let _e31 = vram8_.elems[(_e26 >> 1u)];
    let _e32 = (*index_1);
    real_word_1 = ((_e31 >> ((_e32 & 1u) * 16u)) & 65535u);
    let _e41 = (*index_1);
    let _e46 = vram_reference8_.elems[(_e41 >> 1u)];
    let _e47 = (*index_1);
    reference_word_1 = ((_e46 >> ((_e47 & 1u) * 16u)) & 65535u);
    let _e56 = real_word_1;
    let _e57 = reference_word_1;
    if (_e56 != _e57) {
        {
            let _e59 = (*index_1);
            mirrored_index_1 = (_e59 ^ 1u);
            let _e63 = mirrored_index_1;
            let _e68 = hidden_vram.elems[(_e63 >> 2u)];
            let _e69 = mirrored_index_1;
            real_hidden_word_1 = ((_e68 >> ((_e69 & 3u) * 8u)) & 255u);
            loop {
                let _e80 = i_1;
                if !((_e80 < 1i)) {
                    break;
                }
                {
                    let _e87 = (*index_1);
                    let _e88 = i_1;
                    let _e97 = (*index_1);
                    let _e98 = i_1;
                    let _e107 = vram_upscaled8_.elems[((_e97 + u32((_e98 * 4194304i))) >> 1u)];
                    let _e109 = (*index_1);
                    let _e110 = i_1;
                    let _e122 = real_word_1;
                    let _e125 = (*index_1);
                    let _e126 = i_1;
                    vram_upscaled8_.elems[((_e87 + u32((_e88 * 4194304i))) >> 1u)] = ((_e107 & ~((65535u << (((_e109 + u32((_e110 * 4194304i))) & 1u) * 16u)))) | ((_e122 & 65535u) << (((_e125 + u32((_e126 * 4194304i))) & 1u) * 16u)));
                    let _e137 = mirrored_index_1;
                    let _e138 = i_1;
                    let _e147 = mirrored_index_1;
                    let _e148 = i_1;
                    let _e157 = hidden_vram_upscaled.elems[((_e147 + u32((_e148 * 4194304i))) >> 2u)];
                    let _e159 = mirrored_index_1;
                    let _e160 = i_1;
                    let _e172 = real_hidden_word_1;
                    let _e175 = mirrored_index_1;
                    let _e176 = i_1;
                    hidden_vram_upscaled.elems[((_e137 + u32((_e138 * 4194304i))) >> 2u)] = ((_e157 & ~((255u << (((_e159 + u32((_e160 * 4194304i))) & 3u) * 8u)))) | ((_e172 & 255u) << (((_e175 + u32((_e176 * 4194304i))) & 3u) * 8u)));
                }
                continuing {
                    let _e84 = i_1;
                    i_1 = (_e84 + 1i);
                }
            }
            let _e187 = (*index_1);
            let _e192 = (*index_1);
            let _e197 = vram_reference8_.elems[(_e192 >> 1u)];
            let _e199 = (*index_1);
            let _e207 = real_word_1;
            let _e210 = (*index_1);
            vram_reference8_.elems[(_e187 >> 1u)] = ((_e197 & ~((65535u << ((_e199 & 1u) * 16u)))) | ((_e207 & 65535u) << ((_e210 & 1u) * 16u)));
            return;
        }
    } else {
        return;
    }
}

fn main_1() {
    var index_2: u32;
    var depth_index: u32;
    var color_index: u32;
    var param: u32;
    var param_1_: u32;

    let _e23 = gl_GlobalInvocationID_1;
    index_2 = _e23.x;
    let _e26 = index_2;
    let _e27 = registers;
    if (_e26 >= _e27.num_pixels) {
        {
            return;
        }
    }
    let _e30 = index_2;
    let _e31 = registers;
    depth_index = (_e30 + _e31.fb_depth_addr);
    let _e35 = index_2;
    let _e36 = registers;
    color_index = (_e35 + _e36.fb_addr);
    let _e40 = color_index;
    param = _e40;
    update_rdram_8_((&param));
    let _e44 = depth_index;
    param_1_ = _e44;
    update_rdram_16_((&param_1_));
    return;
}

@compute @workgroup_size(64, 1, 1) 
fn main(@builtin(global_invocation_id) gl_GlobalInvocationID: vec3<u32>) {
    gl_GlobalInvocationID_1 = gl_GlobalInvocationID;
    main_1();
    return;
}
