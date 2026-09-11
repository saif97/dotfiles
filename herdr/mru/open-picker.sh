#!/usr/bin/env bash
# Open one of the pickers as a herdr popup pane.
#   open-picker.sh workspaces | open-picker.sh agents
set -uo pipefail

# BSD readlink has no -f, so resolve the script directory by hand.
mru_script_dir() {
  local src="$1"
  while [ -L "$src" ]; do
    local dir
    dir="$(cd -P "$(dirname "$src")" && pwd)"
    src="$(readlink "$src")"
    case "$src" in /*) ;; *) src="$dir/$src" ;; esac
  done
  (cd -P "$(dirname "$src")" && pwd)
}

cd "$(mru_script_dir "$0")" || exit 1
source ./lib.sh

herdr plugin pane open \
  --plugin saif.herdr-mru \
  --entrypoint "${1:-workspaces}" \
  --placement popup \
  --width 60% \
  --height 60% >/dev/null
