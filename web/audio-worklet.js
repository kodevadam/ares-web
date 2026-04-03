/**
 * web/audio-worklet.js
 *
 * AudioWorklet processor for ares N64 web build.
 *
 * Runs in the AudioWorkletGlobalScope (isolated thread).
 * Receives audio frames from the main thread via a MessagePort and
 * queues them in a local ring buffer for glitch-free playback.
 *
 * Protocol with bridge.js (main thread):
 *   bridge.js sends: { type: 'samples', left: Float32Array, right: Float32Array }
 *   This processor: enqueues and plays them in order.
 *
 * Buffer headroom: ~4 AudioWorklet quanta (4 × 128 = 512 samples ≈ 11ms at
 * 44.1 kHz).  Games producing audio faster than real-time will be rate-limited
 * by the output device.
 */

const RING_CAPACITY = 8192; // stereo frames

class AresAudioProcessor extends AudioWorkletProcessor {
  constructor() {
    super();

    this._ringL = new Float32Array(RING_CAPACITY);
    this._ringR = new Float32Array(RING_CAPACITY);
    this._writePos = 0;
    this._readPos  = 0;
    this._framesQueued = 0;

    // Receive sample batches from bridge.js.
    this.port.onmessage = (e) => {
      if (e.data.type === 'samples') {
        this._enqueue(e.data.left, e.data.right);
      }
    };
  }

  _enqueue(left, right) {
    const count = Math.min(left.length, RING_CAPACITY - 1);
    for (let i = 0; i < count; i++) {
      // Drop oldest if ring is full.
      const nextWrite = (this._writePos + 1) % RING_CAPACITY;
      if (nextWrite === this._readPos) {
        this._readPos = (this._readPos + 1) % RING_CAPACITY;
        if (this._framesQueued > 0) this._framesQueued--;
      }
      this._ringL[this._writePos] = left[i];
      this._ringR[this._writePos] = right[i];
      this._writePos = (this._writePos + 1) % RING_CAPACITY;
      this._framesQueued++;
    }
  }

  process(inputs, outputs) {
    const outL = outputs[0][0];
    const outR = outputs[0][1] || outputs[0][0]; // mono fallback
    const quantum = outL.length; // usually 128

    for (let i = 0; i < quantum; i++) {
      if (this._framesQueued > 0) {
        outL[i] = this._ringL[this._readPos];
        outR[i] = this._ringR[this._readPos];
        this._readPos = (this._readPos + 1) % RING_CAPACITY;
        this._framesQueued--;
      } else {
        // Underrun — output silence.
        outL[i] = 0;
        outR[i] = 0;
      }
    }

    // Report buffer health back to main thread occasionally.
    if (this._framesQueued % 1024 === 0) {
      this.port.postMessage({ type: 'status', queued: this._framesQueued });
    }

    return true; // Keep processor alive.
  }
}

registerProcessor('ares-audio-processor', AresAudioProcessor);
