#!/bin/bash

set -e

echo "Installing dotfiles (idempotent)..."

# --- Symlinks ---

# Claude Code
mkdir -p "$HOME/.claude"
link_if_missing() {
    local target="$1" linkname="$2"
    if [ ! -e "$linkname" ] && [ ! -L "$linkname" ]; then
        ln -s "$target" "$linkname"
        echo "  linked $linkname"
    else
        echo "  $linkname exists, skipping"
    fi
}

# Physical path of a directory, or empty if it isn't one.
resolve_dir() { (cd "$1" 2>/dev/null && pwd -P); }

# ~/.config/<name> → ~/dotfiles/<name>. Three cases beyond a plain link:
#   - ~/.config is itself the dotfiles symlink, so the path already resolves;
#   - an empty dir sits there (usually left by an earlier mkdir), so remove it;
#   - a real dir with contents, so ask before moving it aside.
link_config_dir() {
    local name="$1"
    local target="$HOME/dotfiles/$name"
    local linkname="$HOME/.config/$name"

    if [ "$(resolve_dir "$HOME/.config")" = "$(resolve_dir "$HOME/dotfiles")" ]; then
        echo "  ~/.config is the dotfiles symlink, $name already in place"
        return
    fi

    if [ -L "$linkname" ]; then
        if [ "$(resolve_dir "$linkname")" = "$(resolve_dir "$target")" ]; then
            echo "  $linkname already linked, skipping"
        else
            echo "  WARN: $linkname points to $(readlink "$linkname"), not $target"
        fi
        return
    fi

    if [ ! -e "$linkname" ]; then
        ln -s "$target" "$linkname"
        echo "  linked $linkname"
        return
    fi

    # Empty dir holds no data; take it without asking.
    if [ -d "$linkname" ] && rmdir "$linkname" 2>/dev/null; then
        ln -s "$target" "$linkname"
        echo "  linked $linkname (removed empty dir)"
        return
    fi

    if [ -t 0 ]; then
        local backup="$linkname.bak.$(date +%Y%m%d-%H%M%S)"
        printf "  %s is a real directory. Move it to %s and link? [y/N] " "$linkname" "$(basename "$backup")"
        read -r reply
        case "$reply" in
            y|Y|yes|YES)
                mv "$linkname" "$backup"
                ln -s "$target" "$linkname"
                echo "  linked $linkname (old contents kept in $backup)"
                ;;
            *)
                echo "  kept existing $linkname"
                ;;
        esac
    else
        echo "  WARN: $linkname is a real directory; re-run install.sh interactively to replace it"
    fi
}

link_if_missing "$HOME/dotfiles/ai/aiSystemInstructions.md" "$HOME/.claude/CLAUDE.md"
link_if_missing "$HOME/dotfiles/ai/agents" "$HOME/.claude/agents"
link_if_missing "$HOME/dotfiles/ai/slash_cmds/Claude" "$HOME/.claude/commands"

# Gemini slash commands
mkdir -p "$HOME/.gemini"
link_if_missing "$HOME/dotfiles/ai/slash_cmds/Gemini" "$HOME/.gemini/commands"

# Skills: link per-skill into both ~/.claude/skills and ~/.agents/skills —
# not the whole dir, since both also hold skills installed by other tooling
# that aren't tracked here.
mkdir -p "$HOME/.claude/skills" "$HOME/.agents/skills"
for skill in "$HOME"/dotfiles/ai/skills/*/; do
    name=$(basename "$skill")
    link_if_missing "$skill" "$HOME/.claude/skills/$name"
    link_if_missing "$skill" "$HOME/.agents/skills/$name"
done

# settings.json: if a regular file exists, ask whether to replace it with the
# dotfile symlink (machine-specific overrides belong in settings.local.json).
settings_link="$HOME/.claude/settings.json"
settings_target="$HOME/dotfiles/ai/claude_settings.json"
if [ -L "$settings_link" ]; then
    echo "  $settings_link already linked, skipping"
elif [ -f "$settings_link" ]; then
    if [ -t 0 ]; then
        printf "  %s is a regular file. Replace with symlink to dotfile? [y/N] " "$settings_link"
        read -r reply
        case "$reply" in
            y|Y|yes|YES)
                rm "$settings_link"
                ln -s "$settings_target" "$settings_link"
                echo "  linked $settings_link (old file removed; put machine overrides in settings.local.json)"
                ;;
            *)
                echo "  kept existing $settings_link"
                ;;
        esac
    else
        echo "  WARN: $settings_link is a regular file; re-run install.sh interactively to replace with symlink"
    fi
else
    ln -s "$settings_target" "$settings_link"
    echo "  linked $settings_link"
fi

# Configs linked one by one into ~/.config. Add a line here for each new one.
mkdir -p "$HOME/.config"
link_config_dir nvim
link_config_dir herdr
link_config_dir btop

# Global gitignore
if [ ! -L "$HOME/.gitignore_global" ]; then
    ln -sf "$HOME/dotfiles/global.gitignore" "$HOME/.gitignore_global"
    git config --global core.excludesfile "$HOME/.gitignore_global"
    echo "  linked global gitignore"
else
    echo "  global gitignore already linked"
fi

# Shared Git configuration
git_config="$HOME/dotfiles/git/pub.gitconfig"
if git config --global --get-all include.path | grep -Fxq "$git_config"; then
    echo "  shared git config already included"
else
    git config --global --add include.path "$git_config"
    echo "  included shared git config"
fi

# --- Submodules (fzf-tab, etc.) ---

if [ -f "$HOME/dotfiles/.gitmodules" ]; then
    git -C "$HOME/dotfiles" submodule update --init --recursive
fi

# --- Zsh ---

if ! command -v zsh >/dev/null 2>&1; then
    echo "  installing zsh..."
    if command -v brew >/dev/null 2>&1; then
        brew install zsh
    elif command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update && sudo apt-get install -y zsh
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y zsh
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --noconfirm zsh
    else
        echo "  WARN: install zsh manually (no known package manager found)"
    fi
else
    echo "  zsh already installed"
fi

mkdir -p "$HOME/.zsh"
if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
else
    echo "  zsh-autosuggestions already installed"
fi
if [ ! -d "$HOME/.zsh/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.zsh/zsh-syntax-highlighting"
else
    echo "  zsh-syntax-highlighting already installed"
fi

# Just zsh completion (brew ships it; apt/cargo/tarball installs don't)
if command -v just &> /dev/null; then
    mkdir -p "$HOME/.zsh/completions"
    if [ ! -f "$HOME/.zsh/completions/_just" ]; then
        just --completions zsh > "$HOME/.zsh/completions/_just"
        echo "  generated _just completion"
    else
        echo "  _just completion already present"
    fi
fi

# Source pub.zsh from .zshrc
touch "$HOME/.zshrc"
if ! grep -qF 'source $HOME/dotfiles/pub.zsh' "$HOME/.zshrc"; then
    echo 'source $HOME/dotfiles/pub.zsh' >> "$HOME/.zshrc"
    echo "  added pub.zsh source to .zshrc"
else
    echo "  pub.zsh already sourced in .zshrc"
fi


# --- tree-sitter-cli (required by nvim-treesitter main branch) ---

if ! command -v tree-sitter >/dev/null 2>&1; then
    echo "  installing tree-sitter-cli..."
    if command -v brew >/dev/null 2>&1; then
        brew install tree-sitter-cli
    elif command -v npm >/dev/null 2>&1; then
        npm install -g tree-sitter-cli
    elif command -v cargo >/dev/null 2>&1 && rustup default 2>/dev/null | grep -q .; then
        cargo install tree-sitter-cli
    else
        echo "  WARN: install tree-sitter-cli manually (brew/npm/cargo+toolchain not found)"
    fi
else
    echo "  tree-sitter-cli already installed"
fi

echo "Done."
