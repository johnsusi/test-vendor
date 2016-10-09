cmake_minimum_required (VERSION 3.5)

if (APPLE)
  set(ENV{MACOSX_DEPLOYMENT_TARGET} "10.7")
  set(CFLAGS "-mmacosx-version-min=10.7")
endif()

project(turner)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/tools)

set(CMAKE_MACOSX_RPATH ON)
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -stdlib=libc++")

include(ExternalProject)

include(VendorPlatform)

set(VENDOR_DIR ${PROJECT_SOURCE_DIR}/${VENDOR_PLATFORM})
set(CACHE_DIR  ${PROJECT_BINARY_DIR}/.cache)

set(VENDOR_SOURCE_DIR ${PROJECT_SOURCE_DIR}/vendor)

ExternalProject_add(
  flatbuffers
  URL ${VENDOR_SOURCE_DIR}/flatbuffers
  # URL https://github.com/google/flatbuffers/archive/v1.4.0.tar.gz
#  GIT_REPOSITORY "https://github.com/google/flatbuffers.git"
#  GIT_TAG        "v1.4.0"
  DOWNLOAD_DIR   ${CACHE_DIR}
  CMAKE_GENERATOR ${CMAKE_GENERATOR}
  CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX=${VENDOR_DIR}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_OSX_DEPLOYMENT_TARGET="10.7"
      -DFLATBUFFERS_BUILD_TESTS=NO
  BUILD_COMMAND   cmake --build . --config Release
  INSTALL_COMMAND cmake --build . --config Release --target install
)

ExternalProject_add(
  liquidfun
  URL ${VENDOR_SOURCE_DIR}/liquidfun
  # URL https://github.com/google/liquidfun/archive/v1.1.0.tar.gz
#  GIT_REPOSITORY "https://github.com/google/liquidfun.git"
#  GIT_TAG        "v1.1.0"
  DOWNLOAD_DIR   ${CACHE_DIR}
  CMAKE_GENERATOR ${CMAKE_GENERATOR}
  CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX=${VENDOR_DIR}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_OSX_DEPLOYMENT_TARGET="10.7"
      -DBUILD_SHARED_LIBS=NO
      -DBOX2D_BUILD_EXAMPLES=NO
      -DBOX2D_BUILD_UNITTESTS=NO
      -DBOX2D_INSTALL=ON
      -DBOX2D_INSTALL_DOC=ON
  PATCH_COMMAND ${CMAKE_COMMAND} -DSOURCE_DIR=<SOURCE_DIR> -P ${PROJECT_SOURCE_DIR}/tools/liquidfun.cmake
  BUILD_COMMAND   cmake --build . --config Release
  INSTALL_COMMAND cmake --build . --config Release --target install
)

ExternalProject_add(
  sdl
  # URL https://www.libsdl.org/release/SDL2-2.0.4.tar.gz
  HG_REPOSITORY "http://hg.libsdl.org/SDL"
  HG_TAG        "release-2.0.4"
  DOWNLOAD_DIR   ${CACHE_DIR}
  CMAKE_GENERATOR ${CMAKE_GENERATOR}
  CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX=${VENDOR_DIR}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_OSX_DEPLOYMENT_TARGET="10.7"
      -DBUILD_SHARED_LIBS=NO
      -DSDL_SHARED_ENABLED_BY_DEFAULT=NO
      -DSDL_SHARED=NO
      -DBUILD_SHARED_LIBS=NO
  BUILD_COMMAND   cmake --build . --config Release
  INSTALL_COMMAND cmake --build . --config Release --target install
)

ExternalProject_add(
  zlib
  URL http://zlib.net/zlib-1.2.8.tar.gz
  URL_HASH MD5=44d667c142d7cda120332623eab69f40
  DOWNLOAD_DIR            ${CACHE_DIR}
  BUILD_IN_SOURCE         1
  CONFIGURE_COMMAND       "CFLAGS=${CFLAGS}" ./configure --prefix=${VENDOR_DIR} --static
  BUILD_COMMAND   make
  INSTALL_COMMAND make install
)

# ExternalProject_add(
#   png
#   DEPENDS zlib
#   URL ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.24.tar.gz
#   URL_HASH MD5=65213080dd30a9b16193d9b83adc1ee9
#   DOWNLOAD_DIR   ${CACHE_DIR}
#   CMAKE_ARGS
#       -DCMAKE_INSTALL_PREFIX=${VENDOR_DIR}
#       -DCMAKE_BUILD_TYPE=Release
#       -DBUILD_SHARED_LIBS=NO
#       -DPNG_SHARED=NO
#       -DPNG_TESTS=NO
#       -DZLIB_ROOT=${VENDOR_DIR}
#   BUILD_COMMAND   cmake --build . --config Release
#   INSTALL_COMMAND cmake --build . --config Release --target install
# )
#
#
# #https://www.openssl.org/source/openssl-1.0.2h.tar.gz
#
if (${VENDOR_PLATFORM} MATCHES "linux")
  set(OPENSSL_CONFIG ./Configure linux-x86_64)
  set(OPENSSL_INSTALL make && make install)
elseif (${VENDOR_PLATFORM} MATCHES "darwin")
  set(OPENSSL_CONFIG ./Configure darwin64-x86_64-cc -mmacosx-version-min=10.7)
  set(OPENSSL_INSTALL make && make install)
elseif (${VENDOR_PLATFORM} MATCHES "win32")
  set(OPENSSL_CONFIG perl Configure VC-WIN64A)
  set(OPENSSL_INSTALL ms/do_win64a && nmake -f ms/nt.mak && nmake -f ms/nt.mak install)
else ()
  message(FATAL_ERROR "Unsupported or missing VENDOR_PLATFORM")
endif ()

ExternalProject_add(
  openssl
  DEPENDS zlib
  URL https://www.openssl.org/source/openssl-1.0.2h.tar.gz
  URL_HASH SHA256=1d4007e53aad94a5b2002fe045ee7bb0b3d98f1a47f8b2bc851dcd1c74332919
  #GIT_REPOSITORY https://github.com/openssl/openssl.git
  #GIT_TAG        OpenSSL_1_0_2h
  DOWNLOAD_DIR   ${CACHE_DIR}
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
    ${OPENSSL_CONFIG}
      --prefix=${VENDOR_DIR}
      --with-zlib-include=${VENDOR_DIR}/include
      --with-zlib-lib=${VENDOR_DIR}/lib
      zlib
  BUILD_COMMAND  ""
  INSTALL_COMMAND ${OPENSSL_INSTALL}
)

# ExternalProject_add(
#   webp
#   URL ${VENDOR_SOURCE_DIR}/libwebp
#   # URL https://github.com/webmproject/libwebp/archive/v0.5.1.tar.gz
#   # GIT_REPOSITORY https://chromium.googlesource.com/webm/libwebp
#   # GIT_TAG v0.5.1
#   DOWNLOAD_DIR   ${CACHE_DIR}
#   # CONFIGURE_COMMAND cd <SOURCE_DIR> && ./autogen.sh && ./configure --prefix=${VENDOR_DIR}
#   CMAKE_GENERATOR ${CMAKE_GENERATOR}
#   CMAKE_ARGS
#       -DCMAKE_INSTALL_PREFIX=${VENDOR_DIR}
#       -DCMAKE_BUILD_TYPE=Release
#       -DBUILD_SHARED_LIBS=NO
#   BUILD_COMMAND   cmake --build . --config Release
#   INSTALL_COMMAND cmake --build . --config Release --target install
# )

ExternalProject_add(
  zeromq
  URL ${VENDOR_SOURCE_DIR}/libzmq
  # URL https://github.com/zeromq/zeromq4-1/releases/download/v4.1.5/zeromq-4.1.5.tar.gz
  # GIT_REPOSITORY https://github.com/zeromq/libzmq
#  GIT_TAG
  DOWNLOAD_DIR   ${CACHE_DIR}
  CMAKE_GENERATOR ${CMAKE_GENERATOR}
  CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX=${VENDOR_DIR}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_OSX_DEPLOYMENT_TARGET="10.7"
      -DBUILD_SHARED_LIBS=NO
      -DZMQ_BUILD_FRAMEWORK=NO
      -DZMQ_BUILD_TESTS=NO
  BUILD_COMMAND   cmake --build . --config Release
  INSTALL_COMMAND cmake --build . --config Release --target install
)

ExternalProject_add(
  curl
  DEPENDS zlib openssl
  URL ${VENDOR_SOURCE_DIR}/curl
  # URL https://curl.haxx.se/download/curl-7.50.1.tar.gz
  # GIT_REPOSITORY https://github.com/curl/curl.git
  # GIT_TAG        curl-7_49_1
  DOWNLOAD_DIR   ${CACHE_DIR}
  # CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${VENDOR_DIR} --disable-shared --enable-static
  # BUILD_COMMAND   make
  # INSTALL_COMMAND make install

  CMAKE_GENERATOR ${CMAKE_GENERATOR}
  CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX=${VENDOR_DIR}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_OSX_DEPLOYMENT_TARGET="10.7"
      -DBUILD_SHARED_LIBS=NO
      -DCURL_STATICLIB=YES
      -DHTTP_ONLY=YES
      -DUSE_NGHTTP2=YES
      -DOPENSSL_ROOT_DIR=${VENDOR_DIR}
      -DBUILD_CURL_EXE=NO
      -DZLIB_ROOT=${VENDOR_DIR}
  BUILD_COMMAND   cmake --build . --config Release
  INSTALL_COMMAND cmake --build . --config Release --target install
)

ExternalProject_add(
  glfw
  URL ${VENDOR_SOURCE_DIR}/glfw
  # URL https://github.com/glfw/glfw/archive/3.2.1.tar.gz
  # GIT_REPOSITORY "https://github.com/glfw/glfw.git"
  # GIT_TAG        "3.2.1"
  DOWNLOAD_DIR   ${CACHE_DIR}
  CMAKE_GENERATOR ${CMAKE_GENERATOR}
  CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX=${VENDOR_DIR}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_OSX_DEPLOYMENT_TARGET="10.7"
      -DCMAKE_CXX_FLAGS="-std=c++11 -stdlib=libc++"
      -DCMAKE_EXE_LINKER_FLAGS="-std=c++11 -stdlib=libc++"
      -DBUILD_SHARED_LIBS=NO
      -DGLFW_BUILD_EXAMPLES=NO
      -DGLFW_BUILD_TESTS=NO
      -DGLFW_BUILD_DOCS=NO
  BUILD_COMMAND   cmake --build . --config Release
  INSTALL_COMMAND cmake --build . --config Release --target install
)

ExternalProject_add(
  opencv
  DEPENDS zlib
  URL ${VENDOR_SOURCE_DIR}/opencv
  # URL https://github.com/opencv/opencv/archive/3.1.0.tar.gz
  # GIT_REPOSITORY "https://github.com/opencv/opencv.git"
  # GIT_TAG        "3.1.0"
  DOWNLOAD_DIR   ${CACHE_DIR}
  CMAKE_GENERATOR ${CMAKE_GENERATOR}
  CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX=${VENDOR_DIR}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_OSX_DEPLOYMENT_TARGET=10.7
      "-DCMAKE_CXX_FLAGS=-std=c++11 -stdlib=libc++"
      "-DCMAKE_EXE_LINKER_FLAGS=-std=c++11 -stdlib=libc++"
      -DBUILD_SHARED_LIBS=NO
      -DBUILD_PERF_TESTS=NO
      -DBUILD_TESTS=NO
      -DBUILD_JPEG=YES
      -DBUILD_PNG=YES
      -DBUILD_WEBP=YES
      -DBUILD_TBB=YES
      -DBUILD_ZLIB=NO
      -DWITH_QT=NO
      -DBUILD_FFMPEG=YES
      -DBUILD_opencv_java=NO
      -DBUILD_opencv_python=NO
      -DBUILD_opencv_apps=NO
      -DZLIB_ROOT=${VENDOR_DIR}
      -D3P_LIBRARY_OUTPUT_PATH=${VENDOR_DIR}/lib
  BUILD_COMMAND   cmake --build . --config Release
  INSTALL_COMMAND cmake --build . --config Release --target install
)


# ExternalProject_add(
#   devil
#   DEPENDS png
#   GIT_REPOSITORY https://github.com/DentonW/DevIL.git
#   PATCH_COMMAND ${CMAKE_COMMAND} -E echo ADD_SUBDIRECTORY(DevIL) > <SOURCE_DIR>/CMakeLists.txt
#   BUILD_COMMAND  ""
#   CONFIGURE_COMMAND cd <SOURCE_DIR>/DevIL && ./autogen.sh && ./configure
#   CMAKE_ARGS
#       -DCMAKE_INSTALL_PREFIX=${VENDOR_DIR}
#       -DCMAKE_BUILD_TYPE=Release
#       -DCMAKE_CONFIGURATION_TYPES=Release
#       -DBUILD_SHARED_LIBS=NO
#   INSTALL_COMMAND
#     cmake
#       --build .
#       --target install
#       --config Release
# )
