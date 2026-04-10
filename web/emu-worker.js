/**
 * web/emu-worker.js — Emulation Web Worker
 *
 * Loads the ares N64 WASM module and drives the emulation loop entirely
 * inside a dedicated Worker thread, keeping the browser main thread free
 * for UI, audio scheduling, and canvas presentation.
 *
 * Message protocol (Worker ↔ main thread):
 *
 *   Main → Worker
 *     { type: 'loadRom',  romData: ArrayBuffer }   (transferred)
 *     { type: 'input',    buttons:[b0..b3], axisX:[x0..x3], axisY:[y0..y3] }
 *     { type: 'reset' }
 *     { type: 'stop' }
 *
 *   Worker → Main
 *     { type: 'ready' }
 *     { type: 'romLoaded', ok: bool }
 *     { type: 'frame',  pixels: Uint8ClampedArray.buffer (transferred),
 *                       width, height,
 *                       audioLeft: Float32Array.buffer (transferred),
 *                       audioRight: Float32Array.buffer (transferred),
 *                       audioFrames: N, frameNumber: N }
 *     { type: 'status', msg: string }
 *     { type: 'abort',  error: string }
 */

'use strict';

// Load the Emscripten-generated JS wrapper.  Both files live in the same
// directory as this worker, so the default locateFile (relative to the
// worker URL) finds ares-web.wasm automatically.
importScripts('ares-web.js');

let M        = null;   // Emscripten module instance
let running  = false;

// Current input state — updated immediately when 'input' messages arrive.
const input = {
  buttons: [0, 0, 0, 0],  // bitmask of 14 N64 buttons per port
  axisX:   [0, 0, 0, 0],  // [-32767 .. +32767]
  axisY:   [0, 0, 0, 0],
};

// ── Module initialisation ──────────────────────────────────────────────────

async function initModule() {
  // Request a WebGPU device from within this Worker context.
  // Workers can access navigator.gpu directly in Chrome/Chromium.
  // The device is passed to the WASM module via preinitializedWebGPUDevice
  // so that emscripten_webgpu_get_device() returns it.
  let gpuDevice = null;
  if (typeof navigator !== 'undefined' && navigator.gpu) {
    try {
      const adapter = await navigator.gpu.requestAdapter({ powerPreference: 'high-performance' });
      if (adapter) {
        const adapterLimits = adapter.limits;
        // The paraLLEl-RDP ubershader uses 13 storage buffers in group(1).
        // The paraLLEl-RDP ubershader uses 15 storage buffers (across all bind groups).
        // Require at least 15 to avoid acquiring a device that will fail shader compilation.
        const MIN_STORAGE_BUFS = 15;
        console.info(`[emu-worker] adapter maxStorageBuffersPerShaderStage=${adapterLimits.maxStorageBuffersPerShaderStage} maxBufferSize=${adapterLimits.maxBufferSize}`);
        if (adapterLimits.maxStorageBuffersPerShaderStage < MIN_STORAGE_BUFS) {
          console.warn(
            `[emu-worker] GPU maxStorageBuffersPerShaderStage=${adapterLimits.maxStorageBuffersPerShaderStage}` +
            ` < ${MIN_STORAGE_BUFS} — GPU acceleration disabled, using software renderer`
          );
          // gpuDevice stays null → WASM falls back to software scanout
        } else {
          // Request higher storage-buffer and buffer-size limits.
          gpuDevice = await adapter.requestDevice({
            requiredLimits: {
              maxStorageBufferBindingSize:     Math.min(256 * 1024 * 1024, adapterLimits.maxStorageBufferBindingSize),
              maxBufferSize:                   Math.min(256 * 1024 * 1024, adapterLimits.maxBufferSize),
              maxStorageBuffersPerShaderStage: Math.min(16, adapterLimits.maxStorageBuffersPerShaderStage),
            },
          });
          console.info('[emu-worker] WebGPU device acquired');
        }
      } else {
        console.warn('[emu-worker] No WebGPU adapter — software renderer active');
      }
    } catch (e) {
      console.warn('[emu-worker] WebGPU init failed:', e);
    }
  }

  M = await AresN64Module({
    print:    () => {},
    printErr: (t) => console.warn('[wasm]', t),
    onAbort:  (w) => self.postMessage({ type: 'abort', error: String(w) }),
    preinitializedWebGPUDevice: gpuDevice,
  });

  M._ares_init();
  self.postMessage({ type: 'ready' });
}

// ── Input helpers ──────────────────────────────────────────────────────────

function applyInput() {
  for (let port = 0; port < 4; port++) {
    const btns = input.buttons[port] | 0;
    for (let b = 0; b < 14; b++) {
      M._ares_set_button(port, b, (btns >> b) & 1);
    }
    M._ares_set_axis(port, 0, input.axisX[port] | 0);
    M._ares_set_axis(port, 1, input.axisY[port] | 0);
  }
}

// ── Main emulation loop ────────────────────────────────────────────────────

async function runLoop() {
  running = true;
  let debugFrames = 0;
  while (running) {
    applyInput();
    M._ares_run_frame();

    // ── Framebuffer ──
    const w   = M._ares_get_framebuffer_width();
    const h   = M._ares_get_framebuffer_height();
    const ptr = M._ares_get_framebuffer();

    if (debugFrames < 5) {
      console.log(`[emu-worker] frame ${debugFrames}: w=${w} h=${h} ptr=${ptr}`);
      debugFrames++;
    }
    let pixels = null;
    const transfers = [];

    if (ptr && w && h) {
      const byteLen = w * h * 4;
      // Copy RGBA pixels out of WASM heap so we can transfer ownership.
      pixels = new Uint8ClampedArray(byteLen);
      pixels.set(new Uint8ClampedArray(M.HEAPU8.buffer, ptr, byteLen));
      transfers.push(pixels.buffer);
    }

    // ── Audio ──
    const ptrPtr  = M._malloc(4);
    const frames  = M._ares_get_audio_data(ptrPtr);
    const dataPtr = M.getValue(ptrPtr, 'i32');
    M._free(ptrPtr);

    let audioLeft = null, audioRight = null;
    if (frames && dataPtr) {
      const src = new Float32Array(M.HEAPF32.buffer, dataPtr, frames * 2);
      audioLeft  = new Float32Array(frames);
      audioRight = new Float32Array(frames);
      for (let i = 0; i < frames; i++) {
        audioLeft[i]  = src[i * 2];
        audioRight[i] = src[i * 2 + 1];
      }
      M._ares_consume_audio(frames);
      transfers.push(audioLeft.buffer, audioRight.buffer);
    }

    // Transfer buffers to main thread (zero-copy).
    self.postMessage({
      type: 'frame',
      pixels,
      width:        w,
      height:       h,
      audioLeft,
      audioRight,
      audioFrames:  frames || 0,
      frameNumber:  M._ares_get_frame_number(),
    }, transfers);

    // Yield so that pending 'input' / 'reset' messages can be processed
    // between frames.
    await new Promise(r => setTimeout(r, 0));
  }
}

// ── Message handler ────────────────────────────────────────────────────────

self.onmessage = async (e) => {
  const msg = e.data;
  switch (msg.type) {

    case 'loadRom': {
      // romData arrives as a transferred ArrayBuffer.
      const bytes = new Uint8Array(msg.romData);
      const ptr   = M._malloc(bytes.byteLength);
      console.log(`[emu-worker] loadRom: ${bytes.byteLength} bytes, ptr=${ptr}`);
      if (!ptr) { self.postMessage({ type: 'romLoaded', ok: false }); break; }
      M.HEAPU8.set(bytes, ptr);
      const ok = !!M._ares_load_rom(ptr, bytes.byteLength);
      console.log(`[emu-worker] ares_load_rom returned: ${ok}`);
      M._free(ptr);
      self.postMessage({ type: 'romLoaded', ok });
      if (ok && !running) runLoop();
      break;
    }

    case 'input':
      input.buttons = msg.buttons;
      input.axisX   = msg.axisX;
      input.axisY   = msg.axisY;
      break;

    case 'reset':
      M._ares_reset?.();
      break;

    case 'stop':
      running = false;
      break;
  }
};

// Boot immediately.
initModule().catch(err => {
  console.error('[emu-worker] init failed:', err);
  self.postMessage({ type: 'error', error: String(err) });
});
