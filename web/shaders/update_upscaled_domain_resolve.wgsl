struct RDRAMUpscaling8_ {
    elems: array<u32>,
}

struct RDRAMUpscalingReference8_ {
    elems: array<u32>,
}

struct RDRAMSingleSampled8_ {
    elems: array<u32>,
}

struct Registers {
    num_pixels: u32,
    fb_addr: u32,
    fb_depth_addr: u32,
    width: u32,
    height: u32,
}

@group(0) @binding(3) 
var<storage, read_write> vram_upscaled8_: RDRAMUpscaling8_;
@group(0) @binding(2) 
var<storage, read_write> vram_reference8_: RDRAMUpscalingReference8_;
@group(0) @binding(0) 
var<storage, read_write> vram8_: RDRAMSingleSampled8_;
@group(2) @binding(0) 
var<uniform> registers: Registers;
var<private> gl_GlobalInvocationID_1: vec3<u32>;

fn copy_rdram_8_(index: u32) {
    var index_1: u32;
    var r: u32 = 0u;
    var i: i32 = 0i;
    var real_word: u32;

    index_1 = index;
    loop {
        let _e26 = i;
        if !((_e26 < 1i)) {
            break;
        }
        {
            let _e33 = index_1;
            let _e38 = vram_upscaled8_.elems[(_e33 >> 2u)];
            let _e39 = index_1;
            real_word = ((_e38 >> ((_e39 & 3u) * 8u)) & 255u);
            let _e48 = r;
            let _e49 = real_word;
            r = (_e48 + _e49);
        }
        continuing {
            let _e30 = i;
            i = (_e30 + 1i);
        }
    }
    let _e51 = r;
    r = ((_e51 + 0u) / 1u);
    let _e56 = index_1;
    let _e61 = index_1;
    let _e66 = vram_reference8_.elems[(_e61 >> 2u)];
    let _e68 = index_1;
    let _e76 = r;
    let _e79 = index_1;
    vram_reference8_.elems[(_e56 >> 2u)] = ((_e66 & ~((255u << ((_e68 & 3u) * 8u)))) | ((_e76 & 255u) << ((_e79 & 3u) * 8u)));
    let _e86 = index_1;
    let _e91 = index_1;
    let _e96 = vram8_.elems[(_e91 >> 2u)];
    let _e98 = index_1;
    let _e106 = r;
    let _e109 = index_1;
    vram8_.elems[(_e86 >> 2u)] = ((_e96 & ~((255u << ((_e98 & 3u) * 8u)))) | ((_e106 & 255u) << ((_e109 & 3u) * 8u)));
    return;
}

fn copy_rdram_16_single_sample(index_2: u32) {
    var index_3: u32;
    var upscaled_word: u32;

    index_3 = index_2;
    let _e22 = index_3;
    let _e27 = vram_upscaled8_.elems[(_e22 >> 1u)];
    let _e28 = index_3;
    upscaled_word = ((_e27 >> ((_e28 & 1u) * 16u)) & 65535u);
    let _e37 = index_3;
    let _e42 = index_3;
    let _e47 = vram8_.elems[(_e42 >> 1u)];
    let _e49 = index_3;
    let _e57 = upscaled_word;
    let _e60 = index_3;
    vram8_.elems[(_e37 >> 1u)] = ((_e47 & ~((65535u << ((_e49 & 1u) * 16u)))) | ((_e57 & 65535u) << ((_e60 & 1u) * 16u)));
    let _e67 = index_3;
    let _e72 = index_3;
    let _e77 = vram_reference8_.elems[(_e72 >> 1u)];
    let _e79 = index_3;
    let _e87 = upscaled_word;
    let _e90 = index_3;
    vram_reference8_.elems[(_e67 >> 1u)] = ((_e77 & ~((65535u << ((_e79 & 1u) * 16u)))) | ((_e87 & 65535u) << ((_e90 & 1u) * 16u)));
    return;
}

fn main_1() {
    var coord: vec2<u32>;
    var index_4: u32;
    var depth_index: u32;
    var color_index: u32;
    var mask_coord: vec2<u32>;
    var mask_index: u32;
    var write_mask: u32;
    var shamt: u32;
    var color_write_mask: bool;
    var depth_write_mask: bool;
    var param: u32;
    var param_1_: u32;

    let _e21 = gl_GlobalInvocationID_1;
    coord = _e21.xy;
    let _e24 = coord;
    let _e26 = registers;
    let _e29 = coord;
    index_4 = ((_e24.y * _e26.width) + _e29.x);
    let _e33 = index_4;
    let _e34 = registers;
    depth_index = (_e33 + _e34.fb_depth_addr);
    let _e38 = index_4;
    let _e39 = registers;
    color_index = (_e38 + _e39.fb_addr);
    let _e43 = coord;
    mask_coord = (_e43 >> vec2(2u));
    let _e48 = mask_coord;
    let _e50 = mask_coord;
    let _e52 = registers;
    mask_index = (_e48.x + (_e50.y * ((_e52.width + 3u) >> 2u)));
    let _e62 = coord;
    let _e64 = registers;
    if (_e62.x < _e64.width) {
        {
            let _e68 = mask_index;
            let _e72 = vram_upscaled8_.elems[(2097152u + _e68)];
            write_mask = _e72;
        }
    } else {
        {
            write_mask = 0u;
        }
    }
    let _e75 = coord;
    let _e80 = coord;
    shamt = (2u * ((_e75.x & 3u) + (4u * (_e80.y & 3u))));
    let _e88 = write_mask;
    let _e89 = shamt;
    write_mask = (_e88 >> _e89);
    let _e91 = write_mask;
    color_write_mask = ((_e91 & 1u) != 0u);
    let _e97 = write_mask;
    depth_write_mask = ((_e97 & 2u) != 0u);
    let _e103 = color_write_mask;
    if _e103 {
        {
            let _e104 = color_index;
            color_index = (_e104 & 8388607u);
            let _e107 = color_index;
            color_index = (_e107 ^ 3u);
            let _e110 = color_index;
            param = _e110;
            let _e112 = param;
            copy_rdram_8_(_e112);
        }
    }
    let _e113 = depth_write_mask;
    if _e113 {
        {
            let _e114 = depth_index;
            depth_index = (_e114 & 4194303u);
            let _e117 = depth_index;
            depth_index = (_e117 ^ 1u);
            let _e120 = depth_index;
            param_1_ = _e120;
            let _e122 = param_1_;
            copy_rdram_16_single_sample(_e122);
            return;
        }
    } else {
        return;
    }
}

@compute @workgroup_size(64, 1, 1) 
fn main(@builtin(global_invocation_id) gl_GlobalInvocationID: vec3<u32>) {
    gl_GlobalInvocationID_1 = gl_GlobalInvocationID;
    main_1();
    return;
}
