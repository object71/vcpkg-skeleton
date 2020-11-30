cmake_minimum_required(VERSION 3.16)
set(CMAKE_TOOLCHAIN_FILE ./vcpkg/scripts/buildsystems/vcpkg.cmake)

project(VcpkgSkeleton)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(raylib CONFIG REQUIRED)

if(WIN32)
    add_compile_definitions(WINDOWS=1)
endif ()

if (UNIX AND NOT APPLE)
    add_compile_definitions(LINUX=1)
endif ()

if (APPLE)
    add_compile_definitions(APPLE=1)
endif ()

if(${CMAKE_BUILD_TYPE} MATCHES Debug)
    add_compile_definitions(_DEBUG=1)
else()
    add_compile_definitions(NDEBUG=1)
endif(${CMAKE_BUILD_TYPE} MATCHES Debug)

add_subdirectory(Main)