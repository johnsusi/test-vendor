cmake_minimum_required (VERSION 3.5)

project(turner)

set(CMAKE_MACOSX_RPATH ON)
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -stdlib=libc++")

include(ExternalProject)

if (NOT VENDOR_PLATFORM)

  if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set(VENDOR_PLATFORM darwin-x64)
  elseif (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(VENDOR_PLATFORM linux-x64)
  elseif (WIN32)
    set(VENDOR_PLATFORM win32-ia32)
  else()
    set(VENDOR_PLATFORM unknown)
  endif ()

endif()

set(VENDOR_DIR ${PROJECT_SOURCE_DIR}/${VENDOR_PLATFORM})

ExternalProject_add(
  flatbuffers
  GIT_REPOSITORY "https://github.com/google/flatbuffers.git"
  GIT_TAG        "v1.3.0"
  BUILD_COMMAND  ""
  UPDATE_COMMAND ""
  CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX=${VENDOR_DIR}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_CONFIGURATION_TYPES=Release
      -DFLATBUFFERS_BUILD_TESTS=NO
  INSTALL_COMMAND
    cmake
      --build .
      --target install
      --config Release
)

ExternalProject_add(
  liquidfun
  GIT_REPOSITORY "https://github.com/google/liquidfun.git"
  GIT_TAG        "v1.1.0"
  BUILD_COMMAND  ""
  UPDATE_COMMAND ""
  CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX=${VENDOR_DIR}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_CONFIGURATION_TYPES=Release
      -DBOX2D_BUILD_EXAMPLES=NO
      -DBOX2D_BUILD_UNITTESTS=NO
      -DBOX2D_INSTALL=ON
      -DBOX2D_INSTALL_DOC=ON
  PATCH_COMMAND ${CMAKE_COMMAND} -E echo ADD_SUBDIRECTORY(liquidfun/Box2D) > <SOURCE_DIR>/CMakeLists.txt
  INSTALL_COMMAND
    cmake
      --build .
      --target install
      --config Release
)

# ExternalProject_add(
#   sdl
#   HG_REPOSITORY "http://hg.libsdl.org/SDL"
#   HG_TAG        "release-2.0.4"
#   BUILD_COMMAND ""
#   CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${VENDOR_DIR} --disable-shared --enable-static
#   INSTALL_COMMAND make && make install
# )

ExternalProject_add(
  sdl
  HG_REPOSITORY "http://hg.libsdl.org/SDL"
  HG_TAG        "release-2.0.4"
  BUILD_COMMAND ""
  CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX=${VENDOR_DIR}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_CONFIGURATION_TYPES=Release
      -DSDL_SHARED_ENABLED_BY_DEFAULT=NO
      -DSDL_SHARED=NO
      -DBUILD_SHARED_LIBS=NO
  INSTALL_COMMAND
    cmake
      --build .
      --target install
      --config Release
)

ExternalProject_add(
  opencv
  GIT_REPOSITORY "https://github.com/opencv/opencv.git"
  GIT_TAG        "3.1.0"
  BUILD_COMMAND ""
  UPDATE_COMMAND ""
  CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX=${VENDOR_DIR}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_CONFIGURATION_TYPES=Release
      -DBUILD_SHARED_LIBS=NO
      -DBUILD_PERF_TESTS=NO
      -DBUILD_TESTS=NO
      -DBUILD_JPEG=ON
      -DBUILD_PNG=ON
      -DBUILD_TBB=ON
      -DWITH_QT=NO
      -DBUILD_opencv_java=NO
      -DBUILD_opencv_python=NO
      -DBUILD_opencv_apps=NO
  INSTALL_COMMAND
    cmake
      --build .
      --target install
      --config Release
)

ExternalProject_add(
  zlib
  URL http://zlib.net/zlib-1.2.8.tar.gz
  URL_HASH MD5=44d667c142d7cda120332623eab69f40
  BUILD_COMMAND ""
  CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX=${VENDOR_DIR}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_CONFIGURATION_TYPES=Release
      -DBUILD_SHARED_LIBS=NO
  INSTALL_COMMAND
    cmake
      --build .
      --target install
      --config Release
)

ExternalProject_add(
  png
  DEPENDS zlib
  URL ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.23.tar.gz
  URL_HASH MD5=a49e4cc48d968c79def53d082809c9f2
  BUILD_COMMAND ""
  CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX=${VENDOR_DIR}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_CONFIGURATION_TYPES=Release
      -DBUILD_SHARED_LIBS=NO
      -DPNG_SHARED=NO
      -DPNG_TESTS=NO
      -DZLIB_ROOT=${VENDOR_DIR}
  INSTALL_COMMAND
    cmake
      --build .
      --target install
      --config Release
)


#https://www.openssl.org/source/openssl-1.0.2h.tar.gz

if (${VENDOR_PLATFORM} MATCHES "linux")
  set(OPENSSL_CONFIG linux-x86_64)
elseif (${VENDOR_PLATFORM} MATCHES "darwin")
  set(OPENSSL_CONFIG darwin64-x86_64-cc)
else ()
  set(OPENSSL_CONFIG '')
endif ()

ExternalProject_add(
  openssl
  DEPENDS zlib
  URL https://www.openssl.org/source/openssl-1.0.2h.tar.gz
  #GIT_REPOSITORY https://github.com/openssl/openssl.git
  #GIT_TAG        OpenSSL_1_0_2h
  BUILD_COMMAND  ""
  UPDATE_COMMAND ""
  CONFIGURE_COMMAND
    cd <SOURCE_DIR> && ./Configure ${OPENSSL_CONFIG}
      --prefix=${VENDOR_DIR}
      --with-zlib-include=${VENDOR_DIR}/include
      --with-zlib-lib=${VENDOR_DIR}/lib
      no-deprecated
      no-dso
      zlib
  INSTALL_COMMAND cd <SOURCE_DIR> && make && make install
)

ExternalProject_add(
  webp
  GIT_REPOSITORY https://github.com/webmproject/libwebp.git
  GIT_TAG v0.5.1
  BUILD_COMMAND  ""
  UPDATE_COMMAND ""
#  CONFIGURE_COMMAND cd <SOURCE_DIR> && ./autogen.sh && ./configure --prefix=${VENDOR_DIR}
  CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX=${VENDOR_DIR}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_CONFIGURATION_TYPES=Release
      -DBUILD_SHARED_LIBS=NO
  INSTALL_COMMAND
#    cd <SOURCE_DIR> && make && make install
    cmake
      --build .
      --target install
      --config Release
)

ExternalProject_add(
  zeromq
  GIT_REPOSITORY https://github.com/zeromq/libzmq
#  GIT_TAG
  BUILD_COMMAND  ""
  UPDATE_COMMAND ""
  CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX=${VENDOR_DIR}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_CONFIGURATION_TYPES=Release
      -DBUILD_SHARED_LIBS=NO
  INSTALL_COMMAND
    cmake
      --build .
      --target install
      --config Release
)

ExternalProject_add(
  curl
  DEPENDS zlib openssl
  GIT_REPOSITORY https://github.com/curl/curl.git
  GIT_TAG        curl-7_49_1
  BUILD_COMMAND  ""
  UPDATE_COMMAND ""
  CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX=${VENDOR_DIR}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_CONFIGURATION_TYPES=Release
      -DBUILD_SHARED_LIBS=NO
      -DCURL_STATICLIB=YES
      -DHTTP_ONLY=YES
      -DOPENSSL_ROOT_DIR=${VENDOR_DIR}
      -DBUILD_CURL_EXE=NO
  INSTALL_COMMAND
    cmake
      --build .
      --target install
      --config Release
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
