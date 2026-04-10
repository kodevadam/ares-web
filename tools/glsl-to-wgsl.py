#!/usr/bin/env python3
"""
glsl-to-wgsl.py — transpile paraLLEl-RDP compute shaders to WGSL

Pipeline:
  1. spirv-cross --vulkan-semantics  (preserves set/binding, emits constant_id)
  2. Python patches (this script)
     a. Remove int8/int16 extension blocks
     b. Inline specialization constants with their defaults
     c. Fix local_size_x_id / local_size_y_id → literal workgroup sizes
     d. Remove readonly / writeonly from buffer declarations
     e. For SSBOs whose element type is uint8_t/uint16_t:
        - Change declaration to uint[]
        - Replace every uint(buf.field[EXPR]) read with the appropriate bit-extraction
  3. naga --input-kind glsl --shader-stage compute  (GLSL → WGSL)

Limitations (shaders skipped):
  - Shaders that put u8/u16 fields inside structs used in SSBOs cannot be
    automatically transformed because the CPU-side struct layout would also
    need to change.  Those shaders are listed in SKIP_SHADERS below and
    will be left as empty stubs.

Usage:
    python3 tools/glsl-to-wgsl.py [--spv-dir tools/spv] [--out-dir web/shaders]
"""

import os
import re
import sys
import subprocess
import argparse
import tempfile

# ---------------------------------------------------------------------------
# Spec-constant default values per shader (from ImplementationConstants /
# rdp_data_structures.hpp and rdp_renderer.cpp).  These are the values that
# paraLLEl-RDP uses at pipeline-creation time for the web (no upscaling,
# no subgroups, small-types variant = 0).
#
# Key: shader name → dict of constant_id → (glsl_type, value_str)
# ---------------------------------------------------------------------------
SPEC_CONST_DEFAULTS = {
    # clear_write_mask: ID1=PAGE_STRIDE(256), ID0=local_size_x(64)
    "clear_write_mask": {0: ("uint", "64u"), 1: ("int", "256")},
    # clear_indirect_buffer: ID0=local_size_x(64)
    "clear_indirect_buffer": {0: ("uint", "64u")},
    # clear_super_sampled_write_mask: ID0=local_size_x(64)
    "clear_super_sampled_write_mask": {0: ("uint", "64u")},
    # masked_rdram_resolve: ID1=?, ID0=local_size_x(64)
    "masked_rdram_resolve": {0: ("uint", "64u"), 1: ("uint", "1u")},
    # extract_vram: ID2=SCALING_LOG2(0), ID1=VI_STATUS(0), ID0=RDRAM_SIZE(8*1024*1024)
    "extract_vram": {
        0: ("int", str(8 * 1024 * 1024)),
        1: ("int", "0"),
        2: ("int", "0"),
    },
    # masked_rdram_resolve: ID0=local_size_x(64), ID1=PAGE_STRIDE(256)
    "masked_rdram_resolve": {0: ("uint", "64u"), 1: ("int", "256")},
    # update_upscaled_domain_*: ID3=local_size_x(64), RDRAM_SIZE default, NUM_SAMPLES=1
    "update_upscaled_domain_post": {
        3: ("uint", "64u"), 0: ("int", str(8*1024*1024)),
        1: ("int", "0"), 2: ("bool", "false"), 4: ("int", "1"),
    },
    "update_upscaled_domain_pre": {
        3: ("uint", "64u"), 0: ("int", str(8*1024*1024)),
        1: ("int", "0"), 2: ("bool", "false"), 4: ("int", "1"),
    },
    "update_upscaled_domain_resolve": {
        3: ("uint", "64u"), 0: ("int", str(8*1024*1024)),
        1: ("int", "0"), 2: ("bool", "false"), 4: ("int", "1"),
        5: ("bool", "false"), 6: ("bool", "false"),
    },
    # Core rendering shaders — frozen for non-upscaling 1× render
    "span_setup":  {0: ("uint", "64u"), 1: ("int", "8")},
    "tmem_update": {0: ("uint", "64u")},
    "depth_blend": {
        # 0=RDRAM_SIZE, 1=FB_FMT(0=RGBA8888), 2=FB_COLOR_DEPTH_ALIAS, 3/%4=unknown,
        # 5=MAX_PRIMITIVES, 6=MAX_WIDTH(→MAX_TILES_X=128), 7=RDRAM_INCOHERENT_SCALING
        0: ("uint", str(8*1024*1024)), 1: ("int", "0"), 2: ("int", "1"),
        3: ("int", "8"), 4: ("int", "8"), 5: ("int", "256"), 6: ("int", "1024"), 7: ("int", "0"),
    },
    "rasterizer": {
        # SpecId 0 = gl_WorkGroupSize.x, SpecId 1 = gl_WorkGroupSize.y (NOT RDRAM_SIZE)
        # 8×8 tiles for non-upscaling 1× render
        0: ("uint", "8"), 1: ("uint", "8"), 2: ("int", "8"), 3: ("int", "8"),
        4: ("int", "0"), 5: ("int", "0"), 6: ("int", "1"), 7: ("int", "0"),
    },
    "ubershader": {
        # 0=RDRAM_SIZE, 1=FB_FMT(0=I4 default), 2=FB_COLOR_DEPTH_ALIAS, 3/4=local_size_x/y,
        # 5=MAX_PRIMITIVES, 6=MAX_WIDTH(→MAX_TILES_X=128), 7=RDRAM_INCOHERENT_SCALING
        0: ("uint", str(8*1024*1024)), 1: ("int", "0"), 2: ("int", "1"),
        3: ("int", "8"), 4: ("int", "8"), 5: ("int", "256"), 6: ("int", "1024"), 7: ("int", "0"),
    },
    # RGBA5551 (16bpp) variant — used by most N64 games
    "ubershader_rgba5551": {
        # Same as ubershader but with FB_FMT=2 (RGBA5551), FB_COLOR_DEPTH_ALIAS=0
        0: ("uint", str(8*1024*1024)), 1: ("int", "2"), 2: ("int", "0"),
        3: ("int", "8"), 4: ("int", "8"), 5: ("int", "256"), 6: ("int", "1024"), 7: ("int", "0"),
    },
    # RGBA8888 (32bpp) variant — used by some N64 games
    "ubershader_rgba8888": {
        # Same as ubershader but with FB_FMT=4 (RGBA8888), FB_COLOR_DEPTH_ALIAS=0
        0: ("uint", str(8*1024*1024)), 1: ("int", "4"), 2: ("int", "0"),
        3: ("int", "8"), 4: ("int", "8"), 5: ("int", "256"), 6: ("int", "1024"), 7: ("int", "0"),
    },
}

# ---------------------------------------------------------------------------
# Struct ABI database — byte offsets from SPIR-V MemberDecorate Offset
# Each field: (glsl_type, word_index, bit_offset_within_word)
# element_words = struct byte size / 4
# ---------------------------------------------------------------------------
# Type codes:
#   'i32','u32'       — full 32-bit word
#   'i16','u16'       — 16-bit at bit_offset 0 or 16
#   'u8'              — 8-bit at bit_offset 0,8,16,24
#   'u8vec4'          — packed u8×4 in one word (reads as uvec4)
#   'u16vec4'         — packed u16×4 in two consecutive words
#   'i16vec4'         — packed i16×4 in two consecutive words
#   'ivec4','uvec4'   — full 4×i32 / 4×u32 in four consecutive words

STRUCT_ABI = {
    "TriangleSetupMem": {
        "words": 8,
        "fields": {
            "xh":    ("i32",    0,  0),
            "xm":    ("i32",    1,  0),
            "xl":    ("i32",    2,  0),
            "yh":    ("i16",    3,  0),
            "ym":    ("i16",    3, 16),
            "dxhdy": ("i32",    4,  0),
            "dxmdy": ("i32",    5,  0),
            "dxldy": ("i32",    6,  0),
            "yl":    ("i16",    7,  0),
            "flags": ("u8",     7, 16),
            "tile":  ("u8",     7, 24),
        },
    },
    "DerivedSetupMem": {
        "words": 14,  # 56 bytes
        "fields": {
            "constant_muladd0": ("u8vec4",  0,  0),
            "constant_mulsub0": ("u8vec4",  1,  0),
            "constant_mul0":    ("u8vec4",  2,  0),
            "constant_add0":    ("u8vec4",  3,  0),
            "constant_muladd1": ("u8vec4",  4,  0),
            "constant_mulsub1": ("u8vec4",  5,  0),
            "constant_mul1":    ("u8vec4",  6,  0),
            "constant_add1":    ("u8vec4",  7,  0),
            "fog_color":        ("u8vec4",  8,  0),
            "blend_color":      ("u8vec4",  9,  0),
            "fill_color":       ("u32",    10,  0),
            "dz":               ("u16",    11,  0),
            "dz_compressed":    ("u8",     11, 16),
            "min_lod":          ("u8",     11, 24),
            "factors":          ("i16vec4",12,  0),  # words 12–13
        },
    },
    "DepthBlendStateMem": {
        "words": 4,  # 16 bytes
        "fields": {
            "blend_modes0":  ("u8vec4", 0,  0),
            "blend_modes1":  ("u8vec4", 1,  0),
            "flags":         ("u32",    2,  0),
            "coverage_mode": ("u8",     3,  0),
            "z_mode":        ("u8",     3,  8),
            "padding0":      ("u8",     3, 16),
            "padding1":      ("u8",     3, 24),
        },
    },
    "InstanceIndicesMem": {
        "words": 4,  # 16 bytes
        "fields": {
            "static_depth_tmem": ("u8vec4", 0, 0),
            "other":             ("u8vec4", 1, 0),
            "tile_infos":        ("u8arr8", 2, 0),  # 8 bytes in words 2-3
        },
    },
    "TileInfoMem": {
        "words": 8,  # 32 bytes
        "fields": {
            "slo":     ("u32", 0,  0),
            "shi":     ("u32", 1,  0),
            "tlo":     ("u32", 2,  0),
            "thi":     ("u32", 3,  0),
            "offset":  ("u32", 4,  0),
            "stride":  ("u32", 5,  0),
            "fmt":     ("u8",  6,  0),
            "size":    ("u8",  6,  8),
            "palette": ("u8",  6, 16),
            "mask_s":  ("u8",  6, 24),
            "shift_s": ("u8",  7,  0),
            "mask_t":  ("u8",  7,  8),
            "shift_t": ("u8",  7, 16),
            "flags":   ("u8",  7, 24),
        },
    },
    "SpanSetupMem": {
        "words": 16,  # 64 bytes
        "fields": {
            "rgba":                  ("ivec4",   0,  0),  # words 0-3
            "stzw":                  ("ivec4",   4,  0),  # words 4-7
            "xleft":                 ("u16vec4", 8,  0),  # words 8-9
            "xright":                ("u16vec4",10,  0),  # words 10-11
            "interpolation_base_x":  ("i32",    12,  0),
            "start_x":               ("i32",    13,  0),
            "end_x":                 ("i32",    14,  0),
            "lodlength":             ("i16",    15,  0),
            "valid_line":            ("u16",    15, 16),
        },
    },
    "StaticRasterizationStateMem": {
        "words": 4,  # 16 bytes — all u32
        "fields": {
            "flags":          ("u32", 0, 0),
            "dz_addr":        ("u32", 1, 0),
            "dz_pitch":       ("u32", 2, 0),
            "dz_pitch_log2":  ("u32", 3, 0),
        },
    },
    "SpanInfoOffsetsMem": {
        "words": 4,  # 16 bytes — all u32
        "fields": {
            "offset":         ("u32", 0, 0),
            "y_start":        ("u32", 1, 0),
            "y_end":          ("u32", 2, 0),
            "primitive_index":("u32", 3, 0),
        },
    },
}

# Map SSBO instance names (spirv-cross output) to struct type names
SSBO_STRUCT_MAP = {
    "triangle_setup":    "TriangleSetupMem",
    "derived_setup":     "DerivedSetupMem",
    "depth_blend_state": "DepthBlendStateMem",
    "state_indices":     "InstanceIndicesMem",
    "tile_infos":        "TileInfoMem",
    "span_setups":       "SpanSetupMem",
    "span_setup":        "SpanSetupMem",   # alternate name in some shaders
    "span_info_offsets": "SpanInfoOffsetsMem",
    "span_offsets":      "SpanInfoOffsetsMem",  # alternate name in rasterizer
    "static_rast_state": "StaticRasterizationStateMem",
    "static_raster_state": "StaticRasterizationStateMem",  # alternate in rasterizer
    "static_state":      "StaticRasterizationStateMem",
}

# TMEM array-in-struct SSBOs: inst_name → (struct_type, ssbo_member, bits_per_elem, elems_per_inst)
TMEM_SSBO_ABI = {
    "tmem8":          ("TMEMInstance8Mem",  "instances", "elems", 8,  4096, 1024),
    "tmem16":         ("TMEMInstance16Mem", "instances", "elems", 16, 2048, 1024),
    "tile_instances": ("TileInstance",      "instances", "data",  16, 2048, 1024),
}

# These shaders have u8/u16 fields *inside structs used in SSBOs*.
# Automatic transformation would change the CPU↔GPU memory layout,
# so they are skipped; the generated stub WGSL is empty.
SKIP_SHADERS = {
    # tile_binning — fully hand-written WGSL (web/shaders/tile_binning.wgsl).
    "tile_binning",
    # extract_vram — we use a hand-written WGSL (web/shaders/extract_vram.wgsl)
    # that passes VI_STATUS/RDRAM_SIZE as uniform fields rather than baking them
    # in as spec constants (which would produce a static, broken shader).
    "extract_vram",
}

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def run(cmd, **kw):
    r = subprocess.run(cmd, capture_output=True, text=True, **kw)
    return r.returncode, r.stdout, r.stderr


def _gen_read_expr(raw_name: str, idx: str, ftype: str, word: int, bit: int, words_per_elem: int) -> str:
    """Generate a GLSL expression that reads a field from a raw uint[] SSBO."""
    base = f"({idx}) * {words_per_elem}u + {word}u"
    w = f"{raw_name}[{base}]"
    if ftype == "i32":
        return f"int({w})"
    if ftype == "u32":
        return w
    if ftype == "i16":
        if bit == 0:
            return f"((int({w}) << 16) >> 16)"
        return f"(int({w}) >> 16)"
    if ftype == "u16":
        if bit == 0:
            return f"({w} & 0xFFFFu)"
        return f"({w} >> 16u)"
    if ftype == "u8":
        if bit == 0:
            return f"({w} & 0xFFu)"
        return f"(({w} >> {bit}u) & 0xFFu)"
    if ftype == "u8vec4":
        return (f"uvec4({w} & 0xFFu, ({w} >> 8u) & 0xFFu, "
                f"({w} >> 16u) & 0xFFu, {w} >> 24u)")
    if ftype == "u16vec4":
        w2 = f"{raw_name}[{base} + 1u]"
        return (f"uvec4({w} & 0xFFFFu, {w} >> 16u, "
                f"{w2} & 0xFFFFu, {w2} >> 16u)")
    if ftype == "i16vec4":
        w2 = f"{raw_name}[{base} + 1u]"
        return (f"ivec4((int({w}) << 16) >> 16, int({w}) >> 16, "
                f"(int({w2}) << 16) >> 16, int({w2}) >> 16)")
    if ftype == "ivec4":
        return (f"ivec4(int({raw_name}[{base}]), int({raw_name}[{base}+1u]), "
                f"int({raw_name}[{base}+2u]), int({raw_name}[{base}+3u]))")
    if ftype == "uvec4":
        return (f"uvec4({raw_name}[{base}], {raw_name}[{base}+1u], "
                f"{raw_name}[{base}+2u], {raw_name}[{base}+3u])")
    # Fallback
    return w


def _gen_write_stmt(raw_name: str, idx: str, ftype: str, word: int, bit: int,
                    words_per_elem: int, val_expr: str) -> str:
    """Generate GLSL statement(s) to write a value to a raw uint[] SSBO field."""
    base = f"({idx}) * {words_per_elem}u + {word}u"
    wi = f"{raw_name}[{base}]"
    if ftype in ("i32", "u32"):
        return f"{wi} = uint({val_expr});"
    if ftype in ("u16", "i16"):
        mask = "0xFFFFu"
        if bit == 0:
            return (f"{wi} = ({wi} & ~{mask}) | (uint({val_expr}) & {mask});")
        return (f"{wi} = ({wi} & {mask}) | ((uint({val_expr}) & {mask}) << 16u);")
    if ftype == "u8":
        mask = "0xFFu"
        if bit == 0:
            return f"{wi} = ({wi} & ~{mask}) | (uint({val_expr}) & {mask});"
        return (f"{wi} = ({wi} & ~({mask} << {bit}u)) | "
                f"((uint({val_expr}) & {mask}) << {bit}u);")
    if ftype == "u8vec4":
        return (f"{{ uvec4 _v = uvec4({val_expr}); "
                f"{wi} = (_v.x & 0xFFu) | ((_v.y & 0xFFu) << 8u) | "
                f"((_v.z & 0xFFu) << 16u) | (_v.w << 24u); }}")
    if ftype == "u16vec4":
        w2 = f"{raw_name}[{base}+1u]"
        return (f"{{ uvec4 _v = uvec4({val_expr}); "
                f"{wi} = (_v.x & 0xFFFFu) | (_v.y << 16u); "
                f"{w2} = (_v.z & 0xFFFFu) | (_v.w << 16u); }}")
    if ftype in ("ivec4", "uvec4"):
        stmts = []
        for k in range(4):
            wk = f"{raw_name}[{base}+{k}u]"
            stmts.append(f"{wk} = uint(({val_expr})[{k}]);")
        return " ".join(stmts)
    return f"/* TODO write {ftype} to {wi} */;"


def _strip_outer_cast(val: str) -> str:
    """Strip one outermost sub-word type cast from val using balanced-paren matching."""
    m = re.match(
        r'^(?:uint8_t|int8_t|uint16_t|int16_t|u8vec4|u16vec4|i16vec4)\s*\(', val
    )
    if not m:
        return val
    depth = 1
    i = m.end()
    while i < len(val) and depth > 0:
        if val[i] == '(':
            depth += 1
        elif val[i] == ')':
            depth -= 1
        i += 1
    if depth == 0 and i == len(val):
        return val[m.end():i - 1]
    return val  # paren didn't close at end of string — don't strip


def _strip_subword_casts(val: str) -> str:
    """Iteratively strip outermost sub-word type casts from a GLSL value expression."""
    prev = None
    while val != prev:
        prev = val
        val = _strip_outer_cast(val)
    return val


def legalize_struct_ssbos(glsl: str) -> str:
    """
    Replace Mem-struct SSBO declarations + all field accesses with
    raw uint[] SSBOs and explicit bit-extraction expressions.

    Works in three passes:
    1. Detect Mem-struct SSBO instance names and their struct types.
    2. Replace the SSBO block declarations with  `uint _NAME_raw[];`.
    3. Replace all `NAME.elems[EXPR].FIELD` (read) and
       `NAME.elems[EXPR].FIELD = VAL;` (write) with generated code.
    """
    # ── Pass 1: discover SSBO→struct bindings ──────────────────────────────
    # Pattern:  layout(...) [readonly|writeonly] buffer XxxBuffer { StructType elems[]; } instance;
    # Also matches  buffer XxxBuffer { StructType elems[]; } instance;
    decl_re = re.compile(
        r'layout\s*\([^)]*\)\s*(?:readonly\s+|writeonly\s+)?buffer\s+\w+\s*\{'
        r'\s*(\w+)\s+elems\s*\[\s*\]\s*;\s*\}\s*(\w+)\s*;',
        re.DOTALL,
    )
    _SUBWORD_FTYPES = frozenset({"i16", "u16", "u8", "u8vec4", "u16vec4", "i16vec4", "u8arr8"})

    def _has_subword(stype: str) -> bool:
        abi = STRUCT_ABI.get(stype, {})
        return any(ft in _SUBWORD_FTYPES for (ft, _, _) in abi.get("fields", {}).values())

    instance_to_struct: dict[str, str] = {}
    for m in decl_re.finditer(glsl):
        stype = m.group(1)   # e.g. DerivedSetupMem
        inst  = m.group(2)   # e.g. derived_setup
        # Only legalize structs that actually have sub-word fields; all-u32 structs
        # are valid GLSL already and can stay as-is (removing them breaks function
        # signatures that use the type name as return/parameter type).
        if stype in STRUCT_ABI and _has_subword(stype):
            instance_to_struct[inst] = stype

    if not instance_to_struct:
        return glsl

    # ── Pass 2: replace SSBO declarations + remove struct definitions ────────
    def replace_decl2(m: re.Match) -> str:
        stype = m.group(1)
        inst  = m.group(2)
        if stype not in instance_to_struct.values():
            return m.group(0)
        full = m.group(0)
        full = re.sub(r'\b' + re.escape(stype) + r'\s+elems\s*\[\s*\]\s*;',
                      f'uint {inst}_raw[];', full)
        return full

    glsl = decl_re.sub(replace_decl2, glsl)

    # Remove struct definitions only for structs we actually legalized
    for stype in set(instance_to_struct.values()):
        glsl = re.sub(
            r'struct\s+' + re.escape(stype) + r'\s*\{[^}]*\}\s*;',
            f'// struct {stype} replaced by raw uint[] ABI',
            glsl,
            flags=re.DOTALL,
        )

    # ── Pass 3a: replace WRITE accesses  NAME.elems[EXPR].FIELD = VAL; ─────
    for inst, stype in instance_to_struct.items():
        abi = STRUCT_ABI[stype]
        words = abi["words"]

        for fname, (ftype, word, bit) in abi["fields"].items():
            # Match:  inst.elems[EXPR].fname = VAL;
            # VAL may contain casts like uint16_t(...) or u16vec4(...)
            write_re = re.compile(
                r'(?<!\w)' + re.escape(inst) + r'\.elems\[([^\]]+)\]\.' + re.escape(fname)
                + r'(?!\w)\s*=\s*([^;]+);'
            )
            raw = f"{inst}.{inst}_raw"
            def do_write(m: re.Match, _raw=raw, _ftype=ftype, _w=word,
                         _b=bit, _words=words) -> str:
                idx = m.group(1).strip()
                val = m.group(2).strip()
                # Strip outermost sub-word type casts from val using balanced parens
                val = _strip_subword_casts(val)
                return _gen_write_stmt(_raw, idx, _ftype, _w, _b, _words, val)
            glsl = write_re.sub(do_write, glsl)

    # ── Pass 3b: replace READ accesses ──────────────────────────────────────
    # Handle wrapping casts:  int(inst.elems[EXPR].FIELD), uint(...), ivec4(...), uvec4(...)
    cast_wrap = r'(?:int|uint|ivec4|uvec4|i16vec4|u16vec4)\s*\(\s*'
    double_cast = r'(?:int|uint)\s*\(\s*(?:uint|int)\s*\(\s*'

    for inst, stype in instance_to_struct.items():
        abi = STRUCT_ABI[stype]
        words = abi["words"]
        raw = f"{inst}.{inst}_raw"

        for fname, (ftype, word, bit) in abi["fields"].items():
            if ftype == "u8arr8":
                continue  # handled separately in Pass 4 (tile_infos array handler)
            # Negative lookahead (?!\w) prevents "dz" from matching "dz_compressed"
            core_re = (re.escape(inst) + r'\.elems\[([^\]]+)\]\.'
                       + re.escape(fname) + r'(?!\w)')

            # double-cast:  int(uint(inst.elems[IDX].field))
            dbl = re.compile(double_cast + core_re + r'\s*\)\s*\)')
            def do_dbl(m: re.Match, _r=raw, _ft=ftype, _w=word,
                       _b=bit, _ws=words) -> str:
                expr = _gen_read_expr(_r, m.group(1).strip(), _ft, _w, _b, _ws)
                if m.group(0).lstrip().startswith("int"):
                    return f"int({expr})"
                return expr
            glsl = dbl.sub(do_dbl, glsl)

            # single outer cast:  int(inst.elems[IDX].field) or uvec4(...)
            sgl = re.compile(cast_wrap + core_re + r'\s*\)')
            def do_sgl(m: re.Match, _r=raw, _ft=ftype, _w=word,
                       _b=bit, _ws=words) -> str:
                expr = _gen_read_expr(_r, m.group(1).strip(), _ft, _w, _b, _ws)
                if m.group(0).lstrip().startswith("int(") and not m.group(0).lstrip().startswith("ivec"):
                    return f"int({expr})"
                return expr
            glsl = sgl.sub(do_sgl, glsl)

            # bare access (no outer cast):  inst.elems[IDX].field
            bare = re.compile(core_re)
            def do_bare(m: re.Match, _r=raw, _ft=ftype, _w=word,
                        _b=bit, _ws=words) -> str:
                return _gen_read_expr(_r, m.group(1).strip(), _ft, _w, _b, _ws)
            glsl = bare.sub(do_bare, glsl)

    # ── Pass 4: handle InstanceIndicesMem.tile_infos[K] array-field accesses ──
    # tile_infos is uint8_t[8] stored in words 2-3 of the 4-word InstanceIndicesMem.
    # Access: inst.elems[IDX].tile_infos[K]  →  bit-extraction from raw[IDX*4+2+K/4]
    for inst, stype in instance_to_struct.items():
        if stype != "InstanceIndicesMem":
            continue
        raw = f"{inst}.{inst}_raw"
        # Match:  uint(inst.elems[IDX].tile_infos[K])  or bare version
        # Cast-wrapped:
        ti_cast = re.compile(
            r'(?:uint|int)\s*\(\s*' + re.escape(inst)
            + r'\.elems\[([^\]]+)\]\.tile_infos\[([^\]]+)\]\s*\)'
        )
        def do_ti_cast(m: re.Match, _r=raw) -> str:
            oi = m.group(1).strip();  ii = m.group(2).strip()
            return (f"(({_r}[uint({oi})*4u + 2u + uint({ii})/4u])"
                    f" >> (uint({ii})%4u*8u) & 0xFFu)")
        glsl = ti_cast.sub(do_ti_cast, glsl)
        # Bare:
        ti_bare = re.compile(
            re.escape(inst) + r'\.elems\[([^\]]+)\]\.tile_infos\[([^\]]+)\]'
        )
        def do_ti_bare(m: re.Match, _r=raw) -> str:
            oi = m.group(1).strip();  ii = m.group(2).strip()
            return (f"(({_r}[uint({oi})*4u + 2u + uint({ii})/4u])"
                    f" >> (uint({ii})%4u*8u) & 0xFFu)")
        glsl = ti_bare.sub(do_ti_bare, glsl)

    # ── Pass 5: replace usamplerBuffer with storage buffer ──────────────────
    # texelFetch(samplerBuf, idx).xyz → samplerBuf_raw[idx].xyz (array<uvec4>)
    glsl = re.sub(
        r'(layout\s*\([^)]*\))\s*uniform\s+u?samplerBuffer\s+(\w+)\s*;',
        lambda m: (f'{m.group(1)} readonly buffer '
                   f'{m.group(2).upper()}_BUF {{ uvec4 {m.group(2)}_raw[]; }} '
                   f'{m.group(2)}_blk;'),
        glsl,
    )
    # texelFetch replacement needs balanced-paren matching because the index arg
    # may contain nested parentheses (e.g. int(gl_WorkGroupID.x)).
    tf_pat = re.compile(r'texelFetch\s*\(\s*(\w+)\s*,\s*')
    result2 = []
    pos2 = 0
    while True:
        m = tf_pat.search(glsl, pos2)
        if not m:
            result2.append(glsl[pos2:])
            break
        result2.append(glsl[pos2:m.start()])
        sampler = m.group(1)
        i = m.end()
        depth = 1  # inside the outer texelFetch(
        while i < len(glsl) and depth > 0:
            if glsl[i] == '(':
                depth += 1
            elif glsl[i] == ')':
                depth -= 1
            if depth > 0:
                i += 1
            else:
                break
        idx_expr = glsl[m.end():i].rstrip()
        i += 1  # consume closing ')'
        result2.append(f'{sampler}_blk.{sampler}_raw[{idx_expr}]')
        pos2 = i
    glsl = ''.join(result2)

    return glsl


def legalize_tmem_ssbos(glsl: str) -> str:
    """
    Handle TMEMInstance8Mem / TMEMInstance16Mem / TileInstance SSBOs which use
    an 'instances[]' SSBO member where each instance is a fixed-size sub-word array.

    Access pattern:  inst.instances[INST_IDX].FIELD[ELEM_IDX]
    Maps to raw u32: inst.inst_raw[INST_IDX*WORDS_PER_INST + ELEM_IDX/ELEMS_PER_WORD]
    with bit-extraction / RMW writes.
    """
    # TMEM_SSBO_ABI: inst_name → (struct_type, ssbo_member, field_name, bits, count, words)
    for inst, (stype, smember, field, bits, count, words_per_inst) in TMEM_SSBO_ABI.items():
        # Match the SSBO declaration using the given member name
        decl_re = re.compile(
            r'(layout\s*\([^)]*\)\s*(?:readonly\s+|writeonly\s+)?buffer\s+\w+\s*\{)'
            r'\s*' + re.escape(stype) + r'\s+' + re.escape(smember) + r'\s*\[\s*\]\s*;'
            r'\s*\}\s*' + re.escape(inst) + r'\s*;',
            re.DOTALL,
        )
        if not decl_re.search(glsl):
            continue  # not present in this shader

        # Replace declaration
        def _replace_decl(m: re.Match, _inst=inst, _field=field) -> str:
            prefix = m.group(1)
            return f"{prefix}\n    uint raw[];\n}} {_inst};"
        glsl = decl_re.sub(_replace_decl, glsl)

        # Remove the struct definition
        glsl = re.sub(
            r'struct\s+' + re.escape(stype) + r'\s*\{[^}]*\}\s*;',
            f'// struct {stype} replaced by raw uint[] ABI',
            glsl,
            flags=re.DOTALL,
        )

        raw = f"{inst}.raw"

        if bits == 8:
            # Writes: inst.instances[I].field[J] = uint8_t(VAL);
            wr8 = re.compile(
                re.escape(inst) + r'\.' + re.escape(smember)
                + r'\[([^\]]+)\]\.' + re.escape(field) + r'\[([^\]]+)\]\s*=\s*([^;]+);'
            )
            def do_wr8(m: re.Match, _r=raw, _wpi=words_per_inst) -> str:
                ii = m.group(1).strip(); ji = m.group(2).strip()
                val = _strip_subword_casts(m.group(3).strip())
                return (f"{{ uint _wi8 = uint({ii})*{_wpi}u + uint({ji})/4u;"
                        f" uint _b8 = (uint({ji})%4u)*8u;"
                        f" {_r}[_wi8] = ({_r}[_wi8] & ~(0xFFu << _b8))"
                        f" | ((uint({val}) & 0xFFu) << _b8); }}")
            glsl = wr8.sub(do_wr8, glsl)

            # Reads: uint(inst.instances[I].field[J])  or bare
            rd8_cast = re.compile(
                r'(?:uint|int)\s*\(\s*' + re.escape(inst) + r'\.' + re.escape(smember)
                + r'\[([^\]]+)\]\.' + re.escape(field) + r'\[([^\]]+)\]\s*\)'
            )
            def do_rd8_cast(m: re.Match, _r=raw, _wpi=words_per_inst) -> str:
                ii = m.group(1).strip(); ji = m.group(2).strip()
                return (f"(({_r}[uint({ii})*{_wpi}u + uint({ji})/4u])"
                        f" >> (uint({ji})%4u*8u) & 0xFFu)")
            glsl = rd8_cast.sub(do_rd8_cast, glsl)

            rd8_bare = re.compile(
                re.escape(inst) + r'\.' + re.escape(smember)
                + r'\[([^\]]+)\]\.' + re.escape(field) + r'\[([^\]]+)\]'
            )
            def do_rd8_bare(m: re.Match, _r=raw, _wpi=words_per_inst) -> str:
                ii = m.group(1).strip(); ji = m.group(2).strip()
                return (f"(({_r}[uint({ii})*{_wpi}u + uint({ji})/4u])"
                        f" >> (uint({ji})%4u*8u) & 0xFFu)")
            glsl = rd8_bare.sub(do_rd8_bare, glsl)

        else:  # bits == 16
            # Writes: inst.instances[I].field[J] = uint16_t(VAL);
            wr16 = re.compile(
                re.escape(inst) + r'\.' + re.escape(smember)
                + r'\[([^\]]+)\]\.' + re.escape(field) + r'\[([^\]]+)\]\s*=\s*([^;]+);'
            )
            def do_wr16(m: re.Match, _r=raw, _wpi=words_per_inst) -> str:
                ii = m.group(1).strip(); ji = m.group(2).strip()
                val = _strip_subword_casts(m.group(3).strip())
                return (f"{{ uint _wi16 = uint({ii})*{_wpi}u + uint({ji})/2u;"
                        f" uint _b16 = (uint({ji})&1u)*16u;"
                        f" {_r}[_wi16] = ({_r}[_wi16] & ~(0xFFFFu << _b16))"
                        f" | ((uint({val}) & 0xFFFFu) << _b16); }}")
            glsl = wr16.sub(do_wr16, glsl)

            # Reads: uint(inst.instances[I].field[J])  or bare
            rd16_cast = re.compile(
                r'(?:uint|int)\s*\(\s*' + re.escape(inst) + r'\.' + re.escape(smember)
                + r'\[([^\]]+)\]\.' + re.escape(field) + r'\[([^\]]+)\]\s*\)'
            )
            def do_rd16_cast(m: re.Match, _r=raw, _wpi=words_per_inst) -> str:
                ii = m.group(1).strip(); ji = m.group(2).strip()
                return (f"(({_r}[uint({ii})*{_wpi}u + uint({ji})/2u])"
                        f" >> ((uint({ji})&1u)*16u) & 0xFFFFu)")
            glsl = rd16_cast.sub(do_rd16_cast, glsl)

            rd16_bare = re.compile(
                re.escape(inst) + r'\.' + re.escape(smember)
                + r'\[([^\]]+)\]\.' + re.escape(field) + r'\[([^\]]+)\]'
            )
            def do_rd16_bare(m: re.Match, _r=raw, _wpi=words_per_inst) -> str:
                ii = m.group(1).strip(); ji = m.group(2).strip()
                return (f"(({_r}[uint({ii})*{_wpi}u + uint({ji})/2u])"
                        f" >> ((uint({ji})&1u)*16u) & 0xFFFFu)")
            glsl = rd16_bare.sub(do_rd16_bare, glsl)

    return glsl


def legalize_u8vec4_ssbos(glsl: str) -> str:
    """
    Handle SSBOs with u8vec4 element type (packed RGBA: 4 bytes per element = 1 u32).
    Replaces:
      - Declaration: u8vec4 field[] → uint field[]
      - Writes:      inst.field[i] = u8vec4(VAL) → pack 4 bytes into one u32
      - Reads:       uvec4(inst.field[i]) → expand u32 into 4 bytes
                     ivec4(uvec4(inst.field[i])) → same, then cast to ivec4
    """
    pattern = re.compile(
        r'layout\s*\([^)]*\)\s*(?:readonly\s+|writeonly\s+)?buffer\s+\w+\s*\{'
        r'\s*u8vec4\s+(\w+)\s*\[\s*\d*\s*\]\s*;\s*\}\s*(\w+)\s*;',
        re.DOTALL,
    )
    instances: dict[str, str] = {}  # inst → member
    for m in pattern.finditer(glsl):
        instances[m.group(2)] = m.group(1)

    if not instances:
        return glsl

    # Replace all u8vec4 field[] declarations → uint field[]
    glsl = re.sub(r'\bu8vec4\b(\s+\w+\s*\[\s*\d*\s*\]\s*;)', r'uint\1', glsl)

    for inst, member in instances.items():
        # Writes: inst.member[I] = u8vec4(VAL);
        wr = re.compile(
            r'(?<!\w)' + re.escape(inst) + r'\.' + re.escape(member)
            + r'\[([^\]]+)\]\s*=\s*u8vec4\s*\(([^;]+)\)\s*;'
        )
        def do_wr(m: re.Match, _i=inst, _mem=member) -> str:
            idx = m.group(1).strip()
            val = m.group(2).strip()
            return (f"{{ uvec4 _u8v4 = uvec4({val}); "
                    f"{_i}.{_mem}[{idx}] = (_u8v4.x & 0xFFu) | ((_u8v4.y & 0xFFu) << 8u)"
                    f" | ((_u8v4.z & 0xFFu) << 16u) | (_u8v4.w << 24u); }}")
        glsl = wr.sub(do_wr, glsl)

        # Reads: uvec4(inst.member[I])
        rd_u = re.compile(
            r'uvec4\s*\(\s*(?<!\w)' + re.escape(inst) + r'\.'
            + re.escape(member) + r'\[([^\]]+)\]\s*\)'
        )
        def do_rd_u(m: re.Match, _i=inst, _mem=member) -> str:
            idx = m.group(1).strip()
            w = f"{_i}.{_mem}[{idx}]"
            return (f"uvec4({w} & 0xFFu, ({w} >> 8u) & 0xFFu,"
                    f" ({w} >> 16u) & 0xFFu, {w} >> 24u)")
        glsl = rd_u.sub(do_rd_u, glsl)

        # Bare reads: inst.member[I]  (any remaining after cast-wrapped handled above)
        # Negative lookahead (?!\s*=) prevents matching write targets like inst.member[i] = ...
        rd_bare = re.compile(
            r'(?<!\w)' + re.escape(inst) + r'\.' + re.escape(member) + r'\[([^\]]+)\](?!\s*=)'
        )
        def do_rd_bare(m: re.Match, _i=inst, _mem=member) -> str:
            idx = m.group(1).strip()
            # Return as uvec4 expansion — will be wrapped by any outer ivec4(...)
            w = f"{_i}.{_mem}[{idx}]"
            return (f"uvec4({w} & 0xFFu, ({w} >> 8u) & 0xFFu,"
                    f" ({w} >> 16u) & 0xFFu, {w} >> 24u)")
        glsl = rd_bare.sub(do_rd_bare, glsl)

    return glsl


def remove_extension_blocks(glsl: str) -> str:
    """Remove #if defined(GL_EXT_shader_explicit_arithmetic_types_int8/16)…#endif blocks."""
    # Pattern: #if defined(GL_EXT_shader_explicit_arithmetic_types_int8)
    #            …multiple branches…
    #          #endif
    # We remove the whole block including any GL_NV_gpu_shader5 fallback.
    out = []
    i = 0
    lines = glsl.splitlines(keepends=True)
    skip_depth = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()
        if skip_depth == 0 and re.match(
            r'#if\s+defined\(GL_EXT_shader_explicit_arithmetic_types_int(?:8|16)\)',
            stripped,
        ):
            skip_depth = 1
            i += 1
            continue
        if skip_depth > 0:
            if stripped.startswith("#if"):
                skip_depth += 1
            elif stripped == "#endif":
                skip_depth -= 1
            i += 1
            continue
        out.append(line)
        i += 1
    return "".join(out)


def inline_spec_consts(glsl: str, shader_name: str) -> str:
    """
    Replace   layout(constant_id = N) const TYPE NAME = DEFAULT;
    with      const TYPE NAME = OVERRIDDEN_DEFAULT_OR_ORIGINAL;

    Also fix  layout(local_size_x_id = N, ...) → layout(local_size_x = VAL, ...)
    """
    defaults = SPEC_CONST_DEFAULTS.get(shader_name, {})

    # 1. Collect all constant_id declarations and their id→(type, name, orig_default)
    const_map: dict[int, tuple[str, str, str]] = {}
    pattern = re.compile(
        r'layout\s*\(\s*constant_id\s*=\s*(\d+)\s*\)\s+const\s+(\w+)\s+(\w+)\s*=\s*([^;]+);'
    )
    for m in pattern.finditer(glsl):
        cid = int(m.group(1))
        ctype = m.group(2)
        cname = m.group(3)
        orig = m.group(4).strip()
        const_map[cid] = (ctype, cname, orig)

    # 2. Replace each layout(constant_id=N) declaration with a plain const
    def replace_const(m):
        cid = int(m.group(1))
        ctype = m.group(2)
        cname = m.group(3)
        orig = m.group(4).strip()
        if cid in defaults:
            val = defaults[cid][1]
        else:
            val = orig
        return f"const {ctype} {cname} = {val};"

    glsl = pattern.sub(replace_const, glsl)

    # 3. Fix local_size_{x,y,z}_id qualifiers in layout(...)
    #    layout(local_size_x_id = 3, local_size_y_id = 4, local_size_z = 1) in;
    def replace_workgroup(m):
        # Parse the full qualifier list
        qual = m.group(1)
        parts = [p.strip() for p in qual.split(",")]
        new_parts = []
        for p in parts:
            wm = re.match(r'local_size_([xyz])_id\s*=\s*(\d+)', p)
            if wm:
                axis = wm.group(1)
                cid = int(wm.group(2))
                if cid in defaults:
                    val = defaults[cid][1].rstrip("u")
                elif cid in const_map:
                    val = const_map[cid][2]  # original default
                else:
                    val = "64"
                new_parts.append(f"local_size_{axis} = {val}")
            else:
                new_parts.append(p)
        return f"layout({', '.join(new_parts)}) in;"

    glsl = re.sub(r'layout\(([^)]+)\)\s+in;', replace_workgroup, glsl)

    return glsl


def fix_buffer_qualifiers(glsl: str) -> str:
    """Remove readonly / writeonly from buffer (SSBO) declarations."""
    glsl = re.sub(r'\breadonly\s+buffer\b', 'buffer', glsl)
    glsl = re.sub(r'\bwriteonly\s+buffer\b', 'buffer', glsl)
    return glsl


def find_u8u16_buffers(glsl: str) -> dict[str, int]:
    """
    Scan SSBO declarations for sub-32-bit element arrays.
    Returns a dict: buffer_instance_name → element_bits (8 or 16).

    We look for patterns like:
        layout(...) buffer XxxBuffer {
            uint8_t  elems[];    ← 8-bit
        } name;
    or
        layout(...) buffer XxxBuffer {
            uint16_t data[];     ← 16-bit
        } name;

    Only top-level single-array SSBOs are handled.  SSBOs with structs
    containing sub-word fields are NOT listed here (they will hit SKIP_SHADERS).
    """
    result: dict[str, int] = {}
    # Match a buffer block whose only member is a sub-word array (dynamic or fixed-size)
    pattern = re.compile(
        r'layout\s*\([^)]*\)\s+(?:readonly\s+|writeonly\s+)?buffer\s+\w+\s*\{'
        r'\s*(uint8_t|int8_t|uint16_t|int16_t)\s+(\w+)\s*\[\s*\d*\s*\]\s*;\s*\}\s*(\w+)\s*;',
        re.DOTALL,
    )
    for m in pattern.finditer(glsl):
        elem_type = m.group(1)
        inst_name = m.group(3)
        result[inst_name] = 8 if elem_type in ("uint8_t", "int8_t") else 16
    return result


def rewrite_u8u16_declarations(glsl: str, buf_types: dict[str, int]) -> str:
    """Replace uint8_t/int8_t/uint16_t/int16_t in SSBO member declarations with uint."""
    for inst, bits in buf_types.items():
        # Replace the member declaration inside the block for this instance.
        # Handle dynamic [] and fixed-size [N] arrays, and both signed/unsigned variants.
        if bits == 8:
            orig_types = ("uint8_t", "int8_t")
        else:
            orig_types = ("uint16_t", "int16_t")
        for orig_type in orig_types:
            glsl = re.sub(
                r'\b' + orig_type + r'\b(\s+\w+\s*\[\s*\d*\s*\]\s*;)',
                r'uint\1',
                glsl,
            )
    return glsl


def rewrite_u8u16_reads(glsl: str, buf_types: dict[str, int]) -> str:
    """
    Replace   uint(bufname.field[EXPR])
    with      bit-extraction expression appropriate to 8 or 16 bits.

    The extraction accounts for N64 big-endian byte ordering where needed,
    but paraLLEl-RDP already handles endianness in the index expression itself
    (e.g., `idx ^ 3` for bytes), so we just apply the word-level extraction.
    """
    for inst, bits in buf_types.items():
        if bits == 8:
            # uint(inst.field[EXPR])  →  ((inst.field[(EXPR) >> 2u] >> (((EXPR) & 3u) * 8u)) & 0xFFu)
            # But EXPR can be complex, so we capture it with a balanced-paren helper.
            glsl = _replace_typed_read(glsl, inst, 8)
        else:
            # uint16: ((inst.field[(EXPR) >> 1u] >> (((EXPR) & 1u) * 16u)) & 0xFFFFu)
            glsl = _replace_typed_read(glsl, inst, 16)
    return glsl


def rewrite_u8u16_writes(glsl: str, buf_types: dict[str, int]) -> str:
    """
    Replace SSBO byte/halfword WRITES:
        buf.field[EXPR] = uint8_t(VAL);
        buf.field[EXPR] = uint16_t(VAL);
    with non-atomic read-modify-write into the backing uint[] array.

    Assumes each invocation writes to a unique byte/halfword slot so that
    no two threads race on the same u32 word (true for upscaling-domain shaders).
    """
    for inst, bits in buf_types.items():
        # Match:  inst.FIELD[EXPR] = uint8_t(VAL);
        #      or inst.FIELD[EXPR] = uint16_t(VAL);
        cast_type = "uint8_t" if bits == 8 else "uint16_t"
        # We look for:  INST.FIELD[...] = CAST_TYPE(...);
        write_re = re.compile(
            re.escape(inst) + r'\.(\w+)\[([^\]]+)\]\s*=\s*' +
            re.escape(cast_type) + r'\(([^)]+)\)\s*;'
        )

        def replace_write(m, _bits=bits):
            field = m.group(1)
            idx_e = m.group(2).strip()
            val_e = m.group(3).strip()
            i = f"({idx_e})"
            v = f"({val_e})"
            if _bits == 8:
                mask = "0xFFu"
                shift = f"(({i} & 3u) * 8u)"
                wi = f"({i} >> 2u)"
            else:
                mask = "0xFFFFu"
                shift = f"(({i} & 1u) * 16u)"
                wi = f"({i} >> 1u)"
            inv_mask = f"(~({mask} << {shift}))"
            new_val = f"(({v} & {mask}) << {shift})"
            return (
                f"{inst}.{field}[{wi}] = "
                f"({inst}.{field}[{wi}] & {inv_mask}) | {new_val};"
            )

        glsl = write_re.sub(replace_write, glsl)

    # Also replace bare uint8_t(x) and uint16_t(x) casts that remain
    # (e.g., as rvalue in other expressions)
    glsl = re.sub(r'\buint8_t\s*\(([^)]+)\)', r'(uint(\1) & 0xFFu)', glsl)
    glsl = re.sub(r'\buint16_t\s*\(([^)]+)\)', r'(uint(\1) & 0xFFFFu)', glsl)
    glsl = re.sub(r'\bint8_t\s*\(([^)]+)\)', r'(int(\1))', glsl)
    glsl = re.sub(r'\bint16_t\s*\(([^)]+)\)', r'(int(\1))', glsl)

    return glsl


def _replace_typed_read(glsl: str, inst: str, bits: int) -> str:
    """
    Replace all occurrences of  uint(inst.FIELD[INDEX_EXPR])
    or int(inst.FIELD[INDEX_EXPR]) where INDEX_EXPR may contain nested brackets.
    """
    # Match both uint( and int( prefixes
    field_pattern = re.compile(
        r'\b(uint|int)\(' + re.escape(inst) + r'\.(\w+)\['
    )

    result = []
    pos = 0
    text = glsl
    while True:
        m = field_pattern.search(text, pos)
        if not m:
            result.append(text[pos:])
            break
        result.append(text[pos:m.start()])
        outer_cast = m.group(1)  # "uint" or "int"
        field = m.group(2)
        # Find the balanced bracket starting at m.end()-1 (the '[')
        bracket_start = m.end() - 1  # position of '['
        # Actually m.end() is right after '[', so bracket content starts at m.end()
        idx_start = m.end()
        depth = 1
        i = idx_start
        while i < len(text) and depth > 0:
            if text[i] == '[':
                depth += 1
            elif text[i] == ']':
                depth -= 1
            i += 1
        idx_expr = text[idx_start:i-1]
        # Now expect ')' after the ']'
        after = text[i:]
        if after.startswith(')'):
            i += 1  # consume ')'
        else:
            # Not the pattern we expected; emit as-is
            result.append(text[m.start():i])
            pos = i
            continue

        # Build bit-extraction expression
        e = f"({idx_expr})"  # parenthesized index
        if bits == 8:
            expr = f"(({inst}.{field}[{e} >> 2u] >> (({e} & 3u) * 8u)) & 0xFFu)"
        else:
            expr = f"(({inst}.{field}[{e} >> 1u] >> (({e} & 1u) * 16u)) & 0xFFFFu)"
        if outer_cast == "int":
            expr = f"int({expr})"

        result.append(expr)
        pos = m.start() + (i - m.start())  # advance past consumed input
    return "".join(result)


def deduplicate_bindings(glsl: str) -> str:
    """
    In Vulkan SPIR-V, the same buffer can be declared multiple times with
    different element types at the SAME (set, binding) — a typed-alias pattern.
    After u8/u16→u32 patching, these aliases all become 'uint[]' SSBOs at the
    same binding, which WGSL rejects.

    Strategy: keep the FIRST declaration at each (set, binding) and replace all
    accesses to subsequent (duplicate) instance names with the kept name, then
    remove the duplicate declarations.
    """
    # Match:  layout(set=S, binding=B, std430) [buffer|readonly buffer] XxxType {
    #             uint FIELD[];
    #         } INSTANCE;
    decl_re = re.compile(
        r'(layout\s*\(\s*set\s*=\s*(\d+)\s*,\s*binding\s*=\s*(\d+)\s*,\s*std430\s*\)'
        r'\s*(?:readonly\s+|writeonly\s+)?buffer\s+\w+\s*\{[^}]*\}\s*(\w+)\s*;)',
        re.DOTALL,
    )

    seen: dict[tuple[int, int], str] = {}  # (set, binding) → kept instance name
    to_remove: list[tuple[str, str]] = []  # (old_instance, canonical_instance)

    for m in decl_re.finditer(glsl):
        key = (int(m.group(2)), int(m.group(3)))
        inst = m.group(4)
        if key not in seen:
            seen[key] = inst
        else:
            # This is a duplicate; mark it for removal
            canonical = seen[key]
            if inst != canonical:
                to_remove.append((m.group(1), inst, canonical))

    for full_decl, old_inst, canon_inst in to_remove:
        # Remove the duplicate declaration
        glsl = glsl.replace(full_decl, f"// (alias removed: {old_inst} → {canon_inst})\n", 1)
        # Replace all accesses: old_inst.FIELD[...] → canon_inst.FIELD[...]
        glsl = re.sub(r'\b' + re.escape(old_inst) + r'\.', canon_inst + '.', glsl)

    return glsl


def has_struct_level_u8u16(glsl: str) -> bool:
    """
    Return True if the GLSL contains u8/u16 types *inside struct bodies*
    (other than as a top-level SSBO array member).  These can't be auto-patched.
    """
    # Look for u8vec, i8vec, u16vec, i16vec, or typed fields like 'uint8_t foo;'
    # in struct definitions
    struct_body_re = re.compile(r'struct\s+\w+\s*\{([^}]*)\}', re.DOTALL)
    sub_word_re = re.compile(r'\b(?:u8vec|i8vec|u16vec|i16vec|int8_t|uint8_t|int16_t|uint16_t)\b')
    for m in struct_body_re.finditer(glsl):
        if sub_word_re.search(m.group(1)):
            return True
    return False


def flatten_2d_const_arrays(glsl: str) -> str:
    """
    Naga's GLSL frontend rejects multidimensional array literals:
        const int NAME[M][N] = int[][](int[](row0...), int[](row1...));
    Replace with a flat 1D constant and rewrite [A][B] → [(A)*N+(B)].
    Uses balanced-bracket matching for the access index expressions.
    """
    decl_re = re.compile(
        r'\bconst\s+(\w+)\s+(\w+)\s*\[(\d+)\]\s*\[(\d+)\]\s*=\s*'
        r'\1\s*\[\s*\]\s*\[\s*\]\s*\((.+?)\)\s*;',
        re.DOTALL,
    )

    replacements: dict[str, tuple[int, int]] = {}  # name → (M, N)

    def do_decl(m: re.Match) -> str:
        typ, name, ms, ns, body = m.group(1), m.group(2), m.group(3), m.group(4), m.group(5)
        M, N = int(ms), int(ns)
        # body is like: int[](v0, v1, ...), int[](v0, v1, ...)
        # Extract each row's values
        row_re = re.compile(re.escape(typ) + r'\s*\[\s*\]\s*\(([^)]+)\)')
        rows = row_re.findall(body)
        if len(rows) != M:
            return m.group(0)  # can't parse, leave unchanged
        flat = ', '.join(', '.join(r.strip() for r in row.split(',')) for row in rows)
        replacements[name] = (M, N)
        return f'const {typ} {name}[{M * N}] = {typ}[]({flat});'

    glsl = decl_re.sub(do_decl, glsl)

    # Rewrite NAME[A][B] → NAME[(A)*N+(B)] using balanced-bracket parsing
    for name, (M, N) in replacements.items():
        acc_pat = re.compile(re.escape(name) + r'\s*\[')
        result: list[str] = []
        pos = 0
        while True:
            m = acc_pat.search(glsl, pos)
            if not m:
                result.append(glsl[pos:])
                break
            result.append(glsl[pos:m.start()])
            # Parse [A]
            i = m.end()  # just past the first '['
            depth = 1
            while i < len(glsl) and depth > 0:
                if glsl[i] == '[': depth += 1
                elif glsl[i] == ']': depth -= 1
                if depth > 0: i += 1
                else: break
            idx_a = glsl[m.end():i].strip()
            i += 1  # past the ']'
            # Check for second [B]
            j = i
            while j < len(glsl) and glsl[j] in ' \t': j += 1
            if j < len(glsl) and glsl[j] == '[':
                j += 1  # past '['
                depth = 1
                k = j
                while k < len(glsl) and depth > 0:
                    if glsl[k] == '[': depth += 1
                    elif glsl[k] == ']': depth -= 1
                    if depth > 0: k += 1
                    else: break
                idx_b = glsl[j:k].strip()
                k += 1  # past ']'
                result.append(f'{name}[({idx_a})*{N}+({idx_b})]')
                pos = k
            else:
                # Only one index: shouldn't happen but leave as-is
                result.append(f'{name}[{idx_a}]')
                pos = i
        glsl = ''.join(result)

    return glsl


def unwrap_switch_case_blocks(glsl: str) -> str:
    """
    Naga 29 GLSL frontend rejects switch cases with compound statement bodies:
        case N: {       ← inner brace wrapping a single compound block
            ...
            break;
        }
    Strip those inner braces so each case body is flat:
        case N:
            ...
            break;
    Uses a line-based approach to track switch/case/brace depth.
    """
    lines = glsl.splitlines(keepends=True)
    result: list[str] = []
    # Stack: each entry is ('switch'|'case_block', open_brace_depth)
    brace_depth   = 0  # absolute brace depth in the file
    switch_depths: list[int] = []    # brace_depth when 'switch (' line opened
    case_block_close_depths: list[int] = []  # brace_depth that closes a case block
    skip_line = False  # True → emit nothing for this line (it's a case-block brace)

    i = 0
    while i < len(lines):
        line = lines[i]
        raw = line.rstrip('\n').rstrip('\r')
        stripped = raw.strip()

        # Track brace depth changes for the current line
        opens  = raw.count('{')
        closes = raw.count('}')

        # Check: is this a case-block CLOSING brace?
        # That is: stripped == '}' and current brace_depth - closes == case_block_close_depth
        if (case_block_close_depths and
                stripped == '}' and
                (brace_depth - closes) == case_block_close_depths[-1]):
            # This is the closing brace of a case compound block — skip it
            case_block_close_depths.pop()
            brace_depth += opens - closes  # closes > opens here
            i += 1
            continue

        brace_depth += opens - closes

        # Check: does this line open a switch?
        if re.search(r'\bswitch\s*\(', stripped):
            # The switch body '{' may be on this line or the next
            # brace_depth already updated; the switch body depth = brace_depth
            # (we just incremented by opens-closes which should be 0 or 1)
            switch_depths.append(brace_depth)

        # Check: is this a 'case N:' or 'default:' line followed by '{'?
        # Pattern: stripped starts with "case ...:" or "default:" possibly with ' {'
        if switch_depths:
            m = re.match(r'^(case\s+[^:]+:|default:)\s*(\{)?\s*$', stripped)
            if m:
                if m.group(2):
                    # case N: { is on the same line — opening brace is part of this line
                    # Remove the ' {' from the line and record close depth.
                    # Store brace_depth-1 (the depth before the '{') so the closing '}'
                    # check fires at depth brace_depth-1, not at any inner nested brace.
                    raw_no_brace = raw.rstrip()
                    raw_no_brace = re.sub(r'\s*\{(\s*)$', r'\1', raw_no_brace)
                    result.append(raw_no_brace + ('\n' if line.endswith('\n') else ''))
                    case_block_close_depths.append(brace_depth - 1)
                    i += 1
                    continue
                else:
                    # case N: on its own line; check next non-empty line for '{'
                    j = i + 1
                    while j < len(lines) and not lines[j].strip():
                        j += 1
                    if j < len(lines) and lines[j].strip() == '{':
                        # Peek: next substantive line is '{' — skip it and record close depth.
                        # Store depth before incrementing (i.e. the switch-body depth) so the
                        # closing '}' check fires at that depth rather than at any inner '{}'.
                        result.append(line)
                        i += 1
                        # Skip any blank lines, then the '{' line
                        while i < len(lines) and not lines[i].strip():
                            result.append(lines[i])
                            i += 1
                        case_block_close_depths.append(brace_depth)  # depth before '{'
                        brace_depth += 1                             # account for skipped '{'
                        i += 1  # skip the '{' line itself
                        continue

        result.append(line)
        i += 1

    return ''.join(result)


def patch_glsl(glsl: str, shader_name: str) -> tuple[bool, str, str]:
    """
    Apply all patches.  Returns (ok, patched_glsl, reason_if_not_ok).
    """
    glsl = remove_extension_blocks(glsl)
    glsl = inline_spec_consts(glsl, shader_name)
    glsl = fix_buffer_qualifiers(glsl)

    # Legalize Mem-struct SSBOs: replace packed struct fields with raw uint[] + bit ops.
    # Must run before the sub-word type check so the Mem structs are already cleaned up.
    glsl = legalize_struct_ssbos(glsl)
    # Legalize TMEM array-in-struct SSBOs (TMEMInstance8/16Mem, TileInstance).
    glsl = legalize_tmem_ssbos(glsl)
    # Legalize u8vec4 element SSBOs (packed RGBA color buffers).
    glsl = legalize_u8vec4_ssbos(glsl)

    # Check for struct-level u8/u16 AFTER extension block removal AND struct legalization
    if has_struct_level_u8u16(glsl):
        return False, glsl, "struct-level u8/u16 fields (CPU layout dependency)"

    buf_types = find_u8u16_buffers(glsl)
    glsl = rewrite_u8u16_declarations(glsl, buf_types)
    glsl = rewrite_u8u16_writes(glsl, buf_types)  # writes before reads (ordering matters)
    glsl = rewrite_u8u16_reads(glsl, buf_types)

    # Deduplicate Vulkan aliased bindings (same set+binding, multiple typed views)
    glsl = deduplicate_bindings(glsl)

    # Replace push_constant with a uniform buffer at group=2.
    # WebGPU has no push_constant concept; small uniforms go in a UBO instead.
    # Use binding=1 if binding=0 is already taken (e.g. by GlobalConstants).
    _has_set2_b0 = bool(re.search(r'layout\s*\(\s*[^)]*set\s*=\s*2[^)]*binding\s*=\s*0', glsl))
    _pc_binding = 1 if _has_set2_b0 else 0
    glsl = re.sub(
        r'layout\s*\(\s*push_constant\s*,\s*std430\s*\)\s+uniform\s+',
        f'layout(set = 2, binding = {_pc_binding}, std140) uniform ',
        glsl,
    )

    # Final cleanup: replace any lingering sub-word type names (e.g. spec-const
    # declarations that still use u8vec4, or residual constructor calls).
    # These arise from spec constants that spirv-cross typed as u8vec4 even after
    # spirv-opt froze them. We map to the closest standard 32-bit type.
    glsl = re.sub(r'\bu8vec4\b', 'uvec4', glsl)
    glsl = re.sub(r'\bi8vec4\b', 'ivec4', glsl)
    glsl = re.sub(r'\bu16vec4\b', 'uvec4', glsl)
    glsl = re.sub(r'\bi16vec4\b', 'ivec4', glsl)
    glsl = re.sub(r'\buint8_t\b', 'uint', glsl)
    glsl = re.sub(r'\bint8_t\b', 'int', glsl)
    glsl = re.sub(r'\buint16_t\b', 'uint', glsl)
    glsl = re.sub(r'\bint16_t\b', 'int', glsl)

    # Final sanity check: any remaining sub-word types that we missed?
    remaining = re.findall(r'\b(?:u8vec\d?|i8vec\d?|u16vec\d?|i16vec\d?|uint8_t|int8_t|uint16_t|int16_t)\b', glsl)
    if remaining:
        return False, glsl, f"remaining sub-word types after patching: {set(remaining)}"

    # Naga 29 GLSL frontend rejects switch cases with compound statement bodies
    # (case N: { ... break; }).  Unwrap the inner braces so each case body is flat.
    glsl = unwrap_switch_case_blocks(glsl)

    # Naga 29 GLSL frontend rejects multidimensional array literals (int[M][N] = int[][](...)).
    # Flatten to 1D and rewrite [A][B] accesses to [(A)*N+(B)].
    glsl = flatten_2d_const_arrays(glsl)

    return True, glsl, ""


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def spec_const_str(shader_name: str) -> str | None:
    """
    Build the --set-spec-const-default-value string for spirv-opt, e.g.
    "0:8388608 1:0 2:0 3:64 4:1"
    """
    defaults = SPEC_CONST_DEFAULTS.get(shader_name)
    if not defaults:
        return None
    parts = []
    for cid, (ctype, val_str) in defaults.items():
        # spirv-opt expects raw decimal integer values
        # Parse our python value strings to int
        v_str = val_str.rstrip("u")
        if v_str.lower() == "false":
            v = 0
        elif v_str.lower() == "true":
            v = 1
        else:
            try:
                v = int(v_str, 0)
            except ValueError:
                continue
        parts.append(f"{cid}:{v}")
    return " ".join(parts)


def optimize_spv(spv_path: str, shader_name: str, spirv_opt: str = "spirv-opt") -> tuple[bool, str]:
    """
    Run spirv-opt to freeze & fold spec constants and eliminate dead branches.
    Returns (ok, output_path).
    """
    spec_str = spec_const_str(shader_name)
    cmd = [spirv_opt]
    if spec_str:
        cmd += [f"--set-spec-const-default-value={spec_str}"]
    cmd += [
        "--freeze-spec-const",
        "--fold-spec-const-op-composite",
        "--eliminate-dead-branches",
        "--eliminate-dead-code-aggressive",
    ]
    out_path = spv_path + ".opt.spv"
    cmd += [spv_path, "-o", out_path]
    rc, _, err = run(cmd)
    if rc != 0:
        return False, err
    return True, out_path


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--spv-dir", default="tools/spv")
    ap.add_argument("--out-dir", default="web/shaders")
    ap.add_argument("--spirv-cross", default="spirv-cross")
    ap.add_argument("--spirv-opt", default="spirv-opt")
    ap.add_argument("--naga", default="naga")
    ap.add_argument("--verbose", "-v", action="store_true")
    args = ap.parse_args()

    spv_dir = args.spv_dir
    out_dir = args.out_dir
    os.makedirs(out_dir, exist_ok=True)

    spv_files = sorted(f for f in os.listdir(spv_dir) if f.endswith(".spv"))
    if not spv_files:
        print(f"[glsl-to-wgsl] No .spv files found in {spv_dir}")
        sys.exit(1)

    results = []
    for spv_file in spv_files:
        name = spv_file[:-4]
        spv_path = os.path.join(spv_dir, spv_file)
        wgsl_out = os.path.join(out_dir, f"{name}.wgsl")

        # Skip shaders with struct-level packing issues
        if name in SKIP_SHADERS:
            print(f"  [SKIP] {name}: struct-level u8/u16 (manual WGSL required)")
            results.append((name, "SKIP", "struct-level u8/u16"))
            continue

        # 1. Run spirv-opt to fold spec constants and eliminate dead branches
        ok_opt, opt_result = optimize_spv(spv_path, name, args.spirv_opt)
        if ok_opt:
            source_spv = opt_result
        else:
            # spirv-opt failed (unusual); fall back to original
            source_spv = spv_path

        # 2. Run spirv-cross
        rc, glsl, err = run([
            args.spirv_cross,
            "--version", "450",
            "--no-420pack-extension",
            "--vulkan-semantics",
            source_spv,
        ])

        # Clean up the temp optimized SPV
        if ok_opt and os.path.exists(source_spv):
            os.unlink(source_spv)
        if rc != 0:
            print(f"  [FAIL] {name}: spirv-cross error: {err.strip()}")
            results.append((name, "FAIL", "spirv-cross: " + err.strip()[:80]))
            continue

        # 2. Patch GLSL
        ok, patched, reason = patch_glsl(glsl, name)
        if not ok:
            print(f"  [FAIL] {name}: patch failed: {reason}")
            results.append((name, "FAIL", "patch: " + reason))
            continue

        if args.verbose:
            print(f"\n=== patched GLSL for {name} ===\n{patched}\n")

        # 3. Write patched GLSL to a temp file
        with tempfile.NamedTemporaryFile(
            mode="w", suffix=".glsl", prefix=f"{name}_", delete=False
        ) as tf:
            tf.write(patched)
            tmp_glsl = tf.name

        try:
            # 4. Run naga
            rc2, _, naga_err = run([
                args.naga,
                "--input-kind", "glsl",
                "--shader-stage", "compute",
                tmp_glsl,
                wgsl_out,
            ])
            if rc2 != 0:
                print(f"  [FAIL] {name}: naga error:")
                for line in naga_err.splitlines()[:10]:
                    print(f"         {line}")
                results.append((name, "FAIL", "naga: " + naga_err.splitlines()[0][:80]))
            else:
                wgsl_size = os.path.getsize(wgsl_out)
                print(f"  [OK]   {name}: {wgsl_size} bytes → {wgsl_out}")
                results.append((name, "OK", ""))
        finally:
            os.unlink(tmp_glsl)

    # Summary
    print()
    print("=" * 60)
    ok_count  = sum(1 for _, s, _ in results if s == "OK")
    skip_count = sum(1 for _, s, _ in results if s == "SKIP")
    fail_count = sum(1 for _, s, _ in results if s == "FAIL")
    print(f"  OK: {ok_count}  SKIP: {skip_count}  FAIL: {fail_count}  (total {len(results)})")
    print("=" * 60)

    if fail_count:
        sys.exit(1)


if __name__ == "__main__":
    main()
