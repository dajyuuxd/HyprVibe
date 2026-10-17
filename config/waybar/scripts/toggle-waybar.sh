#!/usr/bin/env bash
# ==============================================================================
# Toggle Waybar Taskbar Visibility (Super + B)
# If hidden: shows it. If visible: hides it. If not running: launches it.
# ==============================================================================

if pgrep -x waybar >/dev/null 2>&1; then
    pkill -SIGUSR1 -x waybar
else
    export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"
    export LD_LIBRARY_PATH="/home/ming/.local/usr/lib:${LD_LIBRARY_PATH:-}"
    /home/ming/.local/usr/bin/waybar \
        -c /home/ming/.config/waybar/config.jsonc \
        -s /home/ming/.config/waybar/style.css >/dev/null 2>&1 &
fi
