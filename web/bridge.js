/**
 * web/bridge.js
 *
 * Main-thread JavaScript bridge for ares N64.
 * Runs in the browser window.  All WASM emulation lives in emu-worker.js.
 *
 * Responsibilities:
 *   1. Spawn and communicate with the emulation Worker.
 *   2. WebGPU device initialisation (forwarded to Worker for future use).
 *   3. RAF loop: collect input, send to Worker; receive frames, paint canvas.
 *   4. AudioContext + AudioWorklet: receive audio from Worker, schedule playback.
 *   5. ROM loading (file picker + drag-and-drop) → transfer to Worker.
 *   6. Keyboard and Gamepad API input state accumulation.
 *   7. Expose a thin Module proxy so touch-controls.js can call set_button/axis.
 */

'use strict';

// ---------------------------------------------------------------------------
// Module-level state
// ---------------------------------------------------------------------------

let worker      = null;   // Web Worker running emu-worker.js
let workerReady = false;  // true after Worker posts 'ready'
let romLoaded   = false;
let running     = false;

let canvas, ctx2d;

// Audio
let audioCtx           = null;
let audioWorkletNode   = null;
let audioWorkletReady  = false;

// FPS
let lastFrameTime = 0;
let frameCount    = 0;
let fpsDisplay    = null;

// Input state accumulated on the main thread each RAF tick.
// Sent to the Worker with every 'frame' request.
const inputState = {
  buttons: new Int32Array(4),  // bitmask of 14 N64 buttons per port
  axisX:   new Int32Array(4),
  axisY:   new Int32Array(4),
};

// Thin proxy so touch-controls.js (and the remote-api auto-connect check)
// can call Module._ares_set_button() / Module._ares_set_axis() without
// knowing about the Worker architecture.
const Module = {
  _ares_set_button: (port, btn, value) => {
    if (port < 0 || port > 3) return;
    if (value) inputState.buttons[port] |=  (1 << btn);
    else        inputState.buttons[port] &= ~(1 << btn);
  },
  _ares_set_axis: (port, axis, value) => {
    if (port < 0 || port > 3) return;
    if (axis === 0) inputState.axisX[port] = value | 0;
    else             inputState.axisY[port] = value | 0;
  },
};
// Make it globally visible (touch-controls.js reads window.Module).
window.Module = Module;

// ---------------------------------------------------------------------------
// 1. WebGPU Initialisation (kept for future worker-side use)
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
  device.lost.then(info => {
    console.error('[ares] GPU device lost:', info.message);
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
// 3. Audio
// ---------------------------------------------------------------------------

async function initAudio() {
  audioCtx = new (window.AudioContext || window.webkitAudioContext)({
    sampleRate:  44100,
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
    console.warn('[ares] AudioWorklet unavailable:', e);
  }

  const resume = () => {
    if (audioCtx.state === 'suspended') audioCtx.resume();
  };
  document.addEventListener('click',     resume, { once: true });
  document.addEventListener('keydown',   resume, { once: true });
  document.addEventListener('touchstart',resume, { once: true });
}

/**
 * Forward audio data (left/right Float32Arrays transferred from Worker)
 * to the AudioWorklet.  Called each time a 'frame' message arrives.
 */
function pushAudio(audioLeft, audioRight) {
  if (!audioWorkletReady || !audioLeft || !audioRight) return;
  if (audioCtx.state !== 'running') return;
  // Buffers are already transferred — zero-copy forward to AudioWorklet.
  audioWorkletNode.port.postMessage(
    { type: 'samples', left: audioLeft, right: audioRight },
    [audioLeft.buffer, audioRight.buffer],
  );
}

// ---------------------------------------------------------------------------
// 4. Worker setup & message handling
// ---------------------------------------------------------------------------

function spawnWorker() {
  worker = new Worker('emu-worker.js');

  worker.onmessage = (e) => {
    const msg = e.data;
    switch (msg.type) {

      case 'ready':
        workerReady = true;
        setStatus('Ready — drop a ROM or click Load ROM');
        console.info('[ares] Emulation Worker ready');
        break;

      case 'romLoaded':
        if (msg.ok) {
          romLoaded = true;
          document.getElementById('drop-overlay')?.classList.add('hidden');
          document.dispatchEvent(new Event('romLoaded'));
          setStatus('Running');
          if (audioCtx?.state === 'suspended') audioCtx.resume();
        } else {
          setStatus('ROM load failed — unsupported or corrupt?');
        }
        break;

      case 'frame': {
        // ── Video ──
        if (msg.pixels && msg.width && msg.height) {
          const w = msg.width, h = msg.height;
          if (canvas.width !== w || canvas.height !== h) {
            canvas.width = w; canvas.height = h;
          }
          const imageData = new ImageData(
            new Uint8ClampedArray(msg.pixels), w, h);
          ctx2d.putImageData(imageData, 0, 0);
        }

        // ── Audio ──
        pushAudio(msg.audioLeft, msg.audioRight);

        // ── FPS counter ──
        frameCount++;
        const now = performance.now();
        if (now - lastFrameTime >= 1000) {
          const fps = Math.round(frameCount * 1000 / (now - lastFrameTime));
          if (fpsDisplay) fpsDisplay.textContent = fps + ' fps';
          frameCount    = 0;
          lastFrameTime = now;
        }
        break;
      }

      case 'status':
        setStatus(msg.msg);
        break;

      case 'abort':
        setStatus('Emulator crash: ' + msg.error);
        document.getElementById('drop-overlay')?.classList.remove('hidden');
        workerReady = false;
        romLoaded   = false;
        running     = false;
        break;

      case 'error':
        console.error('[emu-worker]', msg.error);
        setStatus('Worker error — see console');
        break;
    }
  };

  worker.onerror = (e) => {
    console.error('[emu-worker] uncaught error:', e);
    setStatus('Worker crashed — see console');
  };
}

// ---------------------------------------------------------------------------
// 5. RAF loop  (input collection only — Worker drives the emulation clock)
// ---------------------------------------------------------------------------

function rafLoop(timestamp) {
  if (!running) return;

  // Poll gamepads every RAF tick and merge into inputState.
  pollGamepad();

  // Send the latest input snapshot to the Worker.
  // The Worker reads this before each ares_run_frame() call.
  if (workerReady && romLoaded) {
    worker.postMessage({
      type:    'input',
      buttons: Array.from(inputState.buttons),
      axisX:   Array.from(inputState.axisX),
      axisY:   Array.from(inputState.axisY),
    });
  }

  requestAnimationFrame(rafLoop);
}

// ---------------------------------------------------------------------------
// 6. ROM loading
// ---------------------------------------------------------------------------

async function loadRomFromArrayBuffer(buffer) {
  if (!workerReady) { setStatus('Worker not ready yet'); return false; }
  setStatus('Loading ROM…');
  // Transfer the buffer to the Worker (zero-copy).
  worker.postMessage({ type: 'loadRom', romData: buffer }, [buffer]);
  if (!running) {
    running = true;
    lastFrameTime = performance.now();
    requestAnimationFrame(rafLoop);
  }
  return true;
}

function setupRomLoader() {
  const fileInput = document.getElementById('rom-input');
  fileInput?.addEventListener('change', (e) => {
    const file = e.target.files[0];
    if (!file) return;
    file.arrayBuffer().then(loadRomFromArrayBuffer);
    e.target.value = '';
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
  'ArrowUp':    { type: 'btn', id: 0  },   // D-up
  'ArrowDown':  { type: 'btn', id: 1  },   // D-down
  'ArrowLeft':  { type: 'btn', id: 2  },   // D-left
  'ArrowRight': { type: 'btn', id: 3  },   // D-right
  'KeyX':       { type: 'btn', id: 4  },   // B
  'KeyZ':       { type: 'btn', id: 5  },   // A
  'KeyI':       { type: 'btn', id: 6  },   // C-Up
  'KeyK':       { type: 'btn', id: 7  },   // C-Down
  'KeyJ':       { type: 'btn', id: 8  },   // C-Left
  'KeyL':       { type: 'btn', id: 9  },   // C-Right
  'ShiftLeft':  { type: 'btn', id: 10 },   // L
  'ShiftRight': { type: 'btn', id: 11 },   // R
  'KeyA':       { type: 'btn', id: 12 },   // Z trigger
  'Enter':      { type: 'btn', id: 13 },   // Start
  'KeyW':       { type: 'axis', axis: 1, value: -32767 },
  'KeyS':       { type: 'axis', axis: 1, value:  32767 },
  'KeyD':       { type: 'axis', axis: 0, value:  32767 },
  'KeyQ':       { type: 'axis', axis: 0, value: -32767 },
};

function setupKeyboard() {
  document.addEventListener('keydown', (e) => {
    if (e.repeat) return;
    const m = KEY_MAP[e.code];
    if (!m) return;
    Module._ares_set_button && m.type === 'btn'
      ? Module._ares_set_button(0, m.id, 1)
      : Module._ares_set_axis(0, m.axis, m.value);
  });
  document.addEventListener('keyup', (e) => {
    const m = KEY_MAP[e.code];
    if (!m) return;
    m.type === 'btn'
      ? Module._ares_set_button(0, m.id, 0)
      : Module._ares_set_axis(0, m.axis, 0);
  });
}

// ---------------------------------------------------------------------------
// 8. Gamepad API
// ---------------------------------------------------------------------------

// Standard Gamepad layout button index → N64 button ID (-1 = unused)
const GP_BTN = [5,4,8,9, 10,11,-1,12, 13,13,-1,-1, 0,1,2,3];
const gpPrevBtn  = {};
const gpPrevAxis = {};

function pollGamepad() {
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

    const ax = Math.round((pad.axes[0] ?? 0) * 32767);
    const ay = Math.round((pad.axes[1] ?? 0) * 32767);
    if (ax !== (pa[0] ?? 0)) { Module._ares_set_axis(pi, 0, ax); pa[0] = ax; }
    if (ay !== (pa[1] ?? 0)) { Module._ares_set_axis(pi, 1, ay); pa[1] = ay; }

    // Right stick → C-buttons
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
// 9. Helpers
// ---------------------------------------------------------------------------

function setStatus(msg) {
  const el = document.getElementById('status');
  if (el) el.textContent = msg;
}

// ---------------------------------------------------------------------------
// 10. Boot sequence
// ---------------------------------------------------------------------------

window.aresWebInit = async function() {
  fpsDisplay = document.getElementById('fps');

  setupCanvas();

  setStatus('Initialising GPU…');
  await initWebGPU();  // probes adapter for future worker-side use

  setStatus('Starting emulation worker…');
  spawnWorker();

  setupRomLoader();
  setupKeyboard();

  setStatus('Initialising audio…');
  await initAudio();

  // Expose helpers to the HTML buttons.
  window.resetEmulator = () => worker?.postMessage({ type: 'reset' });

  // Provide the Module proxy to TouchControls (loaded after bridge.js).
  // TouchControls.init() is called from index.html after DOMContentLoaded.

  setStatus('Loading emulator…');
  // Status is updated to 'Ready' when the Worker posts its 'ready' message.
};

// Auto-boot once the DOM is ready.
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => window.aresWebInit());
} else {
  window.aresWebInit();
}
