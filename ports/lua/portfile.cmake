vcpkg_download_distfile(ARCHIVE
    URLS "https://www.lua.org/ftp/lua-5.4.1.tar.gz"
    FILENAME "lua-5.4.1.tar.gz"
    SHA512 49ffbe814ec41e515fc8502b6958151c6c56aa171412f0b211ad9de934be2c958c3709d49435885ddea0fa6765ed511dafb3537558950ff3b4261338214f1571
)
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    PATCHES vs2015-impl-c99.patch
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DCOMPILE_AS_CPP=OFF
    OPTIONS_DEBUG
        -DSKIP_INSTALL_HEADERS=ON
        -DSKIP_INSTALL_TOOLS=ON
)

vcpkg_install_cmake()

set(ENABLE_LUA_CPP 0)
if("cpp" IN_LIST FEATURES)
    set(ENABLE_LUA_CPP 1)
    vcpkg_configure_cmake(
        SOURCE_PATH ${SOURCE_PATH}
        PREFER_NINJA
        OPTIONS
            -DCOMPILE_AS_CPP=ON
        OPTIONS_DEBUG
            -DSKIP_INSTALL_HEADERS=ON
            -DSKIP_INSTALL_TOOLS=ON
    )

    vcpkg_install_cmake()
endif()

vcpkg_copy_pdbs()

vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/lua)

if(VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    if(VCPKG_TARGET_IS_WINDOWS)
        file(READ ${CURRENT_PACKAGES_DIR}/include/luaconf.h LUA_CONF_H)
        string(REPLACE "defined(LUA_BUILD_AS_DLL)" "1" LUA_CONF_H "${LUA_CONF_H}")
        file(WRITE ${CURRENT_PACKAGES_DIR}/include/luaconf.h "${LUA_CONF_H}")
    endif()
endif()

# Handle post-build CMake instructions
configure_file(${CMAKE_CURRENT_LIST_DIR}/vcpkg-cmake-wrapper.cmake.in  ${CURRENT_PACKAGES_DIR}/share/${PORT}/vcpkg-cmake-wrapper.cmake @ONLY)
file(INSTALL ${CMAKE_CURRENT_LIST_DIR}/usage DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})

# Handle copyright
file(INSTALL ${CMAKE_CURRENT_LIST_DIR}/COPYRIGHT DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
