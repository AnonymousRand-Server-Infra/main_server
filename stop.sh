#!/usr/bin/env bash

set -ex

# this makes sure that this script always runs in its own directory so that it pulls
# the right `.env`, for instance (this should also be an absolute path)
script_path="$(dirname "$(realpath "${BASH_SOURCE[0]:-$0}")")"
cd "$script_path"

source ./.env

# still need this for `docker compose down` to succeed
chmod +x ./sync_dotenvs.sh
sudo -u "#$HOST_NONROOT_UID" bash ./sync_dotenvs.sh

# try this in our current directory first in case the services to stop were started by
# this project originally
docker compose --profile "$DOCKER_DEFAULT_PROFILE" down

# otherwise (e.g. if they were started by a nested docker project), we do a project-agnostic stop
# SYNC: containers!
docker stop nginx && docker rm -v nginx
docker stop iocaine && docker rm -v iocaine
docker stop personal_website && docker rm -v personal_website
docker stop personal_website_mysql && docker rm -v personal_website_mysql
docker stop personal_website_anubis && docker rm -v personal_website_anubis
docker stop git_server && docker rm -v git_server
docker stop git_server_mysql && docker rm -v git_server_mysql
docker stop git_server_anubis && docker rm -v git_server_anubis
docker stop mail_server && docker rm -v mail_server
docker stop mail_server_tachyon && docker rm -v mail_server_tachyon
docker stop mail_server_anubis && docker rm -v mail_server_anubis
