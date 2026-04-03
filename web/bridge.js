/**
 * web/bridge.js
 *
 * JavaScript bridge between the ares N64 WASM module and browser Web APIs.
 * Covers Phase 3 (audio + main loop) and Phase 4 (PWA / touch controls).
 *
 * Responsibilities:
 *   1. WebGPU device initialisation.
 *   2. Canvas presentation (2D ImageData path; WebGPU blit in future).
 *   3. RequestAnimationFrame main loop with audio scheduling.
 *   4. AudioContext + AudioWorklet initialisation and per-frame audio push.
 *   5. ROM loading (file picker + drag-and-drop).
 *   6. Keyboard and Gamepad API input.
 *   7. Touch virtual-gamepad forwarding (see touch-controls.js).
 */

'use strict';

// ---------------------------------------------------------------------------
// Module-level state
// ---------------------------------------------------------------------------

let Module;            // Emscripten module (set in onRuntimeInitialized)
let gpuDevice = null;  // WGPUDevice (if WebGPU available)
let canvas;
let ctx2d;
let running = false;
let romLoaded = false;

// Audio
let audioCtx = null;
let audioWorkletNode = null;
let audioWorkletReady = false;
let audioNextTime = 0;   // scheduled play-head (Web Audio clock seconds)
const AUDIO_TARGET_LATENCY_S = 0.08;   // 80ms target buffer ahead of play-head

// Frame timing
let lastFrameTime = 0;
let frameCount = 0;
let fpsDisplay = null;

// ---------------------------------------------------------------------------
// 1. WebGPU Initialisation
// ---------------------------------------------------------------------------

async function initWebGPU() {
  if (!navigator.gpu) {
    console.info('[ares] WebGPU unavailable — software renderer active');
    return null;
  }
  const adapter = await navigator.gpu.requestAdapter({ powerPreference: 'high-performance' });
  if (!adapter) return null;

  const device = await adapter.requestDevice({
    requiredLimits: {
      maxStorageBufferBindingSize: 256 * 1024 * 1024,
      maxBufferSize:               256 * 1024 * 1024,
    },
  }).catch(() => null);

  if (!device) return null;

  device.lost.then((info) => {
    console.error('[ares] GPU device lost:', info.message);
    gpuDevice = null;
  });

  console.info('[ares] WebGPU device acquired');
  return device;
}

// ---------------------------------------------------------------------------
// 2. Canvas setup
// ---------------------------------------------------------------------------

function setupCanvas() {
  canvas = document.getElementById('ares-canvas');
  ctx2d  = canvas.getContext('2d');
}

// ---------------------------------------------------------------------------
// 3. Frame presentation
// ---------------------------------------------------------------------------

function presentFrame() {
  if (!Module) return;
  const ptr    = Module._ares_get_framebuffer();
  const width  = Module._ares_get_framebuffer_width();
  const height = Module._ares_get_framebuffer_height();
  if (!ptr || !width || !height) return;

  if (canvas.width !== width || canvas.height !== height) {
    canvas.width  = width;
    canvas.height = height;
  }

  const byteLen = width * height * 4;
  const pixels  = new Uint8ClampedArray(Module.HEAPU8.buffer, ptr, byteLen);
  ctx2d.putImageData(new ImageData(pixels, width, height), 0, 0);
}

// ---------------------------------------------------------------------------
// 4. Audio
// ---------------------------------------------------------------------------

async function initAudio() {
  // AudioContext requires a user gesture before it can start.
  // We create it here but resume it on first user interaction.
  audioCtx = new (window.AudioContext || window.webkitAudioContext)({
    sampleRate: 44100,
    latencyHint: 'interactive',
  });

  try {
    await audioCtx.audioWorklet.addModule('audio-worklet.js');
    audioWorkletNode = new AudioWorkletNode(audioCtx, 'ares-audio-processor', {
      outputChannelCount: [2],
    });
    audioWorkletNode.connect(audioCtx.destination);
    audioWorkletReady = true;
    console.info('[ares] AudioWorklet ready');
  } catch (e) {
    console.warn('[ares] AudioWorklet failed, audio disabled:', e);
  }

  // Resume AudioContext on first user interaction.
  const resumeAudio = () => {
    if (audioCtx.state === 'suspended') audioCtx.resume();
    document.removeEventListener('click',   resumeAudio);
    document.removeEventListener('keydown', resumeAudio);
    document.removeEventListener('touchstart', resumeAudio);
  };
  document.addEventListener('click',      resumeAudio, { once: true });
  document.addEventListener('keydown',    resumeAudio, { once: true });
  document.addEventListener('touchstart', resumeAudio, { once: true });
}

/**
 * Drain pending audio from the WASM ring buffer and push to AudioWorklet.
 * Called every frame from the main loop.
 */
function pushAudio() {
  if (!audioWorkletReady || !Module || !romLoaded) return;
  if (audioCtx.state !== 'running') return;

  // Temporary pointer-to-pointer trick: allocate 4 bytes, write address.
  const ptrPtr = Module._malloc(4);
  const framesAvail = Module._ares_get_audio_data(ptrPtr);
  const dataPtr = Module.getValue(ptrPtr, 'i32');
  Module._free(ptrPtr);

  if (framesAvail === 0 || !dataPtr) return;

  // Split interleaved f32 L/R into separate Float32Arrays for AudioWorklet.
  const interleaved = new Float32Array(Module.HEAPF32.buffer, dataPtr, framesAvail * 2);
  const left  = new Float32Array(framesAvail);
  const right = new Float32Array(framesAvail);
  for (let i = 0; i < framesAvail; i++) {
    left[i]  = interleaved[i * 2];
    right[i] = interleaved[i * 2 + 1];
  }

  audioWorkletNode.port.postMessage({ type: 'samples', left, right },
    [left.buffer, right.buffer]);

  Module._ares_consume_audio(framesAvail);
}

// ---------------------------------------------------------------------------
// 5. Main loop
// ---------------------------------------------------------------------------

function mainLoop(timestamp) {
  if (!running) return;

  // FPS counter.
  frameCount++;
  if (timestamp - lastFrameTime >= 1000) {
    const fps = Math.round(frameCount * 1000 / (timestamp - lastFrameTime));
    if (fpsDisplay) fpsDisplay.textContent = fps + ' fps';
    frameCount = 0;
    lastFrameTime = timestamp;
  }

  pollGamepad();

  if (romLoaded) {
    Module._ares_run_frame();
    presentFrame();
    pushAudio();
  }

  requestAnimationFrame(mainLoop);
}

// ---------------------------------------------------------------------------
// 6. ROM loading
// ---------------------------------------------------------------------------

async function loadRomFromArrayBuffer(buffer) {
  const data = new Uint8Array(buffer);
  const ptr  = Module._malloc(data.byteLength);
  if (!ptr) { setStatus('Out of memory'); return false; }
  Module.HEAPU8.set(data, ptr);
  const ok = Module._ares_load_rom(ptr, data.byteLength);
  Module._free(ptr);
  if (!ok) { setStatus('ROM load failed — unsupported format?'); return false; }

  romLoaded = true;
  document.getElementById('drop-overlay')?.classList.add('hidden');
  document.dispatchEvent(new Event('romLoaded'));
  setStatus('Running');

  // Resume audio now that we have a user gesture (file selection).
  if (audioCtx && audioCtx.state === 'suspended') await audioCtx.resume();

  if (!running) {
    running = true;
    lastFrameTime = performance.now();
    requestAnimationFrame(mainLoop);
  }
  return true;
}

function setupRomLoader() {
  const fileInput = document.getElementById('rom-input');
  fileInput?.addEventListener('change', (e) => {
    const file = e.target.files[0];
    if (!file) return;
    file.arrayBuffer().then(loadRomFromArrayBuffer);
    e.target.value = '';  // allow re-loading same file
  });

  const drop = document.getElementById('canvas-container') || document.body;
  drop.addEventListener('dragover', (e) => e.preventDefault());
  drop.addEventListener('drop', (e) => {
    e.preventDefault();
    const file = e.dataTransfer.files[0];
    if (file) file.arrayBuffer().then(loadRomFromArrayBuffer);
  });
}

// ---------------------------------------------------------------------------
// 7. Keyboard input
// ---------------------------------------------------------------------------

const KEY_MAP = {
  // D-pad
  'ArrowUp':    { type: 'btn', id: 0  },
  'ArrowDown':  { type: 'btn', id: 1  },
  'ArrowLeft':  { type: 'btn', id: 2  },
  'ArrowRight': { type: 'btn', id: 3  },
  // Face buttons
  'KeyX':       { type: 'btn', id: 4  },  // B
  'KeyZ':       { type: 'btn', id: 5  },  // A
  // C buttons
  'KeyI':       { type: 'btn', id: 6  },  // C-Up
  'KeyK':       { type: 'btn', id: 7  },  // C-Down
  'KeyJ':       { type: 'btn', id: 8  },  // C-Left
  'KeyL':       { type: 'btn', id: 9  },  // C-Right
  // Shoulders
  'ShiftLeft':  { type: 'btn', id: 10 },  // L
  'ShiftRight': { type: 'btn', id: 11 },  // R
  'KeyA':       { type: 'btn', id: 12 },  // Z trigger
  'Enter':      { type: 'btn', id: 13 },  // Start
  // Analog stick (WASD)
  'KeyW':       { type: 'axis', axis: 1, value: -32767 },
  'KeyS':       { type: 'axis', axis: 1, value:  32767 },
  'KeyD':       { type: 'axis', axis: 0, value:  32767 },
  'KeyQ':       { type: 'axis', axis: 0, value: -32767 },
};

// Track which axis keys are currently held.
const axisHeld = { 0: 0, 1: 0 };

function setupKeyboard() {
  document.addEventListener('keydown', (e) => {
    if (!Module || e.repeat) return;
    const m = KEY_MAP[e.code];
    if (!m) return;
    if (m.type === 'btn') {
      Module._ares_set_button(0, m.id, 1);
    } else {
      axisHeld[m.axis] = m.value;
      Module._ares_set_axis(0, m.axis, m.value);
    }
  });
  document.addEventListener('keyup', (e) => {
    if (!Module) return;
    const m = KEY_MAP[e.code];
    if (!m) return;
    if (m.type === 'btn') {
      Module._ares_set_button(0, m.id, 0);
    } else {
      axisHeld[m.axis] = 0;
      Module._ares_set_axis(0, m.axis, 0);
    }
  });
}

// ---------------------------------------------------------------------------
// 8. Gamepad API
// ---------------------------------------------------------------------------

// Standard Gamepad mapping → N64 button IDs
const GP_BTN = [5,4,8,9, 10,11,-1,12, 13,13,-1,-1, 0,1,2,3];
const gpPrevBtn = {};
const gpPrevAxis = {};

function pollGamepad() {
  if (!Module || !romLoaded) return;
  const pads = navigator.getGamepads?.() ?? [];
  for (let pi = 0; pi < Math.min(pads.length, 4); pi++) {
    const pad = pads[pi];
    if (!pad) continue;
    if (!gpPrevBtn[pi])  gpPrevBtn[pi]  = {};
    if (!gpPrevAxis[pi]) gpPrevAxis[pi] = {};
    const pb = gpPrevBtn[pi], pa = gpPrevAxis[pi];

    for (let bi = 0; bi < Math.min(pad.buttons.length, GP_BTN.length); bi++) {
      const n64 = GP_BTN[bi];
      if (n64 < 0) continue;
      const v = pad.buttons[bi].pressed ? 1 : 0;
      if (v !== (pb[bi] ?? 0)) { Module._ares_set_button(pi, n64, v); pb[bi] = v; }
    }

    // Left stick → analog
    const ax = Math.round((pad.axes[0] ?? 0) * 32767);
    const ay = Math.round((pad.axes[1] ?? 0) * 32767);
    if (ax !== (pa[0] ?? 0)) { Module._ares_set_axis(pi, 0, ax); pa[0] = ax; }
    if (ay !== (pa[1] ?? 0)) { Module._ares_set_axis(pi, 1, ay); pa[1] = ay; }

    // Right stick → C-buttons (threshold 0.5)
    const cx = pad.axes[2] ?? 0, cy = pad.axes[3] ?? 0;
    const cLeft  = cx < -0.5 ? 1 : 0, cRight = cx >  0.5 ? 1 : 0;
    const cUp    = cy < -0.5 ? 1 : 0, cDown  = cy >  0.5 ? 1 : 0;
    if (cLeft  !== (pa.cLeft  ?? 0)) { Module._ares_set_button(pi, 8, cLeft);  pa.cLeft  = cLeft; }
    if (cRight !== (pa.cRight ?? 0)) { Module._ares_set_button(pi, 9, cRight); pa.cRight = cRight; }
    if (cUp    !== (pa.cUp    ?? 0)) { Module._ares_set_button(pi, 6, cUp);    pa.cUp    = cUp; }
    if (cDown  !== (pa.cDown  ?? 0)) { Module._ares_set_button(pi, 7, cDown);  pa.cDown  = cDown; }
  }
}

// ---------------------------------------------------------------------------
// 9. Status helpers
// ---------------------------------------------------------------------------

function setStatus(msg) {
  const el = document.getElementById('status');
  if (el) el.textContent = msg;
}

// ---------------------------------------------------------------------------
// 10. Boot sequence (called from Module.onRuntimeInitialized)
// ---------------------------------------------------------------------------

window.aresWebInit = async function(emscriptenModule) {
  Module = emscriptenModule;
  fpsDisplay = document.getElementById('fps');

  setStatus('Requesting GPU…');
  gpuDevice = await initWebGPU();
  if (gpuDevice) Module.preinitializedWebGPUDevice = gpuDevice;

  setStatus('Starting emulator…');
  Module._ares_init();

  setupCanvas();
  setupRomLoader();
  setupKeyboard();

  setStatus('Initialising audio…');
  await initAudio();

  // Expose reset helper globally for the HTML buttons.
  window.resetEmulator = () => Module._ares_reset?.();

  setStatus('Ready — drop a ROM or click Load ROM');
};
