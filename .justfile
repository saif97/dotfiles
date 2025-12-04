set shell := ['bash', '-euc']

default:
    @just --list

ensure-ai:
    @./sync_ai_md.sh

Karabiener-TS-build:
    cd karabinerTS && npm run build

build-dev-container bust="false":
    #!/usr/bin/env bash
    BUILD_ARGS=""
    if [ "{{bust}}" == "true" ]; then
        echo "Busting cache..."
        BUILD_ARGS="--build-arg CACHEBUST=$(date +%s)"
    fi
    docker compose -f devContainer/docker-compose.yml build $BUILD_ARGS

run-dev-container:
    docker compose -f devContainer/docker-compose.yml run --rm dev

