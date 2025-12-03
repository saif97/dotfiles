#!/usr/bin/env bash

# Uninstall all user-installed Android apps via ADB
# This script only removes user-installed apps, not system apps

set -e

echo "Checking ADB connection..."
if ! adb devices | grep -q "device$"; then
    echo "Error: No Android device found. Please connect a device and enable USB debugging."
    exit 1
fi

echo "Fetching list of user-installed packages..."
packages=$(adb shell pm list packages -3 | cut -d: -f2)

if [ -z "$packages" ]; then
    echo "No user-installed packages found."
    exit 0
fi

package_count=$(echo "$packages" | wc -l | xargs)
echo "Found $package_count user-installed packages to uninstall."
echo ""

counter=1
for package in $packages; do
    echo "[$counter/$package_count] Uninstalling: $package"
    adb uninstall "$package" 2>/dev/null || echo "  ⚠️  Failed to uninstall $package"
    ((counter++))
done

echo ""
echo "✅ Uninstallation complete!"
