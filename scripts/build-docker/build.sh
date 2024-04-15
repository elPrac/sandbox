#!/usr/bin/env bash
set -Eeuo pipefail
docker_image=build/linux-mentee:buildroot
# Look if there's already an img for us
if [[ "$(docker images -q $docker_image 2> /dev/null)" == "" ]]; then
    # If not build it
	pushd $SCRIPT_DIR/build-docker
	docker build -t $docker_image .
	popd
fi

