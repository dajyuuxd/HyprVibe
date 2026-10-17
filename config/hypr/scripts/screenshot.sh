#!/bin/bash
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILE="$DIR/Screenshot_$(date +%Y%m%d_%H%M%S).png"

if [ "$1" = "area" ]; then
    GEOM=$(slurp -d -b 1e1e2ebb -c 89b4faee -s 89b4fa33 2>/dev/null)
    [ -z "$GEOM" ] && exit 0
    grim -g "$GEOM" "$FILE"
else
    grim "$FILE"
fi

if [ -f "$FILE" ]; then
    /home/ming/.local/bin/notify-send "Screenshot Captured" "$(basename "$FILE") saved to Screenshots"
fi
