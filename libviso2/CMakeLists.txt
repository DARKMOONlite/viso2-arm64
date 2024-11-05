cmake_minimum_required(VERSION 3.0.2)
project(libviso2)


find_package(catkin REQUIRED )

option(ARM_CROSS_COMPILATION "ARM Cross Compilation" OFF)

# use sse3 instruction set
if(ARM_CROSS_COMPILATION)

  #check if the system has neon support
  include(${PROJECT_SOURCE_DIR}/CPUFeatureDetect.cmake)
  genCPUFeatures(libviso2)
  SET(CMAKE_SYSTEM_PROCESSOR arm)

  if(libviso2_FEATURE_NEON)
    SET(CMAKE_CXX_FLAGS -mfpu=neon)

  else(libviso2_FEATURE_NEON)
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3 -ffast-math -flto -march=armv8-a+crypto -mcpu=cortex-a57+crypto")
    add_definitions(-D__ARM_NEON__)

  endif(libviso2_FEATURE_NEON)
    
else(ARM_CROSS_COMPILATION)
  add_definitions(-msse3)
endif(ARM_CROSS_COMPILATION)

catkin_package(
  INCLUDE_DIRS libviso2/src
  LIBRARIES viso2
)

include_directories(libviso2/src
  ${catkin_INCLUDE_DIRS}
)

add_library(viso2
  libviso2/src/filter.cpp
  libviso2/src/matcher.cpp
  libviso2/src/matrix.cpp
  libviso2/src/reconstruction.cpp
  libviso2/src/triangle.cpp
  libviso2/src/viso.cpp
  libviso2/src/viso_mono.cpp
  libviso2/src/viso_mono_omnidirectional.cpp
  libviso2/src/viso_stereo.cpp)

install(TARGETS viso2
  ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

install(DIRECTORY ${PROJECT_NAME}/src/
  DESTINATION ${CATKIN_PACKAGE_INCLUDE_DESTINATION}
  PATTERN "*.cpp" EXCLUDE
)

