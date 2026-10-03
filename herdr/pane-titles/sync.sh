#!/usr/bin/env bash
# herdr event hook: set each pane's display_agent, which herdr draws on the
# pane border. An agent pane gets its terminal_title_stripped; any other pane
# gets its workspace name. Each title starts with the short hostname.
# Reads all panes from the server rather than from the event payload, so one
# hook handles every event kind.
set -uo pipefail

# herdr event hooks can get a short PATH, so add the usual install folders.
PATH="$PATH:/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin"

SOURCE="pane-titles"

# Herdr runs this plugin on the server that owns the pane, so the hostname
# names the machine the pane runs on.
MACHINE="$(hostname -s)"

# Write only when the value changes. The write itself fires pane.updated, so
# an unconditional write would loop.
workspaces="$(herdr workspace list |
  jq -c '[.result.workspaces[] | {key: .workspace_id, value: .label}] | from_entries')"

herdr pane list | jq -r --argjson ws "$workspaces" --arg machine "$MACHINE" '
  .result.panes[]
  | (if .agent != null then .terminal_title_stripped else $ws[.workspace_id] end // "") as $name
  | (if $name == "" then $machine else "\($machine) · \($name)" end) as $want
  | select($want != (.display_agent // ""))
  | [.pane_id, $want] | @tsv
' | while IFS=$'\t' read -r pane title; do
  if [ -n "$title" ]; then
    herdr pane report-metadata "$pane" --source "$SOURCE" --display-agent "$title" >/dev/null
  else
    herdr pane report-metadata "$pane" --source "$SOURCE" --clear-display-agent >/dev/null
  fi
done
exit 0
