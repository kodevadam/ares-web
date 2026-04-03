/*
 * web/main-web.cpp
 *
 * WASM entry point for ares N64 web build (Phase 1).
 *
 * Exported functions (callable from JS via ccall/cwrap):
 *
 *   int  ares_init()
 *     Initialise the platform and ares scheduler.  Returns 1 on success.
 *
 *   int  ares_load_rom(const uint8_t* data, uint32_t size)
 *     Load an N64 ROM from a caller-owned buffer.
 *     Performs byte-order detection (z64/n64/v64) and byteswap if needed.
 *     Returns 1 on success, 0 on failure.
 *
 *   void ares_run_frame()
 *     Run the emulator for one video frame.
 *
 *   void ares_reset()
 *     Soft-reset the N64.
 *
 *   const uint32_t* ares_get_framebuffer()
 *     Return a pointer to the latest RGBA8888 framebuffer, or NULL.
 *
 *   uint32_t ares_get_framebuffer_width()
 *   uint32_t ares_get_framebuffer_height()
 *     Current framebuffer dimensions (may change per-frame).
 *
 *   void ares_set_button(uint32_t port, uint32_t button, int value)
 *     Set a digital button state.  port: 0-3.  button: see ButtonID enum.
 *
 *   void ares_set_axis(uint32_t port, uint32_t axis, int32_t value)
 *     Set an analog axis.  axis: 0=X, 1=Y.  value: [-32767, +32767].
 */

#include <emscripten/emscripten.h>
#include <stdio.h>
#include <string.h>
#include <vector>

#include "platform-web.hpp"

#include <ares/ares.hpp>
#include <n64/n64.hpp>
#include <mia/mia.hpp>

// ---------------------------------------------------------------------------
// Button ID constants (must match the values used by JS)
// ---------------------------------------------------------------------------

enum ButtonID : u32 {
  BTN_UP      = 0,
  BTN_DOWN    = 1,
  BTN_LEFT    = 2,
  BTN_RIGHT   = 3,
  BTN_B       = 4,
  BTN_A       = 5,
  BTN_C_UP    = 6,
  BTN_C_DOWN  = 7,
  BTN_C_LEFT  = 8,
  BTN_C_RIGHT = 9,
  BTN_L       = 10,
  BTN_R       = 11,
  BTN_Z       = 12,
  BTN_START   = 13,
};

// ---------------------------------------------------------------------------
// Module-level state
// ---------------------------------------------------------------------------

static WebPlatform*    s_platform = nullptr;
static ares::Node::System s_root;
static bool            s_loaded   = false;

// ROM buffer held alive for the session (mia pak holds a view into it).
static std::vector<u8> s_romBuffer;

// ---------------------------------------------------------------------------
// Internal helpers
// ---------------------------------------------------------------------------

// Detect and normalise the ROM byte order to big-endian (z64).
static void normaliseROM(std::vector<u8>& rom) {
  if(rom.size() < 4) return;

  u32 magic = ((u32)rom[0] << 24) | ((u32)rom[1] << 16)
            | ((u32)rom[2] <<  8) | ((u32)rom[3]);

  if(magic == 0x80371240) {
    // Already z64 (big-endian). Nothing to do.
  } else if(magic == 0x37804012) {
    // v64 (byte-swapped within each 16-bit word).
    for(u32 i = 0; i + 1 < rom.size(); i += 2) {
      u8 t = rom[i]; rom[i] = rom[i+1]; rom[i+1] = t;
    }
  } else if(magic == 0x40123780) {
    // n64 (little-endian 32-bit).
    for(u32 i = 0; i + 3 < rom.size(); i += 4) {
      u8 b0 = rom[i+0], b1 = rom[i+1], b2 = rom[i+2], b3 = rom[i+3];
      rom[i+0] = b3; rom[i+1] = b2; rom[i+2] = b1; rom[i+3] = b0;
    }
  }
  // else: unknown header — pass through and let mia/CIC deal with it.
}

// ---------------------------------------------------------------------------
// Exported functions
// ---------------------------------------------------------------------------

extern "C" {

EMSCRIPTEN_KEEPALIVE
int ares_init() {
  if(s_platform) return 1; // Already initialised.

  s_platform = new WebPlatform();
  return 1;
}

EMSCRIPTEN_KEEPALIVE
int ares_load_rom(const u8* data, u32 size) {
  if(!s_platform) return 0;
  if(!data || size < 0x1000) return 0;

  // Unload any existing session.
  if(s_loaded) {
    ares::Nintendo64::option("Enable GPU acceleration", false);
    s_root = {};
    s_loaded = false;
    s_platform->systemPak.reset();
    s_platform->cartridgePak.reset();
  }

  // Copy ROM and normalise byte order.
  s_romBuffer.assign(data, data + size);
  normaliseROM(s_romBuffer);

  // -----------------------------------------------------------------------
  // Build system pak using mia (contains embedded PIF ROMs).
  // -----------------------------------------------------------------------
  auto systemMedium = mia::System::create("Nintendo 64");
  if(!systemMedium) return 0;
  // System::load() appends embedded PIF ROMs; the filesystem directory
  // creation it also does will go into Emscripten MEMFS silently.
  if(systemMedium->load() != LoadResult(successful)) return 0;
  s_platform->systemPak = systemMedium->pak;

  // -----------------------------------------------------------------------
  // Build cartridge pak using mia.
  // mia's Nintendo64::load() needs a file path.  We write the ROM into the
  // Emscripten virtual filesystem so mia can read it back.
  // -----------------------------------------------------------------------
  {
    FILE* f = fopen("/tmp/rom.z64", "wb");
    if(!f) return 0;
    fwrite(s_romBuffer.data(), 1, s_romBuffer.size(), f);
    fclose(f);
  }

  auto cartMedium = mia::Medium::create("Nintendo 64");
  if(!cartMedium) return 0;
  if(cartMedium->load("/tmp/rom.z64") != LoadResult(successful)) return 0;
  s_platform->cartridgePak = cartMedium->pak;

  // -----------------------------------------------------------------------
  // Determine region from pak attributes.
  // -----------------------------------------------------------------------
  string region = "NTSC";
  if(s_platform->cartridgePak) {
    auto r = s_platform->cartridgePak->attribute("region");
    if(r == "PAL") region = "PAL";
  }

  // -----------------------------------------------------------------------
  // Configure N64 options (no Vulkan/GPU in web build).
  // -----------------------------------------------------------------------
  ares::Nintendo64::option("Enable GPU acceleration", false);
  ares::Nintendo64::option("Homebrew Mode", false);
  ares::Nintendo64::option("Recompiler", false); // interpreter-only

  // -----------------------------------------------------------------------
  // Load the N64 core into the ares scheduler.
  // -----------------------------------------------------------------------
  if(!ares::Nintendo64::load(s_root, {"[Nintendo] Nintendo 64 (", region, ")"})) {
    return 0;
  }

  // Connect cartridge.
  if(auto port = s_root->find<ares::Node::Port>("Cartridge Slot")) {
    port->allocate();
    port->connect();
  }

  // Connect a standard gamepad to port 1.
  for(auto id : range(4)) {
    if(auto port = s_root->find<ares::Node::Port>({"Controller Port ", 1 + id})) {
      port->allocate("Gamepad");
      port->connect();
    }
  }

  // Power on.
  if(auto power = s_root->find<ares::Node::Setting::Boolean>("Power")) {
    power->setValue(true);
  }

  s_loaded = true;
  s_platform->shutdownRequested = false;
  return 1;
}

EMSCRIPTEN_KEEPALIVE
void ares_run_frame() {
  if(!s_loaded || !s_root) return;
  if(s_platform && s_platform->shutdownRequested) return;

  // Run one video frame.  Node::System::run() calls the registered callback
  // System::run() → CPU::main(), which loops until vi.refreshed is set.
  // The N64 core uses direct-call scheduling (not libco coroutines), so this
  // is a simple blocking call that returns after one frame.
  s_root->run();
  s_frameCount++;
}

EMSCRIPTEN_KEEPALIVE
void ares_reset() {
  if(!s_loaded || !s_root) return;
  // Soft-reset: power(true) means reset without re-initialising hardware state.
  if(auto reset = s_root->find<ares::Node::Setting::Boolean>("Reset")) {
    reset->setValue(true);
  }
}

EMSCRIPTEN_KEEPALIVE
const u32* ares_get_framebuffer() {
  if(!s_platform || s_platform->framebuffer.empty()) return nullptr;
  return s_platform->framebuffer.data();
}

EMSCRIPTEN_KEEPALIVE
u32 ares_get_framebuffer_width() {
  return s_platform ? s_platform->framebufferWidth : 0;
}

EMSCRIPTEN_KEEPALIVE
u32 ares_get_framebuffer_height() {
  return s_platform ? s_platform->framebufferHeight : 0;
}

EMSCRIPTEN_KEEPALIVE
void ares_set_button(u32 port, u32 button, int value) {
  if(!s_platform || port >= 4) return;
  auto& state = s_platform->inputState[port];
  bool v = value != 0;
  switch((ButtonID)button) {
  case BTN_UP:      state.up      = v; break;
  case BTN_DOWN:    state.down    = v; break;
  case BTN_LEFT:    state.left    = v; break;
  case BTN_RIGHT:   state.right   = v; break;
  case BTN_B:       state.b       = v; break;
  case BTN_A:       state.a       = v; break;
  case BTN_C_UP:    state.cUp     = v; break;
  case BTN_C_DOWN:  state.cDown   = v; break;
  case BTN_C_LEFT:  state.cLeft   = v; break;
  case BTN_C_RIGHT: state.cRight  = v; break;
  case BTN_L:       state.l       = v; break;
  case BTN_R:       state.r       = v; break;
  case BTN_Z:       state.z       = v; break;
  case BTN_START:   state.start   = v; break;
  }
}

EMSCRIPTEN_KEEPALIVE
void ares_set_axis(u32 port, u32 axis, s32 value) {
  if(!s_platform || port >= 4) return;
  auto& state = s_platform->inputState[port];
  // Clamp to s16 range.
  s16 v = (s16)(value < -32767 ? -32767 : value > 32767 ? 32767 : value);
  if(axis == 0) state.axisX = v;
  if(axis == 1) state.axisY = v;
}

// ---------------------------------------------------------------------------
// Audio API
// ---------------------------------------------------------------------------

// Returns sample rate (Hz) of the active audio stream.
EMSCRIPTEN_KEEPALIVE
u32 ares_get_audio_sample_rate() {
  if(!s_platform) return 44100;
  return s_platform->audioSampleRate;
}

// Fills *out_ptr with a pointer to pending stereo f32 samples (interleaved L/R)
// and *out_frames with the number of stereo frames available.
// The pointer is valid until the next call to ares_consume_audio() or
// ares_run_frame().  Returns 0 if no audio is loaded.
EMSCRIPTEN_KEEPALIVE
u32 ares_get_audio_data(const f32** out_ptr) {
  if(!s_platform || !out_ptr) return 0;
  auto& p = *s_platform;

  u32 avail;
  if(p.audioWritePos >= p.audioReadPos)
    avail = p.audioWritePos - p.audioReadPos;
  else
    avail = WebPlatform::AUDIO_RING_FRAMES - p.audioReadPos + p.audioWritePos;

  if(avail == 0) { *out_ptr = nullptr; return 0; }

  // Flatten ring into contiguous staging buffer.
  p.audioStageBuf.resize(avail * 2);
  for(u32 i = 0; i < avail; i++) {
    u32 idx = (p.audioReadPos + i) % WebPlatform::AUDIO_RING_FRAMES;
    p.audioStageBuf[i * 2 + 0] = p.audioRing[idx * 2 + 0];
    p.audioStageBuf[i * 2 + 1] = p.audioRing[idx * 2 + 1];
  }

  *out_ptr = p.audioStageBuf.data();
  return avail;
}

// Marks the first `frames` stereo frames as consumed, advancing the read pointer.
EMSCRIPTEN_KEEPALIVE
void ares_consume_audio(u32 frames) {
  if(!s_platform) return;
  auto& p = *s_platform;
  u32 avail;
  if(p.audioWritePos >= p.audioReadPos)
    avail = p.audioWritePos - p.audioReadPos;
  else
    avail = WebPlatform::AUDIO_RING_FRAMES - p.audioReadPos + p.audioWritePos;
  if(frames > avail) frames = avail;
  p.audioReadPos = (p.audioReadPos + frames) % WebPlatform::AUDIO_RING_FRAMES;
}

// ---------------------------------------------------------------------------
// Remote Testing API (Phase 5)
// ---------------------------------------------------------------------------

static u32 s_frameCount = 0;

EMSCRIPTEN_KEEPALIVE
u32 ares_get_frame_number() {
  return s_frameCount;
}

// Run N frames, optionally setting button state for each.
// inputs: pointer to N*4 bytes: [port0_buttons_lo, port0_buttons_hi, axis_x_hi, axis_x_lo]
// Pass nullptr to hold current input state.
EMSCRIPTEN_KEEPALIVE
void ares_advance_frames(u32 count, const u8* /*inputs*/) {
  if (!s_loaded || !s_root) return;
  for (u32 i = 0; i < count; i++) {
    s_root->run();
    s_frameCount++;
  }
}

// Simple 32-bit XOR hash of the current framebuffer — used for regression testing.
EMSCRIPTEN_KEEPALIVE
u32 ares_get_frame_hash() {
  if (!s_platform || s_platform->framebuffer.empty()) return 0;
  u32 hash = 0x811c9dc5u;
  for (u32 px : s_platform->framebuffer) {
    hash ^= px;
    hash *= 0x01000193u;
  }
  return hash;
}

// Returns 1 if a ROM is loaded and the emulator is running.
EMSCRIPTEN_KEEPALIVE
int ares_is_running() {
  return (s_loaded && s_root && s_platform && !s_platform->shutdownRequested) ? 1 : 0;
}

} // extern "C"
