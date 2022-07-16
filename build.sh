#!/bin/bash

export CMAKE_SOURCE_DIR=.
export CMAKE_BUILD_DIR=build
export CMAKE_BUILD_TYPE=Release
# export CMAKE_INSTALL_PREFIX=/usr/local

rm -rf "${CMAKE_BUILD_DIR}/CMakeCache.txt"

cmake \
-DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
-S ${CMAKE_SOURCE_DIR} \
-B ${CMAKE_BUILD_DIR} \
-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} \
-G Ninja

# cmake --build build
