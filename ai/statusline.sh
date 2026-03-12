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

# Current API call usage (last call)
curr_input=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // empty')
curr_output=$(echo "$input" | jq -r '.context_window.current_usage.output_tokens // empty')
curr_cache_write=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // empty')
curr_cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // empty')

# Calculate context window usage
if [ -n "$window_size" ] && [ "$window_size" != "null" ]; then
    window_k=$((window_size / 1000))
    if [ -n "$used_pct" ] && [ "$used_pct" != "null" ]; then
        used_k=$((window_size * used_pct / 100 / 1000))
    fi
fi

quota_str=$(bash "$(dirname "$0")/quota.sh")

# Build output
output=""

# Model
if [ -n "$model" ]; then
    output+=" $model "
fi

# Directory (basename only)
if [ -n "$dir" ]; then
    basename_dir=$(basename "$dir")
    output+=" $basename_dir "
fi

# Agent
if [ -n "$agent" ]; then
    output+=" $agent "
fi

# Vim mode
if [ -n "$vim_mode" ]; then
    output+=" $vim_mode "
fi

# Context usage with color coding
if [ -n "$used_pct" ] && [ "$used_pct" != "null" ] && [ -n "$used_k" ]; then
    if [ "$used_pct" -ge 80 ]; then
        RED=$'\033[0;31m'
        RESET=$'\033[0m'
        context_str="${RED}${used_k}k/${window_k}k ${used_pct}%${RESET} "
    else
        context_str="${used_k}k/${window_k}k ${used_pct}% "
    fi
    output+="$context_str"
fi

# Current API call usage (last call)
if [ -n "$curr_input" ] && [ "$curr_input" != "null" ] && [ -n "$curr_output" ] && [ "$curr_output" != "null" ]; then
    curr_total=$((curr_input + curr_output))

    cache_info=""
    if [ -n "$curr_cache_write" ] && [ "$curr_cache_write" != "null" ] && [ "$curr_cache_write" -gt 0 ]; then
        cache_info=" ✎${curr_cache_write}"
    fi
    if [ -n "$curr_cache_read" ] && [ "$curr_cache_read" != "null" ] && [ "$curr_cache_read" -gt 0 ]; then
        cache_info="${cache_info} ✓${curr_cache_read}"
    fi

    DIM=$'\033[2m'
    RESET=$'\033[0m'
    output+="${DIM}↑${curr_input} ↓${curr_output}${cache_info}${RESET} "
fi

# Quota windows
if [ -n "$quota_str" ]; then
    output+="$quota_str "
fi

printf "%s" "$output"
