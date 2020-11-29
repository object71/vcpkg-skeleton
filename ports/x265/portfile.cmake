vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO videolan/x265
    REF 07295ba7ab551bb9c1580fdaee3200f1b45711b7 #v3.4
    SHA512 21a4ef8733a9011eec8b336106c835fbe04689e3a1b820acb11205e35d2baba8c786d9d8cf5f395e78277f921857e4eb8622cf2ef3597bce952d374f7fe9ec29
    HEAD_REF master
    PATCHES
        disable-install-pdb.patch
)

set(ENABLE_ASSEMBLY OFF)
if (VCPKG_TARGET_IS_WINDOWS)
    vcpkg_find_acquire_program(NASM)
    get_filename_component(NASM_EXE_PATH ${NASM} DIRECTORY)
    set(ENV{PATH} "$ENV{PATH};${NASM_EXE_PATH}")
    set(ENABLE_ASSEMBLY ON)
endif ()

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" ENABLE_SHARED)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}/source
    PREFER_NINJA
    OPTIONS
        -DENABLE_ASSEMBLY=${ENABLE_ASSEMBLY}
        -DENABLE_SHARED=${ENABLE_SHARED}
    OPTIONS_DEBUG
        -DENABLE_CLI=OFF
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# remove duplicated include files
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

vcpkg_copy_tools(TOOL_NAMES x265 AUTO_CLEAN)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static" OR VCPKG_TARGET_IS_LINUX)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin)
endif()

if(WIN32 AND (NOT MINGW))
    if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
        vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/x265.pc" "-lx265" "-lx265-static")
        vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/x265.pc" "-lx265" "-lx265-static")
    endif()
endif()

if(UNIX)
    vcpkg_fixup_pkgconfig(SYSTEM_LIBRARIES numa)
else()
    vcpkg_fixup_pkgconfig()
endif()

# Handle copyright
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
