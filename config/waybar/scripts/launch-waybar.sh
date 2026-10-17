#!/usr/bin/env bash
# ==============================================================================
# Persistent Waybar Supervisor Daemon
# Ensures Waybar always runs and immediately restarts if ever interrupted
# ==============================================================================

LOCKFILE="${XDG_RUNTIME_DIR:-/tmp}/waybar-supervisor.lock"
exec 200>"$LOCKFILE"
if ! flock -n 200; then
    # Another supervisor is already running; exit gracefully
    exit 0
fi

export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"
export LD_LIBRARY_PATH="/home/ming/.local/usr/lib:${LD_LIBRARY_PATH:-}"

CONFIG="$HOME/.config/waybar/config.jsonc"
STYLE="$HOME/.config/waybar/style.css"
WAYBAR_BIN="/home/ming/.local/usr/bin/waybar"
[ ! -x "$WAYBAR_BIN" ] && WAYBAR_BIN="$(which waybar 2>/dev/null || echo '/usr/bin/waybar')"

# Wait for Wayland compositor socket to be ready
while [ -z "$WAYLAND_DISPLAY" ] || [ ! -S "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/$WAYLAND_DISPLAY" ]; do
    sleep 0.5
done

# Keep Waybar constantly running
while true; do
    "$WAYBAR_BIN" -c "$CONFIG" -s "$STYLE" >/dev/null 2>&1
    sleep 1
done
