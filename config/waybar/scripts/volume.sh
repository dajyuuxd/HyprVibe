#!/usr/bin/env bash
# ==============================================================================
# Waybar Real Audio Volume Controller
# Supports WirePlumber (wpctl), PulseAudio/Pipewire-Pulse (pactl), and ALSA
# ==============================================================================

# Handle Actions
case "$1" in
    up)
        if command -v wpctl >/dev/null 2>&1; then
            wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 2>/dev/null
            wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+ 2>/dev/null
        elif command -v pactl >/dev/null 2>&1; then
            pactl set-sink-mute @DEFAULT_SINK@ 0 2>/dev/null
            pactl set-sink-volume @DEFAULT_SINK@ +5% 2>/dev/null
        fi
        ;;
    down)
        if command -v wpctl >/dev/null 2>&1; then
            wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- 2>/dev/null
        elif command -v pactl >/dev/null 2>&1; then
            pactl set-sink-volume @DEFAULT_SINK@ -5% 2>/dev/null
        fi
        ;;
    mute)
        if command -v wpctl >/dev/null 2>&1; then
            wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle 2>/dev/null
        elif command -v pactl >/dev/null 2>&1; then
            pactl set-sink-mute @DEFAULT_SINK@ toggle 2>/dev/null
        fi
        ;;
    mixer)
        if command -v pavucontrol >/dev/null 2>&1; then
            pavucontrol &
        elif command -v alsamixer >/dev/null 2>&1; then
            kitty -e alsamixer &
        fi
        exit 0
        ;;
esac

# Read Real State
VOL=100
MUTED=0

if command -v wpctl >/dev/null 2>&1; then
    status=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null || echo "")
    if [ -n "$status" ]; then
        vol_raw=$(echo "$status" | awk '{print $2}')
        # Convert e.g. 0.85 -> 85
        VOL=$(awk -v v="$vol_raw" 'BEGIN { printf "%d", (v * 100) + 0.5 }')
        if echo "$status" | grep -q "MUTED"; then
            MUTED=1
        fi
    fi
elif command -v pactl >/dev/null 2>&1; then
    sink_info=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null || echo "")
    if [ -n "$sink_info" ]; then
        VOL=$(echo "$sink_info" | grep -Po '\d+%' | head -n 1 | tr -d '%')
        [ -z "$VOL" ] && VOL=100
        mute_info=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null || echo "")
        if echo "$mute_info" | grep -q "yes"; then
            MUTED=1
        fi
    fi
fi

# Fallback state file if audio service is currently offline
STATE_FILE="$HOME/.config/waybar/scripts/.volume_state"
if ! command -v wpctl >/dev/null 2>&1 && ! pactl info >/dev/null 2>&1; then
    [ -f "$STATE_FILE" ] && read -r VOL MUTED < "$STATE_FILE"
    [ -z "$VOL" ] && VOL=100
    [ -z "$MUTED" ] && MUTED=0
else
    echo "$VOL $MUTED" > "$STATE_FILE"
fi

# Determine Icon and Class
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

printf '{"text": "%s", "tooltip": "Volume: %s%%\nClick to mute, Scroll to adjust", "class": "%s"}\n' "$TEXT" "$VOL" "$CLASS"
