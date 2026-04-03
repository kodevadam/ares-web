#pragma once
// web/webgpu-rdp.hpp
//
// WebGPU replacement for ares/n64/vulkan/vulkan.hpp.
// Presents the same external interface so vi.cpp / rdp/render.cpp can
// reference either backend with a simple #if defined(WEBGPU) guard.
//
// The implementation lives in web/webgpu-rdp.cpp and uses Emscripten's
// WebGPU C bindings (-s USE_WEBGPU=1).

#include <stdint.h>

namespace ares::Nintendo64 {

struct WebGpuRdp {
  // Lifecycle -----------------------------------------------------------
  // Called once after the system node is constructed.
  // Obtains the WGPUDevice via emscripten_webgpu_get_device(), creates all
  // persistent GPU resources (RDRAM buffer, pipelines, bind groups).
  // Returns true on success; falls back to CPU-only mode on failure.
  auto load(Node::Object) -> bool;

  // Releases all GPU resources.
  auto unload() -> void;

  // Per-frame / per-command interface -----------------------------------

  // Process the current RDP command range [command.current, command.end).
  // Queues commands into the internal CPU-side command buffer.
  // On SyncFull, flushes to GPU and blocks until the frame is resolved.
  // Returns false if the backend is unavailable (caller falls through to
  // the software stub path).
  auto render() -> bool;

  // Called by VI at the start of each new video frame (before any RDP
  // commands for that frame are enqueued).  Resets per-frame GPU state.
  auto frame() -> void;

  // Routes a VI register write into the WebGPU renderer so the scanout
  // pipeline knows the framebuffer address / format / dimensions.
  // `address` is the VI register index (0-13, same values as vulkan.cpp).
  auto writeWord(u32 address, u32 data) -> void;

  // Scanout interface ---------------------------------------------------

  // Initiates an asynchronous GPU→CPU copy of the rendered framebuffer.
  // `field` is the interlace field flag (0 or 1).
  // Returns true when a valid frame is available (may be a previous frame
  // on the first call while the async copy is in flight).
  auto scanoutAsync(bool field) -> bool;

  // Returns a pointer to the most recently completed RGBA8888 scanout
  // buffer and sets width/height.  Sets rgba=nullptr if no frame is ready.
  // Blocks (via emscripten_sleep loop under ASYNCIFY) until the GPU→CPU
  // copy initiated by scanoutAsync() has finished.
  auto mapScanoutRead(const u8*& rgba, u32& width, u32& height) -> void;

  // Releases the pointer returned by mapScanoutRead().
  auto unmapScanoutRead() -> void;

  // Signals that the host has finished reading the scanout buffer so the
  // implementation can recycle it.
  auto endScanout() -> void;

  // Returns a non-null crash message string if the GPU renderer has
  // entered an unrecoverable error state, nullptr otherwise.
  auto crashed() -> const char*;

  // State ---------------------------------------------------------------
  struct Implementation;
  Implementation* implementation = nullptr;

  bool enable = true;  // set to false to disable GPU rendering entirely
};

extern WebGpuRdp webgpurdp;

}
