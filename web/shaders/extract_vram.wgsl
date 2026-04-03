// Translated from extract_vram.comp (paraLLEl-RDP)
// Copies VRAM (RDRAM framebuffer) into a 2-D RGBA8 storage texture for VI scanout.
//
// WGSL differences vs GLSL:
//  - push_constant → uniform buffer at group(2) binding(0)
//  - Two VRAM buffer aliases (vram16/vram32) unified as vram_u32; u16 extracted manually.
//  - storage image (rgba8ui) → texture_storage_2d<rgba8uint, write>
//  - RDRAM_SIZE is a uniform constant; masks computed from it.

struct Registers {
    fb_offset  : i32,
    fb_width   : i32,
    offset     : vec2<i32>,
    resolution : vec2<i32>,
    rdram_size : u32,   // replaces specialization constant RDRAM_SIZE
    fmt_rgba32 : u32,   // 1 = RGBA8888, 0 = RGBA5551
    fetch_aa   : u32,   // 1 = read hidden VRAM alpha
    _pad       : u32,
}

@group(2) @binding(0) var<uniform> regs: Registers;

@group(0) @binding(0) var output_tex  : texture_storage_2d<rgba8uint, write>;
// Unified VRAM buffer (u32 words).  u16 pairs are stored big-endian within each word.
@group(0) @binding(1) var<storage, read> vram_u32   : array<u32>;
// Hidden VRAM (sub-pixel alpha for RGBA5551).
@group(0) @binding(2) var<storage, read> hidden_vram: array<u32>;

fn vram_read_u16(index_u16: i32) -> u32 {
    // Two u16 per u32 word; byte-swap parity matches N64 big-endian layout.
    let word_idx = u32(index_u16 >> 1);
    let word     = vram_u32[word_idx];
    let shift    = select(0u, 16u, (index_u16 & 1) == 0);
    return (word >> shift) & 0xFFFFu;
}

fn fetch_color(coord: vec2<i32>) -> vec4<u32> {
    let rdram_mask_32 = i32(regs.rdram_size >> 2u) - 1;
    let rdram_mask_16 = i32(regs.rdram_size >> 1u) - 1;

    var color: vec4<u32>;

    if (regs.fmt_rgba32 != 0u) {
        // RGBA8888 (32bpp)
        var linear = coord.y * regs.fb_width + coord.x + regs.fb_offset;
        linear &= rdram_mask_32;
        let word = vram_u32[u32(linear)];
        color = (vec4<u32>(word) >> vec4<u32>(24u, 16u, 8u, 5u)) & vec4<u32>(0xFFu, 0xFFu, 0xFFu, 7u);
    } else {
        // RGBA5551 (16bpp)
        var linear = coord.y * regs.fb_width + coord.x + regs.fb_offset;
        linear &= rdram_mask_16;
        // XOR by 1 matches the byte-swap the GLSL version uses.
        let word   = vram_read_u16(linear ^ 1);
        let r      = (word >> 8u)  & 0xF8u;
        let g      = (word >> 3u)  & 0xF8u;
        let b      = (word << 2u)  & 0xF8u;
        let hv_idx = u32(linear >> 1); // one u8 per 2 u16 in hidden_vram word
        let hv_sh  = select(0u, 8u, (linear & 1) != 0);
        let hv     = (hidden_vram[hv_idx] >> hv_sh) & 0xFFu;
        let a      = ((word & 1u) << 2u) | hv;
        color = vec4<u32>(r, g, b, a);
    }

    if (regs.fetch_aa == 0u) {
        color.w = 7u;
    }
    return color;
}

@compute @workgroup_size(16, 8, 1)
fn main(@builtin(global_invocation_id) gid: vec3<u32>) {
    if (any(vec2<u32>(gid.xy) >= vec2<u32>(regs.resolution))) {
        return;
    }
    let coord = vec2<i32>(gid.xy) + regs.offset;
    let col   = fetch_color(coord);
    textureStore(output_tex, vec2<i32>(gid.xy), col);
}
