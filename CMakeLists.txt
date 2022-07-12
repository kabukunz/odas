
project(odas C CXX)

set(CMAKE_CXX_STANDARD 17)

cmake_minimum_required(VERSION 2.8)

# eigen
find_package(Eigen3)

find_package(PkgConfig)

# JSONCPP
# https://github.com/open-source-parsers/jsoncpp/issues/455#issuecomment-283921965
pkg_check_modules(JSONCPP jsoncpp)
# link_libraries(${JSONCPP_LIBRARIES})
include_directories("/usr/local/include/json")
# include_directories("${JSONCPP_INCLUDE_DIRS}")
# target_link_libraries(myprogram ${JSONCPP_LIBRARIES})

# FIXME: wrong library version
# In file included from /Users/max/Developer/Library/Graphics/odas/test_odas.cpp:5:
# /Users/max/Developer/Library/Graphics/odas/odas/popot.hpp:7:10: fatal error: 'jsoncpp/json/json.h' file not found
# #include <jsoncpp/json/json.h>



# OPEN MP
if (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    message("-- Setting OpenMP flags on MacOs. Assuming `brew install libomp`")
    if(CMAKE_C_COMPILER_ID MATCHES "Clang")
        set(OpenMP_C_FLAGS "-Xpreprocessor -fopenmp -I/usr/local/opt/libomp/include" CACHE INTERNAL "OpenMP flags for Xcode toolchain.")
        set(OpenMP_C_LIB_NAMES "omp" CACHE INTERNAL "OpenMP lib name for Xcode toolchain.")
        set(OpenMP_omp_LIBRARY "/usr/local/opt/libomp/lib/libomp.dylib" CACHE INTERNAL "OpenMP lib name for Xcode toolchain.")
    endif()

    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        set(OpenMP_CXX_FLAGS "-Xpreprocessor -fopenmp -I/usr/local/opt/libomp/include" CACHE INTERNAL "OpenMP flags for Xcode toolchain.")
        set(OpenMP_CXX_LIB_NAMES "omp" CACHE INTERNAL "OpenMP lib name for Xcode toolchain.")
        set(OpenMP_omp_LIBRARY "/usr/local/opt/libomp/lib/libomp.dylib" CACHE INTERNAL "OpenMP lib name for Xcode toolchain.")
    endif()
endif()

find_package(OpenMP)
if (OPENMP_FOUND)
    # set (CMAKE_CXX_FLAGS "-Ofast -std=c++17 -I/usr/include/jsoncpp ${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
endif()

# PCL
find_package(PCL CONFIG 1.2 REQUIRED PATHS ${CMAKE_SOURCE_DIR}/../pcl/build/install/share/pcl-1.12)
include_directories(${PCL_INCLUDE_DIRS})
link_directories(${PCL_LIBRARY_DIRS})
add_definitions(${PCL_DEFINITIONS})

# NLOPT
find_package(NLOPT)
# SET(NLOPT_LIBRARIES "/usr/lib/x86_64-linux-gnu/libnlopt.so")

# POPT
# set(POPT_ROOT_DIR /usr/local/Cellar/popt/1.16)
# pkg_check_modules(POPT REQUIRED IMPORTED_TARGET myPopt)
# set(ENV{PKG_CONFIG_PATH} "/usr/local/Cellar/popt/1.16/lib/pkgconfig/popt.pc")
# pkg_check_modules(JSON jsoncpp REQUIRED)
pkg_search_module(POPT potp_odas)
# SET(POPOT_LIBRARIES "/usr/local/lib/libpopot.so")

# CMAES
find_package(libcmaes CONFIG REQUIRED PATHS ${CMAKE_SOURCE_DIR}/../libcmaes/build/install/lib/cmake/libcmaes)
# libcmaes::cmaes
get_target_property(LIBCMAES_INCLUDE_DIRS libcmaes::cmaes INTERFACE_INCLUDE_DIRECTORIES)
include_directories(${LIBCMAES_INCLUDE_DIRS})


# NSGA2 (unknown license)
# SET(NSGA2_LIBRARIES "/usr/local/lib/libnsga2.so")
# -- Install configuration: "Relase"
# -- Installing: /Users/max/Developer/Library/Graphics/nsga2-cpp/build/install/include/nsga2/global.h
# -- Installing: /Users/max/Developer/Library/Graphics/nsga2-cpp/build/install/include/nsga2/random.h
# -- Installing: /Users/max/Developer/Library/Graphics/nsga2-cpp/build/install/include/nsga2/NSGA2.h
# -- Installing: /Users/max/Developer/Library/Graphics/nsga2-cpp/build/install/include/nsga2/exception.h
# -- Installing: /Users/max/Developer/Library/Graphics/nsga2-cpp/build/install/lib/libnsga2.dylib
# -- Installing: /Users/max/Developer/Library/Graphics/nsga2-cpp/build/install/lib/static/libnsga2-static.a

add_library(NSGA2 STATIC IMPORTED)
set_property(TARGET NSGA2 PROPERTY IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/../nsga2-cpp/build/install/lib/static/libnsga2-static.a")
include_directories(odas "${CMAKE_SOURCE_DIR}/../nsga2-cpp/build/install/include")

# what's this linux lib?
# SET(NEWUOA_LIBRARIES "/usr/local/lib/libnewuoa.so")

set(SRC_LIST test_odas_new.cpp)

# aux_source_directory(. SRC_LIST)

add_executable(${PROJECT_NAME} ${SRC_LIST})

# set_target_properties(${PROJECT_NAME} PROPERTIES LINKER_LANGUAGE CXX)

target_link_libraries (${PROJECT_NAME} ${PCL_LIBRARIES})
target_link_libraries (${PROJECT_NAME} ${CMAES_LIBRARIES})
# target_link_libraries (${PROJECT_NAME} ${NLOPT_LIBRARIES})
# target_link_libraries (${PROJECT_NAME} ${POPOT_LIBRARIES})
# target_link_libraries (${PROJECT_NAME} ${NSGA2})
# target_link_libraries (${PROJECT_NAME} ${NEWUOA_LIBRARIES})

