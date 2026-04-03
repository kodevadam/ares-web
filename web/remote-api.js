/**
 * web/remote-api.js — Browser-side Remote Testing API
 *
 * Connects to a WebSocket server (remote-relay.js or any WS endpoint) and
 * exposes a command interface for automated N64 game testing.
 *
 * Usage (from the page or a browser extension):
 *
 *   const api = new AresRemoteAPI('ws://localhost:9001');
 *   api.connect();
 *
 * Or auto-connect if the URL hash is set:
 *   index.html#remote=ws://localhost:9001
 *
 * Wire protocol (JSON over WebSocket, newline-delimited):
 *
 *   → { id, cmd, ...args }
 *   ← { id, ok, result?, error? }
 *
 * Supported commands:
 *
 *   load_rom          { data: base64 }      → { ok }
 *   run_frame         {}                    → { frame_number, hash }
 *   advance_frames    { count }             → { frame_number }
 *   screenshot        {}                    → { width, height, data: base64 }
 *   set_button        { port, button, value }→ { ok }
 *   set_axis          { port, axis, value }  → { ok }
 *   reset             {}                    → { ok }
 *   get_status        {}                    → { loaded, frame, hash, fps }
 *   get_audio         {}                    → { sample_rate, frames, data: base64 }
 */

'use strict';

class AresRemoteAPI {
  constructor(wsUrl) {
    this._url    = wsUrl;
    this._ws     = null;
    this._Module = null;  // set after Module is ready
    this._reconnectDelay = 2000;
    this._pendingFps = [];
    this._lastFpsTime = performance.now();
    this._frameCount = 0;
  }

  connect() {
    console.info('[remote-api] Connecting to', this._url);
    this._ws = new WebSocket(this._url);

    this._ws.onopen  = () => { console.info('[remote-api] Connected'); };
    this._ws.onclose = () => {
      console.info('[remote-api] Disconnected — retrying in', this._reconnectDelay, 'ms');
      setTimeout(() => this.connect(), this._reconnectDelay);
    };
    this._ws.onerror = (e) => { console.warn('[remote-api] WS error', e); };
    this._ws.onmessage = (e) => {
      let msg;
      try { msg = JSON.parse(e.data); } catch { return; }
      this._handleCommand(msg);
    };
  }

  setModule(m) { this._Module = m; }

  _send(obj) {
    if (this._ws && this._ws.readyState === WebSocket.OPEN) {
      this._ws.send(JSON.stringify(obj));
    }
  }

  _reply(id, result, error) {
    this._send({ id, ok: !error, result: result ?? null, error: error ?? null });
  }

  async _handleCommand(msg) {
    const { id, cmd } = msg;
    const M = this._Module;
    if (!M) { this._reply(id, null, 'Module not ready'); return; }

    try {
      switch (cmd) {

        case 'get_status': {
          const loaded = !!M._ares_is_running?.();
          const frame  = M._ares_get_frame_number?.() ?? 0;
          const hash   = loaded ? (M._ares_get_frame_hash?.() ?? 0) >>> 0 : 0;
          this._reply(id, { loaded, frame, hash: hash.toString(16), fps: this._currentFps() });
          break;
        }

        case 'load_rom': {
          const bytes = Uint8Array.from(atob(msg.data), c => c.charCodeAt(0));
          const ptr   = M._malloc(bytes.byteLength);
          M.HEAPU8.set(bytes, ptr);
          const ok = M._ares_load_rom(ptr, bytes.byteLength);
          M._free(ptr);
          this._reply(id, { ok: !!ok }, ok ? null : 'ROM load failed');
          break;
        }

        case 'run_frame': {
          M._ares_run_frame();
          this._frameCount++;
          const frame = M._ares_get_frame_number?.() ?? 0;
          const hash  = (M._ares_get_frame_hash?.() ?? 0) >>> 0;
          this._reply(id, { frame_number: frame, hash: hash.toString(16) });
          break;
        }

        case 'advance_frames': {
          const count = Math.max(1, Math.min(msg.count ?? 1, 3600));
          M._ares_advance_frames(count, 0);
          this._frameCount += count;
          this._reply(id, { frame_number: M._ares_get_frame_number?.() ?? 0 });
          break;
        }

        case 'screenshot': {
          const ptr    = M._ares_get_framebuffer?.();
          const width  = M._ares_get_framebuffer_width?.()  ?? 0;
          const height = M._ares_get_framebuffer_height?.() ?? 0;
          if (!ptr || !width || !height) {
            this._reply(id, null, 'No framebuffer');
            break;
          }
          // Convert RGBA → PNG via OffscreenCanvas.
          const bytes = new Uint8ClampedArray(M.HEAPU8.buffer, ptr, width * height * 4);
          const imgData = new ImageData(bytes, width, height);
          const oc = new OffscreenCanvas(width, height);
          const ctx = oc.getContext('2d');
          ctx.putImageData(imgData, 0, 0);
          const blob = await oc.convertToBlob({ type: 'image/png' });
          const ab   = await blob.arrayBuffer();
          const b64  = btoa(String.fromCharCode(...new Uint8Array(ab)));
          this._reply(id, { width, height, data: b64, format: 'png' });
          break;
        }

        case 'set_button': {
          M._ares_set_button(msg.port ?? 0, msg.button, msg.value ? 1 : 0);
          this._reply(id, { ok: true });
          break;
        }

        case 'set_axis': {
          M._ares_set_axis(msg.port ?? 0, msg.axis, msg.value ?? 0);
          this._reply(id, { ok: true });
          break;
        }

        case 'reset': {
          M._ares_reset?.();
          this._reply(id, { ok: true });
          break;
        }

        case 'get_audio': {
          const ptrPtr = M._malloc(4);
          const frames = M._ares_get_audio_data(ptrPtr);
          const dataPtr = M.getValue(ptrPtr, 'i32');
          M._free(ptrPtr);
          if (!frames || !dataPtr) { this._reply(id, { sample_rate: 44100, frames: 0, data: '' }); break; }
          const rawF32 = new Float32Array(M.HEAPF32.buffer, dataPtr, frames * 2);
          // Convert f32 → i16 PCM for compact transfer.
          const pcm = new Int16Array(frames * 2);
          for (let i = 0; i < frames * 2; i++) pcm[i] = Math.round(rawF32[i] * 32767);
          M._ares_consume_audio(frames);
          const b64 = btoa(String.fromCharCode(...new Uint8Array(pcm.buffer)));
          this._reply(id, { sample_rate: M._ares_get_audio_sample_rate?.() ?? 44100, frames, data: b64 });
          break;
        }

        default:
          this._reply(id, null, `Unknown command: ${cmd}`);
      }
    } catch (err) {
      this._reply(id, null, String(err));
    }
  }

  _currentFps() {
    const now = performance.now();
    const elapsed = now - this._lastFpsTime;
    if (elapsed >= 1000) {
      this._lastFpsValue = Math.round(this._frameCount * 1000 / elapsed);
      this._frameCount = 0;
      this._lastFpsTime = now;
    }
    return this._lastFpsValue ?? 0;
  }
}

// ---------------------------------------------------------------------------
// Auto-connect if URL hash contains remote=ws://...
// ---------------------------------------------------------------------------

(function autoConnect() {
  const hash = new URLSearchParams(location.hash.slice(1));
  const wsUrl = hash.get('remote');
  if (!wsUrl) return;

  // Wait for Module to be ready.
  const check = setInterval(() => {
    if (typeof Module !== 'undefined' && Module._ares_is_running) {
      clearInterval(check);
      const api = new AresRemoteAPI(wsUrl);
      api.setModule(Module);
      api.connect();
      window._aresRemoteAPI = api;
      console.info('[remote-api] Auto-connected to', wsUrl);
    }
  }, 200);
})();
