#!/usr/bin/env bash
set -Eeuo pipefail

: "${rc:-1}"
readonly root_dir=/workdir
readonly broot_dir="${root_dir}"/buildroot
# TODO: Enable whenever we have a ext_broot_config
readonly BR_EXT_PATH="${broot_dir}/../buildroot-external-syzbot"
readonly BR_ARTIFACTS_PATH="${broot_dir}/output/images"


pushd "${broot_dir}"
if [ ! -d "${BR_ARTIFACTS_PATH}" ]; then
    # Configure buildroot for the very first time
    { make BR2_EXTERNAL="${BR_EXT_PATH}" qemu_x86_64_syzbot_defconfig ; rc=$?; } || :
    if (( rc != 0 )); then
        error "Can't  custom defconfig ($rc)" && exit 3
    fi
fi

