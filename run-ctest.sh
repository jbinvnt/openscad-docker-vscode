#!/bin/bash
cd "$(dirname "$0")"
DOCKER_BUILDKIT=1 COMPOSE_DOCKER_CLI_BUILD=1 BUILD_TYPE=Release docker-compose -f docker-compose.yml -f docker-compose-ctest.yml build
DOCKER_BUILDKIT=1 COMPOSE_DOCKER_CLI_BUILD=1 BUILD_TYPE=Release docker-compose -f docker-compose.yml -f docker-compose-ctest.yml run openscad