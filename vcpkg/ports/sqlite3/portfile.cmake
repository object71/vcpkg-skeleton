set(SQLITE_VERSION 3330000)
set(SQLITE_HASH a9cb038c82dcafe1b5aa410f60bff21066b3e3456161bc91829a1a3b3b6591e0595209f45d4a6b10b0ad08e88df3f1b2062d4b075205e32d34780da7dea3e07b)

vcpkg_download_distfile(ARCHIVE
    URLS "https://sqlite.org/2020/sqlite-amalgamation-${SQLITE_VERSION}.zip"
    FILENAME "sqlite-amalgamation-${SQLITE_VERSION}.zip"
    SHA512 ${SQLITE_HASH}
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${SQLITE_VERSION}
    PATCHES fix-arm-uwp.patch
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
    geopoly WITH_GEOPOLY
    json1 WITH_JSON1
    INVERTED_FEATURES
    tool SQLITE3_SKIP_TOOLS
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS ${FEATURE_OPTIONS}
    OPTIONS_DEBUG
        -DSQLITE3_SKIP_TOOLS=ON
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH share/unofficial-${PORT} TARGET_PATH share/unofficial-${PORT})

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

if(NOT SQLITE3_SKIP_TOOLS AND EXISTS ${CURRENT_PACKAGES_DIR}/tools/sqlite3-bin${VCPKG_HOST_EXECUTABLE_SUFFIX})
    file(RENAME ${CURRENT_PACKAGES_DIR}/tools/sqlite3-bin${VCPKG_HOST_EXECUTABLE_SUFFIX} ${CURRENT_PACKAGES_DIR}/tools/sqlite3${VCPKG_HOST_EXECUTABLE_SUFFIX})
endif()

configure_file(
    ${CMAKE_CURRENT_LIST_DIR}/sqlite3-config.in.cmake
    ${CURRENT_PACKAGES_DIR}/share/unofficial-${PORT}/unofficial-sqlite3-config.cmake
    @ONLY
)

file(WRITE ${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright "SQLite is in the Public Domain.\nhttp://www.sqlite.org/copyright.html\n")
vcpkg_copy_pdbs()
