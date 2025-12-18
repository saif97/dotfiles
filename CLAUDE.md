# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS that manages configurations for:
- **Neovim**: Highly customized Lua-based configuration with custom Colemak-inspired keybindings
- **Ghostty**: Terminal emulator configuration
- **Karabiner-Elements**: Keyboard customization (both EDN and TypeScript formats)
- **Lazygit**: Git UI configuration
- **Starship**: Shell prompt configuration
- **Zsh**: Shell configuration and history settings
- **Just**: Task runner for project maintenance and automation

## Installation

Run the install script to set up symlinks and install dependencies:
```bash
./install.sh
```

This script:
- Creates symlinks for configuration files to their expected locations (~/.config/)
- Installs zsh plugins (zsh-autosuggestions, zsh-syntax-highlighting)
- Sets up AI system instructions for Gemini

## Neovim Configuration

### Structure
The Neovim configuration is located in `nvim/` and follows this architecture:

- **Entry point**: `nvim/init.lua` - Loads keymaps, vim options, and conditionally loads full Neovim config or VSCode-Neovim compatibility mode
- **Package manager**: Uses lazy.nvim (`nvim/lua/config/lazy.lua`) for plugin management
- **Keymaps**: `nvim/lua/keymaps.lua` - Contains three setup functions:
  - `setup()`: Common keymaps for both VSCode and Neovim
  - `setupNvimPreLazy()`: Pre-lazy configuration (bullet points, etc.)
  - `setupNvim()`: Full Neovim-specific keymaps
  - `setupVScode()`: VSCode-specific keymaps
- **Plugins**: Individual plugin configs in `nvim/lua/plugins/`
- **LSP**: Language server configurations in `nvim/lua/lsp/`
  - `pyright_ls.lua`: Python LSP with Ruff integration (type checking only, linting disabled)
  - `solidity.lua`: Solidity smart contract language support
- **User commands**: `nvim/lua/userCmds.lua` - Custom commands like `:LspRestart`, `:Poop`
- **Auto commands**: `nvim/lua/autoCmd.lua`
- **Options**: `nvim/lua/vimOptions.lua` - All vim settings

### Colemak-Inspired Navigation
The Neovim configuration uses a custom Colemak-inspired key layout:
- `e/u` = down/up (instead of j/k)
- `n/i` = previous word/next word (instead of b/w)
- `l/y` = line start/end (instead of 0/$)
- `o` = insert mode (instead of i)
- `c` = copy/yank (instead of y)
- `x` = cut (instead of d)
- `w` = change without copying to register
- `b/B` = next/previous search match (instead of n/N)
- `L/Y` = undo/redo (instead of u/Ctrl-r)

### Key Plugins
- **blink-cmp**: Completion engine
- **snacks.nvim**: Multi-purpose plugin for UI enhancements
- **noice.nvim**: UI enhancement for cmdline, messages, and LSP docs with Treesitter rendering
- **nvim-notify**: Notification system (used by noice.nvim)
- **diffview**: Git diff viewer
- **neo-tree**: File explorer
- **sidekick**: Claude Code AI assistant with adaptive layout (float/split based on window width), Zellij multiplexer support, and devbox integration
- **nvim-justice**: Just task runner integration
- **copilot**: GitHub Copilot integration
- **catppuccin**: Color scheme

### Important Neovim Details
- VSCode-Neovim compatibility mode: Detects `vim.g.vscode` and loads minimal config
- Tab size: 2 spaces (configured as tabs, not spaces - `expandtab = false`)
- Leader key: Space
- Auto-save enabled
- Clipboard synced with system

## Karabiner Configuration

Two formats exist for keyboard customization:

### karabiner.edn (Goku format)
The primary configuration uses Goku (Karabiner DSL in EDN):
- Implements vi-mode keybindings system-wide (triggered by left_command)
- Media controls via layer mode (key: 0)
- Symbol mode (key: 4) for quick access to special characters
- Numpad mode (key: 2)
- Launch mode (key: semicolon)
- Stock profile for switching off customizations

**Key Mappings in Vi Mode (when left_command is held)**:
- `k/i/j/l` = down/up/left/right arrows
- `h/n` = delete forward/backspace
- `u/o` = home/end
- Mouse button remapping (swaps button4/button5)
- RSI prevention: caps_lock → command, right_command → escape

### karabinerTS/ (TypeScript format)
Alternative TypeScript-based configuration using karabiner.ts library.
- Extended support for QWERTY→Colemak mapping in iPhone Mirroring and UTM apps
- Custom app-specific keyboard layouts

**Build command**:
```bash
cd karabinerTS && npm run build
```

## Ghostty Terminal

Configuration in `ghostty/config`:
- Background opacity: 0.90
- No window decoration, transparent titlebar
- Custom keybindings (disable defaults, use cmd+t prefix for actions)
- Claude Code support: shift+enter for newline
- Alt+delete for forward word deletion
- Mouse scroll multiplier: 2

## Git Configuration

Global gitignore: `global.gitignore`
Lazygit config: `lazygit/config.yml`

## Shell Configuration

### Zsh
Configuration files in `zsh/`:
- `history.zsh`: History settings
- `completion.zsh`: Comprehensive completion system setup with fzf-tab integration
  - Load order: fpath setup → compinit → fzf → fzf-tab → syntax plugins
  - **fzf-tab**: Fuzzy completion with preview support (using bat and lsd)
  - Includes Docker, Google Cloud SDK, and Dart CLI completions
  - Preview for directories (lsd) and files (bat with syntax highlighting)
  - Group navigation with `[` and `]` keys
  - Continuous trigger on right arrow

Additional scripts:
- `chime.zsh`: Chime-related configurations
- `pub.zsh`: Publication/sharing scripts (publicly tracked config)

### Starship
Prompt configuration in `starship/starship.toml`

## Development Workflows

### Modifying Neovim
1. For plugin changes: Edit files in `nvim/lua/plugins/`
2. For keymaps: Edit `nvim/lua/keymaps.lua` (maintain separation between VSCode and Neovim modes)
3. For LSP: Add configurations in `nvim/lua/lsp/`
4. Lazy.nvim will auto-install plugins on next launch

### Modifying Karabiner
**EDN format (primary)**:
```bash
# Edit karabiner.edn, then Goku will auto-generate karabiner.json
# Goku must be installed and running
```

**TypeScript format**:
```bash
cd karabinerTS
npm run build
# This generates the karabiner.json configuration
```

### Task Runner
The project uses `just` to automate tasks. Configuration is in `just/justfile`.

## Claude Code Integration

This repository is configured for use with Claude Code:
- **System instructions**: `ai/aiSystemInstructions.md` contains critical rules for Claude
- **Settings**: `ai/claude_settings.json` configures hooks (sound on stop) and features
- **Slash commands**: Custom commands in `ai/slash_cmds/` (e.g., `/update_claude`)
- **Sidekick integration**: Neovim plugin provides AI assistance with `<c-y>` toggle
  - Adaptive layout: float mode (<260 cols) or right split (≥260 cols)
  - Zellij multiplexer support for terminal sessions
  - Devbox tool integration

## Important Notes
- You can find plugin documentations here `~/.local/share/nvim/lazy/`.
- The repository contains `playground.py` and `playground` files which are gitignored and used for temporary experimentation
- AI system instructions are stored in `ai/aiSystemInstructions.md` and symlinked for Gemini
- `cmds.sh` contains symlink commands for setting up config directories
- Always read files before modifying them to ensure working with the latest version
- The configuration is highly personalized with Colemak-inspired keybindings throughout
- In nvim, using adaptive pane size with vim.o.winwidth (same for height)
- Whenever adding or making significant changes to dotfiles, keep install.sh updated (used for VMs & dev containers)
- `pub.zsh` is publicly tracked zsh config file for shareable configurations
- VSCode Neovim path updated to `/opt/homebrew/bin/nvim` (Apple Silicon)
- i'm using dev container