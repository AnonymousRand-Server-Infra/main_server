#!/usr/bin/env bash

set -ex

# this makes sure that this script always runs in its own directory so that it pulls
# the right `.env`, for instance (this should also be an absolute path)
script_path="$(dirname "$(realpath "${BASH_SOURCE[0]:-$0}")")"
cd "$script_path"

source ./.env
path_to_utils="$PATH_FROM_ROOT_TO_UTILS"

chmod +x "$path_to_utils/sync_dotenvs.sh" && "$path_to_utils/sync_dotenvs.sh"
chmod +x ./stop.sh && ./stop.sh

docker system prune --force

# manually build all dockerfiles with `--no-cache` to see all possible changes
# SYNC: directories which have dockerfiles!
docker compose --profile "$DOCKER_DEFAULT_PROFILE" \
    --project-directory ./proxy/nginx/ build --no-cache
docker compose --profile "$DOCKER_DEFAULT_PROFILE" \
    --project-directory ./proxy/anubis/ build --no-cache
docker compose --profile "$DOCKER_DEFAULT_PROFILE" \
    --project-directory ./proxy/iocaine/ build --no-cache
docker compose --profile "$DOCKER_DEFAULT_PROFILE" \
    --project-directory ./services/personal_website/ build --no-cache
docker compose --profile "$DOCKER_DEFAULT_PROFILE" \
    --project-directory ./services/mail_server/ build --no-cache

if [[ "$1" == "-d" ]]; then
    docker compose --profile "$DOCKER_DEFAULT_PROFILE" up --force-recreate -d
else
    docker compose --profile "$DOCKER_DEFAULT_PROFILE" up --force-recreate
fi
