cmake_minimum_required(VERSION 3.24)

project(ez-common
    VERSION 1.0.0
    LANGUAGES CXX
)

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
    )
endif()

