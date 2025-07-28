#!/usr/bin/env bash
set -Eeuo pipefail

env="${env:-buildroot}"

# Accept --env <value> or just a positional <value>
# meaning you can call build.sh either way:
# ./build.sh yocto      # Yocto
# ./build.sh buildroot  # Buildroot

if [[ $# -ge 1 ]]; then
    if [[ "$1" == "-e" || "$1" == "--env" ]]; then
        env="${2:-}"
        shift 2
    else
        env="$1"
        shift
    fi
fi

case "$env" in
    buildroot)
        docker_image="build/linux-sandbox:buildroot"
        base_image="debian:bookworm-slim"
        ;;
    yocto)
        docker_image="build/linux-sandbox:yocto"
        base_image="crops/poky:ubuntu-22.04"
        ;;
    *)
        echo "Usage: $0 [--env <buildroot|yocto>] OR $0 <buildroot|yocto>"
        exit 1
        ;;
esac

# Export for sourcing in start.sh
export docker_image

# Only build image if missing
if [[ -z "$(docker images -q "$docker_image" 2>/dev/null)" ]]; then
    pushd "$SCRIPT_DIR/build-docker" > /dev/null
    docker build --build-arg BASE_IMAGE="$base_image" -t "$docker_image" .
    popd > /dev/null
fi
