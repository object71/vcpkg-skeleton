# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/rational
    REF boost-1.74.0
    SHA512 b1641e1ad4740210232c2d71f764be3e4d7066348c80d0153d89f998cef05a763b4dfd6934cdbe4a085f74e10f645f74544e51900e9dea1c4be5a72f3809fb0f
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
