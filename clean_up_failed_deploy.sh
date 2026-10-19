#!/usr/bin/env bash

set -euo pipefail
set -x

# IMPORTANT: this removes ALL docker containers on this host!
# `|| true` in case there were no containers
docker rm -f $(sudo docker ps -aq) || true

# note that this command won't work if you run it standalone since then the glob is evaluated before
# the `sudo` (whereas here we run this whole script with `sudo`), unless you do `bash -c '...'`
# SYNC: the socket volume's path on the host!
rm -f /var/lib/docker/volumes/shared_sckts/_data/*
