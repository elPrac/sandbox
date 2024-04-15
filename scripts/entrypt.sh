#!/usr/bin/env bash
set -Eeuo pipefail
#set -x

. scripts/helper-func.sh

info "Configure Buildroot"

. scripts/config-broot.sh   # Configure build system
