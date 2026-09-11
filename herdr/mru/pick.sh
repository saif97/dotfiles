#!/usr/bin/env bash
# Recency-ordered picker, for a herdr popup pane.
#   pick.sh workspace | pick.sh agent
# Add --print to write the chosen id to stdout instead of focusing it.
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
mode="${2:-focus}"

read -r cur_ws cur_pane < <(mru_focused)

case "$kind" in
  workspace)
    rows=$(mru_workspace_rows)
    ranked=$(mru_rank workspace)
    current="$cur_ws"
    prompt="project> "
    ;;
  agent)
    rows=$(mru_agent_rows)
    ranked=$(mru_rank pane)
    current="$cur_pane"
    prompt="agent> "
    ;;
  *)
    echo "usage: pick.sh workspace|agent [--print]" >&2
    exit 2
    ;;
esac

# Where you are now goes in the header, not in the list. Then row one is always
# the place you would go back to, and Enter always moves you.
here=$(printf '%s\n' "$rows" | awk -F'\t' -v id="$current" '$1 == id { print $2; exit }')
rows=$(printf '%s\n' "$rows" | awk -F'\t' -v id="$current" '$1 != id')
[ -n "$rows" ] || exit 0

rankfile=$(mktemp) || exit 1
trap 'rm -f "$rankfile"' EXIT
printf '%s\n' "$ranked" >"$rankfile"

header="most recent first · esc cancels"
[ -n "$here" ] && header="here: ${here}   ${header}"

# MRU_FZF_OPTS is split on whitespace on purpose; the tests use it too.
# shellcheck disable=SC2086
selection=$(printf '%s\n' "$rows" |
  mru_order_by "$rankfile" |
  fzf --ansi \
      --no-sort \
      --delimiter='\t' \
      --with-nth=2.. \
      --prompt="$prompt" \
      --header="$header" \
      --height=100% \
      --layout=reverse \
      --info=inline \
      --cycle \
      ${MRU_FZF_OPTS:-}) || exit 0

id="${selection%%$'\t'*}"
[ -n "$id" ] || exit 0

if [ "$mode" = "--print" ]; then
  printf '%s\n' "$id"
  exit 0
fi

if [ "$kind" = workspace ]; then
  herdr workspace focus "$id" >/dev/null
else
  herdr agent focus "$id" >/dev/null
fi
