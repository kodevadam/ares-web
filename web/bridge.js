/**
 * web/bridge.js
 *
 * JavaScript bridge between the ares N64 WASM module and browser Web APIs.
 *
 * Responsibilities:
 *   1. WebGPU device initialisation (adapter → device → set on Module).
 *   2. Canvas presentation: copy the RGBA8888 framebuffer from WASM memory
 *      to a 2-D canvas using ImageData, or to a WebGPU canvas via GPUTexture.
 *   3. Main loop via requestAnimationFrame.
 *   4. ROM loading (file picker + drag-and-drop → ares_load_rom).
 *   5. Keyboard and Gamepad API input → ares_set_button / ares_set_axis.
 *   6. Audio stub (Phase 3: replaced by AudioWorklet + SharedArrayBuffer).
 *
 * This file is loaded by index.html before the WASM module.
 */

'use strict';

// ---------------------------------------------------------------------------
// Globals
// ---------------------------------------------------------------------------

let Module;          // Emscripten module, set by onRuntimeInitialized
let gpuDevice;       // WGPUDevice handle (opaque integer in WASM address space)
let canvas;          // <canvas> element for video output
let ctx2d;           // CanvasRenderingContext2D fallback (non-WebGPU path)
let gpuCtx;          // GPUCanvasContext (WebGPU presentation path)
let gpuPresentFormat;
let running = false;
let romLoaded = false;

// ---------------------------------------------------------------------------
// 1.  WebGPU Initialisation
// ---------------------------------------------------------------------------

async function initWebGPU() {
  if (!navigator.gpu) {
    console.warn('[ares-web] WebGPU not available — falling back to software renderer');
    return null;
  }

  const adapter = await navigator.gpu.requestAdapter({
    powerPreference: 'high-performance',
  });
  if (!adapter) {
    console.warn('[ares-web] Could not get GPU adapter');
    return null;
  }

  // Request a device with the limits paraLLEl-RDP needs.
  const device = await adapter.requestDevice({
    requiredLimits: {
      maxStorageBufferBindingSize: 256 * 1024 * 1024,  // 256 MiB (for RDRAM + TMEM)
      maxBufferSize:               256 * 1024 * 1024,
      maxComputeWorkgroupStorageSize: 16384,
      maxComputeInvocationsPerWorkgroup: 256,
    },
  });

  device.lost.then((info) => {
    console.error('[ares-web] GPU device lost:', info.message);
    if (info.reason !== 'destroyed') {
      // Attempt recovery on next load.
      gpuDevice = null;
    }
  });

  return device;
}

// ---------------------------------------------------------------------------
// 2.  Canvas setup
// ---------------------------------------------------------------------------

function setupCanvas(width, height) {
  canvas = document.getElementById('ares-canvas');
  if (!canvas) {
    canvas = document.createElement('canvas');
    canvas.id = 'ares-canvas';
    document.getElementById('canvas-container').appendChild(canvas);
  }
  canvas.width  = width  || 640;
  canvas.height = height || 480;

  if (gpuDevice) {
    try {
      gpuCtx = canvas.getContext('webgpu');
      gpuPresentFormat = navigator.gpu.getPreferredCanvasFormat();
      gpuCtx.configure({
        device: gpuDevice,
        format: gpuPresentFormat,
        alphaMode: 'opaque',
      });
      console.log('[ares-web] Using WebGPU canvas context');
      return;
    } catch (e) {
      console.warn('[ares-web] WebGPU canvas context failed, falling back to 2D:', e);
    }
  }

  ctx2d = canvas.getContext('2d');
  console.log('[ares-web] Using 2D canvas context');
}

// ---------------------------------------------------------------------------
// 3.  Frame presentation
// ---------------------------------------------------------------------------

/**
 * Present the current framebuffer.
 * Reads the RGBA8888 buffer from WASM linear memory and draws it to canvas.
 */
function presentFrame() {
  if (!Module) return;

  const ptr    = Module._ares_get_framebuffer();
  const width  = Module._ares_get_framebuffer_width();
  const height = Module._ares_get_framebuffer_height();

  if (!ptr || width === 0 || height === 0) return;

  // Resize canvas if dimensions changed.
  if (canvas.width !== width || canvas.height !== height) {
    canvas.width  = width;
    canvas.height = height;
    if (gpuCtx) {
      gpuCtx.configure({
        device: gpuDevice,
        format: gpuPresentFormat,
        alphaMode: 'opaque',
      });
    }
  }

  // Copy RGBA bytes from WASM heap.
  const byteLen = width * height * 4;
  const data    = new Uint8ClampedArray(Module.HEAPU8.buffer, ptr, byteLen);

  if (ctx2d) {
    // 2D canvas path.
    const imgData = new ImageData(data, width, height);
    // Ensure the off-screen size matches.
    if (ctx2d.canvas.width !== width || ctx2d.canvas.height !== height) {
      ctx2d.canvas.width  = width;
      ctx2d.canvas.height = height;
    }
    ctx2d.putImageData(imgData, 0, 0);
  } else if (gpuDevice && gpuCtx) {
    // WebGPU path: upload as a GPUTexture and blit to canvas.
    presentFrameWebGPU(data, width, height);
  }
}

/**
 * WebGPU canvas blit: upload the CPU framebuffer into a texture and draw it.
 */
function presentFrameWebGPU(rgba, width, height) {
  const texture = gpuDevice.createTexture({
    size: [width, height],
    format: 'rgba8unorm',
    usage: GPUTextureUsage.TEXTURE_BINDING |
           GPUTextureUsage.COPY_DST        |
           GPUTextureUsage.RENDER_ATTACHMENT,
  });

  gpuDevice.queue.writeTexture(
    { texture },
    rgba,
    { bytesPerRow: width * 4, rowsPerImage: height },
    [width, height],
  );

  // Simple fullscreen blit via a render pass to the swap-chain texture.
  const swapChainTexture = gpuCtx.getCurrentTexture();
  const encoder = gpuDevice.createCommandEncoder();
  const pass = encoder.beginRenderPass({
    colorAttachments: [{
      view: swapChainTexture.createView(),
      loadOp: 'clear',
      clearValue: { r: 0, g: 0, b: 0, a: 1 },
      storeOp: 'store',
    }],
  });
  // Note: a full-screen blit requires a render pipeline. For Phase 2 we use
  // the 2D canvas fallback for simplicity. This stub is left here so the
  // WebGPU presentation path can be completed in Phase 4.
  pass.end();
  gpuDevice.queue.submit([encoder.finish()]);
  texture.destroy();
}

// ---------------------------------------------------------------------------
// 4.  Main loop
// ---------------------------------------------------------------------------

function mainLoop() {
  if (!running) return;

  pollGamepad();

  if (romLoaded) {
    Module._ares_run_frame();
    presentFrame();
  }

  requestAnimationFrame(mainLoop);
}

// ---------------------------------------------------------------------------
// 5.  ROM loading
// ---------------------------------------------------------------------------

function loadRomFromArrayBuffer(arrayBuffer) {
  const data = new Uint8Array(arrayBuffer);
  const ptr  = Module._malloc(data.length);
  if (!ptr) {
    setStatus('Out of memory loading ROM');
    return false;
  }
  Module.HEAPU8.set(data, ptr);
  const ok = Module._ares_load_rom(ptr, data.length);
  Module._free(ptr);

  if (!ok) {
    setStatus('Failed to load ROM');
    return false;
  }

  romLoaded = true;
  setStatus('ROM loaded — running');
  if (!running) {
    running = true;
    requestAnimationFrame(mainLoop);
  }
  return true;
}

function setupRomLoader() {
  const fileInput = document.getElementById('rom-input');
  if (fileInput) {
    fileInput.addEventListener('change', (e) => {
      const file = e.target.files[0];
      if (!file) return;
      const reader = new FileReader();
      reader.onload = (ev) => loadRomFromArrayBuffer(ev.target.result);
      reader.readAsArrayBuffer(file);
    });
  }

  // Drag-and-drop on the canvas container.
  const container = document.getElementById('canvas-container') || document.body;
  container.addEventListener('dragover', (e) => { e.preventDefault(); });
  container.addEventListener('drop', (e) => {
    e.preventDefault();
    const file = e.dataTransfer.files[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = (ev) => loadRomFromArrayBuffer(ev.target.result);
    reader.readAsArrayBuffer(file);
  });
}

// ---------------------------------------------------------------------------
// 6.  Keyboard input
// ---------------------------------------------------------------------------

// Keyboard → N64 button mapping (ButtonID values from main-web.cpp).
const KEY_MAP = {
  'ArrowUp':    { type: 'button', id: 0  },  // D-up
  'ArrowDown':  { type: 'button', id: 1  },  // D-down
  'ArrowLeft':  { type: 'button', id: 2  },  // D-left
  'ArrowRight': { type: 'button', id: 3  },  // D-right
  'KeyX':       { type: 'button', id: 4  },  // B
  'KeyZ':       { type: 'button', id: 5  },  // A
  'KeyI':       { type: 'button', id: 6  },  // C-up
  'KeyK':       { type: 'button', id: 7  },  // C-down
  'KeyJ':       { type: 'button', id: 8  },  // C-left
  'KeyL':       { type: 'button', id: 9  },  // C-right
  'ShiftLeft':  { type: 'button', id: 10 },  // L
  'ShiftRight': { type: 'button', id: 11 },  // R
  'KeyA':       { type: 'button', id: 12 },  // Z
  'Enter':      { type: 'button', id: 13 },  // Start
  // Analog stick via WASD keys
  'KeyW':       { type: 'axis', axis: 1, value: -32767 },  // Stick up
  'KeyS':       { type: 'axis', axis: 1, value:  32767 },  // Stick down
  'KeyD':       { type: 'axis', axis: 0, value:  32767 },  // Stick right
  'KeyQ':       { type: 'axis', axis: 0, value: -32767 },  // Stick left
};

function setupKeyboard() {
  document.addEventListener('keydown', (e) => {
    const mapping = KEY_MAP[e.code];
    if (!mapping || !Module) return;
    if (mapping.type === 'button') {
      Module._ares_set_button(0, mapping.id, 1);
    } else if (mapping.type === 'axis') {
      Module._ares_set_axis(0, mapping.axis, mapping.value);
    }
  });

  document.addEventListener('keyup', (e) => {
    const mapping = KEY_MAP[e.code];
    if (!mapping || !Module) return;
    if (mapping.type === 'button') {
      Module._ares_set_button(0, mapping.id, 0);
    } else if (mapping.type === 'axis') {
      Module._ares_set_axis(0, mapping.axis, 0);
    }
  });
}

// ---------------------------------------------------------------------------
// 7.  Gamepad API
// ---------------------------------------------------------------------------

// Standard gamepad button → N64 button mapping.
const GAMEPAD_BUTTON_MAP = [
  5,   // Button 0 (A)    → A
  4,   // Button 1 (B)    → B
  8,   // Button 2 (X)    → not used (map to C-left loosely)
  9,   // Button 3 (Y)    → C-right (approx)
  10,  // Button 4 (LB)   → L
  11,  // Button 5 (RB)   → R
  -1,  // Button 6 (LT)   → Z (analog — handled below)
  12,  // Button 7 (RT)   → Z
  13,  // Button 8 (back) → Start (approx)
  13,  // Button 9 (start)→ Start
  -1,  // Button 10 (L3)
  -1,  // Button 11 (R3)
  0,   // Button 12 (D-up)
  1,   // Button 13 (D-down)
  2,   // Button 14 (D-left)
  3,   // Button 15 (D-right)
];

const gamepadAxisPrev = {};
const gamepadButtonPrev = {};

function pollGamepad() {
  if (!Module || !romLoaded) return;
  const pads = navigator.getGamepads ? navigator.getGamepads() : [];
  const pad = pads[0];
  if (!pad) return;

  const port = 0;
  const prev = gamepadButtonPrev[port] = gamepadButtonPrev[port] || {};
  const axPrev = gamepadAxisPrev[port] = gamepadAxisPrev[port] || {};

  // Buttons.
  for (let i = 0; i < Math.min(pad.buttons.length, GAMEPAD_BUTTON_MAP.length); i++) {
    const n64btn = GAMEPAD_BUTTON_MAP[i];
    if (n64btn < 0) continue;
    const pressed = pad.buttons[i].pressed ? 1 : 0;
    if (pressed !== (prev[i] || 0)) {
      Module._ares_set_button(port, n64btn, pressed);
      prev[i] = pressed;
    }
  }

  // Left stick → N64 analog stick.
  const ax = Math.round(pad.axes[0] * 32767);
  const ay = Math.round(pad.axes[1] * 32767);
  if (ax !== (axPrev[0] || 0)) { Module._ares_set_axis(port, 0, ax); axPrev[0] = ax; }
  if (ay !== (axPrev[1] || 0)) { Module._ares_set_axis(port, 1, ay); axPrev[1] = ay; }
}

// ---------------------------------------------------------------------------
// 8.  Status display
// ---------------------------------------------------------------------------

function setStatus(msg) {
  const el = document.getElementById('status');
  if (el) el.textContent = msg;
  console.log('[ares-web]', msg);
}

// ---------------------------------------------------------------------------
// 9.  Boot sequence
// ---------------------------------------------------------------------------

window.aresWebInit = async function(emscriptenModule) {
  Module = emscriptenModule;

  setStatus('Initialising WebGPU…');
  gpuDevice = await initWebGPU();

  // Pass the device to Emscripten's WebGPU bridge BEFORE calling ares_init.
  // Emscripten's emscripten_webgpu_get_device() reads this property.
  if (gpuDevice) {
    Module.preinitializedWebGPUDevice = gpuDevice;
  }

  setStatus('Initialising emulator…');
  Module._ares_init();

  setupCanvas(640, 480);
  setupRomLoader();
  setupKeyboard();

  setStatus('Ready — drop a ROM file or click Load ROM');
};
