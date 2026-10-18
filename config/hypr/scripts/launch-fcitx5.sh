#!/usr/bin/env bash
# ==============================================================================
# Persistent Fcitx5 Input Method Launcher for Hyprland
# Ensures fcitx5 input method starts and stays active with Hyprland
# ==============================================================================

LOCKFILE="${XDG_RUNTIME_DIR:-/tmp}/fcitx5-launch.lock"
exec 203>"$LOCKFILE"
if ! flock -n 203; then
    exit 0
fi

export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"
export XDG_CURRENT_DESKTOP="${XDG_CURRENT_DESKTOP:-Hyprland}"
export XMODIFIERS="@im=fcitx"
export QT_IM_MODULE="fcitx"
export GTK_IM_MODULE="fcitx"
export SDL_IM_MODULE="fcitx"

if command -v fcitx5 >/dev/null 2>&1; then
    if ! pgrep -x fcitx5 >/dev/null 2>&1; then
        fcitx5 -d &
    fi
fi
