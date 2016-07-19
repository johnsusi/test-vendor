cmake_minimum_required (VERSION 3.5)

project(HELLO)

add_executable(TestApp src/test.cpp)

set_target_properties(TestApp
  PROPERTIES
    CXX_STANDARD   14
    CXX_EXTENSIONS NO
)

# if (NOT VENDOR_PLATFORM)
#
#   execute_process(
#     COMMAND node -p `\${process.platform}-\${process.arch}`
#     OUTPUT_VARIABLE VENDOR_PLATFORM
#   )
#
#   if (NOT VENDOR_PLATFORM)
#
#     if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
#       set(VENDOR_PLATFORM darwin-x64)
#     elseif (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
#       set(VENDOR_PLATFORM linux-x64)
#     elseif (WIN32)
#       set(VENDOR_PLATFORM win32-ia32)
#     else ()
#       message(SEND_ERROR "Please supply -DVENDOR_PLATFORM=<platform>-<arch> to cmake")
#     endif ()
#   endif ()
#
# endif ()
#
# include_directories(${CMAKE_CURRENT_SOURCE_DIR}/vendor/${VENDOR_PLATFORM}/include)
# link_directories(${CMAKE_CURRENT_SOURCE_DIR}/vendor/${VENDOR_PLATFORM}/lib)
#
# if (APPLE)
#
#   function (find_osx_frameworks var)
#     foreach(name ${ARGN})
#       find_library(${name}_FRAMEWORK ${name})
#       mark_as_advanced(${name}_FRAMEWORK)
#       list(APPEND TEMP_LIB ${${name}_FRAMEWORK})
#     endforeach()
#     set(${var} ${TEMP_LIB} PARENT_SCOPE)
#   endfunction()
#
#   find_osx_frameworks(EXTRA_LIBS
#     AudioToolbox
#     AudioUnit
#     AppKit
#     ApplicationServices
#     Carbon
#     Cocoa
#     CoreAudio
#     CoreFoundation
#     CoreGraphics
#     CoreMedia
#     CoreMIDI
#     CoreServices
#     CoreText
#     CoreVideo
#     ForceFeedback
#     Foundation
#     IOKit
#     IOSurface
#     OpenGL
#     iconv
#     objc
#   )
#
#   # include_directories(/usr/local/include)
#
# endif()
# #
# # if(NOT WIN32)
# #   INCLUDE(FindPkgConfig)
# #   PKG_SEARCH_MODULE(SDL2 REQUIRED sdl2)
# # else()
# #   find_package(SDL)
# # endif()
#
# # include_directories(${SDL2_INCLUDE_DIRS})
# # link_directories(${SDL2_LIBRARY_DIRS})
#
#
#
# if (DEFINED CMAKE_JS_VERSION)
#
#   message(JS)
#   include_directories(${CMAKE_JS_INC})
#
#   add_library(addon SHARED src/addon.cpp)
#   set_target_properties(addon
#     PROPERTIES
#       PREFIX         ""
#       SUFFIX         ".node"
#       CXX_STANDARD   14
#       CXX_EXTENSIONS NO
#   )
#   target_link_libraries(addon
#     ${CMAKE_JS_LIB}
#     sdl
#   )
#
# else()
#
#   add_executable(TestApp src/main.cpp)
#   set_target_properties(TestApp
#     PROPERTIES
#       CXX_STANDARD   14
#       CXX_EXTENSIONS NO
#   )
#
#   target_link_libraries(TestApp
#     SDL2
#     ${EXTRA_LIBS}
#   )
#
# endif()
