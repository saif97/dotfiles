# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains dotfiles for a highly customized development environment with unified Colemak-inspired keybindings across all tools:

- **Neovim**: Modern Lua-based configuration with Lazy.nvim, AI integration (CodeCompanion), and extensive plugin ecosystem
- **VS Code**: Integrated with vscode-neovim extension, Cursor AI, matching keybindings
- **Terminal**: Ghostty with semi-transparent theming, tmux with plugin ecosystem
- **Shell**: Zsh with starship prompt, extensive aliases, and tool integrations
- **Keyboard**: Karabiner-Elements for system-wide key remapping

## Setup Commands

Initial environment setup from `cmds.sh`:
```bash
# Create symlinks
ln -s "$DOT_FILES/tmux" "$HOME/.config/tmux"
ln -s $HOME/dotfiles/ghostty $HOME/.config/ghostty
ln -s $HOME/dotfiles/lazygit $HOME/.config/lazygit

# Install required packages
brew install zsh-autosuggestions zsh-syntax-highlighting
```

## Key Aliases and Commands

From `pub.zsh`:
```bash
# Core navigation
alias l='lsd -ali'
alias cat='bat'
alias cd='z'        # zoxide
alias v='nvim'
alias nv='nvim'

# Development
alias lg="lazygit"
alias tm="tmux attach"
alias tms="tmux source-file '$DOT_FILES/tmux/tmux.conf'"

# Claude Code integration
alias cld="claude --continue"
alias cldn="claude"

# Python
alias python='python3'
alias py='python3'
alias pysour='source ./venv/bin/activate'
```

## Keymapping System (Colemak-Inspired)

**Core Navigation** (consistent across Neovim and VS Code):
- `e` → down (replaces `j`)
- `u` → up (replaces `k`) 
- `n` → previous word (replaces `b`)
- `i` → next word (replaces `w`)
- `l` → beginning of line (replaces `0`)
- `y` → end of line (replaces `$`)
- `o` → insert mode (replaces `i`)

**Window Management** (Ctrl+e/u/n/i):
- `Ctrl+e` → focus down
- `Ctrl+u` → focus up
- `Ctrl+n` → focus left
- `Ctrl+i` → focus right

**Search Navigation**:
- `b` → next search result
- `B` → previous search result

## Development Workflow Keymaps

**Configuration Management**:
- `<leader>rc` → reload current file
- `<leader>rs` → reload snippets
- `<leader>rk` → reload keymaps

**Project Navigation** (Telescope):
- `<leader>sp` → search projects (sessions)
- `<leader>sf` → search files
- `<leader>sg` → search by grep
- `<leader>sb` → search buffers

**AI Integration**:
- `<leader>lp` → LLM Command Palette (Neovim)
- `<leader>lc` → CodeCompanion chat (Neovim)
- `<leader>lb` → LLM current buffer (Neovim)
- `<leader>an` → Cursor agent (VS Code)
- `<leader>ac` → Cursor chat (VS Code)

## Architecture and Plugin Management

**Neovim Configuration Structure**:
- Uses Lazy.nvim for plugin management with lazy loading
- Modular Lua configuration in `/nvim/lua/`
- AI integration via CodeCompanion and GitHub Copilot
- LSP configuration with Mason for language servers
- Telescope for fuzzy finding and project management
- Tree-sitter for syntax highlighting and code understanding

**VS Code Integration**:
- vscode-neovim extension provides Vim keybindings
- Custom multi-command configurations for complex workflows
- Cursor AI integration with matching keymaps to Neovim
- Settings synchronized to match Neovim behavior

**Cross-Editor Consistency**:
- Navigation keymaps identical between Neovim and VS Code
- Window management unified across all applications
- Theme consistency (GruvboxDark) across terminal, editors, and tools

## Working with this Repository

**Critical Conventions**:
1. **Keymapping Priority**: Always preserve the Colemak-inspired navigation system - it's fundamental to the entire setup
2. **Dual Environment Support**: Any navigation/editing changes must work in both Neovim and VS Code
3. **AI Integration**: Leverage CodeCompanion in Neovim and Cursor features in VS Code for development assistance
4. **Theme Consistency**: Maintain GruvboxDark theme across all tools
5. **Session Management**: Use built-in project/session management via telescope extensions

**Testing Changes**:
- Test keymaps in both Neovim and VS Code
- Verify window management works across terminal, editor, and system
- Check theme consistency across all tools
