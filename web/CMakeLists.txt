cmake_minimum_required(VERSION 3.28)

# This sub-project is only built when targeting Emscripten.
if(NOT CMAKE_SYSTEM_NAME STREQUAL "Emscripten")
  message(FATAL_ERROR "web/CMakeLists.txt must be configured with the Emscripten toolchain")
endif()

# ---------------------------------------------------------------------------
# Emscripten link flags
# ---------------------------------------------------------------------------

# Initial memory: 256 MiB (enough for RDRAM + scratch).
# ALLOW_MEMORY_GROWTH lets it expand further if needed.
# ASYNCIFY is required by the Emscripten fiber API used in libco.
# USE_WEBGPU=1 provides the webgpu.h C header that maps to the browser GPU API.
# EXPORTED_RUNTIME_METHODS: expose ccall/cwrap for JS → WASM calls.
# ENVIRONMENT=web: produce a web-only module (no Node.js shims).
# MODULARIZE=1: wrap the output in a factory function for clean init.

set(ARES_WEB_LINK_FLAGS
  "-O2"
  "-msimd128"
  "-flto"
  "-s WASM=1"
  "-s ALLOW_MEMORY_GROWTH=1"
  "-s INITIAL_MEMORY=268435456"  # 256 MiB
  "-s ASYNCIFY"
  "-s USE_WEBGPU=1"
  "-s ENVIRONMENT=web"
  "-s MODULARIZE=1"
  "-s EXPORT_NAME=AresN64Module"
  "-s EXPORTED_RUNTIME_METHODS=[ccall,cwrap,setValue,getValue,UTF8ToString,stringToUTF8]"
  "-s EXPORTED_FUNCTIONS=[_malloc,_free,_ares_init,_ares_load_rom,_ares_run_frame,_ares_reset,_ares_get_framebuffer,_ares_get_framebuffer_width,_ares_get_framebuffer_height,_ares_set_button,_ares_set_axis]"
  # FORCE_FILESYSTEM=1: enable Emscripten MEMFS so mia can write/read
  # the ROM via a virtual path (/tmp/rom.z64) and the N64 system can
  # create its save directory entry.
  "-s FORCE_FILESYSTEM=1"
)

# ---------------------------------------------------------------------------
# Compile flags (applied to all sources in this target)
# ---------------------------------------------------------------------------

set(ARES_WEB_COMPILE_FLAGS
  "-O2"
  "-msimd128"
  "-flto"
  "-D__EMSCRIPTEN__"
  "-DARES_WEB=1"
  # Disable Vulkan/native-platform paths
  "-UNDEFINEDVULKAN"  # ensure VULKAN is NOT defined
)

# ---------------------------------------------------------------------------
# ares-web executable (compiled to .wasm + .js)
# ---------------------------------------------------------------------------

add_executable(ares-web
  main-web.cpp
  platform-web.cpp
)

# Pull in the ares core (N64 only — enforced by ARES_CORES=n64 in preset)
# and the mia ROM-loading library.
target_link_libraries(ares-web
  PRIVATE
    ares::ares
    ares::mia
    libco
)

target_include_directories(ares-web
  PRIVATE
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/thirdparty
)

# Remove the VULKAN define from the ares target for this build so the
# paraLLEl-RDP Vulkan path is not compiled.
target_compile_definitions(ares-web PRIVATE
  ARES_WEB=1
)

# Block VULKAN define coming from ares/n64/CMakeLists.txt.
# We achieve this by undefining it immediately after it would be set.
# (The N64 CMakeLists.txt calls target_compile_definitions(ares PUBLIC VULKAN)
# but we override it here for the ares-web target.)
target_compile_options(ares-web PRIVATE -UVULKAN)

# Apply compile flags
target_compile_options(ares-web PRIVATE ${ARES_WEB_COMPILE_FLAGS})

# Apply link flags (passed as a single string to avoid CMake list issues)
string(JOIN " " _link_flags_str ${ARES_WEB_LINK_FLAGS})
set_target_properties(ares-web PROPERTIES
  LINK_FLAGS "${_link_flags_str}"
  OUTPUT_NAME "ares-n64"
  SUFFIX ".js"
)

# ---------------------------------------------------------------------------
# Install / output
# ---------------------------------------------------------------------------

install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/ares-n64.js
  ${CMAKE_CURRENT_BINARY_DIR}/ares-n64.wasm
  DESTINATION ${CMAKE_INSTALL_PREFIX}/web
)
