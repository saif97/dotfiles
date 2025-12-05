
default:
    just --justfile {{justfile()}} --list

hello:
    echo "Hello from global justfile!"

sync-ai-markedown-files:
    @./sync_ai_md.sh

adb-uninstall-apps:
    ./scripts/uninstall_all_apps.sh

# Dev Container commands
devcontainer-build:
    devcontainer build --workspace-folder .

devcontainer-build-no-cache:
    devcontainer build --workspace-folder . --no-cache

devcontainer-up:
    devcontainer up --workspace-folder .

devcontainer-exec:
    devcontainer exec --workspace-folder . zsh

devcontainer-down:
    devcontainer down --workspace-folder /Users/saif.hakeam/dotfiles

