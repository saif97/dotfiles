#!/usr/bin/env bash

# Uninstall specified apps from Android or iOS
# Default: simulators/emulators only
# Use --physical flag for physical devices

set -e

PHYSICAL=false

# Parse flags
while [[ $# -gt 0 ]]; do
    case $1 in
        --physical|-p)
            PHYSICAL=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--physical|-p]"
            exit 1
            ;;
    esac
done

# ============================================
# APP LIST - Update this list as needed
# Use package names for Android (com.example.app)
# Use bundle IDs for iOS (com.example.app)
# ============================================
APPS=(
    "com.example.wohiz"
)

# ============================================
# Platform Detection
# ============================================
detect_platform() {
    local android_connected=false
    local ios_connected=false

    if $PHYSICAL; then
        # Check for physical Android device
        if command -v adb &>/dev/null && adb devices 2>/dev/null | grep -w "device$" | grep -qv "emulator"; then
            android_connected=true
        fi
        # Check for physical iOS device
        if command -v xcrun &>/dev/null; then
            if xcrun devicectl list devices 2>/dev/null | grep -E "[0-9A-F]{8}-" | grep -qv "unavailable"; then
                ios_connected=true
            fi
        fi
    else
        # Check for Android emulator
        if command -v adb &>/dev/null && adb devices 2>/dev/null | grep -q "emulator.*device$"; then
            android_connected=true
        fi
        # Check for iOS simulator (booted)
        if command -v xcrun &>/dev/null && xcrun simctl list devices booted 2>/dev/null | grep -q "Booted"; then
            ios_connected=true
        fi
    fi

    if $android_connected && $ios_connected; then
        echo "both"
    elif $android_connected; then
        echo "android"
    elif $ios_connected; then
        echo "ios"
    else
        echo "none"
    fi
}

# ============================================
# Android Uninstall
# ============================================
uninstall_android() {
    local target_desc="emulator"
    local adb_target="-e"  # -e targets emulator

    if $PHYSICAL; then
        target_desc="physical device"
        adb_target="-d"  # -d targets physical device
    fi

    echo "🤖 Uninstalling apps from Android $target_desc..."
    echo ""

    local counter=1
    local total=${#APPS[@]}

    for app in "${APPS[@]}"; do
        echo "[$counter/$total] Uninstalling: $app"
        if adb $adb_target uninstall "$app" 2>/dev/null; then
            echo "  ✓ Success"
        else
            echo "  ⚠️  Failed or not installed"
        fi
        ((counter++))
    done
}

# ============================================
# iOS Uninstall
# ============================================
uninstall_ios() {
    if $PHYSICAL; then
        echo "🍎 Uninstalling apps from iOS physical device..."
        echo ""

        # Get physical device UDID
        local udid
        udid=$(xcrun devicectl list devices 2>/dev/null | grep -E "[0-9A-F]{8}-" | grep -v "unavailable" | head -1 | awk '{print $3}')

        if [ -z "$udid" ]; then
            echo "Error: Could not get iOS device UDID. Is the device connected and unlocked?"
            exit 1
        fi

        echo "Device UDID: $udid"
        echo ""

        local counter=1
        local total=${#APPS[@]}

        for app in "${APPS[@]}"; do
            echo "[$counter/$total] Uninstalling: $app"
            if xcrun devicectl device uninstall app --device "$udid" "$app" 2>/dev/null; then
                echo "  ✓ Success"
            else
                echo "  ⚠️  Failed or not installed"
            fi
            ((counter++))
        done
    else
        echo "🍎 Uninstalling apps from iOS Simulator..."
        echo ""

        local counter=1
        local total=${#APPS[@]}

        for app in "${APPS[@]}"; do
            echo "[$counter/$total] Uninstalling: $app"
            if xcrun simctl uninstall booted "$app" 2>/dev/null; then
                echo "  ✓ Success"
            else
                echo "  ⚠️  Failed or not installed"
            fi
            ((counter++))
        done
    fi
}

# ============================================
# Main
# ============================================
main() {
    if [ ${#APPS[@]} -eq 0 ]; then
        echo "No apps specified in the APPS list. Edit this script to add apps."
        exit 0
    fi

    echo "Apps to uninstall: ${#APPS[@]}"
    echo ""

    local platform
    platform=$(detect_platform)

    case $platform in
        android)
            uninstall_android
            ;;
        ios)
            uninstall_ios
            ;;
        both)
            echo "Both Android and iOS devices detected."
            echo "Please disconnect one device and try again."
            exit 1
            ;;
        none)
            if $PHYSICAL; then
                echo "Error: No physical Android or iOS device found."
                echo ""
                echo "For Android: Connect device and enable USB debugging"
                echo "For iOS: Connect device, unlock it, and trust this computer"
            else
                echo "Error: No Android emulator or iOS Simulator running."
                echo ""
                echo "For Android: Start an emulator via Android Studio or 'emulator -avd <name>'"
                echo "For iOS: Start a simulator via Xcode or 'xcrun simctl boot <device>'"
            fi
            exit 1
            ;;
    esac

    echo ""
    echo "✅ Uninstallation complete!"
}

main "$@"
