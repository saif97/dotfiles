#!/bin/bash
set -e

# Fix ownership of volume-mounted directories (excluding workspace which is a bind mount)
for dir in /home/dev_in_a_box/.local/share/nvim \
           /home/dev_in_a_box/.cache/nvim \
           /home/dev_in_a_box/.local/state/nvim \
           /home/dev_in_a_box/.zsh_history; do
    if [ -e "$dir" ]; then
        sudo chown -R dev_in_a_box:dev_in_a_box "$dir" 2>/dev/null || true
    fi
done

# Execute the command passed to the container
exec "$@"
