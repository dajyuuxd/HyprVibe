#!/usr/bin/env bash
# ==============================================================================
# Battery Badge for Waybar
# Reads every battery under /sys/class/power_supply and reports the first one.
# On machines with no battery (desktops / VMs) it collapses itself (class
# "empty") so the bar stays clean instead of showing an anonymous pill.
# ==============================================================================

for bat in /sys/class/power_supply/BAT* /sys/class/power_supply/battery*; do
    [ -d "$bat" ] || continue

    cap="$(cat "$bat/capacity" 2>/dev/null)"
    [ -z "$cap" ] && continue
    status="$(cat "$bat/status" 2>/dev/null)"

    case "$status" in
        Charging|"Not charging")
            icon="󰂄"
            ;;
        Full)
            icon="󰁹"
            ;;
        *)
            if   [ "$cap" -ge 90 ]; then icon="󰂂"
            elif [ "$cap" -ge 80 ]; then icon="󰂁"
            elif [ "$cap" -ge 70 ]; then icon="󰂀"
            elif [ "$cap" -ge 60 ]; then icon="󰁿"
            elif [ "$cap" -ge 50 ]; then icon="󰁾"
            elif [ "$cap" -ge 40 ]; then icon="󰁽"
            elif [ "$cap" -ge 30 ]; then icon="󰁼"
            elif [ "$cap" -ge 20 ]; then icon="󰁻"
            else                        icon="󰁺"
            fi
            ;;
    esac

    class="normal"
    if   [ "$cap" -le 15 ]; then class="critical"
    elif [ "$cap" -le 30 ]; then class="warning"
    fi

    printf '{"text":"%s %s%%","tooltip":"Battery: %s%% (%s)","class":"%s"}\n' \
        "$icon" "$cap" "$cap" "${status:-Unknown}" "$class"
    exit 0
done

# No battery found: collapse the bubble entirely
printf '{"text":"","tooltip":"","class":"empty"}\n'
