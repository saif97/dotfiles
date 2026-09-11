# herdr-mru

Recency switching for herdr projects (workspaces) and agents.

herdr orders its own workspace picker by workspace number, and
`previous_workspace` / `previous_agent` move in list order. This plugin adds the
missing order: what you used last.

## What it gives you

| Key | Action |
| --- | --- |
| `ctrl+cmd+p` | Project picker, most recent first |
| `ctrl+cmd+shift+p` | Back through recent projects, no dialog |
| `ctrl+cmd+]` | Forward again through recent projects |
| `ctrl+cmd+a` | Agent picker, most recent first |
| `ctrl+cmd+shift+a` | Back through recent agents, no dialog |
| `ctrl+cmd+[` | Forward again through recent agents |

The keys live in `../config.toml`. `last_pane = "ctrl+cmd+y"` there gives the
same back-and-forth for panes, and herdr provides it by itself. Keep these
chords off plain `ctrl+<letter>`: herdr grabs them globally, so the agent in the
pane never sees them. `ctrl+y` was the first try, and it took away paste in
Claude Code.

## Walking the history

Back is not a toggle. The first press freezes the ranking as it is then and
moves you one step along it. Each press inside the next
`HERDR_MRU_WALK_TIMEOUT_MS` (3 s) steps one item further back, the way
alt-tab does.

Forward retraces the frozen list toward where the walk started. It does not
expire: it works as long as you are still standing where the walk left you.
Only back needs the timeout, because back also has to mean "the one before
this" again once the walk is over; forward has only the one job, so pausing to
look at where you landed must not kill it. Forward does nothing when there is
no walk to retrace, or when you left the walk by other means.

The list stays frozen because focusing an item normally makes it the most
recent one; against a live ranking, every second press would send you back to
where you came from.

Stop pressing and the walk ends. The item you stopped on becomes the most
recent one, so a later back press returns you and the ping-pong of the old
toggle is still there. Steps you only passed through do not reorder anything:
`walk.sh` saves its state before it focuses, `track.sh` marks those focuses
with a `w`, and a marked visit has to outlast the walk window before it
counts.

## How it works

- `herdr-plugin.toml` hooks `workspace.focused` and `pane.focused`. herdr runs
  `track.sh` on every focus change.
- `track.sh` asks the server what has focus and appends one line to
  `~/.local/state/herdr-mru/focus.log`. It reads the server rather than the
  event payload, so one hook handles every event kind.
- `lib.sh` ranks that history. Focuses of the same item in a row count as one
  visit, and a visit shorter than `HERDR_MRU_DWELL_MS` (900 ms) is dropped. This
  keeps pane cycling from filling the list with items you only passed through.
- `pick.sh` merges the ranking with the live workspace or agent list, and shows
  it in `fzf`. Items you have never focused come last.
- `walk.sh` builds the frozen list — where you are, then the history, then
  whatever is live but never focused — and keeps a cursor into it in
  `~/.local/state/herdr-mru/walk.state`. Items that closed while the walk was
  open are stepped over.

Agents are keyed by pane id, because an agent has a name only after you rename
it.

## Settings

Environment variables, all optional:

| Variable | Default | Meaning |
| --- | --- | --- |
| `HERDR_MRU_DIR` | `~/.local/state/herdr-mru` | Where the history is kept |
| `HERDR_MRU_DWELL_MS` | `900` | How long an item must hold focus to count |
| `HERDR_MRU_WALK_TIMEOUT_MS` | `3000` | How long a walk stays open between presses |
| `HERDR_MRU_MAX_LINES` | `2000` | Trim the history above this |
| `HERDR_MRU_KEEP_LINES` | `500` | How much to keep when trimming |
| `MRU_FZF_OPTS` | empty | Extra options for `fzf` |

## Install on a new machine

```bash
herdr plugin link ~/dotfiles/herdr/mru
herdr server reload-config
```

`install.sh` does this for you when herdr is present. The link is machine state
in `~/.config/herdr/plugins.json`, which is not tracked, so a new checkout needs
it once.

## Check it

```bash
herdr plugin list --plugin saif.herdr-mru          # linked and enabled?
herdr plugin log list --plugin saif.herdr-mru      # did the hooks run?
tail ~/.local/state/herdr-mru/focus.log            # is history arriving?
herdr plugin action invoke back-agent --plugin saif.herdr-mru     # back
herdr plugin action invoke forward-agent --plugin saif.herdr-mru  # forward
cat ~/.local/state/herdr-mru/walk.state            # is a walk open?
```

The hooks run with a short `PATH` and, on some builds, no `HOME`. `lib.sh`
repairs both. If `herdr plugin log list` reports `herdr: command not found`,
that repair is what failed.
