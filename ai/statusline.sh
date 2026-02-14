#!/usr/bin/env bash

# Simple status line script
# Edit the sections below to customize what appears

input=$(cat)

# Extract data from JSON
model=$(echo "$input" | jq -r '.model.display_name // empty')
dir=$(echo "$input" | jq -r '.workspace.current_dir // empty')
agent=$(echo "$input" | jq -r '.agent.name // empty')
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')

# Context window details
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
window_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')

# Calculate context window usage
if [ -n "$window_size" ] && [ "$window_size" != "null" ]; then
    window_k=$((window_size / 1000))
    # Calculate used tokens from percentage (more accurate than total_input + total_output)
    if [ -n "$used_pct" ] && [ "$used_pct" != "null" ]; then
        used_k=$((window_size * used_pct / 100 / 1000))
    fi
fi

# Build output - customize these sections
output=""

# Model
if [ -n "$model" ]; then
    output+="$model "
fi

# Directory (basename only)
if [ -n "$dir" ]; then
    basename_dir=$(basename "$dir")
    output+="$basename_dir "
fi

# Agent
if [ -n "$agent" ]; then
    output+="<$agent> "
fi

# Vim mode
if [ -n "$vim_mode" ]; then
    output+="($vim_mode) "
fi

# Context usage (tokens + percentage) with color coding
if [ -n "$used_pct" ] && [ "$used_pct" != "null" ] && [ -n "$used_k" ]; then
    # Color coding: red when usage >= 80%, otherwise default
    if [ "$used_pct" -ge 80 ]; then
        # Red color for high usage (warning)
        RED='\033[0;31m'
        RESET='\033[0m'
        context_str="${RED}${used_k}k/${window_k}k (${used_pct}%)${RESET} "
    else
        # Default color for normal usage
        context_str="${used_k}k/${window_k}k (${used_pct}%) "
    fi
    output+="$context_str"
fi

# Print output (use printf for proper ANSI escape sequence handling)
printf "%s" "$output"
