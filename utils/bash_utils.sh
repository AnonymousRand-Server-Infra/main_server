#!/usr/bin/env bash

set -euo pipefail
set -x

# IMPORTANT: since this script is sourced, do NOT change the working directory in here!

# this makes sure no errors are thrown if the container doesn't exist
function errorless_docker_down {
    container_name="$1"
    if docker inspect "$container_name" &> /dev/null; then
        docker stop "$container_name" && docker rm -v "$container_name"
    fi
}
