#!/usr/bin/env bash
# Go back and forth without the picker.
#   toggle.sh workspace   -> the workspace you were in before this one
#   toggle.sh agent       -> the agent you were in before this one
# Focusing the target records it too, so pressing the key again returns you.
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

kind="${1:-workspace}"
read -r cur_ws cur_pane < <(mru_focused)

case "$kind" in
  workspace)
    current="$cur_ws"
    live=()
    while IFS= read -r _id; do [ -n "$_id" ] && live+=("$_id"); done \
      < <(herdr workspace list | jq -r '.result.workspaces[].workspace_id')
    ranked=$(mru_rank workspace)
    ;;
  agent)
    current="$cur_pane"
    live=()
    while IFS= read -r _id; do [ -n "$_id" ] && live+=("$_id"); done \
      < <(herdr agent list | jq -r '.result.agents[].pane_id')
    ranked=$(mru_rank pane)
    ;;
  *)
    echo "usage: toggle.sh workspace|agent" >&2
    exit 2
    ;;
esac

is_live() {
  local id="$1" x
  [ "${#live[@]}" -eq 0 ] && return 1
  for x in "${live[@]}"; do [ "$x" = "$id" ] && return 0; done
  return 1
}

# The first item in the history that is not where we are and still exists.
target=""
while read -r id; do
  [ -n "$id" ] || continue
  [ "$id" = "$current" ] && continue
  is_live "$id" || continue
  target="$id"
  break
done <<<"$ranked"

# Cold history: fall back to any other live item, so the key still does
# something sensible on the first press after a restart.
if [ -z "$target" ] && [ "${#live[@]}" -gt 0 ]; then
  for id in "${live[@]}"; do
    [ "$id" = "$current" ] && continue
    target="$id"
    break
  done
fi

[ -n "$target" ] || exit 0

if [ "$kind" = workspace ]; then
  herdr workspace focus "$target" >/dev/null
else
  herdr agent focus "$target" >/dev/null
fi
