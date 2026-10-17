#!/bin/bash
STATE_FILE="$HOME/.config/waybar/scripts/.volume_state"

# Initialize state if not present (default 75% unmuted)
if [ ! -f "$STATE_FILE" ]; then
    echo "75 0" > "$STATE_FILE"
fi

read -r VOL MUTED < "$STATE_FILE"
[ -z "$VOL" ] && VOL=75
[ -z "$MUTED" ] && MUTED=0

case "$1" in
    up)
        VOL=$((VOL + 5))
        [ "$VOL" -gt 100 ] && VOL=100
        MUTED=0
        ;;
    down)
        VOL=$((VOL - 5))
        [ "$VOL" -lt 0 ] && VOL=0
        ;;
    mute)
        if [ "$MUTED" -eq 1 ]; then
            MUTED=0
        else
            MUTED=1
        fi
        ;;
esac

echo "$VOL $MUTED" > "$STATE_FILE"

# Format for Waybar JSON
if [ "$MUTED" -eq 1 ]; then
    ICON="󰝟"
    TEXT="$ICON Muted"
    CLASS="muted"
else
    if [ "$VOL" -ge 65 ]; then
        ICON="󰕾"
    elif [ "$VOL" -ge 30 ]; then
        ICON="󰖀"
    else
        ICON="󰕿"
    fi
    TEXT="$ICON $VOL%"
    CLASS="normal"
fi

printf '{"text": "%s", "tooltip": "Volume: %s%%", "class": "%s"}\n' "$TEXT" "$VOL" "$CLASS"
