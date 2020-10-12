#!/usr/bin/env bash

set -e

cd $(git rev-parse --show-toplevel)

source ./docker-config

if [[ $(git diff --stat HEAD .) != '' ]]; then
  echo "The repo is dirty. Please commit or stash!" >&2
  exit 1
fi

COMMIT_TAG=$(git describe)

if ! [[ $? -eq 0 ]]; then
  echo "The commit is not tagged. Please add annotated tag!" >&2
  exit 1
fi

sudo docker build -t "$DOCKER_CONTAINER:$COMMIT_TAG" .
