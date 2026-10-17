#!/usr/bin/env bash
# ==============================================================================
# Persistent Audio Launcher for Hyprland (PipeWire + WirePlumber)
# Ensures audio services always launch and stay active with Hyprland
# ==============================================================================

LOCKFILE="${XDG_RUNTIME_DIR:-/tmp}/pipewire-launch.lock"
exec 202>"$LOCKFILE"
if ! flock -n 202; then
    exit 0
fi

export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"

# Try starting via systemd user services first
if command -v systemctl >/dev/null 2>&1; then
    systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP 2>/dev/null || true
    systemctl --user start pipewire pipewire-pulse wireplumber 2>/dev/null || true
fi

# Fallback: direct process launch if any service didn't start via systemd
if ! pgrep -x pipewire >/dev/null 2>&1 && command -v pipewire >/dev/null 2>&1; then
    pipewire &
    sleep 0.5
fi

if ! pgrep -x pipewire-pulse >/dev/null 2>&1 && command -v pipewire-pulse >/dev/null 2>&1; then
    pipewire-pulse &
fi

if ! pgrep -x wireplumber >/dev/null 2>&1 && command -v wireplumber >/dev/null 2>&1; then
    wireplumber &
fi

# Wait for audio server to be ready and initialize volume
sleep 1
if command -v wpctl >/dev/null 2>&1; then
    wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 2>/dev/null || true
fi
