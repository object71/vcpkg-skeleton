cmake_minimum_required(VERSION 3.16)

project(RaylibDoom)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(WIN32)
    add_compile_definitions(WINDOWS=1)
    include_directories(./vcpkg/installed/x64-windows/include)
    link_directories(./vcpkg/installed/x64-windows/lib)
endif ()

if (UNIX AND NOT APPLE)
    add_compile_definitions(LINUX=1)
    include_directories(./vcpkg/installed/x64-linux/include)
    link_directories(./vcpkg/installed/x64-linux/lib)
endif ()

if (APPLE)
    add_compile_definitions(APPLE=1)
    include_directories(./vcpkg/installed/x64-ios/include)
    link_directories(./vcpkg/installed/x64-ios/lib)
endif ()

if(${CMAKE_BUILD_TYPE} MATCHES Debug)
    add_compile_definitions(_DEBUG=1)
else()
    add_compile_definitions(NDEBUG=1)
endif(${CMAKE_BUILD_TYPE} MATCHES Debug)

add_subdirectory(Main)