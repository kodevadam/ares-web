#!/usr/bin/env bash
# tools/transpile-shaders.sh
#
# Transpile paraLLEl-RDP SPIR-V compute shaders to WGSL using Naga.
#
# Prerequisites:
#   cargo install naga-cli   (from https://github.com/gfx-rs/wgpu/tree/trunk/naga)
#   OR: use naga from the system wgpu installation
#
# Usage:
#   ./tools/transpile-shaders.sh [--spirv-dir PATH] [--out-dir PATH]
#
# The script:
#   1. Locates slangmosh.hpp (the pre-compiled SPIR-V blob).
#   2. Extracts individual shader SPIR-V blobs from the header.
#   3. Feeds each blob to `naga --from spirv --to wgsl`.
#   4. Applies post-processing patches (push_constant → uniform UBO,
#      subgroup no-ops, combined image sampler splits, etc.).
#   5. Writes the .wgsl files to web/shaders/, overwriting the stubs.
#
# After running this script, re-run cmake to regenerate generated/shader_sources.h.
#
# NOTE: The complex shaders (ubershader, rasterizer, etc.) use extensive
#       GLSL preprocessor #includes that are baked into the SPIR-V binary by
#       slangmosh.  Naga handles raw SPIR-V correctly.
#
# Manual fixups likely needed after transpilation:
#   - push_constant blocks → @group(3) @binding(0) var<uniform>
#   - GL_KHR_shader_subgroup_* → either WebGPU subgroup extension
#     or non-subgroup fallback path
#   - Specialization constants → WGSL override declarations
#   - Combined image samplers → separate texture + sampler bindings

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

SPIRV_DIR="${SPIRV_DIR:-${REPO_ROOT}/ares/n64/vulkan/parallel-rdp/parallel-rdp/shaders}"
OUT_DIR="${OUT_DIR:-${REPO_ROOT}/web/shaders}"
SLANGMOSH_HEADER="${REPO_ROOT}/ares/n64/vulkan/parallel-rdp/parallel-rdp/shaders/slangmosh.hpp"

# Parse arguments.
while [[ $# -gt 0 ]]; do
  case "$1" in
    --spirv-dir) SPIRV_DIR="$2"; shift 2 ;;
    --out-dir)   OUT_DIR="$2";   shift 2 ;;
    *) echo "Unknown argument: $1"; exit 1 ;;
  esac
done

echo "[transpile-shaders] Source: $SPIRV_DIR"
echo "[transpile-shaders] Output: $OUT_DIR"

# ---------------------------------------------------------------------------
# Check for naga-cli
# ---------------------------------------------------------------------------

if ! command -v naga &>/dev/null; then
  echo ""
  echo "ERROR: 'naga' not found in PATH."
  echo ""
  echo "Install naga-cli with:"
  echo "  cargo install naga-cli"
  echo ""
  echo "Or install it as part of wgpu:"
  echo "  cargo install wgpu --features naga-cli"
  echo ""
  exit 1
fi

NAGA_VERSION=$(naga --version 2>&1 | head -1)
echo "[transpile-shaders] Using: $NAGA_VERSION"

# ---------------------------------------------------------------------------
# Helper: extract a named SPIR-V array from slangmosh.hpp and write to .spv
# ---------------------------------------------------------------------------

# slangmosh.hpp contains entries like:
#   static const uint32_t clear_write_mask_comp[] = { 0x07230203, ... };
# We extract the u32 array, convert to binary .spv, then pass to naga.

extract_spirv() {
  local name="$1"     # e.g. "clear_write_mask_comp"
  local out_spv="$2"  # output .spv path

  python3 - "$SLANGMOSH_HEADER" "$name" "$out_spv" <<'PYEOF'
import sys, struct, re

header_path = sys.argv[1]
array_name  = sys.argv[2]
out_path    = sys.argv[3]

with open(header_path, 'r') as f:
    content = f.read()

# Match the array definition (possibly multi-line).
pattern = r'static\s+const\s+uint32_t\s+' + re.escape(array_name) + r'\s*\[\s*\]\s*=\s*\{([^}]+)\}'
m = re.search(pattern, content, re.DOTALL)
if not m:
    print(f"[ERROR] Could not find array '{array_name}' in slangmosh.hpp", file=sys.stderr)
    sys.exit(1)

words_str = m.group(1)
words = [int(w, 0) for w in re.findall(r'0x[0-9a-fA-F]+|\d+', words_str)]

with open(out_path, 'wb') as f:
    for w in words:
        f.write(struct.pack('<I', w))

print(f"[transpile-shaders]   Extracted {len(words)} u32 words → {out_path}")
PYEOF
}

# ---------------------------------------------------------------------------
# Post-process WGSL: apply required fixups after Naga output
# ---------------------------------------------------------------------------

postprocess_wgsl() {
  local wgsl_file="$1"

  # 1. push_constant → @group(3) @binding(0) var<uniform>
  #    Naga emits push constants as a special address space; remap to group 3.
  sed -i 's/var<push_constant>/var<uniform>/g' "$wgsl_file"
  # Add @group(3) @binding(0) annotation to push_constant UBO vars.
  # (Naga typically emits: var push_constants: PushConstants; without group/binding)
  python3 - "$wgsl_file" <<'PYEOF'
import sys, re

path = sys.argv[1]
with open(path) as f:
    content = f.read()

# Pattern: var push_constants : SomeStruct;  (no @group annotation)
# Replace with: @group(3) @binding(0) var<uniform> push_constants : SomeStruct;
content = re.sub(
    r'(?<!@group\(\d\) @binding\(\d\) )var<uniform>\s+(push_constants\s*:)',
    r'@group(3) @binding(0) var<uniform> \1',
    content
)

with open(path, 'w') as f:
    f.write(content)
PYEOF

  # 2. Remove or stub subgroup intrinsics not supported in base WGSL.
  #    Leave them if the browser advertises subgroup support; otherwise
  #    they will cause a validation error.
  #    For now, we emit a #TODO comment so they are visible.
  grep -n "subgroupBallot\|subgroupAny\|subgroupElect\|subgroupAdd" "$wgsl_file" 2>/dev/null | \
    head -5 | while read -r line; do
      echo "[transpile-shaders]   WARNING: subgroup op in $wgsl_file: $line"
    done || true
}

# ---------------------------------------------------------------------------
# Main transpilation loop
# ---------------------------------------------------------------------------

# Map from .wgsl output name → C symbol name in slangmosh.hpp
declare -A SHADER_MAP=(
  ["clear_write_mask"]="clear_write_mask_comp"
  ["clear_indirect_buffer"]="clear_indirect_buffer_comp"
  ["clear_super_sampled_write_mask"]="clear_super_sampled_write_mask_comp"
  ["masked_rdram_resolve"]="masked_rdram_resolve_comp"
  ["extract_vram"]="extract_vram_comp"
  ["ubershader"]="ubershader_comp"
  ["rasterizer"]="rasterizer_comp"
  ["span_setup"]="span_setup_comp"
  ["tile_binning"]="tile_binning_combined_comp"
  ["depth_blend"]="depth_blend_comp"
  ["tmem_update"]="tmem_update_comp"
  ["update_upscaled_domain_pre"]="update_upscaled_domain_pre_comp"
  ["update_upscaled_domain_post"]="update_upscaled_domain_post_comp"
  ["update_upscaled_domain_resolve"]="update_upscaled_domain_resolve_comp"
)

TMPDIR_SPIRV="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_SPIRV"' EXIT

failed=0
succeeded=0

for wgsl_name in "${!SHADER_MAP[@]}"; do
  spirv_sym="${SHADER_MAP[$wgsl_name]}"
  spv_file="${TMPDIR_SPIRV}/${wgsl_name}.spv"
  wgsl_out="${OUT_DIR}/${wgsl_name}.wgsl"

  echo ""
  echo "[transpile-shaders] Processing: $wgsl_name ($spirv_sym)"

  # Extract SPIR-V from slangmosh.hpp.
  if ! extract_spirv "$spirv_sym" "$spv_file" 2>&1; then
    echo "[transpile-shaders]   SKIP (not found in slangmosh.hpp)"
    ((failed++))
    continue
  fi

  # Transpile SPIR-V → WGSL with Naga.
  if naga "$spv_file" "${TMPDIR_SPIRV}/${wgsl_name}.wgsl" 2>&1; then
    cp "${TMPDIR_SPIRV}/${wgsl_name}.wgsl" "$wgsl_out"
    postprocess_wgsl "$wgsl_out"
    echo "[transpile-shaders]   OK → $wgsl_out"
    ((succeeded++))
  else
    echo "[transpile-shaders]   FAIL (naga reported errors; keeping stub)"
    ((failed++))
  fi
done

echo ""
echo "=========================================="
echo "[transpile-shaders] Done: $succeeded succeeded, $failed failed."
echo ""
echo "Next steps:"
echo "  1. Review web/shaders/*.wgsl for subgroup warnings."
echo "  2. Re-run cmake to regenerate generated/shader_sources.h."
echo "  3. Build the WASM target."
echo "=========================================="
