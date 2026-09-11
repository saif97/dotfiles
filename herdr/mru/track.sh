#!/usr/bin/env bash
# herdr event hook: record what has focus now.
# Bound to workspace.focused and pane.focused in herdr-plugin.toml.
# Keep this fast; herdr runs it on every focus change.
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

cd "$(mru_script_dir "$0")" || exit 0
source ./lib.sh

mkdir -p "$HERDR_MRU_DIR" || exit 0

# Read the focused ids from the server rather than from the event payload, so
# that one hook handles all three event kinds and stays correct if the payload
# shape changes.
read -r ws pane < <(mru_focused) || exit 0
[ -n "${ws:-}" ] || exit 0
[ "$ws" = "-" ] && exit 0

printf '%s %s %s\n' "$(mru_now_ms)" "$ws" "${pane:--}" >>"$HERDR_MRU_LOG"

# Trim now and then. The reader only needs the recent tail.
lines=$(wc -l <"$HERDR_MRU_LOG" 2>/dev/null || echo 0)
if [ "$lines" -gt "$HERDR_MRU_MAX_LINES" ]; then
  tail -n "$HERDR_MRU_KEEP_LINES" "$HERDR_MRU_LOG" >"$HERDR_MRU_LOG.tmp" &&
    mv "$HERDR_MRU_LOG.tmp" "$HERDR_MRU_LOG"
fi
exit 0
