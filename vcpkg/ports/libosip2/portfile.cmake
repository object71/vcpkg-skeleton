set(LIBOSIP2_VER "5.1.0")

vcpkg_download_distfile(ARCHIVE
    URLS "https://ftp.gnu.org/gnu/osip/libosip2-${LIBOSIP2_VER}.tar.gz" "https://www.mirrorservice.org/sites/ftp.gnu.org/gnu/osip/libosip2-${LIBOSIP2_VER}.tar.gz"
    FILENAME "libosip2-${LIBOSIP2_VER}.tar.gz"
    SHA512 391c9a0ea399f789d7061b0216d327eecba5bbf0429659f4f167604b9e703e1678ba6f58079aa4f84b3636a937064ecfb92e985368164fcb679e95654e43d65b
)

vcpkg_extract_source_archive_ex(
    ARCHIVE ${ARCHIVE}
    OUT_SOURCE_PATH SOURCE_PATH
)

if(VCPKG_TARGET_IS_WINDOWS)
    set(OPTIONS --enable-mt=no)
endif()
vcpkg_configure_make(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS ${OPTIONS}
)

vcpkg_install_make()
vcpkg_fixup_pkgconfig()
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)