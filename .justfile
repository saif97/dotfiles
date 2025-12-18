set shell := ['bash', '-euc']

default:
    @just --list

ensure-ai:
    @./sync_ai_md.sh

Karabiener-TS-build:
    cd karabinerTS && npm run build

build-dev-container-base-image:
    #!/usr/bin/env bash
    docker compose -f devContainer/docker-compose.yml build 

# terminal
build-dev-container-bust-cache:
    #!/usr/bin/env bash
    docker compose -f devContainer/docker-compose.yml build --build-arg CACHEBUST=$(date +%s)
    
run-dev-container:
    docker compose -f devContainer/docker-compose.yml run --rm dev

