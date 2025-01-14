# project
cmake_minimum_required(VERSION 3.0.2)
project (libviso2)

# directories
set (LIBVISO2_SRC_DIR src)

# include directory
include_directories("${LIBVISO2_SRC_DIR}")

option(ARM_CROSS_COMPILATION "ARM Cross Compilation" ON)


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

# sources
FILE(GLOB LIBVISO2_SRC_FILES "src/*.cpp")

# make release version
set(CMAKE_BUILD_TYPE Release)

# demo program
add_executable(viso2 ${LIBVISO2_SRC_FILES})
target_link_libraries (viso2 png)

