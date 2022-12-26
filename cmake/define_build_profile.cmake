include_guard()

# Define a custom CMake build configuration (build type).
#
#   ez_common_define_build_profile(<new-profile-name>
#     [BASED_ON_PROFILE <base-profile-name>]
#     [C_FLAGS options...]
#     [CXX_FLAGS options...]
#     [EXE_LINKER_FLAGS options...]
#     [SHARED_LINKER_FLAGS options...]
#     [STATIC_LINKER_FLAGS options...]
#     [MODULE_LINKER_FLAGS options...]
#   )
#
# Example:
#
#   # Define new CMake custom build type "Debug_with_sanitizers" which has all the same
#   # options which the existing "Debug" CMake build configurations has but adds a few
#   # more for enabling address sanitizer.
#   ez_common_define_build_profile(Debug_with_sanitizers
#       BASED_ON_PROFILE Debug
#       C_FLAGS
#           -fsanitize=address -fno-omit-frame-pointer
#       CXX_FLAGS
#           -fsanitize=address -fno-omit-frame-pointer
#       STATIC_LINKER_FLAGS
#           -fsanitize=address -fno-omit-frame-pointer
#   )
#
#   Then this config can be used (for single configuration generator):
#     cmake -DCMAKE_BUILD_TYPE=Debug_with_sanitizers ...
#
#   or for multiconfig generator:
#     cmake ...
#     cmake --build . --config Debug_with_sanitizers
#
function(ez_common_define_build_profile new_profile)
    get_property(is_multiconfig GLOBAL
        PROPERTY GENERATOR_IS_MULTI_CONFIG
    )

    if(is_multiconfig AND (NOT ${new_profile} IN_LIST CMAKE_CONFIGURATION_TYPES))
        list(APPEND CMAKE_CONFIGURATION_TYPES ${new_profile})
    endif()

    set(multivalue_kw
        C_FLAGS
        CXX_FLAGS
        EXE_LINKER_FLAGS
        SHARED_LINKER_FLAGS
        STATIC_LINKER_FLAGS
        MODULE_LINKER_FLAGS
    )

    string(TOUPPER ${new_profile} new_profile)

    # Exit if configuration already exists.
    foreach(k ${multivalue_kw})
        if (DEFINED CACHE{CMAKE_${k}_${new_profile}} AND
                (NOT "$CACHE{CMAKE_C_FLAGS_${new_profile}}" STREQUAL ""))
            return()
        endif()
    endforeach()

    cmake_parse_arguments(PARSE_ARGV 1 dbp "" "BASED_ON_PROFILE" "${multivalue_kw}")

    if(DEFINED dpb_UNPARSED_ARGUMENTS)
        list(JOIN dpb_UNPARSED_ARGUMENTS "\n - " args)
        message(FATAL_ERROR "Can't parse the following arguments:\n- $d")
    endif()

    if (DEFINED dbp_BASED_ON_PROFILE)
        string(TOUPPER ${dbp_BASED_ON_PROFILE} base_profile)
    endif()

    foreach(k ${multivalue_kw})
        if (DEFINED base_profile)
            set(CMAKE_${k}_${new_profile}
                "${CMAKE_${k}_${base_profile}}" CACHE STRING "" FORCE)
        endif()

        if (DEFINED dbp_${k})
            list(JOIN dbp_${k} " " options)
            set(CMAKE_${k}_${new_profile} ${options} CACHE STRING "" FORCE)
        endif()
    endforeach()
endfunction()
