
default:
    @just --list

ensure-ai:
    @./sync_ai_md.sh

Karabiener-TS-build:
    cd karabinerTS && npm run build

build-dev-container bust="false":
    #!/usr/bin/env bash
    cd ./devContainer
    CACHE_FLAG=""
    if [ "{{bust}}" == "true" ]; then
        echo "Busting cache..."
        CACHE_FLAG="--build-arg CACHEBUST=$(date +%s)"
    fi
    docker build $CACHE_FLAG --platform linux/amd64 -t dev_container -f devContainer/dockerfile .

