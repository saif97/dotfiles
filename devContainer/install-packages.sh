#!/bin/bash

set -e

echo "Installing packages..."

# Update package lists
apt-get update

# Install packages
apt-get install -y \
    git \
    curl \
    ripgrep \
    zsh \
    ca-certificates \
    build-essential \
    software-properties-common \
    python3 \
    python3-pip \
    lazygit \
    make \
    neovim \
    fzf \
    fd-find \
    bat \
    zoxide


# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "Package installation complete!"
