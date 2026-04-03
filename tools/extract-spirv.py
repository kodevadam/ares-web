#!/usr/bin/env python3
"""
tools/extract-spirv.py
Extract individual SPIR-V compute shaders from slangmosh.hpp's spirv_bank[]
and write them as .spv binary files for Naga transpilation.

Shader variants chosen for web (SUBGROUP=0, SMALL_TYPES=0, UBERSHADER=1
where applicable) to avoid subgroup ops that aren't in base WGSL.

Usage: python3 tools/extract-spirv.py [--out-dir /path/to/spv]
"""

import sys, struct, re, os, argparse

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT  = os.path.dirname(SCRIPT_DIR)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--slangmosh', default=os.path.join(
        REPO_ROOT,
        'ares/n64/vulkan/parallel-rdp/parallel-rdp/shaders/slangmosh.hpp'))
    ap.add_argument('--out-dir', default=os.path.join(REPO_ROOT, 'tools', 'spv'))
    args = ap.parse_args()

    os.makedirs(args.out_dir, exist_ok=True)

    print(f'[extract-spirv] Reading {args.slangmosh} ...', flush=True)

    with open(args.slangmosh, 'r') as f:
        content = f.read()

    # Extract the spirv_bank[] u32 values.
    m = re.search(r'static\s+const\s+uint32_t\s+spirv_bank\s*\[\s*\]\s*=\s*\{([^}]+)\}',
                  content, re.DOTALL)
    if not m:
        print('[ERROR] Could not find spirv_bank[] in slangmosh.hpp', file=sys.stderr)
        sys.exit(1)

    words_str = m.group(1)
    # Parse hex u32 literals (may have trailing 'u' suffix like 0x07230203u)
    raw_tokens = re.findall(r'0x[0-9a-fA-F]+u?|\b[0-9]+u?\b', words_str)
    words = [int(t.rstrip('u'), 0) for t in raw_tokens if t.rstrip('u')]
    print(f'[extract-spirv] Loaded {len(words)} u32 words from spirv_bank')

    # ---------------------------------------------------------------------------
    # Shader map: (name, word_offset, byte_size)
    # Chosen variants: SUBGROUP=0, SMALL_TYPES=0, UBERSHADER=1 where multiple
    # variants exist (ubershader/tile_binning) so we get full rendering without
    # subgroup ops (not in base WGSL).
    # ---------------------------------------------------------------------------
    SHADERS = [
        # Simple utility shaders
        ('tmem_update',                      0,      29448),
        ('span_setup',                       7362,   21624),
        ('clear_indirect_buffer',            12768,    880),
        # tile_binning: SUBGROUP=0, UBERSHADER=1, SMALL_TYPES=0
        ('tile_binning',                     24472,  19528),
        # ubershader: SUBGROUP=0, SMALL_TYPES=0
        ('ubershader',                       55934, 206752),
        # depth_blend: SUBGROUP=0, SMALL_TYPES=0
        ('depth_blend',                     264844,  63356),
        # rasterizer: SMALL_TYPES=0
        ('rasterizer',                      328900, 163292),
        # Simple utility shaders (no variants)
        ('extract_vram',                    423785,   6236),
        ('masked_rdram_resolve',            425344,   2804),
        ('clear_write_mask',               426045,   1504),
        ('update_upscaled_domain_post',    426421,   4756),
        ('update_upscaled_domain_pre',     427610,   9368),
        ('update_upscaled_domain_resolve', 429952,  13716),
        ('clear_super_sampled_write_mask', 433381,    828),
    ]

    for (name, word_off, byte_size) in SHADERS:
        word_count = byte_size // 4
        end = word_off + word_count
        if end > len(words):
            print(f'  [SKIP] {name}: offset {word_off}+{word_count} exceeds bank size {len(words)}')
            continue

        chunk = words[word_off:end]
        out_path = os.path.join(args.out_dir, f'{name}.spv')
        with open(out_path, 'wb') as f:
            for w in chunk:
                f.write(struct.pack('<I', w))

        print(f'  [OK]   {name}: {word_count} words ({byte_size} bytes) → {out_path}')

    print(f'\n[extract-spirv] Done. SPV files in {args.out_dir}')

if __name__ == '__main__':
    main()
