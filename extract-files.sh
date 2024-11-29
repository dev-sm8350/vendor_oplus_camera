#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
# Copyright (C) 2022 Paranoid Android
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=camera
VENDOR=oplus

# Load extract utilities and do some sanity checks.
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction.
CLEAN_VENDOR=true

KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
        system_ext/priv-app/OplusCamera/OplusCamera.apk)
            split --bytes=20M -d "${2}" "${2}".part
            tmp_dir="${EXTRACT_TMP_DIR}/OplusCamera"
            $APKTOOL d -q "$2" -o "$tmp_dir" -f
            grep -rl "com.oneplus.gallery" "$tmp_dir" | xargs sed -i 's|"com.oneplus.gallery"|"com.google.android.apps.photos"|g'
            $APKTOOL b -q "$tmp_dir" -o "$2"
            rm -rf "$tmp_dir"
            split --bytes=20M -d "$2" "$2".part
            ;;
        odm/lib64/libSuperRaw.so | odm/lib64/libYTCommon.so | odm/lib64/liblvimfs_wrapper.so)
            "${PATCHELF}" --replace-needed "libstdc++.so" "libstdc++_vendor.so" "${2}"
            ;;
    esac
}

# Initialize the helper.
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"

split -b 20M proprietary/system_ext/priv-app/OplusCamera/OplusCamera.apk proprietary/system_ext/priv-app/OplusCamera/OplusCamera.part
