#!/usr/bin/env bash

# Log func
info () { printf "%b%s%b" "\E[1;34m❯ \E[1;36m" "$1" "\E[0m\n"; }
error () { printf "%b%s%b" "\E[1;31m❯ " "ERROR: $1" "\E[0m\n" >&2; }

# Keep stack quiet
pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

