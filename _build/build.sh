#!/bin/sh

# Move file for use with mf, read more at https://github.com/greeenlaser/personal-stash/tree/main/mf

set -e

#
# References
#

KMAKE_ORIGIN=project.kmake

LICENSE_ORIGIN=../LICENSE
LICENSE_TARGET=LICENSE

SRC_ORIGIN=..
SRC_TARGET=src
INCLUDE_ORIGIN=..
INCLUDE_TARGET=include

case "$1" in
    --linux)
        BUILD_RELEASE="--compile ${KMAKE_ORIGIN} release-linux"
        BUILD_DEBUG="--compile ${KMAKE_ORIGIN} debug-linux"
        ;;
    --windows-gnu)
        BUILD_RELEASE="--compile ${KMAKE_ORIGIN} release-windows-gnu"
        BUILD_DEBUG="--compile ${KMAKE_ORIGIN} debug-windows-gnu"
        ;;
    --windows)
        BUILD_RELEASE="--compile ${KMAKE_ORIGIN} release-windows"
        BUILD_DEBUG="--compile ${KMAKE_ORIGIN} debug-windows"
        ;;
    *)
        echo "Error: Argument must be --linux, --windows-gnu or --windows" >&2
        exit 1
        ;;
esac

#
# Copy sources, headers and license
#

if [ -d "${SRC_TARGET}" ]; then
    rm -rf "${SRC_TARGET}"
fi
mkdir "${SRC_TARGET}"

if [ -d "${INCLUDE_TARGET}" ]; then
    rm -rf "${INCLUDE_TARGET}"
fi
mkdir "${INCLUDE_TARGET}"

mf --o --f "${LICENSE_ORIGIN}" --t "${LICENSE_TARGET}"

# Source files

mf --f "${SRC_ORIGIN}/lodepng.cpp" --t "${SRC_TARGET}/lodepng.cpp"

# Headers

mf --f "${INCLUDE_ORIGIN}/lodepng.h" --t "${INCLUDE_TARGET}/lodepng.h"

#
# Compile
#

kalamake ${BUILD_RELEASE} && kalamake ${BUILD_DEBUG}

#
# Cleanup
#

# Only delete src but keep include because its needed by the libraries
rm -rf "${SRC_TARGET}"

rm -rf "release/obj"
rm -rf "debug/obj"
