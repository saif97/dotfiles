
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
    devcontainer build --workspace-folder /Users/saif.hakeam/dotfiles

devcontainer-build-no-cache:
    devcontainer build --workspace-folder /Users/saif.hakeam/dotfiles --no-cache

devcontainer-up:
    devcontainer up --workspace-folder /Users/saif.hakeam/dotfiles

devcontainer-exec:
    devcontainer exec --workspace-folder /Users/saif.hakeam/dotfiles zsh

devcontainer-down:
    devcontainer down --workspace-folder /Users/saif.hakeam/dotfiles

