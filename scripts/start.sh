#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail -o errtrace
# set -x
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly root_dir="$(readlink -f $SCRIPT_DIR/../)"

. $SCRIPT_DIR/build-docker/build.sh


# TODO:
# Docker opt needed for bridged net-stack
#--device=/dev/vhost-net
#--device-cgroup-rule='c *:* rwm'
#-p 80:8080/tcp
#-p 2222:22/tcp
#--cap-add NET_ADMIN

cmd=${@:-"bash"}
docker_opts=(
    --rm
    --interactive
    --tty
    --volume ${root_dir}:/workdir
    $docker_image
    bash -c "$cmd"
)
docker run ${docker_opts[@]}
