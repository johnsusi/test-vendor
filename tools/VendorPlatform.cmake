if (NOT VENDOR_PLATFORM)

  if (NOT VENDOR_ARCH)
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
      set(VENDOR_ARCH x64  CACHE STRING "Vendor arch")
    else()
      set(VENDOR_ARCH ia32 CACHE STRING "Vendor arch")
    endif()
  endif()

  if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set(VENDOR_PLATFORM darwin-${VENDOR_ARCH} CACHE STRING "Vendor platform")
  elseif (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(VENDOR_PLATFORM linux-${VENDOR_ARCH} CACHE STRING "Vendor platform")
  elseif (WIN32)
    set(VENDOR_PLATFORM win32-${VENDOR_ARCH} CACHE STRING "Vendor platform")
  else()
    message(FATAL_ERROR "Unsupported or missing VENDOR_PLATFORM")
  endif ()

endif()

get_filename_component(VENDOR_DIR_ ../${VENDOR_PLATFORM} ABSOLUTE)

set(VENDOR_DIR ${VENDOR_DIR_} CACHE PATH "Location of vendor headers and libraries")

include_directories(${VENDOR_DIR}/include)
link_directories(${VENDOR_DIR}/lib ${VENDOR_DIR}/share/OpenCV/3rdparty/lib)

set(GLFW_LIBRARIES_ glfw3)
set(OPENCV_LIBRARIES_
  opencv_core
  opencv_imgproc
  opencv_imgcodecs
  libpng
  libjpeg
  libjasper
  libwebp
  libtiff
  ippicv
  IlmImf
  z
)


if (${VENDOR_PLATFORM} MATCHES "darwin")

  set(GLFW_LIBRARIES_
    ${GLFW_LIBRARIES_}
    "-framework Cocoa"
    "-framework IOKit"
    "-framework OpenGL"
    "-framework CoreVideo"
  )

  set(OPENCV_LIBRARIES_
    ${OPENCV_LIBRARIES_}
    "-framework OpenCL"

  )

endif()

set(GLFW_LIBRARIES    ${GLFW_LIBRARIES_}   CACHE STRING "GLFW libraries")
set(OPENCV_LIBRARIES  ${OPENCV_LIBRARIES_} CACHE STRING "OpenCV libraries")

set(VENDOR_LIBRARIES  ${GLFW_LIBRARIES} ${OPENCV_LIBRARIES} CACHE STRING "Vendor libraries")
