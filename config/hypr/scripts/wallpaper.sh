#!/usr/bin/env bash
# ==============================================================================
# Wallpaper Picker
# Picks a random image from ~/Pictures/Background and applies it via hyprpaper.
# ==============================================================================

DIR="${WALLPAPER_DIR:-$HOME/Pictures/Background}"
[ -d "$DIR" ] || exit 0
command -v hyprctl >/dev/null 2>&1 || exit 0

mapfile -t images < <(find "$DIR" -maxdepth 1 -type f \
    \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \
       -o -iname '*.webp' -o -iname '*.bmp' \) 2>/dev/null | sort)

[ "${#images[@]}" -eq 0 ] && exit 0

# Avoid repeating the exact same wallpaper twice in a row when possible
last_file="${XDG_RUNTIME_DIR:-/tmp}/.last_wallpaper"
last="$(cat "$last_file" 2>/dev/null)"
img="${images[$((RANDOM % ${#images[@]}))]}"

if [ "${#images[@]}" -gt 1 ] && [ "$img" = "$last" ]; then
    for candidate in "${images[@]}"; do
        if [ "$candidate" != "$last" ]; then img="$candidate"; break; fi
    done
fi

hyprctl hyprpaper wallpaper ",$img" >/dev/null 2>&1
echo "$img" > "$last_file" 2>/dev/null
