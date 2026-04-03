# Ares N64 Web — Browser PWA Port Plan

## Overview

Port ares — the actual emulator, not a lookalike — to run in a web browser via
WebAssembly (Emscripten), with a PWA shell for mobile support. **N64 only** —
all other console cores are excluded from the build to minimize binary size.

The goal is **literal ares in the browser**: same emulation core, same
paraLLEl-RDP rendering (via WebGPU instead of Vulkan), same scheduler, same
accuracy. The only differences from desktop ares are:

- **WebGPU** replaces Vulkan for paraLLEl-RDP compute shaders
- **Emscripten fibers** replace native libco coroutines
- **Interpreter mode** for CPU/RSP (WASM can't do native JIT)
- **Web platform layer** replaces ruby (video/audio/input) and hiro (GUI)

ROMs are loaded directly by the user via file picker or drag-and-drop. No ROM
database or persistent storage.

## Architecture

```
┌──────────────────────────────────────────────────────┐
│                    Browser (PWA)                      │
│                                                       │
│  ┌───────────┐  ┌────────────┐  ┌─────────────────┐  │
│  │  Web UI   │  │  Service   │  │  Remote Test    │  │
│  │  (Touch + │  │  Worker    │  │  API (WS)       │  │
│  │  Gamepad) │  │  (Offline) │  │                 │  │
│  └─────┬─────┘  └────────────┘  └────────┬────────┘  │
│        │                                 │            │
│  ┌─────▼─────────────────────────────────▼─────────┐  │
│  │          JavaScript Bridge Layer                 │  │
│  │   WebGPU · WebAudio · Gamepad · File API        │  │
│  └──────────────────┬──────────────────────────────┘  │
│                     │                                 │
│  ┌──────────────────▼──────────────────────────────┐  │
│  │           Ares N64 Core (WASM)                  │  │
│  │   VR4300 · RSP · paraLLEl-RDP(WebGPU) · AI·VI  │  │
│  │   libco (Emscripten fibers)                     │  │
│  └─────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────┘
```

## Key Technical Decisions

### 1. Compilation Target: WASM via Emscripten

WASM is the only viable compilation target. Every successful browser emulator
(N64Wasm, v86, JSLinux) uses it. asm.js is obsolete. Pure JS rewrite is
impractical for 500K+ lines of C++.

### 2. Graphics: WebGPU Port of paraLLEl-RDP (LLE, Not HLE)

Ares has **no software RDP renderer** — the non-Vulkan code path
(`ares/n64/rdp/render.cpp`) is entirely stubs. paraLLEl-RDP via Vulkan compute
is the only rendering pipeline. To keep this ares (not a knockoff), we port
paraLLEl-RDP to WebGPU rather than substituting an HLE renderer.

**What this involves:**

1. **Shader transpilation**: paraLLEl-RDP's SPIR-V compute shaders → WGSL
   - Use Naga (Rust, part of wgpu) or Tint (C++, part of Dawn/Chrome) to
     transpile. Both handle SPIR-V → WGSL.
   - Alternatively, use `spirv-webgpu-transform` (Rust crate) for targeted
     SPIR-V patching to make shaders WebGPU-compliant.
   - Manual review needed: WGSL lacks some Vulkan features (combined image
     samplers, certain memory layout qualifiers). Fixups will be needed.

2. **Vulkan host code → WebGPU API**: The C++ code in `ares/n64/vulkan/` that
   manages Vulkan devices, command buffers, pipelines, synchronization, and
   memory must be rewritten to use WebGPU equivalents:

   | Vulkan concept | WebGPU equivalent |
   |----------------|-------------------|
   | `VkDevice` | `GPUDevice` |
   | `VkCommandBuffer` | `GPUCommandEncoder` |
   | `VkComputePipeline` | `GPUComputePipeline` |
   | `VkBuffer` | `GPUBuffer` |
   | `VkImage` / `VkImageView` | `GPUTexture` / `GPUTextureView` |
   | `VkFence` / `VkSemaphore` | `GPUQueue.onSubmittedWorkDone()` / implicit ordering |
   | `vkQueueSubmit` | `GPUQueue.submit()` |
   | Timeline semaphores | Map work done callbacks or `GPUBuffer.mapAsync()` |
   | Push constants | Uniform buffers (WebGPU has no push constants) |
   | Storage images | Storage textures |
   | Subgroup operations | Check WGSL subgroup support (experimental in some browsers) |

3. **WebGPU access from WASM**: Two approaches:
   - **Option A (recommended)**: Use Emscripten's built-in WebGPU bindings
     (`-s USE_WEBGPU=1`). Emscripten provides `webgpu.h` / `wgpu.h` C headers
     that map to the browser's WebGPU API. Write the WebGPU host code in C++
     using these headers. This keeps everything in WASM.
   - **Option B**: Write the WebGPU orchestration in JavaScript and call into
     it from WASM via `EM_JS`. More flexible but harder to maintain.

4. **Async GPU operations**: Vulkan uses fences and timeline semaphores for
   CPU-GPU sync. WebGPU is more async-oriented. Key concern: `syncFull()` in
   the RDP currently calls `processor->wait_for_timeline()` which blocks.
   In WebGPU, use `GPUBuffer.mapAsync()` for readback and structure the
   frame loop to handle the async nature (e.g., double-buffer scanout).

5. **Browser support**: WebGPU is shipped in Chrome 113+, Firefox 141+,
   Safari 26+, Edge. ~70% coverage as of early 2026. Compute shaders are a
   core part of the spec, not an extension.

6. **Upscaling**: Because this is paraLLEl-RDP, upscaling (2x, 4x) works
   automatically — same as desktop ares. This is a major advantage over any
   HLE approach.

### 3. CPU Execution: Optimized Interpreter (MVP), MIPS→WASM JIT (Future)

WASM does not support runtime native code generation. Ares's VR4300 and RSP
JIT recompilers generate x86/ARM machine code, which is incompatible.

**MVP: Optimized interpreter mode.** Disable recompilers
(`Accuracy::CPU::Recompiler = false`, `Accuracy::RSP::Recompiler = false`)
but apply aggressive interpreter optimizations to close the gap with the
desktop recompiler. The ares interpreter currently decodes every instruction
from scratch via nested switch statements with no caching. The recompiler is
~4-8x faster. Our goal is to recover 2-4x of that gap.

**Interpreter optimization strategy (cumulative, ordered by priority):**

1. **Build flags: `-O3 -flto -msimd128`** (free, high impact)
   - LTO enables cross-file inlining. Ares instruction handlers (`ADDI`, `LW`,
     etc.) are in separate `.cpp` files — without LTO the compiler cannot
     inline them into the dispatch loop. Single biggest free win.
   - WASM SIMD (`-msimd128`) maps RSP's SSE4.1 intrinsics to WASM 128-bit
     SIMD. Critical for RSP-heavy games.
   - Use 32-bit WASM memory (not `memory64`) — V8/SpiderMonkey reserve 4GB
     virtual regions giving zero-overhead bounds checks via guard pages.

2. **Tail-call threaded dispatch** (~12-15% over switch, medium effort)
   - WASM tail calls are shipped in all major browsers (WASM 3.0, Sept 2025).
   - Restructure the CPU interpreter so each opcode handler is a separate
     function that `[[clang::musttail]]` calls the next handler.
   - Replaces the single unpredictable `br_table` dispatch with per-handler
     branch sites that hardware can predict.
   - Reference: wasm3 interpreter uses this exact design.
   - Lighter alternative: "switched goto" — duplicate the switch at the end
     of each case for per-site branch prediction. Less restructuring.

3. **Idle loop detection** (game-dependent, low effort)
   - The recompiler special-cases branch-to-self and jump-to-self, skipping
     62+ stall cycles. The interpreter does not. Adding this is trivial and
     gives huge speedups for games that spin-wait.

4. **Cached/block interpreter** (~1.5-2x over raw interpret, high effort)
   - Pre-decode MIPS instructions into a compact struct (handler function
     pointer + pre-extracted operands) on first execution. Cache by PC in a
     hash table. Re-execution skips decode entirely.
   - Keep per-instruction metadata < 32 bytes to stay in L1 cache (mupen64plus
     uses 132 bytes/instruction and L2 pressure is its main bottleneck).
   - This is the same architecture as mupen64plus's "cached interpreter" which
     powers N64Wasm at playable speeds.

5. **Flat memory map** (medium impact, medium effort)
   - Replace the address range switch tree with a flat array where RDRAM and
     MMIO regions sit at their N64 physical addresses. One pointer offset
     instead of a branch tree. Ares already fast-paths ~97% of accesses via
     `devirtualize<>()` but the remaining 3% hits a slow path.

**Estimated combined effect:** 2-4x faster than naive interpreter, putting
many games within playable range on desktop browsers. Mobile will require
further optimization.

**Future: MIPS→WASM JIT** (the v86 approach, major effort):
- Profile code hotness during interpretation
- Translate hot MIPS basic blocks to WASM bytecode (generated in C++ as byte
  arrays)
- Pass bytecode to JS via Emscripten binding → `WebAssembly.compile()` +
  `WebAssembly.instantiate()` with shared memory
- New functions callable via indirect function table (`call_indirect`)
- Batch translations to avoid Chrome's ~1000 live WASM module limit
- Fall back to interpreter while async compilation is pending
- Track code invalidation per memory page

Alternative: MIPS→JS JIT (the 1964js approach) using `new Function()`. Simpler
but potentially slower. Good fallback if WASM module generation proves too
complex.

### 4. Coroutines: Emscripten Fibers

The ares scheduler runs every emulated component (CPU, RSP, VI, AI, SI) as a
libco coroutine. **No Emscripten backend exists in libco.** We create one.

Create `libco/emscripten.c` using Emscripten's fiber API
(`<emscripten/fiber.h>`):

| libco API | Emscripten equivalent |
|-----------|-----------------------|
| `co_create(size, entry)` | `emscripten_fiber_init()` with malloc'd C stack + asyncify stack |
| `co_switch(handle)` | `emscripten_fiber_swap()` |
| `co_delete(handle)` | `free()` the stack allocations |
| `co_active()` | Thread-local tracking of current fiber |

Stack sizes: 128KB C stack + 16KB asyncify stack per fiber.
Compile flag: `-s ASYNCIFY`.

### 5. ROM Loading

- `<input type="file" accept=".z64,.n64,.v64">` and drag-and-drop
- Read into WASM memory via `FileReader` / `ArrayBuffer`
- Auto-detect byte order (z64/n64/v64) and byte-swap if needed
- Minimal mia: only ROM header parsing + CIC detection (required for PIF boot)
- No ROM database, no IndexedDB, no persistent library

### 6. Audio: WebAudio API

- AudioWorklet with small buffer (256 samples) for low latency
- Ring buffer in SharedArrayBuffer between WASM emulation thread and
  AudioWorklet
- Resume AudioContext on first user gesture (browser requirement)
- Fallback to ScriptProcessorNode if AudioWorklet unavailable
- 44.1 kHz stereo from ares AI — no resampling needed

### 7. Input: Gamepad API + Keyboard + Touch

- `navigator.getGamepads()` polling (matches ares's existing poll model)
- Keyboard mapping for desktop
- Virtual touch overlay for mobile (analog stick + all N64 buttons)
- Input state written to shared memory region, read by WASM platform layer

---

## Implementation Phases

### Phase 1: WASM Build System + libco Backend

Get the N64 core compiling to WASM and the scheduler running.

**Tasks:**

1. **Emscripten CMake preset** in `CMakePresets.json`
   - `CMAKE_TOOLCHAIN_FILE` → Emscripten's `Emscripten.cmake`
   - Enable only `CORE_N64`
   - Link flags: `-s WASM=1 -s ALLOW_MEMORY_GROWTH=1 -s INITIAL_MEMORY=256MB`
   - Link flags: `-s ASYNCIFY -s USE_WEBGPU=1`
   - Compile flags: `-O2 -msimd128`

2. **`web/CMakeLists.txt`** for the web target
   - Build ares core (N64 only) as static lib
   - Build minimal mia (header parsing + CIC) as static lib
   - Link into single WASM module

3. **Stub platform-incompatible code**
   - `#if !defined(__EMSCRIPTEN__)` guards around native Vulkan, native GL,
     native audio/input drivers
   - Disable CPU/RSP recompilers when `__EMSCRIPTEN__` defined
   - Stub nall OS utilities (filesystem paths, process spawning, native threads)
   - Exclude sljit, librashader, libchdr

4. **`libco/emscripten.c`** — new fiber backend
   - Implement using `emscripten_fiber_*` API
   - Update `libco/libco.c` with `#if defined(__EMSCRIPTEN__)` selection

5. **`web/main-web.cpp`** — minimal entry point
   - Initialize ares N64 core
   - Implement `ares::Platform` with placeholder callbacks
   - Export to JS: `init()`, `loadROM(ptr, size)`, `runFrame()`
   - Verify scheduler enters and exits cleanly

**Exit criteria:** WASM compiles, links, loads in browser. `scheduler.enter()`
runs one frame of N64 emulation and returns without crashing.

### Phase 2: WebGPU paraLLEl-RDP Port

The core rendering work. This is the hardest phase and the one that makes this
real ares rather than a knockoff.

**Tasks:**

1. **Shader transpilation**
   - Inventory all SPIR-V compute shaders in paraLLEl-RDP
   - Transpile to WGSL using Naga or Tint
   - Validate: compare output of each shader against reference renders
   - Manual fixups for WGSL incompatibilities (combined samplers, push
     constants → uniform buffers, etc.)

2. **WebGPU abstraction layer** (`web/webgpu-rdp.cpp`)
   - Create a thin Vulkan→WebGPU translation layer, or rewrite the host code
     in `ares/n64/vulkan/vulkan.cpp` to use Emscripten's `webgpu.h` directly
   - Key subsystems to port:
     - Device/queue initialization
     - Compute pipeline creation (from WGSL shaders)
     - Buffer management (RDRAM upload, command buffers, readback)
     - Texture management (TMEM, framebuffer, scanout)
     - Command encoding and submission
     - Synchronization (async readback via `mapAsync`)

3. **Scanout pipeline**
   - `vulkan.mapScanoutRead()` → WebGPU buffer readback (async)
   - Double-buffer to avoid stalling: while GPU renders frame N, CPU reads
     frame N-1
   - VI reads the readback buffer and outputs to the platform video callback

4. **Integration with ares RDP**
   - Replace `#if defined(VULKAN)` path in `ares/n64/rdp/render.cpp`
   - Add `#if defined(WEBGPU)` path that calls the WebGPU RDP
   - Same command interface: `enqueue_command()`, `wait_for_timeline()`,
     `scanout_async_buffer()`

5. **Canvas presentation**
   - WebGPU renders to a texture → copy to canvas via `GPUCanvasContext`
   - Or: readback to CPU → upload as WebGL2 texture (simpler, slightly slower)
   - Handle aspect ratio, scaling, fullscreen

**Exit criteria:** A commercial N64 game boots and renders correctly in the
browser using paraLLEl-RDP compute shaders via WebGPU. Visual output matches
desktop ares.

### Phase 3: Audio & Input

Make it playable.

**Tasks:**

1. **Audio** (`web/platform-web.cpp` + `web/bridge.js`)
   - AudioWorklet reads from ring buffer in SharedArrayBuffer
   - WASM `platform->audio()` mixes streams and pushes to ring buffer
   - Handle underrun/overrun, resume on gesture

2. **Input** (`web/bridge.js`)
   - Keyboard mapping (WASD, arrows, common keys → N64 buttons)
   - Gamepad API polling each frame
   - Write state to shared memory struct read by WASM `platform->input()`

3. **Main loop**
   - `emscripten_set_main_loop()` at target framerate
   - Each tick: poll input → `emulator->root->run()` → present → push audio

**Exit criteria:** Game is playable with keyboard/gamepad and audible sound.

### Phase 4: Web UI & PWA

Package for end users and mobile.

**Tasks:**

1. **`web/index.html`** — minimal app shell
   - `<canvas>` for video output
   - ROM load button + drag-and-drop
   - Settings (volume, input mapping, upscale factor)
   - Responsive layout

2. **`web/touch-controls.js`** — virtual gamepad for mobile
   - Analog stick + all N64 buttons
   - Configurable layout, opacity, size
   - Haptic feedback

3. **`web/manifest.json`** + **`web/sw.js`** — PWA
   - Standalone display, landscape orientation
   - Cache WASM/JS/CSS/HTML for offline
   - No ROM caching

4. **Mobile polish**
   - Landscape lock during emulation
   - Fullscreen on play
   - `beforeinstallprompt` for home screen install

**Exit criteria:** Installs as PWA on Android/iOS. Touch controls work.
Offline-capable after first load.

### Phase 5: Remote Testing API

Enable automated game testing.

**Tasks:**

1. **`web/remote-api.js`** — WebSocket control API
   ```
   load_rom(arrayBuffer)      → Load and start
   send_input(buttonState)    → Set controller for next frame
   screenshot()               → Current frame as PNG (base64)
   advance_frames(n, inputs)  → Step N frames with input sequence
   save_state() / load_state()
   reset()
   get_status()               → FPS, frame count, state
   ```

2. **`web/remote-relay.js`** — Node.js WebSocket relay
   - Bridges HTTP/WS from automated tools to browser
   - Stateless

3. **Deterministic mode**
   - Fixed timestep, no frame skip
   - Input sequences with frame numbers
   - Frame hash output for regression testing

**Exit criteria:** External script loads ROM, sends input, captures screenshot
via WebSocket.

### Phase 6: Performance Optimization

**Note:** Build-level optimizations (`-O3 -flto -msimd128`, 32-bit WASM
memory) are applied from Phase 1. Interpreter restructuring (tail-call
dispatch, idle loop detection) is done in Phase 1 as part of the initial port.
This phase covers the heavier optimizations.

**Prioritized:**

1. **Cached/block interpreter** (highest impact for CPU-bound games)
   - Pre-decode MIPS instructions into compact dispatch structs
   - Cache blocks by PC, skip re-decode on re-execution
   - Keep per-instruction metadata < 32 bytes for L1 cache

2. **Web Worker for emulation**
   - Emulation in dedicated Worker, main thread for UI only
   - SharedArrayBuffer for framebuffer and audio ring buffer
   - Requires `Cross-Origin-Isolation` headers (`COOP` + `COEP`)

3. **Flat memory map**
   - Replace address-range switches with flat 4GB-mapped array
   - Direct pointer arithmetic for all memory access

4. **MIPS→WASM JIT** (v86 approach, major effort)
   - New recompiler backend emitting WASM bytecode
   - Profile-guided hot block compilation
   - Batched modules (stay under Chrome's ~1000 module limit)
   - Async compilation with interpreter fallback
   - Per-page code invalidation tracking

5. **Memory optimization**
   - Target < 128MB base WASM memory for mobile
   - Lazy-load minimal mia data

---

## Risk Assessment

| Risk | Severity | Likelihood | Mitigation |
|------|----------|------------|------------|
| WebGPU paraLLEl-RDP port harder than expected | High | Medium | Start here — it's the critical path. Prototype with one shader first. If blocked, Angrylion (software LLE) compiled to WASM+SIMD is the fallback. |
| Interpreter too slow on mobile | High | High | WASM SIMD for RSP; Web Worker; accept that mobile may not hit 60fps for all games |
| WGSL shader incompatibilities | Medium | Medium | Use Naga/Tint transpilers; manual fixup for edge cases; test against desktop reference renders |
| WebGPU async model mismatches Vulkan sync | Medium | Medium | Double-buffer scanout; restructure sync points; use `mapAsync` callbacks |
| Emscripten fiber overhead | Medium | Low | Well-tested API; tune stack sizes; profile early |
| Audio latency | Medium | Medium | AudioWorklet with 256-sample buffer; tune ring buffer |
| Large WASM binary | Medium | Medium | N64-only; `-Oz`; gzip/brotli; code splitting if needed |
| WebGPU not on older mobile browsers | Medium | Low | ~70% coverage now; can add Angrylion WASM fallback for non-WebGPU browsers |

## File Structure

```
web/
├── index.html              # App shell
├── manifest.json           # PWA manifest
├── sw.js                   # Service worker
├── styles.css              # UI styles
├── ui.js                   # UI logic & settings
├── bridge.js               # WASM ↔ Web API glue (audio, input, timing)
├── touch-controls.js       # Virtual gamepad overlay
├── remote-api.js           # Remote testing API (browser-side)
├── remote-relay.js         # Node.js WebSocket relay
├── platform-web.cpp        # ares::Platform implementation for web
├── main-web.cpp            # WASM entry point
├── webgpu-rdp.cpp          # WebGPU host code for paraLLEl-RDP
├── webgpu-rdp.hpp          # WebGPU RDP interface
├── shaders/                # Transpiled WGSL shaders (from SPIR-V)
├── CMakeLists.txt          # Web build configuration
└── icons/                  # PWA icons
```

Modified existing files:
- `CMakePresets.json` — Emscripten preset
- `CMakeLists.txt` — conditional web target
- `libco/libco.c` — Emscripten backend detection
- `libco/emscripten.c` — new fiber backend (new file)
- `ares/n64/rdp/render.cpp` — add `#if defined(WEBGPU)` path
- `ares/n64/vulkan/vulkan.hpp` — abstract interface for WebGPU backend

## References

- [N64Wasm](https://github.com/nbarkhina/N64Wasm) — proves WASM N64 emulation works at playable speeds
- [v86](https://github.com/copy/v86) — reference for WASM-to-WASM JIT approach
- [n64js](https://hulkholden.github.io/n64js/) — JS N64 emulator, reference for HLE fallback
- [Emscripten Fiber API](https://emscripten.org/docs/api_reference/fiber.h.html)
- [Emscripten WebGPU](https://emscripten.org/docs/api_reference/html5.h.html#webgpu) — C/C++ WebGPU bindings
- [wingolog: JIT in WASM](https://wingolog.org/archives/2022/08/18/just-in-time-code-generation-within-webassembly)
- [paraLLEl-RDP](https://github.com/Themaister/parallel-rdp) — Vulkan compute LLE renderer
- [Naga](https://github.com/gfx-rs/wgpu/tree/trunk/naga) — SPIR-V → WGSL transpiler
- [Tint](https://dawn.googlesource.com/tint) — SPIR-V → WGSL (Chrome's shader compiler)
- [WebGPU spec](https://www.w3.org/TR/webgpu/)
- [WebGPU Shading Language spec](https://www.w3.org/TR/WGSL/)
