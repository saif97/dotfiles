# shellcheck shell=bash
# Shared state, ranking, and rendering for the herdr MRU switcher.

# herdr event hooks run with a bare environment: no HOME, and a short PATH.
# Restore HOME first, because the herdr CLI needs it to find its config dir.
if [ -z "${HOME:-}" ]; then
  HOME="$(getent passwd "$(id -u)" 2>/dev/null | cut -d: -f6)"
  [ -n "$HOME" ] && export HOME
fi

HERDR_MRU_DIR="${HERDR_MRU_DIR:-${XDG_STATE_HOME:-${HOME:-/tmp}/.local/state}/herdr-mru}"
HERDR_MRU_LOG="$HERDR_MRU_DIR/focus.log"
HERDR_MRU_WALK_STATE="$HERDR_MRU_DIR/walk.state"

# An item must hold focus this long (ms) before it enters the history.
# This keeps pane cycling (prefix+tab) from filling the list with items
# you only passed through.
HERDR_MRU_DWELL_MS="${HERDR_MRU_DWELL_MS:-900}"
# How long a walk stays open (ms). A press inside this window steps further
# along the list the walk froze; a later press starts a new walk from the
# ranking as it is then. It is also the dwell a walk stop must hold before it
# counts as a visit, so passing through does not reorder the history.
HERDR_MRU_WALK_TIMEOUT_MS="${HERDR_MRU_WALK_TIMEOUT_MS:-3000}"
HERDR_MRU_MAX_LINES="${HERDR_MRU_MAX_LINES:-2000}"
HERDR_MRU_KEEP_LINES="${HERDR_MRU_KEEP_LINES:-500}"

# herdr event hooks run with a bare PATH, so resolve the binary once.
HERDR_BIN="${HERDR_BIN:-$(command -v herdr 2>/dev/null || true)}"
if [ -z "$HERDR_BIN" ]; then
  for _cand in "${HOME:-}/.local/bin/herdr" /usr/local/bin/herdr /opt/homebrew/bin/herdr /usr/bin/herdr; do
    [ -x "$_cand" ] && { HERDR_BIN="$_cand"; break; }
  done
  unset _cand
fi

# Call sites keep saying "herdr"; command bypasses this function, so there is
# no recursion.
herdr() {
  [ -n "$HERDR_BIN" ] || { echo "herdr-mru: herdr binary not found" >&2; return 127; }
  command "$HERDR_BIN" "$@"
}

# Milliseconds since the epoch, with no subprocess (bash 5 builtin).
mru_now_ms() {
  local r="${EPOCHREALTIME:-}"
  if [[ $r =~ ^([0-9]+)[.,]([0-9]{3}) ]]; then
    printf '%s%s\n' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
  else
    printf '%s000\n' "$(date +%s)"
  fi
}

# Ranked ids, most recent first, one per line.
#   mru_rank workspace   -> workspace ids
#   mru_rank pane        -> pane ids
# Consecutive focuses of the same id count as one visit. A visit shorter
# than HERDR_MRU_DWELL_MS is dropped. A visit a walk made (field 4 is "w")
# must instead outlast HERDR_MRU_WALK_TIMEOUT_MS, which is the point where the
# walk is over and you have stayed: steps you only passed through leave the
# history as it was. Lines written before field 4 existed read as normal ones.
mru_rank() {
  local field
  case "$1" in
    workspace) field=2 ;;
    pane) field=3 ;;
    *) return 1 ;;
  esac
  [ -f "$HERDR_MRU_LOG" ] || return 0
  awk -v f="$field" -v now="$(mru_now_ms)" -v dwell="$HERDR_MRU_DWELL_MS" \
      -v walkdwell="$HERDR_MRU_WALK_TIMEOUT_MS" '
    function need() { return curwalk ? walkdwell : dwell }
    {
      ts = $1 + 0
      id = $(f)
      if (id == "" || id == "null" || id == "-") next
      if (id != cur) {
        if (cur != "" && ts - start >= need()) runs[++n] = cur
        cur = id
        start = ts
        curwalk = ($4 == "w")
      } else if ($4 != "w") {
        # A focus you made yourself ends the walk claim on this run.
        curwalk = 0
      }
    }
    END {
      if (cur != "" && now - start >= need()) runs[++n] = cur
      for (i = n; i >= 1; i--)
        if (!(runs[i] in seen)) { seen[runs[i]] = 1; print runs[i] }
    }
  ' "$HERDR_MRU_LOG"
}

# Walk state. Line 1 is "kind cursor expected_id last_ms"; the lines after it
# are the frozen id list, index 0 first, one per line.
mru_walk_head() {
  [ -f "$HERDR_MRU_WALK_STATE" ] || return 1
  head -n 1 "$HERDR_MRU_WALK_STATE"
}

mru_walk_list() {
  [ -f "$HERDR_MRU_WALK_STATE" ] || return 1
  tail -n +2 "$HERDR_MRU_WALK_STATE"
}

# mru_walk_save <kind> <cursor> <expected_id> <list>
mru_walk_save() {
  local tmp
  mkdir -p "$HERDR_MRU_DIR" || return 0
  tmp="$HERDR_MRU_WALK_STATE.tmp.$$"
  {
    printf '%s %s %s %s\n' "$1" "$2" "$3" "$(mru_now_ms)"
    printf '%s\n' "$4"
  } >"$tmp" && mv "$tmp" "$HERDR_MRU_WALK_STATE"
}

# True while a press would still continue the walk that wrote $2 as last_ms.
mru_walk_fresh() {
  case "${1:-}" in
    '' | *[!0-9]*) return 1 ;;
  esac
  [ $(( $(mru_now_ms) - $1 )) -le "$HERDR_MRU_WALK_TIMEOUT_MS" ]
}

# Order "id<TAB>label" rows on stdin by the ranked ids in file $1.
# Ranked rows come first, in rank order. The rest keep their own order.
mru_order_by() {
  awk -v rankfile="$1" '
    BEGIN {
      while ((getline id < rankfile) > 0) if (!(id in rank)) rank[id] = ++r
    }
    {
      split($0, parts, "\t")
      id = parts[1]
      if (id in rank) { ranked[rank[id]] = $0; if (rank[id] > max) max = rank[id] }
      else rest[++k] = $0
    }
    END {
      for (i = 1; i <= max; i++) if (i in ranked) print ranked[i]
      for (i = 1; i <= k; i++) print rest[i]
    }
  '
}

# jq prelude: status icon and colour, shared by the pickers.
MRU_JQ_STYLE='
  def icon: {"working":"◐","blocked":"●","done":"✓","idle":"○"}[.] // "·";
  def colour: {"working":"33","blocked":"31","done":"32","idle":"90"}[.] // "90";
  def badge: "\u001b[" + colour + "m" + icon + "\u001b[0m";
  def dim: "\u001b[90m" + . + "\u001b[0m";
'

# Rows of "workspace_id<TAB>styled label" for the workspace picker.
mru_workspace_rows() {
  herdr workspace list | jq -r "$MRU_JQ_STYLE"'
    .result.workspaces[]
    | [ .workspace_id,
        ((.agent_status // "idle") | badge) + " " + .label
        + "  " + (("· " + (.tab_count|tostring) + "t " + (.pane_count|tostring) + "p"
                  + (if .worktree.is_linked_worktree then " · worktree" else "" end)) | dim)
      ] | @tsv'
}

# Rows of "pane_id<TAB>styled label" for the agent picker.
mru_agent_rows() {
  local labels
  labels="$(herdr workspace list |
    jq -c '[.result.workspaces[] | {key: .workspace_id, value: .label}] | from_entries')"
  herdr agent list | jq -r --argjson labels "$labels" "$MRU_JQ_STYLE"'
    .result.agents[]
    | [ .pane_id,
        (.agent_status | badge) + " " + (.name // .agent)
        + "  " + (($labels[.workspace_id] // .workspace_id) | dim)
        + "  " + ((.terminal_title_stripped // "") | dim)
      ] | @tsv'
}

# Focused workspace and pane ids, as "<workspace_id> <pane_id>".
mru_focused() {
  herdr api snapshot |
    jq -r '.result.snapshot
           | ((.focused_workspace_id // "-") + " " + (.focused_pane_id // "-"))'
}
