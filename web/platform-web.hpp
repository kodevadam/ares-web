#pragma once

/*
 * web/platform-web.hpp
 *
 * Declares WebPlatform — the ares::Platform subclass for the WASM build —
 * and the shared input state written by JS and read during input polling.
 */

#include <ares/ares.hpp>
#include <n64/n64.hpp>

// ---------------------------------------------------------------------------
// Per-port controller state (written by JS via ares_set_button / ares_set_axis)
// ---------------------------------------------------------------------------

struct ControllerState {
  bool up      = false;
  bool down    = false;
  bool left    = false;
  bool right   = false;
  bool b       = false;
  bool a       = false;
  bool cUp     = false;
  bool cDown   = false;
  bool cLeft   = false;
  bool cRight  = false;
  bool l       = false;
  bool r       = false;
  bool z       = false;
  bool start   = false;
  s16  axisX   = 0;  // [-32767, +32767]
  s16  axisY   = 0;  // [-32767, +32767]
};

// ---------------------------------------------------------------------------
// WebPlatform
// ---------------------------------------------------------------------------

struct WebPlatform : ares::Platform {
  WebPlatform();
  ~WebPlatform() override;

  // ares::Platform interface
  auto pak(ares::Node::Object) -> std::shared_ptr<vfs::directory> override;
  auto video(ares::Node::Video::Screen, const u32* data, u32 pitch,
             u32 width, u32 height) -> void override;
  auto audio(ares::Node::Audio::Stream) -> void override;
  auto input(ares::Node::Input::Input)  -> void override;
  auto event(ares::Event)               -> void override;

  // VFS pak directories provided to the core.
  std::shared_ptr<vfs::directory> systemPak;
  std::shared_ptr<vfs::directory> cartridgePak;

  // Captured framebuffer (RGBA8888).
  std::vector<u32> framebuffer;
  u32 framebufferWidth  = 0;
  u32 framebufferHeight = 0;

  // Controller state for up to 4 ports.
  ControllerState inputState[4];

  bool shutdownRequested = false;
};

extern WebPlatform* g_webPlatform;
