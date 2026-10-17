#!/usr/bin/env bash
# ==============================================================================
# Clipboard History Manager for Hyprland (Super + V)
# Powered by cliphist, wl-clipboard, and wofi
# ==============================================================================

export PATH="/home/ming/.local/bin:/home/ming/.local/usr/bin:$PATH"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"

# Toggle off if wofi is already visible
if pidof wofi >/dev/null; then
    pkill -9 wofi
    exit 0
fi

# Ensure persistent watcher is running
if ! pgrep -f "launch-clipboard.sh" >/dev/null 2>&1; then
    /home/ming/.config/hypr/scripts/launch-clipboard.sh &
fi

items=$(cliphist list 2>/dev/null)

if [ -z "$items" ]; then
    notify-send -u low -t 2500 -i edit-paste "Clipboard History" "No items in clipboard yet.\nCopy any text with Ctrl+C or mouse select to begin!"
    exit 0
fi

selected=$(echo "$items" | wofi --dmenu \
    --prompt "Clipboard History..." \
    --width 540 \
    --height 350 \
    --location center \
    --hide-scroll \
    --insensitive \
    --style /home/ming/.config/wofi/style.css \
    --define=key_exit=Escape \
    --define=close_on_focus_loss=true)

if [ -n "$selected" ]; then
    # Extract item ID reliably
    item_id=$(echo "$selected" | awk '{print $1}')
    
    if [ -n "$item_id" ]; then
        # Decode original clipboard content directly by ID
        decoded=$(cliphist decode "$item_id" 2>/dev/null)
        
        if [ -n "$decoded" ]; then
            # Sync to both standard CLIPBOARD and PRIMARY selection
            printf "%s" "$decoded" | wl-copy
            printf "%s" "$decoded" | wl-copy --primary
            
            # Wait for wofi window unmap & compositor focus restore
            sleep 0.22
            
            # Trigger paste into the active window
            if command -v wtype >/dev/null 2>&1; then
                active_class=$(hyprctl activewindow -j 2>/dev/null | grep -Po '"class":\s*"\K[^"]*' || echo "")
                if [ "$active_class" = "kitty" ]; then
                    wtype -M ctrl -M shift -k v -m shift -m ctrl 2>/dev/null || wtype -M shift -k insert -m shift 2>/dev/null || true
                else
                    wtype -M ctrl -k v -m ctrl 2>/dev/null || true
                fi
            fi
        fi
    fi
fi
