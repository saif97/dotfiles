
default:
    @just --list

ensure-ai:
    @./sync_ai_md.sh

Karabiener-TS-build:
	cd karabinerTS && npm run build
