cmake_minimum_required(VERSION 3.16)

project(RaylibDoom)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(WIN32)
    add_compile_definitions(WINDOWS=1)
    
endif (WIN32)

if(${CMAKE_BUILD_TYPE} MATCHES Debug)
    add_compile_definitions(_DEBUG=1)
else()
    add_compile_definitions(NDEBUG=1)
endif(${CMAKE_BUILD_TYPE} MATCHES Debug)

include_directories(./vcpkg/installed/x64-windows/include)
link_directories(./vcpkg/installed/x64-windows/lib)

add_subdirectory(Doom)