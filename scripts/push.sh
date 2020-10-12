#!/usr/bin/env bash

set -e

cd $(git rev-parse --show-toplevel)

source ./docker-config

COMMIT_TAG=$(git describe)

if ! [[ $? -eq 0 ]]; then
  echo "The commit is not tagged. Please add annotated tag!" >&2
  exit 1
fi

if [[ $(git ls-remote --tags origin | grep -c "refs/tags/$COMMIT_TAG") -eq 0 ]]; then
  echo "The tag has not been push to origin!" >&2
  exit 1
fi

# Push
sudo docker tag "$DOCKER_CONTAINER:$COMMIT_TAG" "$DOCKER_REGISTRY/$DOCKER_CONTAINER:$COMMIT_TAG"
sudo docker push "$DOCKER_REGISTRY/$DOCKER_CONTAINER:$COMMIT_TAG"

BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [[ "$BRANCH" == "master" ]]; then
  # Push with 'latest' tag
  sudo docker tag "$DOCKER_REGISTRY/$DOCKER_CONTAINER:$COMMIT_TAG" "$DOCKER_REGISTRY/$DOCKER_CONTAINER:latest"
  sudo docker push "$DOCKER_REGISTRY/$DOCKER_CONTAINER:latest"
fi
