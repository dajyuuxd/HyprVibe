#!/usr/bin/env bash
# ==============================================================================
# Persistent Clipboard History Watcher
# Powered by cliphist and wl-clipboard
# ==============================================================================

LOCKFILE="${XDG_RUNTIME_DIR:-/tmp}/cliphist-watcher.lock"
exec 201>"$LOCKFILE"
if ! flock -n 201; then
    # Another watcher is already active
    exit 0
fi

export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"
export PATH="/home/ming/.local/bin:/home/ming/.local/usr/bin:$PATH"

# Wait for Wayland compositor socket to be ready
while [ -z "$WAYLAND_DISPLAY" ] || [ ! -S "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/$WAYLAND_DISPLAY" ]; do
    sleep 0.5
done

# Clean any orphaned wl-paste processes
pkill -x wl-paste 2>/dev/null || true
sleep 0.2

# Start text and image watchers
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

wait
