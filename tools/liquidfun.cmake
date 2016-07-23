
message("script")
message(${SOURCE_DIR})

set(TARGET "${SOURCE_DIR}/CMakeLists.txt")

file(WRITE ${TARGET} "
cmake_minimum_required (VERSION 3.5)

if (CMAKE_BUILD_TOOL MATCHES \"(msdev|devenv|nmake|MSBuild)\")
  add_definitions(/Wv:18)
endif()

add_subdirectory(liquidfun/Box2D)
")
