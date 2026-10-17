#!/usr/bin/env bash
# ==============================================================================
# Clipboard History Manager for Hyprland (Super + V)
# Powered by cliphist, wl-clipboard, and wofi
# ==============================================================================

export PATH="/home/ming/.local/bin:/home/ming/.local/usr/bin:$PATH"

# Toggle off if wofi is already visible
if pidof wofi >/dev/null; then
    pkill -9 wofi
    exit 0
fi

# Ensure watcher daemon is running
if ! pgrep -f "wl-paste.*cliphist" >/dev/null 2>&1; then
    wl-paste --watch cliphist store >/dev/null 2>&1 &
fi

items=$(cliphist list 2>/dev/null)

if [ -z "$items" ]; then
    notify-send -u low -i edit-paste "Clipboard" "Clipboard history is empty"
    exit 0
fi

selected=$(echo "$items" | wofi --dmenu \
    --prompt "Paste History..." \
    --width 520 \
    --height 340 \
    --location center \
    --hide-scroll \
    --insensitive \
    --style /home/ming/.config/wofi/style.css \
    --define=key_exit=Escape \
    --define=close_on_focus_loss=true)

if [ -n "$selected" ]; then
    echo "$selected" | cliphist decode | wl-copy

    # Give focus back to the target window and simulate paste
    sleep 0.12
    if command -v wtype >/dev/null 2>&1; then
        active_class=$(hyprctl activewindow -j 2>/dev/null | grep -Po '"class":\s*"\K[^"]*' || echo "")
        if [ "$active_class" = "kitty" ]; then
            wtype -M shift -k insert -m shift 2>/dev/null || wtype -M ctrl -M shift -k v -m shift -m ctrl 2>/dev/null || true
        else
            wtype -M ctrl -k v -m ctrl 2>/dev/null || true
        fi
    fi
fi
