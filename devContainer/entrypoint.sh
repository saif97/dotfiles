#!/bin/bash
set -e

# Copy Gemini config (excluding tmp dir)
if [ -d /tmp/host_gemini ]; then
    mkdir -p /home/dev_in_a_box/.gemini
    cp -r /tmp/host_gemini/* /home/dev_in_a_box/.gemini/
    rm -rf /home/dev_in_a_box/.gemini/tmp
fi

# Fix ownership of volume-mounted directories (excluding workspace which is a bind mount)
for dir in /home/dev_in_a_box/.local/share/nvim \
           /home/dev_in_a_box/.cache/nvim \
           /home/dev_in_a_box/.local/state/nvim \
           /home/dev_in_a_box/.zsh_history \
           /home/dev_in_a_box/.gemini \
           /home/dev_in_a_box/.claude; do
    if [ -e "$dir" ]; then
        sudo chown -R dev_in_a_box:dev_in_a_box "$dir" 2>/dev/null || true
    fi
done

# Execute the command passed to the container
exec "$@"
