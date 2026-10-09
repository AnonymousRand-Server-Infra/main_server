#!/usr/bin/env bash

set -ex

# this makes sure that this script always runs in its own directory so that it pulls
# the right `.env`, for instance (this should also be an absolute path)
script_path="$(dirname "$(realpath "${BASH_SOURCE[0]:-$0}")")"
cd "$script_path"

source .env

chmod +x ./sync_dotenvs.sh
sudo -u "#$HOST_NONROOT_UID" bash ./sync_dotenvs.sh

# try this in our current directory first in case the services to restart were started by
# this project originally
docker compose --profile "$DOCKER_DEFAULT_PROFILE" down

# otherwise (e.g. if they were started by a nested docker project), we do a project-agnostic restart
docker stop nginx && docker rm -v nginx
docker stop iocaine && docker rm -v iocaine
docker stop personal_website && docker rm -v personal_website
docker stop personal_website_mysql && docker rm -v personal_website_mysql
docker stop personal_website_anubis && docker rm -v personal_website_anubis
docker stop mail_server && docker rm -v mail_server
docker stop mail_server_tachyon && docker rm -v mail_server_tachyon
docker stop mail_server_anubis && docker rm -v mail_server_anubis

docker system prune --force
## for some reason only running the `docker compose build` part of these scripts
## fails to see changes
#./proxy/nginx/deploy.sh --no-stop
#./services/personal_website/deploy.sh --no-stop
docker compose --profile "$DOCKER_DEFAULT_PROFILE" up --build
