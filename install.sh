#!/bin/bash

set -e

# Safety check: prevent accidental runs on already configured systems
if [ -f "$HOME/.zshrc" ]; then
    echo "ERROR: .zshrc already exists. This script is for fresh VMs and dev containers only."
    echo "Installation cancelled to prevent overwriting your existing configuration."
    exit 1
fi

echo "Installing dotfiles..."

cd $HOME/.config

# Setup global gitignore
ln -sf $HOME/.config/global.gitignore $HOME/.gitignore_global
git config --global core.excludesfile $HOME/.gitignore_global

# Create symlink for gemini AI instructions
mkdir -p $HOME/.gemini
ln -sf $HOME/.config/ai/aiSystemInstructions.md $HOME/.gemini/GEMINI.md

# Symlink zsh config files to home directory
ln -sf $HOME/.config/chime.zsh $HOME/chime.zsh

# Install zsh plugins
echo "Installing zsh plugins..."
mkdir -p $HOME/.zsh
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting $HOME/.zsh/zsh-syntax-highlighting

# Setup .zshrc using dev container template
echo "Configuring .zshrc..."
cp $HOME/.config/devContainer/zshrc $HOME/.zshrc
