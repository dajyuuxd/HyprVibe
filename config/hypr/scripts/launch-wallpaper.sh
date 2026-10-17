#!/usr/bin/env bash
# ==============================================================================
# Wallpaper Rotation Supervisor
# Keeps the desktop background changing by cycling through ~/Pictures/Background
# on a fixed interval. Flock-protected so only one rotation loop ever runs.
# Override the interval (seconds) with the WALLPAPER_INTERVAL env variable.
# ==============================================================================

LOCKFILE="${XDG_RUNTIME_DIR:-/tmp}/wallpaper-rotate.lock"
exec 200>"$LOCKFILE"
flock -n 200 || exit 0

export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"
INTERVAL="${WALLPAPER_INTERVAL:-600}"
SCRIPT="$HOME/.config/hypr/scripts/wallpaper.sh"

# Wait for the compositor socket to appear
SOCK="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/$WAYLAND_DISPLAY"
while [ ! -S "$SOCK" ]; do sleep 0.5; done

# Give hyprpaper a moment to start, then rotate forever
sleep 2
while true; do
    "$SCRIPT"
    sleep "$INTERVAL"
done
