#!/usr/bin/env bash

set -ex

# this makes sure that this script always runs in its own directory so that it pulls
# the right `.env`, for instance (this should also be an absolute path)
script_path="$(dirname "$(realpath "${BASH_SOURCE[0]:-$0}")")"
cd "$script_path"

source ./.env

chmod +x ./sync_dotenvs.sh
sudo -u "#$HOST_NONROOT_UID" bash ./sync_dotenvs.sh

chmod +x ./stop.sh
./stop.sh

docker system prune --force
if [[ "$1" == "-d" ]]; then
    docker compose --profile "$DOCKER_DEFAULT_PROFILE" up --build --force-recreate -d
else
    docker compose --profile "$DOCKER_DEFAULT_PROFILE" up --build --force-recreate
fi
