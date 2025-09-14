#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail -o errtrace
set -x

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly root_dir="$(readlink -f "$SCRIPT_DIR/../")"
readonly WORK_DIR="/workdir"
readonly OEROOT="$WORK_DIR/sources/openembedded-core"
readonly TEMPLATECONF="$WORK_DIR/sources/openembedded-core/meta/conf/templates/default"
readonly BUILDDIR="$WORK_DIR/build_sandbox"

# Add 
OE_INIT_BUILD_CMD="source $OEROOT/oe-init-build-env $BUILDDIR"
OE_BB_INIT_CMD="$OE_INIT_BUILD_CMD && bash"
env="${env:-buildroot}"
cmd_args=()

# Parse environment selection only
while [[ $# -gt 0 ]]; do
    case "$1" in
        -e|--env)
            env="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [-e|--env <buildroot|yocto>] [command]"
            exit 0
            ;;
        *)
            cmd_args+=("$1")
            shift
            ;;
    esac
done

# Call build.sh with --env and source it to get docker_image
. $SCRIPT_DIR/build-docker/build.sh --env "$env"

cmd="${cmd_args[*]:-$OE_BB_INIT_CMD}"

# Docker opts
docker_opts=(
    --rm
    --interactive
    --network host
    --tty
    --env OEROOT=$OEROOT
    --env TEMPLATECONF=$TEMPLATECONF
    --volume "$root_dir:$WORK_DIR"
    --workdir $WORK_DIR
    "$docker_image"
    bash -c "$cmd"
)

# TODO:
# --device=/dev/vhost-net
# --device-cgroup-rule='c *:* rwm'
# -p 80:8080/tcp
# -p 2222:22/tcp
# --cap-add NET_ADMIN

docker run "${docker_opts[@]}"