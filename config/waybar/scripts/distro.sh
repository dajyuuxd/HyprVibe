#!/usr/bin/env bash
# ==============================================================================
# Linux Distribution Badge for Waybar
# Shows the distribution name (with its icon) and reports the version + kernel
# in the tooltip. Falls back gracefully on any distro.
# ==============================================================================

# shellcheck disable=SC1091
. /etc/os-release 2>/dev/null || true

name="${NAME:-Linux}"
pretty="${PRETTY_NAME:-$name}"
version="${VERSION:-${VERSION_ID:-${BUILD_ID:-}}}"
kernel="$(uname -r 2>/dev/null)"
arch="$(uname -m 2>/dev/null)"

# Distro glyph (falls back to the generic Tux icon)
case "$name" in
    Arch*)              icon="󰣇" ;;
    Ubuntu*)            icon="󰕈" ;;
    Debian*)            icon="󰕈" ;;
    Fedora*)            icon="󰣛" ;;
    Linux*Mint*|Mint*)  icon="󰣭" ;;
    openSUSE*|*SUSE*)   icon="󰣭" ;;
    Manjaro*)           icon="󰣇" ;;
    *)                  icon="󰌽" ;;
esac

# Build the tooltip (escaped newlines for JSON)
if [ -n "$version" ]; then
    tooltip="${pretty} (${version})\\nKernel: ${kernel}\\nArchitecture: ${arch}"
else
    tooltip="${pretty}\\nKernel: ${kernel}\\nArchitecture: ${arch}"
fi

printf '{"text":"%s %s","tooltip":"%s","class":"distro"}\n' "$icon" "$name" "$tooltip"
