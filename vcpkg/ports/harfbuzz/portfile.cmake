vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO harfbuzz/harfbuzz
    REF 9c98b2b9a9e43669c5e2b37eaa41b1e07de1ede3 # 2.7.2
    SHA512 00b61034abce61370a7ff40bf5aa80bc1b3557d1f978ef91725fc30b34c4c00c682a3b9c99233e7e52d579b60694a1ba08714d5c9b01ad13e9fd76828facc720
    HEAD_REF master
    PATCHES
        0001-fix-cmake-export.patch
        0002-fix-uwp-build.patch
        0003-remove-broken-test.patch
        # This patch is required for propagating the full list of static dependencies from freetype
        find-package-freetype-2.patch
        # This patch is required for propagating the full list of dependencies from glib
        glib-cmake.patch
        fix_include.patch
        icu.patch
)

file(READ ${SOURCE_PATH}/CMakeLists.txt _contents)

if("${_contents}" MATCHES "include \\(FindFreetype\\)")
    message(FATAL_ERROR "Harfbuzz's cmake must not directly include() FindFreetype.")
endif()

if("${_contents}" MATCHES "find_library\\(GLIB_LIBRARIES")
    message(FATAL_ERROR "Harfbuzz's cmake must not directly find_library() glib.")
endif()

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    icu         HB_HAVE_ICU
    graphite2   HB_HAVE_GRAPHITE2
    glib        HB_HAVE_GLIB
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS ${FEATURE_OPTIONS}
        -DHB_HAVE_FREETYPE=ON
        -DHB_BUILD_TESTS=OFF
    OPTIONS_DEBUG
        -DSKIP_INSTALL_HEADERS=ON
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets()

vcpkg_copy_pdbs()

if ("glib" IN_LIST FEATURES)
    # Propagate dependency on glib downstream
    file(READ "${CURRENT_PACKAGES_DIR}/share/harfbuzz/harfbuzzConfig.cmake" _contents)
    file(WRITE "${CURRENT_PACKAGES_DIR}/share/harfbuzz/harfbuzzConfig.cmake" "
include(CMakeFindDependencyMacro)
find_dependency(unofficial-glib CONFIG)
    
${_contents}
")
endif()

# Handle copyright
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
