vcpkg_fail_port_install(ON_TARGET "uwp")

if(VCPKG_TARGET_IS_LINUX)
    message("${PORT} currently requires the following tools and libraries from the system package manager:\n    autoreconf\n    libudev\n\nThese can be installed on Ubuntu systems via apt-get install autoreconf libudev-dev")
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libusb/libusb
    REF e782eeb2514266f6738e242cdcb18e3ae1ed06fa # v1.0.23
    SHA512 27cfff4bbf64d5ec5014acac0871ace74b6af76141bd951309206f4806e3e3f2c7ed32416f5b55fd18d033ca5494052eb2e50ed3cc0be10839be2bd4168a9d4c
    HEAD_REF master
)

if(VCPKG_TARGET_IS_WINDOWS)
  if(VCPKG_PLATFORM_TOOLSET MATCHES "v142")
    set(MSVS_VERSION 2017)  #they are abi compatible, so it should work
  elseif(VCPKG_PLATFORM_TOOLSET MATCHES "v141")
    set(MSVS_VERSION 2017)
  else()
    set(MSVS_VERSION 2015)
  endif()

  if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
      set(LIBUSB_PROJECT_TYPE dll)
      if (VCPKG_CRT_LINKAGE STREQUAL static)
        file(READ "${SOURCE_PATH}/msvc/libusb_${LIBUSB_PROJECT_TYPE}_${MSVS_VERSION}.vcxproj" PROJ_FILE)
        string(REPLACE "<RuntimeLibrary>MultiThreadedDLL</RuntimeLibrary>" "<RuntimeLibrary>MultiThreaded</RuntimeLibrary>" PROJ_FILE "${PROJ_FILE}")
        string(REPLACE "<RuntimeLibrary>MultiThreadedDebugDLL</RuntimeLibrary>" "<RuntimeLibrary>MultiThreadedDebug</RuntimeLibrary>" PROJ_FILE "${PROJ_FILE}")
        file(WRITE "${SOURCE_PATH}/msvc/libusb_${LIBUSB_PROJECT_TYPE}_${MSVS_VERSION}.vcxproj" "${PROJ_FILE}")
      endif()
  else()
      set(LIBUSB_PROJECT_TYPE static)
      if (VCPKG_CRT_LINKAGE STREQUAL dynamic)
        file(READ "${SOURCE_PATH}/msvc/libusb_${LIBUSB_PROJECT_TYPE}_${MSVS_VERSION}.vcxproj" PROJ_FILE)
        string(REPLACE "<RuntimeLibrary>MultiThreaded</RuntimeLibrary>" "<RuntimeLibrary>MultiThreadedDLL</RuntimeLibrary>" PROJ_FILE "${PROJ_FILE}")
        string(REPLACE "<RuntimeLibrary>MultiThreadedDebug</RuntimeLibrary>" "<RuntimeLibrary>MultiThreadedDebugDLL</RuntimeLibrary>" PROJ_FILE "${PROJ_FILE}")
        file(WRITE "${SOURCE_PATH}/msvc/libusb_${LIBUSB_PROJECT_TYPE}_${MSVS_VERSION}.vcxproj" "${PROJ_FILE}")
      endif()
  endif()

  # The README file in the archive is a symlink to README.md 
  # which causes issues with the windows MSBUILD process
  file(REMOVE ${SOURCE_PATH}/README)

  vcpkg_install_msbuild(
      SOURCE_PATH ${SOURCE_PATH}
      PROJECT_SUBPATH msvc/libusb_${LIBUSB_PROJECT_TYPE}_${MSVS_VERSION}.vcxproj
      LICENSE_SUBPATH COPYING
  )
  file(INSTALL ${SOURCE_PATH}/libusb/libusb.h  DESTINATION ${CURRENT_PACKAGES_DIR}/include/libusb-1.0)
else()
    vcpkg_configure_make(
        SOURCE_PATH ${SOURCE_PATH}
        AUTOCONFIG
    )
    vcpkg_install_make()
endif()

configure_file(${CURRENT_PORT_DIR}/usage ${CURRENT_PACKAGES_DIR}/share/${PORT}/usage @ONLY)
file(INSTALL ${CURRENT_PORT_DIR}/vcpkg-cmake-wrapper.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
