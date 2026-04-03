struct UploadInfo {
    width: i32,
    height: i32,
    min_t_mod: f32,
    max_t_mod: f32,
    vram_addr: i32,
    vram_width: i32,
    vram_size: i32,
    vram_effective_width: i32,
    tmem_offset: i32,
    tmem_stride_words: i32,
    tmem_size: i32,
    tmem_fmt: i32,
    mode: i32,
    inv_tmem_stride_words: f32,
    dxt: i32,
    padding: i32,
}

struct VRAM32Buffer {
    data: array<u32>,
}

struct TMEM16Buffer {
    data: array<u32, 2048>,
}

struct TMEMInstances {
    raw: array<u32>,
}

struct UploadInfos {
    upload_info: array<UploadInfo, 256>,
}

struct Registers {
    num_uploads: i32,
}

@group(0) @binding(0) 
var<storage, read_write> vram32_: VRAM32Buffer;
@group(0) @binding(1) 
var<storage, read_write> tmem16_: TMEM16Buffer;
@group(0) @binding(2) 
var<storage, read_write> tile_instances: TMEMInstances;
@group(1) @binding(0) 
var<uniform> _1120_: UploadInfos;
@group(2) @binding(0) 
var<uniform> registers: Registers;
var<private> current_tmem_value: u32;
var<private> tmem_dirty: bool;
var<private> gl_GlobalInvocationID_1: vec3<u32>;

fn update_tmem_lut(info: UploadInfo, tmem16_index: i32) {
    var info_1: UploadInfo;
    var tmem16_index_1: i32;
    var tmem16_offset: i32;
    var pixel_offset: i32;
    var pixel_offset_splat: i32;
    var local: i32;
    var shamt: i32;
    var local_1: i32;
    var shamt_1_: i32;
    var shamt_2_: i32;
    var span_iteration: i32;
    var span_pixel: i32;
    var rdram_addr: i32;
    var word: u32;

    info_1 = info;
    tmem16_index_1 = tmem16_index;
    let _e21 = info_1;
    tmem16_offset = ((_e21.tmem_offset & 4095i) >> 1u);
    let _e29 = tmem16_index_1;
    let _e30 = tmem16_offset;
    pixel_offset = ((_e29 - _e30) & 2047i);
    let _e36 = info_1;
    let _e38 = info_1;
    if ((_e36.vram_size - _e38.tmem_size) == 2i) {
        {
            let _e43 = pixel_offset;
            pixel_offset_splat = (_e43 >> 2u);
            let _e47 = pixel_offset_splat;
            let _e48 = info_1;
            pixel_offset_splat = (_e47 << u32((_e48.vram_size - 2i)));
            let _e54 = pixel_offset_splat;
            let _e55 = info_1;
            if (_e54 >= _e55.vram_effective_width) {
                {
                    return;
                }
            }
        }
    } else {
        {
            let _e58 = info_1;
            let _e60 = info_1;
            if ((_e58.vram_size - _e60.tmem_size) == 1i) {
                {
                    let _e65 = pixel_offset;
                    if ((_e65 & 4i) == 0i) {
                        {
                            let _e70 = info_1;
                            let _e72 = info_1;
                            if (_e72.vram_size == 2i) {
                                local = 2i;
                            } else {
                                local = 0i;
                            }
                            let _e79 = local;
                            shamt = (_e70.tmem_size + _e79);
                            let _e82 = pixel_offset;
                            let _e86 = shamt;
                            pixel_offset_splat = ((_e82 & -8i) >> u32(_e86));
                            let _e89 = pixel_offset_splat;
                            let _e90 = info_1;
                            if (_e89 >= _e90.vram_effective_width) {
                                {
                                    return;
                                }
                            }
                        }
                    } else {
                        {
                            return;
                        }
                    }
                }
            } else {
                {
                    let _e93 = info_1;
                    let _e95 = info_1;
                    if (_e93.vram_size == _e95.tmem_size) {
                        {
                            let _e98 = pixel_offset;
                            if ((_e98 & 12i) == 0i) {
                                {
                                    let _e103 = info_1;
                                    let _e105 = info_1;
                                    if (_e105.vram_size == 2i) {
                                        local_1 = 2i;
                                    } else {
                                        local_1 = 0i;
                                    }
                                    let _e112 = local_1;
                                    shamt_1_ = (_e103.tmem_size + _e112);
                                    let _e115 = pixel_offset;
                                    let _e119 = shamt_1_;
                                    pixel_offset_splat = ((_e115 & -4i) >> u32(_e119));
                                    let _e122 = pixel_offset_splat;
                                    let _e123 = info_1;
                                    if (_e122 >= _e123.vram_effective_width) {
                                        {
                                            return;
                                        }
                                    }
                                }
                            } else {
                                {
                                    return;
                                }
                            }
                        }
                    } else {
                        {
                            let _e126 = info_1;
                            let _e128 = info_1;
                            if ((_e126.vram_size - _e128.tmem_size) == -1i) {
                                {
                                    let _e134 = pixel_offset;
                                    if ((_e134 & 28i) == 0i) {
                                        {
                                            let _e139 = info_1;
                                            shamt_2_ = _e139.tmem_size;
                                            let _e142 = pixel_offset;
                                            let _e143 = shamt_2_;
                                            pixel_offset_splat = ((_e142 >> u32(_e143)) & -8i);
                                            let _e149 = pixel_offset_splat;
                                            let _e150 = info_1;
                                            if (_e149 >= _e150.vram_effective_width) {
                                                {
                                                    return;
                                                }
                                            }
                                        }
                                    } else {
                                        {
                                            return;
                                        }
                                    }
                                }
                            } else {
                                {
                                    let _e153 = pixel_offset;
                                    span_iteration = (_e153 >> 2u);
                                    let _e158 = span_iteration;
                                    span_iteration = (_e158 * 2i);
                                    let _e161 = span_iteration;
                                    span_pixel = (_e161 * 2i);
                                    let _e165 = span_pixel;
                                    let _e168 = info_1;
                                    if ((_e165 + 2i) < _e168.vram_effective_width) {
                                        {
                                            let _e171 = span_pixel;
                                            span_pixel = (_e171 + 2i);
                                        }
                                    }
                                    let _e174 = span_pixel;
                                    let _e175 = info_1;
                                    if (_e174 >= _e175.vram_effective_width) {
                                        {
                                            return;
                                        }
                                    }
                                    let _e178 = span_pixel;
                                    pixel_offset_splat = _e178;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    let _e179 = info_1;
    let _e181 = pixel_offset_splat;
    let _e182 = info_1;
    rdram_addr = (_e179.vram_addr + (_e181 << u32((_e182.vram_size - 1i))));
    let _e190 = rdram_addr;
    let _e192 = rdram_addr;
    let _e196 = pixel_offset;
    rdram_addr = (_e190 + ((2i * (_e192 & 1i)) * (_e196 & 3i)));
    let _e202 = rdram_addr;
    if ((_e202 & 1i) == 0i) {
        {
            let _e207 = rdram_addr;
            let _e217 = vram32_.data[(((_e207 >> 1u) ^ 1i) >> 1u)];
            let _e218 = rdram_addr;
            word = ((_e217 >> ((u32(((_e218 >> 1u) ^ 1i)) & 1u) * 16u)) & 65535u);
        }
    } else {
        {
            let _e232 = rdram_addr;
            let _e239 = vram32_.data[((_e232 ^ 3i) >> 2u)];
            let _e240 = rdram_addr;
            let _e254 = rdram_addr;
            let _e263 = vram32_.data[(((_e254 + 1i) ^ 3i) >> 2u)];
            let _e264 = rdram_addr;
            word = ((((_e239 >> ((u32((_e240 ^ 3i)) & 3u) * 8u)) & 255u) << 8u) | ((_e263 >> ((u32(((_e264 + 1i) ^ 3i)) & 3u) * 8u)) & 255u));
        }
    }
    let _e278 = word;
    current_tmem_value = _e278;
    tmem_dirty = true;
    return;
}

fn compute_upload_t(offset: i32, inv_stride: f32) -> i32 {
    var offset_1: i32;
    var inv_stride_1: f32;

    offset_1 = offset;
    inv_stride_1 = inv_stride;
    let _e21 = offset_1;
    let _e25 = inv_stride_1;
    return i32(((f32(_e21) + 0.5f) * _e25));
}

fn update_tmem_32_(info_2: UploadInfo, tmem16_index_2: i32, upper_tmem: bool, yuv: bool) {
    var info_3: UploadInfo;
    var tmem16_index_3: i32;
    var upper_tmem_1: bool;
    var yuv_1: bool;
    var tmem16_offset_1: i32;
    var tmem16_stride: i32;
    var pixel_offset_1: i32;
    var upload_x_xor: i32 = 0i;
    var upload_x: i32;
    var upload_y: i32;
    var word_offset: i32;
    var iteration_candidate_first: i32;
    var iteration_candidate_second: i32;
    var first_t: i32;
    var second_t: i32;
    var iteration_candidate_first_write_index: i32;
    var iteration_candidate_second_write_index: i32;
    var param: i32;
    var param_1_: f32;
    var min_t: i32;
    var param_2_: i32;
    var param_3_: f32;
    var max_t: i32;
    var max_word_candidate: i32;
    var min_word_candidate: i32;
    var found_candidate: bool = false;
    var t: i32;
    var candidate_solution_first: i32;
    var candidate_solution_second: i32;
    var candidate_t_first: i32;
    var candidate_t_second: i32;
    var param_4_: i32;
    var param_5_: f32;
    var last_line_upload_x: i32;
    var iteration_offset: i32;
    var i: i32 = 0i;
    var _395_: bool;
    var _401_: bool;
    var line_rdram_addr: i32;
    var rdram_addr_1: i32;
    var word_1: u32;
    var y0_: u32;
    var y1_: u32;
    var u: u32;
    var v: u32;

    info_3 = info_2;
    tmem16_index_3 = tmem16_index_2;
    upper_tmem_1 = upper_tmem;
    yuv_1 = yuv;
    let _e25 = info_3;
    tmem16_offset_1 = ((_e25.tmem_offset & 2047i) >> 1u);
    let _e33 = info_3;
    tmem16_stride = _e33.tmem_stride_words;
    let _e36 = tmem16_index_3;
    let _e37 = tmem16_offset_1;
    pixel_offset_1 = ((_e36 - _e37) & 1023i);
    let _e46 = info_3;
    if (_e46.mode == 2i) {
        {
            let _e50 = pixel_offset_1;
            word_offset = (_e50 >> 1u);
            let _e55 = info_3;
            if (_e55.tmem_stride_words == 0i) {
                {
                    let _e59 = word_offset;
                    iteration_candidate_first = (_e59 & -2i);
                    let _e64 = iteration_candidate_first;
                    iteration_candidate_second = (_e64 + 1i);
                    let _e68 = iteration_candidate_first;
                    let _e69 = info_3;
                    first_t = ((_e68 * _e69.dxt) >> 16u);
                    let _e76 = iteration_candidate_second;
                    let _e77 = info_3;
                    second_t = ((_e76 * _e77.dxt) >> 16u);
                    let _e84 = first_t;
                    let _e85 = second_t;
                    if (_e84 != _e85) {
                        {
                            let _e87 = iteration_candidate_first;
                            let _e88 = first_t;
                            iteration_candidate_first_write_index = (_e87 ^ (_e88 & 1i));
                            let _e93 = iteration_candidate_second;
                            let _e94 = second_t;
                            iteration_candidate_second_write_index = (_e93 ^ (_e94 & 1i));
                            let _e99 = iteration_candidate_second_write_index;
                            let _e100 = word_offset;
                            if (_e99 == _e100) {
                                {
                                    let _e102 = second_t;
                                    upload_x_xor = ((_e102 & 1i) << 1u);
                                }
                            } else {
                                {
                                    let _e108 = iteration_candidate_first_write_index;
                                    let _e109 = word_offset;
                                    if (_e108 == _e109) {
                                        {
                                            let _e111 = first_t;
                                            upload_x_xor = ((_e111 & 1i) << 1u);
                                        }
                                    } else {
                                        {
                                            return;
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        {
                            let _e117 = upload_x_xor;
                            let _e118 = first_t;
                            upload_x_xor = (_e117 ^ ((_e118 & 1i) << 1u));
                        }
                    }
                }
            } else {
                {
                    let _e125 = word_offset;
                    param = (_e125 & -2i);
                    let _e130 = info_3;
                    param_1_ = _e130.min_t_mod;
                    let _e133 = param;
                    let _e134 = param_1_;
                    let _e135 = compute_upload_t(_e133, _e134);
                    min_t = _e135;
                    let _e137 = word_offset;
                    param_2_ = (_e137 | 1i);
                    let _e141 = info_3;
                    param_3_ = _e141.max_t_mod;
                    let _e144 = param_2_;
                    let _e145 = param_3_;
                    let _e146 = compute_upload_t(_e144, _e145);
                    max_t = _e146;
                    let _e148 = word_offset;
                    let _e151 = tmem16_stride;
                    let _e152 = min_t;
                    max_word_candidate = ((_e148 | 1i) - (_e151 * _e152));
                    let _e156 = word_offset;
                    let _e160 = tmem16_stride;
                    let _e161 = max_t;
                    min_word_candidate = ((_e156 & -2i) - (_e160 * _e161));
                    let _e165 = min_t;
                    let _e166 = min_word_candidate;
                    let _e167 = info_3;
                    min_t = max(_e165, ((_e166 * _e167.dxt) >> 16u));
                    let _e174 = max_t;
                    let _e175 = max_word_candidate;
                    let _e176 = info_3;
                    max_t = min(_e174, ((_e175 * _e176.dxt) >> 16u));
                    let _e185 = max_t;
                    t = _e185;
                    loop {
                        let _e187 = t;
                        let _e188 = min_t;
                        if !((_e187 >= _e188)) {
                            break;
                        }
                        {
                            let _e194 = word_offset;
                            let _e198 = tmem16_stride;
                            let _e199 = t;
                            candidate_solution_first = ((_e194 & -2i) - (_e198 * _e199));
                            let _e203 = word_offset;
                            let _e206 = tmem16_stride;
                            let _e207 = t;
                            candidate_solution_second = ((_e203 | 1i) - (_e206 * _e207));
                            let _e211 = candidate_solution_first;
                            let _e212 = info_3;
                            candidate_t_first = ((_e211 * _e212.dxt) >> 16u);
                            let _e219 = candidate_solution_second;
                            let _e220 = info_3;
                            candidate_t_second = ((_e219 * _e220.dxt) >> 16u);
                            let _e227 = candidate_solution_second;
                            let _e228 = candidate_t_second;
                            let _e229 = tmem16_stride;
                            let _e232 = candidate_t_second;
                            let _e236 = word_offset;
                            if (((_e227 + (_e228 * _e229)) ^ (_e232 & 1i)) == _e236) {
                                {
                                    found_candidate = true;
                                    let _e239 = candidate_solution_second;
                                    let _e243 = pixel_offset_1;
                                    pixel_offset_1 = ((_e239 << 1u) + (_e243 & 1i));
                                    break;
                                }
                            } else {
                                {
                                    let _e247 = candidate_solution_first;
                                    let _e248 = candidate_t_first;
                                    let _e249 = tmem16_stride;
                                    let _e252 = candidate_t_first;
                                    let _e256 = word_offset;
                                    if (((_e247 + (_e248 * _e249)) ^ (_e252 & 1i)) == _e256) {
                                        {
                                            found_candidate = true;
                                            let _e259 = candidate_solution_first;
                                            let _e263 = pixel_offset_1;
                                            pixel_offset_1 = ((_e259 << 1u) + (_e263 & 1i));
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                        continuing {
                            let _e191 = t;
                            t = (_e191 - 1i);
                        }
                    }
                    let _e267 = found_candidate;
                    if !(_e267) {
                        {
                            return;
                        }
                    }
                }
            }
            let _e269 = pixel_offset_1;
            upload_x = _e269;
            upload_y = 0i;
        }
    } else {
        {
            let _e271 = tmem16_stride;
            if (_e271 == 0i) {
                {
                    let _e274 = pixel_offset_1;
                    upload_x = _e274;
                    let _e275 = info_3;
                    upload_y = (_e275.height - 1i);
                }
            } else {
                {
                    let _e279 = pixel_offset_1;
                    param_4_ = _e279;
                    let _e281 = info_3;
                    param_5_ = _e281.inv_tmem_stride_words;
                    let _e284 = param_4_;
                    let _e285 = param_5_;
                    let _e286 = compute_upload_t(_e284, _e285);
                    upload_y = _e286;
                    let _e287 = pixel_offset_1;
                    let _e288 = upload_y;
                    let _e289 = tmem16_stride;
                    upload_x = (_e287 - (_e288 * _e289));
                    let _e292 = upload_y;
                    let _e293 = info_3;
                    if (_e292 >= _e293.height) {
                        {
                            let _e296 = upload_x;
                            let _e297 = tmem16_stride;
                            let _e298 = upload_y;
                            let _e299 = info_3;
                            upload_x = (_e296 + (_e297 * ((_e298 - _e299.height) + 1i)));
                            let _e306 = info_3;
                            upload_y = (_e306.height - 1i);
                        }
                    }
                }
            }
        }
    }
    let _e310 = upload_x;
    let _e311 = upload_y;
    last_line_upload_x = (_e310 ^ ((_e311 & 1i) << 1u));
    let _e319 = last_line_upload_x;
    let _e320 = info_3;
    let _e323 = upload_y;
    if ((_e319 >= _e320.width) && (_e323 > 0i)) {
        {
            let _e327 = upload_y;
            upload_y = (_e327 - 1i);
            let _e330 = upload_x;
            let _e331 = tmem16_stride;
            upload_x = (_e330 + _e331);
        }
    }
    let _e333 = upload_x;
    let _e334 = upload_y;
    let _e340 = upload_x_xor;
    upload_x = (_e333 ^ (((_e334 & 1i) << 1u) | _e340));
    let _e344 = info_3;
    let _e348 = yuv_1;
    if ((_e344.vram_size == 3i) || _e348) {
        {
            let _e351 = upload_x;
            iteration_offset = (4i * (_e351 & -2i));
        }
    } else {
        {
            let _e356 = info_3;
            if (_e356.vram_size == 2i) {
                {
                    let _e360 = upload_x;
                    if ((_e360 & 2i) != 0i) {
                        {
                            let _e365 = upload_y;
                            if (_e365 > 0i) {
                                {
                                    let _e368 = upload_y;
                                    upload_y = (_e368 - 1i);
                                    let _e371 = upload_x;
                                    let _e372 = tmem16_stride;
                                    upload_x = (_e371 + _e372);
                                    let _e374 = upload_x;
                                    upload_x = (_e374 ^ 2i);
                                }
                            } else {
                                {
                                    return;
                                }
                            }
                        }
                    }
                    let _e378 = upload_x;
                    iteration_offset = (2i * (_e378 & -2i));
                }
            } else {
                {
                    let _e383 = info_3;
                    if (_e383.vram_size == 1i) {
                        {
                            loop {
                                {
                                    let _e389 = i;
                                    let _e392 = upload_y;
                                    _395_ = ((_e389 < 4i) && (_e392 > 0i));
                                    let _e398 = _395_;
                                    if _e398 {
                                        {
                                            let _e399 = upload_x;
                                            _401_ = ((_e399 & 6i) != 0i);
                                        }
                                    } else {
                                        {
                                            let _e404 = _395_;
                                            _401_ = _e404;
                                        }
                                    }
                                    let _e405 = _401_;
                                    if _e405 {
                                        {
                                            let _e406 = upload_y;
                                            upload_y = (_e406 - 1i);
                                            let _e409 = upload_x;
                                            let _e410 = tmem16_stride;
                                            upload_x = (_e409 + _e410);
                                            let _e412 = upload_x;
                                            upload_x = (_e412 ^ 2i);
                                            let _e415 = i;
                                            i = (_e415 + 1i);
                                            continue;
                                        }
                                    } else {
                                        {
                                            break;
                                        }
                                    }
                                }
                            }
                            let _e418 = upload_x;
                            if ((_e418 & 6i) != 0i) {
                                {
                                    return;
                                }
                            }
                            let _e423 = upload_x;
                            iteration_offset = (_e423 & -2i);
                        }
                    }
                }
            }
        }
    }
    let _e427 = upload_x;
    let _e428 = info_3;
    if (_e427 >= _e428.width) {
        {
            return;
        }
    }
    let _e431 = info_3;
    let _e433 = upload_y;
    let _e434 = info_3;
    let _e437 = info_3;
    line_rdram_addr = (_e431.vram_addr + ((_e433 * _e434.vram_width) << u32((_e437.vram_size - 1i))));
    let _e445 = line_rdram_addr;
    let _e446 = iteration_offset;
    let _e449 = upload_x;
    rdram_addr_1 = ((_e445 + _e446) + (4i * (_e449 & 1i)));
    let _e456 = rdram_addr_1;
    if ((_e456 & 3i) == 0i) {
        {
            let _e461 = rdram_addr_1;
            let _e467 = vram32_.data[(_e461 >> 2u)];
            word_1 = _e467;
        }
    } else {
        {
            let _e468 = rdram_addr_1;
            let _e475 = vram32_.data[((_e468 ^ 3i) >> 2u)];
            let _e476 = rdram_addr_1;
            let _e490 = rdram_addr_1;
            let _e499 = vram32_.data[(((_e490 + 1i) ^ 3i) >> 2u)];
            let _e500 = rdram_addr_1;
            let _e517 = rdram_addr_1;
            let _e526 = vram32_.data[(((_e517 + 2i) ^ 3i) >> 2u)];
            let _e527 = rdram_addr_1;
            let _e544 = rdram_addr_1;
            let _e553 = vram32_.data[(((_e544 + 3i) ^ 3i) >> 2u)];
            let _e554 = rdram_addr_1;
            word_1 = ((((((_e475 >> ((u32((_e476 ^ 3i)) & 3u) * 8u)) & 255u) << 24u) | (((_e499 >> ((u32(((_e500 + 1i) ^ 3i)) & 3u) * 8u)) & 255u) << 16u)) | (((_e526 >> ((u32(((_e527 + 2i) ^ 3i)) & 3u) * 8u)) & 255u) << 8u)) | ((_e553 >> ((u32(((_e554 + 3i) ^ 3i)) & 3u) * 8u)) & 255u));
        }
    }
    let _e568 = yuv_1;
    if _e568 {
        {
            let _e569 = upper_tmem_1;
            if _e569 {
                {
                    let _e570 = word_1;
                    y0_ = ((_e570 >> 16u) & 255u);
                    let _e576 = word_1;
                    y1_ = ((_e576 >> 0u) & 255u);
                    let _e582 = y0_;
                    let _e585 = y1_;
                    word_1 = ((_e582 << 8u) | _e585);
                }
            } else {
                {
                    let _e587 = word_1;
                    u = ((_e587 >> 24u) & 255u);
                    let _e593 = word_1;
                    v = ((_e593 >> 8u) & 255u);
                    let _e599 = u;
                    let _e602 = v;
                    word_1 = ((_e599 << 8u) | _e602);
                }
            }
        }
    } else {
        {
            let _e604 = word_1;
            let _e607 = upper_tmem_1;
            word_1 = (_e604 >> (16u - (16u * select(0u, 1u, _e607))));
            let _e614 = word_1;
            word_1 = (_e614 & 65535u);
        }
    }
    let _e617 = word_1;
    current_tmem_value = _e617;
    tmem_dirty = true;
    return;
}

fn update_tmem_16_(info_4: UploadInfo, tmem16_index_4: i32) {
    var info_5: UploadInfo;
    var tmem16_index_5: i32;
    var tmem16_offset_2: i32;
    var tmem16_stride_1: i32;
    var pixel_offset_2: i32;
    var upload_x_xor_1: i32 = 0i;
    var upload_x_1: i32;
    var upload_y_1: i32;
    var word_offset_1: i32;
    var param_1: i32;
    var param_1_1: f32;
    var min_t_1: i32;
    var param_2_1: i32;
    var param_3_1: f32;
    var max_t_1: i32;
    var max_word_candidate_1: i32;
    var min_word_candidate_1: i32;
    var found_candidate_1: bool = false;
    var t_1: i32;
    var candidate_solution: i32;
    var computed_t: i32;
    var param_4_1: i32;
    var param_5_1: f32;
    var iteration_offset_1: i32;
    var _757_: bool;
    var _763_: bool;
    var line_rdram_addr_1: i32;
    var rdram_addr_2: i32;
    var word_2: u32;

    info_5 = info_4;
    tmem16_index_5 = tmem16_index_4;
    let _e21 = info_5;
    tmem16_offset_2 = ((_e21.tmem_offset & 4095i) >> 1u);
    let _e29 = info_5;
    tmem16_stride_1 = _e29.tmem_stride_words;
    let _e32 = tmem16_index_5;
    let _e33 = tmem16_offset_2;
    pixel_offset_2 = ((_e32 - _e33) & 2047i);
    let _e42 = info_5;
    if (_e42.mode == 2i) {
        {
            let _e46 = pixel_offset_2;
            word_offset_1 = (_e46 >> 2u);
            let _e51 = info_5;
            if (_e51.tmem_stride_words == 0i) {
                {
                    let _e55 = word_offset_1;
                    let _e56 = info_5;
                    upload_x_xor_1 = ((((_e55 * _e56.dxt) >> 16u) & 1i) << 1u);
                }
            } else {
                {
                    let _e67 = word_offset_1;
                    param_1 = _e67;
                    let _e69 = info_5;
                    param_1_1 = _e69.min_t_mod;
                    let _e72 = param_1;
                    let _e73 = param_1_1;
                    let _e74 = compute_upload_t(_e72, _e73);
                    min_t_1 = _e74;
                    let _e76 = word_offset_1;
                    param_2_1 = _e76;
                    let _e78 = info_5;
                    param_3_1 = _e78.max_t_mod;
                    let _e81 = param_2_1;
                    let _e82 = param_3_1;
                    let _e83 = compute_upload_t(_e81, _e82);
                    max_t_1 = _e83;
                    let _e85 = word_offset_1;
                    let _e86 = tmem16_stride_1;
                    let _e87 = min_t_1;
                    max_word_candidate_1 = (_e85 - (_e86 * _e87));
                    let _e91 = word_offset_1;
                    let _e92 = tmem16_stride_1;
                    let _e93 = max_t_1;
                    min_word_candidate_1 = (_e91 - (_e92 * _e93));
                    let _e97 = min_t_1;
                    let _e98 = min_word_candidate_1;
                    let _e99 = info_5;
                    min_t_1 = max(_e97, ((_e98 * _e99.dxt) >> 16u));
                    let _e106 = max_t_1;
                    let _e107 = max_word_candidate_1;
                    let _e108 = info_5;
                    max_t_1 = min(_e106, ((_e107 * _e108.dxt) >> 16u));
                    let _e117 = max_t_1;
                    t_1 = _e117;
                    loop {
                        let _e119 = t_1;
                        let _e120 = min_t_1;
                        if !((_e119 >= _e120)) {
                            break;
                        }
                        {
                            let _e126 = word_offset_1;
                            let _e127 = tmem16_stride_1;
                            let _e128 = t_1;
                            candidate_solution = (_e126 - (_e127 * _e128));
                            let _e132 = candidate_solution;
                            let _e133 = info_5;
                            computed_t = ((_e132 * _e133.dxt) >> 16u);
                            let _e140 = candidate_solution;
                            let _e141 = computed_t;
                            let _e142 = tmem16_stride_1;
                            let _e145 = word_offset_1;
                            if ((_e140 + (_e141 * _e142)) == _e145) {
                                {
                                    found_candidate_1 = true;
                                    let _e148 = computed_t;
                                    upload_x_xor_1 = ((_e148 & 1i) << 1u);
                                    let _e154 = candidate_solution;
                                    let _e158 = pixel_offset_2;
                                    pixel_offset_2 = ((_e154 << 2u) + (_e158 & 3i));
                                }
                            }
                        }
                        continuing {
                            let _e123 = t_1;
                            t_1 = (_e123 - 1i);
                        }
                    }
                    let _e162 = found_candidate_1;
                    if !(_e162) {
                        {
                            return;
                        }
                    }
                }
            }
            let _e164 = pixel_offset_2;
            upload_x_1 = _e164;
            upload_y_1 = 0i;
        }
    } else {
        {
            let _e166 = tmem16_stride_1;
            if (_e166 == 0i) {
                {
                    let _e169 = pixel_offset_2;
                    upload_x_1 = _e169;
                    let _e170 = info_5;
                    upload_y_1 = (_e170.height - 1i);
                }
            } else {
                {
                    let _e174 = pixel_offset_2;
                    param_4_1 = _e174;
                    let _e176 = info_5;
                    param_5_1 = _e176.inv_tmem_stride_words;
                    let _e179 = param_4_1;
                    let _e180 = param_5_1;
                    let _e181 = compute_upload_t(_e179, _e180);
                    upload_y_1 = _e181;
                    let _e182 = pixel_offset_2;
                    let _e183 = upload_y_1;
                    let _e184 = tmem16_stride_1;
                    upload_x_1 = (_e182 - (_e183 * _e184));
                    let _e187 = upload_y_1;
                    let _e188 = info_5;
                    if (_e187 >= _e188.height) {
                        {
                            let _e191 = upload_x_1;
                            let _e192 = tmem16_stride_1;
                            let _e193 = upload_y_1;
                            let _e194 = info_5;
                            upload_x_1 = (_e191 + (_e192 * ((_e193 - _e194.height) + 1i)));
                            let _e201 = info_5;
                            upload_y_1 = (_e201.height - 1i);
                        }
                    }
                }
            }
        }
    }
    let _e206 = info_5;
    let _e208 = info_5;
    if (_e206.tmem_size != _e208.vram_size) {
        {
            let _e211 = info_5;
            let _e213 = info_5;
            if ((_e211.vram_size - _e213.tmem_size) == 1i) {
                {
                    let _e218 = upload_x_1;
                    iteration_offset_1 = ((_e218 & -4i) * 4i);
                    let _e224 = upload_x_1;
                    let _e230 = info_5;
                    let _e233 = info_5;
                    if (((_e224 & -4i) + 2i) < (_e230.vram_effective_width >> u32((3i - _e233.vram_size)))) {
                        {
                            let _e239 = iteration_offset_1;
                            iteration_offset_1 = (_e239 + 8i);
                        }
                    }
                }
            } else {
                {
                    let _e242 = info_5;
                    _757_ = (_e242.tmem_size == 2i);
                    let _e248 = _757_;
                    if _e248 {
                        {
                            let _e249 = info_5;
                            _763_ = (_e249.vram_size == 1i);
                        }
                    } else {
                        {
                            let _e253 = _757_;
                            _763_ = _e253;
                        }
                    }
                    let _e254 = _763_;
                    if _e254 {
                        {
                            let _e255 = upload_x_1;
                            if ((_e255 & 4i) != 0i) {
                                {
                                    let _e260 = tmem16_stride_1;
                                    let _e265 = upload_y_1;
                                    if (((_e260 & 4i) != 0i) && (_e265 > 0i)) {
                                        {
                                            let _e269 = upload_y_1;
                                            upload_y_1 = (_e269 - 1i);
                                            let _e272 = upload_x_1;
                                            let _e273 = tmem16_stride_1;
                                            upload_x_1 = (_e272 + _e273);
                                        }
                                    } else {
                                        {
                                            return;
                                        }
                                    }
                                }
                            }
                            let _e275 = upload_x_1;
                            iteration_offset_1 = (_e275 & -4i);
                        }
                    }
                }
            }
        }
    } else {
        {
            let _e279 = upload_x_1;
            iteration_offset_1 = ((_e279 & -4i) * 2i);
        }
    }
    let _e285 = upload_x_1;
    let _e286 = info_5;
    if (_e285 >= _e286.width) {
        {
            return;
        }
    }
    let _e289 = info_5;
    let _e291 = upload_y_1;
    let _e292 = info_5;
    let _e295 = info_5;
    line_rdram_addr_1 = (_e289.vram_addr + ((_e291 * _e292.vram_width) << u32((_e295.vram_size - 1i))));
    let _e303 = upload_x_1;
    let _e304 = upload_y_1;
    let _e310 = upload_x_xor_1;
    upload_x_1 = (_e303 ^ (((_e304 & 1i) << 1u) | _e310));
    let _e313 = line_rdram_addr_1;
    let _e314 = iteration_offset_1;
    let _e317 = upload_x_1;
    rdram_addr_2 = ((_e313 + _e314) + (2i * (_e317 & 3i)));
    let _e324 = rdram_addr_2;
    if ((_e324 & 1i) == 0i) {
        {
            let _e329 = rdram_addr_2;
            let _e339 = vram32_.data[(((_e329 >> 1u) ^ 1i) >> 1u)];
            let _e340 = rdram_addr_2;
            word_2 = ((_e339 >> ((u32(((_e340 >> 1u) ^ 1i)) & 1u) * 16u)) & 65535u);
        }
    } else {
        {
            let _e354 = rdram_addr_2;
            let _e361 = vram32_.data[((_e354 ^ 3i) >> 2u)];
            let _e362 = rdram_addr_2;
            let _e376 = rdram_addr_2;
            let _e385 = vram32_.data[(((_e376 + 1i) ^ 3i) >> 2u)];
            let _e386 = rdram_addr_2;
            word_2 = ((((_e361 >> ((u32((_e362 ^ 3i)) & 3u) * 8u)) & 255u) << 8u) | ((_e385 >> ((u32(((_e386 + 1i) ^ 3i)) & 3u) * 8u)) & 255u));
        }
    }
    let _e400 = word_2;
    current_tmem_value = _e400;
    tmem_dirty = true;
    return;
}

fn main_1() {
    var tmem16_index_6: i32;
    var upper_tmem_2: bool;
    var _wi16_: u32;
    var _b16_: u32;
    var num_uploads: i32;
    var info_6: UploadInfo;
    var i_1: i32 = 0i;
    var param_2: UploadInfo;
    var param_1_2: i32;
    var yuv_2: bool;
    var param_2_2: UploadInfo;
    var param_3_2: i32;
    var param_4_2: bool;
    var param_5_2: bool;
    var param_6_: UploadInfo;
    var param_7_: i32;
    var _wi16_1: u32;
    var _b16_1: u32;

    tmem_dirty = false;
    let _e19 = gl_GlobalInvocationID_1;
    let _e25 = tmem16_.data[(_e19.x >> 1u)];
    let _e26 = gl_GlobalInvocationID_1;
    current_tmem_value = ((_e25 >> ((_e26.x & 1u) * 16u)) & 65535u);
    let _e35 = gl_GlobalInvocationID_1;
    tmem16_index_6 = (i32(_e35.x) ^ 1i);
    let _e41 = tmem16_index_6;
    upper_tmem_2 = (_e41 >= 1024i);
    {
        let _e49 = gl_GlobalInvocationID_1;
        _wi16_ = (0u + (u32(_e49.x) / 2u));
        let _e56 = gl_GlobalInvocationID_1;
        _b16_ = ((u32(_e56.x) & 1u) * 16u);
        let _e64 = _wi16_;
        let _e67 = _wi16_;
        let _e70 = tile_instances.raw[_e67];
        let _e72 = _b16_;
        let _e76 = current_tmem_value;
        let _e80 = _b16_;
        tile_instances.raw[_e64] = ((_e70 & ~((65535u << _e72))) | ((u32(_e76) & 65535u) << _e80));
    }
    let _e83 = registers;
    num_uploads = _e83.num_uploads;
    loop {
        let _e89 = i_1;
        let _e90 = num_uploads;
        if !((_e89 < _e90)) {
            break;
        }
        {
            let _e97 = i_1;
            let _e100 = _1120_.upload_info[_e97];
            info_6.width = _e100.width;
            let _e103 = i_1;
            let _e106 = _1120_.upload_info[_e103];
            info_6.height = _e106.height;
            let _e109 = i_1;
            let _e112 = _1120_.upload_info[_e109];
            info_6.min_t_mod = _e112.min_t_mod;
            let _e115 = i_1;
            let _e118 = _1120_.upload_info[_e115];
            info_6.max_t_mod = _e118.max_t_mod;
            let _e121 = i_1;
            let _e124 = _1120_.upload_info[_e121];
            info_6.vram_addr = _e124.vram_addr;
            let _e127 = i_1;
            let _e130 = _1120_.upload_info[_e127];
            info_6.vram_width = _e130.vram_width;
            let _e133 = i_1;
            let _e136 = _1120_.upload_info[_e133];
            info_6.vram_size = _e136.vram_size;
            let _e139 = i_1;
            let _e142 = _1120_.upload_info[_e139];
            info_6.vram_effective_width = _e142.vram_effective_width;
            let _e145 = i_1;
            let _e148 = _1120_.upload_info[_e145];
            info_6.tmem_offset = _e148.tmem_offset;
            let _e151 = i_1;
            let _e154 = _1120_.upload_info[_e151];
            info_6.tmem_stride_words = _e154.tmem_stride_words;
            let _e157 = i_1;
            let _e160 = _1120_.upload_info[_e157];
            info_6.tmem_size = _e160.tmem_size;
            let _e163 = i_1;
            let _e166 = _1120_.upload_info[_e163];
            info_6.tmem_fmt = _e166.tmem_fmt;
            let _e169 = i_1;
            let _e172 = _1120_.upload_info[_e169];
            info_6.mode = _e172.mode;
            let _e175 = i_1;
            let _e178 = _1120_.upload_info[_e175];
            info_6.inv_tmem_stride_words = _e178.inv_tmem_stride_words;
            let _e181 = i_1;
            let _e184 = _1120_.upload_info[_e181];
            info_6.dxt = _e184.dxt;
            let _e187 = i_1;
            let _e190 = _1120_.upload_info[_e187];
            info_6.padding = _e190.padding;
            let _e192 = info_6;
            if (_e192.mode == 1i) {
                {
                    let _e196 = info_6;
                    param_2 = _e196;
                    let _e198 = tmem16_index_6;
                    param_1_2 = _e198;
                    let _e200 = param_2;
                    let _e201 = param_1_2;
                    update_tmem_lut(_e200, _e201);
                }
            } else {
                {
                    let _e202 = info_6;
                    yuv_2 = (_e202.tmem_fmt == 1i);
                    let _e207 = info_6;
                    let _e211 = yuv_2;
                    if ((_e207.tmem_size == 3i) || _e211) {
                        {
                            let _e213 = info_6;
                            param_2_2 = _e213;
                            let _e215 = tmem16_index_6;
                            param_3_2 = (_e215 & 1023i);
                            let _e219 = upper_tmem_2;
                            param_4_2 = _e219;
                            let _e221 = yuv_2;
                            param_5_2 = _e221;
                            let _e223 = param_2_2;
                            let _e224 = param_3_2;
                            let _e225 = param_4_2;
                            let _e226 = param_5_2;
                            update_tmem_32_(_e223, _e224, _e225, _e226);
                        }
                    } else {
                        {
                            let _e227 = info_6;
                            param_6_ = _e227;
                            let _e229 = tmem16_index_6;
                            param_7_ = _e229;
                            let _e231 = param_6_;
                            let _e232 = param_7_;
                            update_tmem_16_(_e231, _e232);
                        }
                    }
                }
            }
            {
                let _e233 = i_1;
                let _e239 = gl_GlobalInvocationID_1;
                _wi16_1 = ((u32((_e233 + 1i)) * 1024u) + (u32(_e239.x) / 2u));
                let _e246 = gl_GlobalInvocationID_1;
                _b16_1 = ((u32(_e246.x) & 1u) * 16u);
                let _e254 = _wi16_1;
                let _e257 = _wi16_1;
                let _e260 = tile_instances.raw[_e257];
                let _e262 = _b16_1;
                let _e266 = current_tmem_value;
                let _e270 = _b16_1;
                tile_instances.raw[_e254] = ((_e260 & ~((65535u << _e262))) | ((u32(_e266) & 65535u) << _e270));
            }
        }
        continuing {
            let _e93 = i_1;
            i_1 = (_e93 + 1i);
        }
    }
    let _e273 = tmem_dirty;
    if _e273 {
        {
            let _e274 = gl_GlobalInvocationID_1;
            let _e280 = gl_GlobalInvocationID_1;
            let _e286 = tmem16_.data[(_e280.x >> 1u)];
            let _e288 = gl_GlobalInvocationID_1;
            let _e297 = current_tmem_value;
            let _e300 = gl_GlobalInvocationID_1;
            tmem16_.data[(_e274.x >> 1u)] = ((_e286 & ~((65535u << ((_e288.x & 1u) * 16u)))) | ((_e297 & 65535u) << ((_e300.x & 1u) * 16u)));
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
