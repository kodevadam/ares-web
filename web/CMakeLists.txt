cmake_minimum_required(VERSION 3.28)

# This sub-project is only built when targeting Emscripten.
if(NOT CMAKE_SYSTEM_NAME STREQUAL "Emscripten")
  message(FATAL_ERROR "web/CMakeLists.txt must be configured with the Emscripten toolchain")
endif()

# ---------------------------------------------------------------------------
# Embed WGSL shader sources as C string literals
#
# Each .wgsl file in web/shaders/ is read at configure time and written into
# web/generated/shader_sources.h as a const char* global.  webgpu-rdp.cpp
# #includes that header.
# ---------------------------------------------------------------------------

set(SHADER_DIR      "${CMAKE_CURRENT_SOURCE_DIR}/shaders")
set(SHADER_HEADER   "${CMAKE_CURRENT_BINARY_DIR}/generated/shader_sources.h")

file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/generated")

set(SHADER_FILES
  clear_write_mask
  clear_indirect_buffer
  clear_super_sampled_write_mask
  masked_rdram_resolve
  extract_vram
  ubershader
  rasterizer
  span_setup
  tile_binning
  depth_blend
  tmem_update
  update_upscaled_domain_pre
  update_upscaled_domain_post
  update_upscaled_domain_resolve
)

# Build the header at configure time.
set(_shader_header_content "// AUTO-GENERATED — do not edit by hand.\n// Run cmake to regenerate.\n\n")

foreach(SHADER ${SHADER_FILES})
  set(WGSL_FILE "${SHADER_DIR}/${SHADER}.wgsl")
  if(EXISTS "${WGSL_FILE}")
    file(READ "${WGSL_FILE}" _wgsl_raw)
    # Escape backslashes and double-quotes for embedding in a C string literal.
    string(REPLACE "\\" "\\\\" _wgsl_esc "${_wgsl_raw}")
    string(REPLACE "\"" "\\\"" _wgsl_esc "${_wgsl_esc}")
    string(REPLACE "\n" "\\n\"\n\"" _wgsl_esc "${_wgsl_esc}")
    string(REPLACE "${SHADER}" "_" _var_name "${SHADER}")
    string(REPLACE "-" "_" _var_name "wgsl_${SHADER}")
    string(REPLACE "-" "_" _var_name "${_var_name}")
    string(APPEND _shader_header_content
      "static const char* wgsl_${SHADER} = \"${_wgsl_esc}\";\n\n")
  else()
    string(APPEND _shader_header_content
      "static const char* wgsl_${SHADER} = \"\";\n\n")
  endif()
endforeach()

file(WRITE "${SHADER_HEADER}" "${_shader_header_content}")

# Force regeneration when any shader changes.
foreach(SHADER ${SHADER_FILES})
  set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS
    "${SHADER_DIR}/${SHADER}.wgsl")
endforeach()

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
  "-O3"
  "-msimd128"
  "-flto"
  "-s WASM=1"
  "-s ALLOW_MEMORY_GROWTH=1"
  "-s INITIAL_MEMORY=268435456"  # 256 MiB
  "-s ASYNCIFY"
  # ASYNCIFY_IGNORE_INDIRECT: skip instrumentation of indirect calls that are
  # never on the async stack (most N64 interpreter dispatch paths).  Reduces
  # ASYNCIFY code-size and runtime overhead significantly.
  "-s ASYNCIFY_IGNORE_INDIRECT=1"
  # Increase ASYNCIFY stack size (default 4096) to accommodate deeper call
  # chains in the N64 interpreter without stack overflow.
  "-s ASYNCIFY_STACK_SIZE=65536"
  "-s USE_WEBGPU=1"
  "-s ENVIRONMENT=web,worker"
  "-s MODULARIZE=1"
  "-s EXPORT_NAME=AresN64Module"
  "-s EXPORTED_RUNTIME_METHODS=[ccall,cwrap,setValue,getValue,UTF8ToString,stringToUTF8]"
  "-s EXPORTED_FUNCTIONS=[_malloc,_free,_ares_init,_ares_load_rom,_ares_run_frame,_ares_reset,_ares_get_framebuffer,_ares_get_framebuffer_width,_ares_get_framebuffer_height,_ares_set_button,_ares_set_axis,_ares_get_audio_sample_rate,_ares_get_audio_data,_ares_consume_audio,_ares_get_frame_number,_ares_advance_frames,_ares_get_frame_hash,_ares_is_running]"
  # FORCE_FILESYSTEM=1: enable Emscripten MEMFS so mia can write/read
  # the ROM via a virtual path (/tmp/rom.z64) and the N64 system can
  # create its save directory entry.
  "-s FORCE_FILESYSTEM=1"
)

# ---------------------------------------------------------------------------
# Compile flags (applied to all sources in this target)
# ---------------------------------------------------------------------------

set(ARES_WEB_COMPILE_FLAGS
  "-O3"
  "-msimd128"
  "-flto"
)

# ---------------------------------------------------------------------------
# ares-web executable (compiled to .wasm + .js)
# ---------------------------------------------------------------------------

add_executable(ares-web
  main-web.cpp
  platform-web.cpp
  webgpu-rdp.cpp
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
    ${CMAKE_CURRENT_BINARY_DIR}   # for generated/shader_sources.h
)

# Define WEBGPU so the #if defined(WEBGPU) guards in vi.cpp, render.cpp, etc.
# activate the WebGPU code path.  VULKAN must NOT be defined.
target_compile_definitions(ares-web
  PRIVATE
    ARES_WEB=1
    WEBGPU=1
)

# Undefine VULKAN in case it leaked in from the ares N64 CMakeLists.
target_compile_options(ares-web PRIVATE -UVULKAN)

# Apply compile flags
target_compile_options(ares-web PRIVATE ${ARES_WEB_COMPILE_FLAGS})

# Apply link flags (passed as a single string to avoid CMake list issues)
string(JOIN " " _link_flags_str ${ARES_WEB_LINK_FLAGS})
set_target_properties(ares-web PROPERTIES
  LINK_FLAGS "${_link_flags_str}"
  OUTPUT_NAME "ares-web"
  SUFFIX ".js"
)

# ---------------------------------------------------------------------------
# Copy static web assets to build directory
# ---------------------------------------------------------------------------

set(WEB_ASSETS
  "${CMAKE_CURRENT_SOURCE_DIR}/index.html"
  "${CMAKE_CURRENT_SOURCE_DIR}/bridge.js"
  "${CMAKE_CURRENT_SOURCE_DIR}/emu-worker.js"
  "${CMAKE_CURRENT_SOURCE_DIR}/audio-worklet.js"
  "${CMAKE_CURRENT_SOURCE_DIR}/touch-controls.js"
  "${CMAKE_CURRENT_SOURCE_DIR}/styles.css"
  "${CMAKE_CURRENT_SOURCE_DIR}/sw.js"
  "${CMAKE_CURRENT_SOURCE_DIR}/manifest.json"
  "${CMAKE_CURRENT_SOURCE_DIR}/remote-api.js"
)

foreach(_asset ${WEB_ASSETS})
  get_filename_component(_name "${_asset}" NAME)
  configure_file("${_asset}" "${CMAKE_CURRENT_BINARY_DIR}/${_name}" COPYONLY)
endforeach()

# Copy icon assets (PWA manifest references icons/icon-192.png etc.)
file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/icons")
foreach(_size 192 512)
  configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/icons/icon-${_size}.png"
    "${CMAKE_CURRENT_BINARY_DIR}/icons/icon-${_size}.png"
    COPYONLY)
endforeach()

# ---------------------------------------------------------------------------
# Install / output
# ---------------------------------------------------------------------------

install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/ares-web.js
  ${CMAKE_CURRENT_BINARY_DIR}/ares-web.wasm
  ${CMAKE_CURRENT_BINARY_DIR}/index.html
  ${CMAKE_CURRENT_BINARY_DIR}/bridge.js
  DESTINATION ${CMAKE_INSTALL_PREFIX}/web
)
