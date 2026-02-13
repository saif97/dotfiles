#!/bin/bash
# Boot the first available iPhone simulator

# Find the first available iPhone simulator and extract its device ID
DEVICE_ID=$(xcrun simctl list devices available | grep "iPhone" | head -n 1 | grep -oE '[A-F0-9-]{36}')

if [ -z "$DEVICE_ID" ]; then
    echo "Error: No iPhone simulator found"
    exit 1
fi

echo "Booting simulator: $DEVICE_ID"
xcrun simctl boot "$DEVICE_ID" 2>/dev/null || true
open -a Simulator
