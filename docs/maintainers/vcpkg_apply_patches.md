# vcpkg_apply_patches

Apply a set of patches to a source tree. This function is deprecated in favor of the `PATCHES` argument to `vcpkg_from_github()` et al.

## Usage
```cmake
vcpkg_apply_patches(
    SOURCE_PATH <${SOURCE_PATH}>
    [QUIET]
    PATCHES <patch1.patch>...
)
```

## Parameters
### SOURCE_PATH
The source path in which apply the patches. By convention, this is usually set in the portfile as the variable `SOURCE_PATH`.

### PATCHES
A list of patches that are applied to the source tree.

Generally, these take the form of `${CMAKE_CURRENT_LIST_DIR}/some.patch` to select patches in the `port\<port>\` directory.

### QUIET
Disables the warning message upon failure.

This should only be used for edge cases, such as patches that are known to fail even on a clean source tree.

## Examples

* [libbson](https://github.com/Microsoft/vcpkg/blob/master/ports/libbson/portfile.cmake)
* [gdal](https://github.com/Microsoft/vcpkg/blob/master/ports/gdal/portfile.cmake)

## Source
[scripts/cmake/vcpkg_apply_patches.cmake](https://github.com/Microsoft/vcpkg/blob/master/scripts/cmake/vcpkg_apply_patches.cmake)
