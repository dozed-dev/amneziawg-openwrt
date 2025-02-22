#!/usr/bin/env bash
# apk v3 repository index control tool
# TODO: add signing + verifying with signatures

set -euxo pipefail

usage() {
    echo "usage: $(basename "$0") {create,verify,dump} pkg_path" >&2
    exit 1
}

if [ $# -lt 2 ]; then
    usage
fi

ACTION="$1"
PKG_PATH="$2"

if [ ! -d "${PKG_PATH}" ]; then
    echo "${PKG_PATH}: directory not found" >&2
    exit 1
fi

case "${ACTION}" in
    create)
        echo "Creating packages.adb index in ${PKG_PATH}" >&2
        ( cd "${PKG_PATH}" && ${APK} mkndx --allow-untrusted --output packages.adb -- *.apk )
        ;;
    verify)
        echo "Verifying packages.adb in ${PKG_PATH}" >&2
        ${APK} verify --allow-untrusted "${PKG_PATH}/packages.adb"
        ;;
    dump)
        echo "Dumping packages.adb in ${PKG_PATH}" >&2
        ${APK} adbdump "${PKG_PATH}/packages.adb" | tee "${PKG_PATH}/packages.adb.txt"
        ;;
    *)
        echo "unknown action: ${ACTION}" >&2
        usage
esac
