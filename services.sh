#!/bin/bash

DOCKER_PATH="$(cd -P -- "$(pwd)/.docker" && pwd -P)"

cd "${DOCKER_PATH}/"

if [[ "$1" == "build" ]]; then

  docker-compose stop
  docker-compose down
  docker-compose rm
  docker-compose build

fi

if [[ "$1" == "up" ]]; then

  docker-compose up -d
  docker-compose ps

fi

if [[ "$1" == "down" ]]; then

  docker-compose stop
  docker-compose down
  docker-compose ps

fi

if [[ "$1" == "bash" ]]; then

  SERVICE_BASH=$2

  if [[ "$SERVICE_BASH" == "" ]]; then
    SERVICE_BASH="php-fpm"
  fi

  docker exec -it $SERVICE_BASH bash;

fi
