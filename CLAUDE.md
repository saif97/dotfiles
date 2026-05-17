# CLAUDE.md

Personal macOS dotfiles. Non-obvious context for Claude Code.

## Structure
- `nvim/` — Neovim (Lua, lazy.nvim). Entry: `init.lua`. Plugins: `lua/plugins/`. Keymaps: `lua/keymaps.lua` (four setup fns for VSCode/Neovim pre-lazy/post-lazy splits). LSP: `lua/lsp/`. Options: `lua/vimOptions.lua`.
- `karabiner.edn` — primary (Goku). `karabinerTS/` — alt (npm run build).
- `ghostty/`, `lazygit/`, `starship/`, `zsh/`, `just/` — tool configs.
- `ai/` — Claude Code system instructions, settings, slash commands.
- `install.sh` — fresh VM/dev-container bootstrap. **Must keep updated when adding dotfiles or changes.**

## Colemak-inspired Neovim keymap (non-standard)
- `e/u` = down/up, `n/i` = prev/next word, `l/y` = line start/end
- `o` = insert, `c` = yank, `x` = cut, `w` = change (no register)
- `b/B` = next/prev search, `L/Y` = undo/redo
- Leader = Space. Tab = 2 (hard tabs, `expandtab = false`). Clipboard synced.

## Karabiner vi-mode (hold left_command)
- `k/i/j/l` = arrows; `h/n` = del fwd/bksp; `u/o` = home/end
    * caps_lock → command; right_command → escape (RSI)

    ## Zsh completion load order
fpath → compinit → fzf → fzf-tab → syntax plugins. fzf-tab uses `lsd` (dirs) + `bat` (files) for preview.

## Claude Code integration
- Sidekick: `<c-y>` toggle, adaptive layout (float <260 cols, split ≥260)
- Slash commands: `ai/slash_cmds/`

## Notes
- Nvim plugin docs live at `~/.local/share/nvim/lazy/`
- `pub.zsh` = publicly shareable zsh config
