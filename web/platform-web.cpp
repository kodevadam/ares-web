/*
 * web/platform-web.cpp
 *
 * ares::Platform implementation for the WebAssembly build.
 *
 * Responsibilities:
 *   - Serve ROM/system pak directories (VFS) to the emulation core.
 *   - Capture video frames into a host-side RGBA buffer.
 *   - Drain audio samples from the stream (discarded for Phase 1; proper
 *     AudioWorklet bridging is Phase 3).
 *   - Feed controller state from the input table written by JS.
 *   - Handle the Shutdown event.
 */

#include "platform-web.hpp"

#include <n64/n64.hpp>

// ---------------------------------------------------------------------------
// Global platform instance (defined here, declared extern in platform-web.hpp)
// ---------------------------------------------------------------------------
WebPlatform* g_webPlatform = nullptr;

// ---------------------------------------------------------------------------
// WebPlatform implementation
// ---------------------------------------------------------------------------

WebPlatform::WebPlatform() {
  ares::platform = this;
  g_webPlatform  = this;
}

WebPlatform::~WebPlatform() {
  if(ares::platform == this) ares::platform = nullptr;
  if(g_webPlatform  == this) g_webPlatform  = nullptr;
}

// Called by ares when it needs access to the VFS for a named node.
auto WebPlatform::pak(ares::Node::Object node) -> std::shared_ptr<vfs::directory> {
  if(!node) return {};
  auto name = node->name();
  if(name == "Nintendo 64")           return systemPak;
  if(name == "Nintendo 64 Cartridge") return cartridgePak;
  return {};
}

// Called by ares after every rendered video frame.
auto WebPlatform::video(
    ares::Node::Video::Screen screen,
    const u32* data, u32 pitch, u32 width, u32 height) -> void {
  if(!data || width == 0 || height == 0) return;

  framebufferWidth  = width;
  framebufferHeight = height;

  // Resize our local buffer if necessary.
  u32 pixels = width * height;
  if(framebuffer.size() != pixels) framebuffer.resize(pixels);

  // ares delivers XRGB8888 (0x00RRGGBB) packed into u32.
  // Expand to RGBA8888 (byte-order: R G B A) so the JS side can blit
  // directly into a Canvas ImageData / WebGPU texture.
  u32 srcPitch = pitch / sizeof(u32); // pitch is in bytes
  for(u32 y = 0; y < height; y++) {
    const u32* src = data + y * srcPitch;
    u32*       dst = framebuffer.data() + y * width;
    for(u32 x = 0; x < width; x++) {
      u32 px = src[x];
      u8 r = (px >> 16) & 0xff;
      u8 g = (px >>  8) & 0xff;
      u8 b = (px >>  0) & 0xff;
      dst[x] = (r) | ((u32)g << 8) | ((u32)b << 16) | (0xffu << 24);
    }
  }
}

// Called by ares for each audio mix event.
// Pushes stereo f32 samples into a circular ring buffer.
// JS drains the ring via ares_get_audio_data() / ares_consume_audio().
auto WebPlatform::audio(ares::Node::Audio::Stream stream) -> void {
  if(!stream) return;

  // Track the stream's sample rate (usually 44100 for N64).
  if(stream->frequency() > 0)
    audioSampleRate = (u32)stream->frequency();

  f64 s[2];
  while(stream->pending()) {
    stream->read(s);
    u32 wNext = (audioWritePos + 1) % AUDIO_RING_FRAMES;
    if(wNext == audioReadPos) {
      // Ring full — drop oldest sample by advancing readPos.
      audioReadPos = (audioReadPos + 1) % AUDIO_RING_FRAMES;
    }
    audioRing[audioWritePos * 2 + 0] = (f32)s[0];
    audioRing[audioWritePos * 2 + 1] = (f32)s[1];
    audioWritePos = wNext;
  }
}

// Called by ares when it needs to poll a controller input node.
auto WebPlatform::input(ares::Node::Input::Input node) -> void {
  if(!node) return;

  // Determine which port this input belongs to by walking up the tree.
  // The N64 controller ports are named "Controller Port 1"…"Controller Port 4".
  u32 port = 0;
  if(auto parent = node->parent()) {
    auto grandparent = parent->parent();
    if(grandparent) {
      auto gname = grandparent->name();
      if(gname == "Controller Port 1") port = 0;
      else if(gname == "Controller Port 2") port = 1;
      else if(gname == "Controller Port 3") port = 2;
      else if(gname == "Controller Port 4") port = 3;
    }
  }
  if(port >= 4) return;

  auto& state = inputState[port];
  auto  name  = node->name();

  if(auto button = node->cast<ares::Node::Input::Button>()) {
    if(name == "Up")      button->setValue(state.up);
    if(name == "Down")    button->setValue(state.down);
    if(name == "Left")    button->setValue(state.left);
    if(name == "Right")   button->setValue(state.right);
    if(name == "B")       button->setValue(state.b);
    if(name == "A")       button->setValue(state.a);
    if(name == "C-Up")    button->setValue(state.cUp);
    if(name == "C-Down")  button->setValue(state.cDown);
    if(name == "C-Left")  button->setValue(state.cLeft);
    if(name == "C-Right") button->setValue(state.cRight);
    if(name == "L")       button->setValue(state.l);
    if(name == "R")       button->setValue(state.r);
    if(name == "Z")       button->setValue(state.z);
    if(name == "Start")   button->setValue(state.start);
  }

  if(auto axis = node->cast<ares::Node::Input::Axis>()) {
    // Analog stick: values are s16 in the range [-32768, +32767].
    if(name == "X-Axis") axis->setValue(state.axisX);
    if(name == "Y-Axis") axis->setValue(state.axisY);
    // Individual half-axes used by some cores:
    if(name == "L-Left")  axis->setValue(state.axisX < 0 ? -state.axisX : 0);
    if(name == "L-Right") axis->setValue(state.axisX > 0 ?  state.axisX : 0);
    if(name == "L-Up")    axis->setValue(state.axisY < 0 ? -state.axisY : 0);
    if(name == "L-Down")  axis->setValue(state.axisY > 0 ?  state.axisY : 0);
  }
}

// Called by ares for lifecycle events.
auto WebPlatform::event(ares::Event e) -> void {
  if(e == ares::Event::Shutdown) {
    shutdownRequested = true;
  }
}
