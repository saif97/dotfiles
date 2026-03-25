#!/bin/bash
# Save clipboard image to shared dir and copy VM-side path to clipboard.
# Triggered via Karabiner on the HOST machine (Cmd+Opt+V).
# No dependencies — uses native osascript.

SHARED_DIR="$HOME/dev/clipboard"
VM_PATH="/Users/admin/dev/clipboard"
TIMESTAMP=$(date +%s)
FILENAME="clip_${TIMESTAMP}.png"
HOST_FILE="${SHARED_DIR}/${FILENAME}"
VM_FILE="${VM_PATH}/${FILENAME}"

mkdir -p "$SHARED_DIR"

# Check if clipboard has an image
if ! osascript -e 'the clipboard as «class PNGf»' &>/dev/null; then
	afplay /System/Library/Sounds/Basso.aiff &
	exit 1
fi

# Save clipboard image to shared dir
osascript \
	-e 'set png_data to (the clipboard as «class PNGf»)' \
	-e "set fp to open for access POSIX file \"${HOST_FILE}\" with write permission" \
	-e 'write png_data to fp' \
	-e 'close access fp'

# Copy VM-side path to clipboard
echo -n "$VM_FILE" | pbcopy

afplay /System/Library/Sounds/Pop.aiff &
