# herdr-mru

Recency switching for herdr projects (workspaces) and agents.

herdr orders its own workspace picker by workspace number, and
`previous_workspace` / `previous_agent` move in list order. This plugin adds the
missing order: what you used last.

## What it gives you

| Key | Action |
| --- | --- |
| `ctrl+cmd+p` | Project picker, most recent first |
| `ctrl+cmd+shift+p` | Go to the previous project, no dialog |
| `ctrl+cmd+a` | Agent picker, most recent first |
| `ctrl+cmd+shift+a` | Go to the previous agent, no dialog |

The keys live in `../config.toml`. `last_pane = "ctrl+cmd+y"` there gives the
same back-and-forth for panes, and herdr provides it by itself. Keep these
chords off plain `ctrl+<letter>`: herdr grabs them globally, so the agent in the
pane never sees them. `ctrl+y` was the first try, and it took away paste in
Claude Code.

The toggles ping-pong. Going back records the move too, so the same key returns
you.

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
- `toggle.sh` takes the first item in the history that is not where you are and
  still exists. With no history it falls back to any other live item.

Agents are keyed by pane id, because an agent has a name only after you rename
it.

## Settings

Environment variables, all optional:

| Variable | Default | Meaning |
| --- | --- | --- |
| `HERDR_MRU_DIR` | `~/.local/state/herdr-mru` | Where the history is kept |
| `HERDR_MRU_DWELL_MS` | `900` | How long an item must hold focus to count |
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
herdr plugin action invoke toggle-agent --plugin saif.herdr-mru
```

The hooks run with a short `PATH` and, on some builds, no `HOME`. `lib.sh`
repairs both. If `herdr plugin log list` reports `herdr: command not found`,
that repair is what failed.
