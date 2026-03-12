#!/usr/bin/env bash
# quota.sh — prints quota usage for the 5h and 7d Claude windows
#
# Output: "5h:14% (40m left) 7d:2% (5d left)"  (with ANSI color)
# Called by statusline.sh via: quota_str=$(bash quota.sh)

QUOTA_CACHE="/tmp/claude-statusline-quota.json"
QUOTA_CACHE_TTL=60

_color() {
    local pct=$1
    if   [ "$pct" -ge 80 ]; then printf '\033[91m'  # bright red
    elif [ "$pct" -ge 50 ]; then printf '\033[33m'  # yellow
    else                         printf '\033[32m'  # green
    fi
}

_time_left() {
    local resets_at=$1 now=$2
    local epoch
    epoch=$(date -jf "%Y-%m-%dT%H:%M:%S" "${resets_at%%[.+]*}" +%s 2>/dev/null)
    [ -z "$epoch" ] && return

    local secs=$(( epoch - now ))
    local days=$(( secs / 86400 ))
    local hrs=$(( (secs % 86400) / 3600 ))
    local mins=$(( (secs % 3600) / 60 ))

    if   [ "$days" -gt 0 ]; then echo "-${days}d"
    elif [ "$hrs"  -gt 0 ]; then echo "-${hrs}h"
    else                         echo "-${mins}m"
    fi
}

_fetch() {
    local creds token response
    creds=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null) || return 1
    token=$(echo "$creds" | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
    [ -z "$token" ] || [ "$token" = "null" ] && return 1
    response=$(curl -sf --max-time 3 \
        -H "Authorization: Bearer $token" \
        -H "anthropic-beta: oauth-2025-04-20" \
        "https://api.anthropic.com/api/oauth/usage" 2>/dev/null) || return 1
    echo "$response" | jq -e '.five_hour' >/dev/null 2>&1 || return 1
    echo "$response" > "$QUOTA_CACHE"
}

# Refresh cache in background if stale
cache_age=9999
[ -f "$QUOTA_CACHE" ] && cache_age=$(( $(date +%s) - $(stat -f%m "$QUOTA_CACHE" 2>/dev/null || echo 0) ))
[ "$cache_age" -gt "$QUOTA_CACHE_TTL" ] && _fetch 2>/dev/null &

[ -f "$QUOTA_CACHE" ] || exit 0

# ── Read cached values ────────────────────────────────────────────────────
q5=$(jq -r '.five_hour.utilization  // empty' "$QUOTA_CACHE" 2>/dev/null | cut -d. -f1)
q7=$(jq -r '.seven_day.utilization  // empty' "$QUOTA_CACHE" 2>/dev/null | cut -d. -f1)
r5=$(jq -r '.five_hour.resets_at    // empty' "$QUOTA_CACHE" 2>/dev/null)
r7=$(jq -r '.seven_day.resets_at    // empty' "$QUOTA_CACHE" 2>/dev/null)

RESET=$'\033[0m'
now=$(date +%s)
out=""

if [ -n "$q5" ]; then
    left=$(_time_left "$r5" "$now")
    [ -n "$left" ] && left=" ($left)"
    out+="$(_color "$q5")5h:${q5}%${left}${RESET}"
fi

if [ -n "$q7" ]; then
    left=$(_time_left "$r7" "$now")
    [ -n "$left" ] && left=" ($left)"
    [ -n "$out" ] && out+=" "
    out+="$(_color "$q7")7d:${q7}%${left}${RESET}"
fi

printf "%s" "$out"
