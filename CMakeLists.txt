cmake_minimum_required(VERSION 3.14)

project(rematchpy)

set(REmatch_ROOT ${PROJECT_SOURCE_DIR}/REmatch)

find_package(SWIG 4.0 COMPONENTS python)

if(NOT Python3_INCLUDE_DIRS)
  IF(PYTHON_VERSION)
    find_package(Python3 ${PYTHON_VERSION} EXACT REQUIRED COMPONENTS Development)
  else()
    find_package(Python3 REQUIRED COMPONENTS Interpreter Development)
  endif()
endif()

include(${SWIG_USE_FILE})

set(CMAKE_SWIG_OUTDIR "${PROJECT_SOURCE_DIR}/python/packages/pyrematch")

# Use static libgcc and libstdc++
if(NOT APPLE)
  string(CONCAT CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} "
                                "-static-libgcc")
endif()

string(CONCAT CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} "
                              "-static-libstdc++")

# Include Python 3 include dirs
include_directories(SYSTEM ${Python3_INCLUDE_DIRS})

include_directories(SYSTEM ${REmatch_ROOT}/thirdparty)
include_directories(${REmatch_ROOT}/src)

find_package(Boost 1.58 REQUIRED)
include_directories(SYSTEM ${Boost_INCLUDE_DIRS})

set(SWIG ON)

add_subdirectory(REmatch)

add_subdirectory(src)