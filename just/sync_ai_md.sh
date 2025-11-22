#!/usr/bin/env bash
set -e

CLAUDE="CLAUDE.md"
GEMINI="GEMINI.md"

# Navigate to repo root
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

ignore_file() {
    local file=$1
    # check if already ignored by git
    if git check-ignore -q "$file"; then
        echo "$file is already ignored."
        return
    fi

    # Use .git/info/exclude for local excludes
    local exclude_file=".git/info/exclude"
    
    if [ -f "$exclude_file" ]; then
        if ! grep -q "^$file$" "$exclude_file"; then
            echo "$file" >> "$exclude_file"
            echo "Added $file to $exclude_file"
        fi
    else
        # Ensure the directory exists just in case
        mkdir -p "$(dirname "$exclude_file")"
        echo "$file" > "$exclude_file"
        echo "Created $exclude_file with $file"
    fi
}

if [[ -f "$CLAUDE" && ! -f "$GEMINI" ]]; then
    echo "Creating symlink: $GEMINI -> $CLAUDE"
    ln -s "$CLAUDE" "$GEMINI"
    ignore_file "$GEMINI"
elif [[ -f "$GEMINI" && ! -f "$CLAUDE" ]]; then
    echo "Creating symlink: $CLAUDE -> $GEMINI"
    ln -s "$GEMINI" "$CLAUDE"
    ignore_file "$CLAUDE"
elif [[ -f "$CLAUDE" && -f "$GEMINI" ]]; then
    echo "Both $CLAUDE and $GEMINI exist."
else
    echo "Error: Neither $CLAUDE nor $GEMINI found."
    exit 1
fi
