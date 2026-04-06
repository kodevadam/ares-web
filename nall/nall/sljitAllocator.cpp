#include <nall/platform.hpp>

#if !defined(PLATFORM_WASM) && !defined(__EMSCRIPTEN__)
// sljit JIT allocator — not used on WebAssembly (sljit is a stub interface target).
#include <sljit.h>
#include <nall/bump-allocator.hpp>

auto sljit_nall_malloc_exec(sljit_uw size, void* exec_allocator_data) -> void* {
  auto allocator = (nall::bump_allocator*)exec_allocator_data;
  return allocator->tryAcquire(size, false);
}
#endif
