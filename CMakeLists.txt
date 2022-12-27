#
# Note: this file isn't for direct use, it is meant for making this repository
# be fetchable by means of FetchContent CMake functionality.
#
cmake_minimum_required(VERSION 3.24)

project(ez-common)


##############################################################################
# Setup project general properties
##############################################################################
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")
include(define_build_profile)


##############################################################################
# Define functions for enabling (on demand) preset custom build profiles
##############################################################################

# Enable DEBUG_WITH_UBASAN custom build configuration.
function(ez_common_enable_build_profile_debug_with_ubasan)
    ez_common_define_build_profile(Debug_with_ubasan
        BASED_ON_PROFILE Debug
        C_FLAGS
            -fsanitize=address -fsanitize=undefined -fno-omit-frame-pointer -fno-sanitize-recover=all
        CXX_FLAGS
            -fsanitize=address -fsanitize=undefined -fno-omit-frame-pointer -fno-sanitize-recover=all
        SHARED_LINKER_FLAGS
            -fsanitize=address -fsanitize=undefined
        EXE_LINKER_FLAGS
            -fsanitize=address -fsanitize=undefined
    )
endfunction()


##############################################################################
# Setup ez::common::compile_options target
##############################################################################

add_library(ez_common_compile_options INTERFACE)
add_library(ez::common::compile_options ALIAS ez_common_compile_options)

if(MSVC)
    target_compile_options(ez_common_compile_options
        INTERFACE
        /EHsc
        /Wall
        /WX
        /Zc:__cplusplus
    )
else()
    target_compile_options(ez_common_compile_options
        INTERFACE
        -Wall
        -Wcast-align
        -Wconversion
        -Werror
        -Wextra
        -Wnon-virtual-dtor
        -Wold-style-cast
        -Woverloaded-virtual
        -Wpedantic
        -Wshadow
        -Wsign-conversion
        -fconcepts-diagnostics-depth=2
    )
endif()
