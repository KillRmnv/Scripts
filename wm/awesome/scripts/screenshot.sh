#!/bin/bash

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILE="$DIR/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"

case "$1" in
    full)
        maim "$FILE"
        ;;
    select)
        maim -s "$FILE"
        ;;
    clipboard)
        maim | xclip -selection clipboard -t image/png
        notify-send "Screenshot" "Copied to clipboard"
        exit 0
        ;;
    select_clipboard)
        maim -s | xclip -selection clipboard -t image/png
        notify-send "Screenshot" "Selection copied to clipboard"
        exit 0
        ;;
esac

if [ -f "$FILE" ]; then
    notify-send "Screenshot" "Saved: $(basename $FILE)" -i "$FILE"
fi
