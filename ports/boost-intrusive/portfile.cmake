# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/intrusive
    REF boost-1.74.0
    SHA512 d089f07ee9fe84fb63a279138f954731f525cae1b5c7800f76d1c79ec11239d89743c7c8222d00e9cb7134b020b0c67730ed7bf67c1f111e8758e16bd2b5d20e
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
