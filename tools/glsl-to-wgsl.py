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
}

# These shaders have u8/u16 fields *inside structs used in SSBOs*.
# Automatic transformation would change the CPU↔GPU memory layout,
# so they are skipped; the generated stub WGSL is empty.
SKIP_SHADERS = {
    # Core rendering shaders — use mixed u8/u16 struct fields in SSBOs.
    # The CPU-side C++ structs share the same packed byte layout, so mechanical
    # transformation would corrupt the CPU↔GPU interface.  Manual WGSL required.
    "depth_blend",
    "rasterizer",
    "span_setup",
    "tile_binning",
    "tmem_update",
    "ubershader",
    # extract_vram — we use a hand-written WGSL (web/shaders/extract_vram.wgsl)
    # that passes VI_STATUS/RDRAM_SIZE as uniform fields rather than baking them
    # in as spec constants (which would produce a static, broken shader).
    "extract_vram",
    # update_upscaled_domain_* are handled below — they only have SSBO-level
    # u8/u16 arrays (no struct packing) but DO have write-side casts.
}

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def run(cmd, **kw):
    r = subprocess.run(cmd, capture_output=True, text=True, **kw)
    return r.returncode, r.stdout, r.stderr


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
    # Match a buffer block whose only member is uint8_t or uint16_t array
    pattern = re.compile(
        r'layout\s*\([^)]*\)\s+(?:readonly\s+|writeonly\s+)?buffer\s+\w+\s*\{'
        r'\s*(uint8_t|uint16_t)\s+(\w+)\s*\[\s*\]\s*;\s*\}\s*(\w+)\s*;',
        re.DOTALL,
    )
    for m in pattern.finditer(glsl):
        elem_type = m.group(1)
        # field_name = m.group(2)  # usually "data" or "elems"
        inst_name = m.group(3)
        result[inst_name] = 8 if elem_type == "uint8_t" else 16
    return result


def rewrite_u8u16_declarations(glsl: str, buf_types: dict[str, int]) -> str:
    """Replace uint8_t/uint16_t in SSBO member declarations with uint."""
    for inst, bits in buf_types.items():
        # Replace the member declaration inside the block for this instance
        orig_type = "uint8_t" if bits == 8 else "uint16_t"
        # Replace pattern:  `    uint8_t  data[];` inside the block whose instance name matches
        # We do a simple global replace since other occurrences are in struct bodies (which
        # we don't modify in Group-1/2 shaders).
        glsl = re.sub(
            r'\b' + orig_type + r'\b(\s+\w+\s*\[\s*\]\s*;)',
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
    where INDEX_EXPR may contain nested parentheses/brackets.
    """
    # We search for uint(inst.FIELD[... and extract the balanced bracket content
    field_pattern = re.compile(
        r'\buint\(' + re.escape(inst) + r'\.(\w+)\['
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
        field = m.group(1)
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


def patch_glsl(glsl: str, shader_name: str) -> tuple[bool, str, str]:
    """
    Apply all patches.  Returns (ok, patched_glsl, reason_if_not_ok).
    """
    glsl = remove_extension_blocks(glsl)
    glsl = inline_spec_consts(glsl, shader_name)
    glsl = fix_buffer_qualifiers(glsl)

    # Check for struct-level u8/u16 AFTER extension block removal
    if has_struct_level_u8u16(glsl):
        return False, glsl, "struct-level u8/u16 fields (CPU layout dependency)"

    buf_types = find_u8u16_buffers(glsl)
    glsl = rewrite_u8u16_declarations(glsl, buf_types)
    glsl = rewrite_u8u16_writes(glsl, buf_types)  # writes before reads (ordering matters)
    glsl = rewrite_u8u16_reads(glsl, buf_types)

    # Deduplicate Vulkan aliased bindings (same set+binding, multiple typed views)
    glsl = deduplicate_bindings(glsl)

    # Replace push_constant with a uniform buffer at group=2, binding=0
    # WebGPU has no push_constant concept; small uniforms go in a UBO instead.
    glsl = re.sub(
        r'layout\s*\(\s*push_constant\s*,\s*std430\s*\)\s+uniform\s+',
        'layout(set = 2, binding = 0, std140) uniform ',
        glsl,
    )

    # Final check: any remaining sub-word types?
    remaining = re.findall(r'\b(?:u8vec\d?|i8vec\d?|u16vec\d?|i16vec\d?|uint8_t|int8_t|uint16_t|int16_t)\b', glsl)
    if remaining:
        return False, glsl, f"remaining sub-word types after patching: {set(remaining)}"

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
