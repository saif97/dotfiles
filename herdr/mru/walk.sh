#!/usr/bin/env bash
# Walk the recency history without the picker.
#   walk.sh workspace back | walk.sh workspace forward
#   walk.sh agent back     | walk.sh agent forward
#
# The first "back" press freezes the ranking as it is then. Presses that follow
# inside HERDR_MRU_WALK_TIMEOUT_MS step further along that frozen list, so you
# can go back more than one item. "forward" retraces the same list toward where
# the walk started, and does nothing when no walk is open.
#
# The list stays frozen on purpose: focusing an item normally makes it the most
# recent one, and a live ranking would send every second press back to where you
# came from. Once the walk times out, the item you stopped on becomes the most
# recent one and "back" returns you, as before.
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
direction="${2:-back}"

case "$kind" in
  workspace | agent) ;;
  *) echo "usage: walk.sh workspace|agent [back|forward]" >&2; exit 2 ;;
esac
case "$direction" in
  back | forward) ;;
  *) echo "usage: walk.sh workspace|agent [back|forward]" >&2; exit 2 ;;
esac

read -r cur_ws cur_pane < <(mru_focused)

case "$kind" in
  workspace)
    current="$cur_ws"
    live="$(herdr workspace list | jq -r '.result.workspaces[].workspace_id')"
    ;;
  agent)
    current="$cur_pane"
    live="$(herdr agent list | jq -r '.result.agents[].pane_id')"
    ;;
esac

is_live() {
  [ -n "$1" ] && printf '%s\n' "$live" | grep -qxF -- "$1"
}

# Continue the open walk only when it is the same kind and you are still
# standing where it last put you. Moving by any other means ends it.
#
# Only back also asks that the walk be fresh, because back has two jobs: inside
# the window it steps deeper, and after it, it has to mean "go to the one before
# this" again. Forward has only the one job, so a pause must not kill it — you
# look at where you landed, decide it was the wrong turn, and come back.
cursor=0
walk_list=""
if head="$(mru_walk_head)"; then
  read -r w_kind w_cursor w_expected w_last <<<"$head"
  if [ "$w_kind" = "$kind" ] && [ "$w_expected" = "$current" ] &&
     { [ "$direction" = forward ] || mru_walk_fresh "$w_last"; }; then
    cursor="$w_cursor"
    walk_list="$(mru_walk_list)"
  fi
fi

# A new walk goes back from where you are; there is nothing to retrace forward.
if [ -z "$walk_list" ]; then
  [ "$direction" = forward ] && exit 0

  case "$kind" in
    workspace) ranked="$(mru_rank workspace)" ;;
    agent) ranked="$(mru_rank pane)" ;;
  esac

  # Where you are is index 0. Then the history, most recent first. Then whatever
  # is live but never focused, so the walk still moves on a cold history.
  walk_list="$(
    {
      printf '%s\n' "$current"
      while IFS= read -r id; do
        is_live "$id" && printf '%s\n' "$id"
      done <<<"$ranked"
      printf '%s\n' "$live"
    } | awk 'NF && !seen[$0]++'
  )"
  cursor=0
fi

items=()
while IFS= read -r id; do
  [ -n "$id" ] && items+=("$id")
done <<<"$walk_list"
[ "${#items[@]}" -gt 0 ] || exit 0

step=1
[ "$direction" = forward ] && step=-1

# Step over items that closed while the walk was open.
target=""
idx="$cursor"
while :; do
  idx=$((idx + step))
  [ "$idx" -lt 0 ] && break
  [ "$idx" -ge "${#items[@]}" ] && break
  candidate="${items[$idx]}"
  [ "$candidate" = "$current" ] && continue
  is_live "$candidate" || continue
  target="$candidate"
  break
done

# At either end of the list. Keep the walk open so the other direction still
# works, and stay put.
if [ -z "$target" ]; then
  mru_walk_save "$kind" "$cursor" "$current" "$walk_list"
  exit 0
fi

# Save before focusing: track.sh reads this state to tell a walk step apart
# from a focus you made yourself.
mru_walk_save "$kind" "$idx" "$target" "$walk_list"

if [ "$kind" = workspace ]; then
  herdr workspace focus "$target" >/dev/null
else
  herdr agent focus "$target" >/dev/null
fi
