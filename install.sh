#!/usr/bin/env bash
# ==============================================================================
# Arch Linux + Hyprland Small Screen Setup Installer
# Complete automated setup and dependency installation script
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"

echo -e "\033[1;34m:: Starting Hyprland Desktop Setup & Dependency Installation...\033[0m"

# 1. Check Arch Linux / Pacman
if ! command -v pacman >/dev/null 2>&1; then
    echo -e "\033[1;31m[!] Error: pacman package manager not found. This script is designed for Arch Linux.\033[0m"
    exit 1
fi

# 2. Install Dependencies
echo -e "\033[1;32m:: [1/7] Installing System Dependencies with Pacman...\033[0m"
PKGS=(
    hyprland
    hyprpaper
    waybar
    wofi
    kitty
    dunst
    dolphin
    grim
    slurp
    wl-clipboard
    brightnessctl
    libnotify
    polkit-kde-agent
    qt5-wayland
    qt6-wayland
    xdg-desktop-portal-hyprland
    xdg-desktop-portal
    ttf-jetbrains-mono-nerd
    noto-fonts-emoji
    jq
    fastfetch
    networkmanager
    bluez
    bluez-utils
)

if [ "$EUID" -eq 0 ]; then
    pacman -Syu --needed --noconfirm "${PKGS[@]}"
else
    echo -e "\033[1;33m:: Requesting sudo permissions to install required packages...\033[0m"
    sudo pacman -Syu --needed --noconfirm "${PKGS[@]}"
fi

# 3. Setup Nerd Fonts & Glyph Support
echo -e "\033[1;32m:: [2/7] Configuring Fonts & Symbols...\033[0m"
FONT_DIR="$HOME/.local/share/fonts/NerdFonts"
mkdir -p "$FONT_DIR"

# Download Symbols Nerd Font if not present
if [ ! -f "$FONT_DIR/SymbolsNerdFont-Regular.ttf" ]; then
    echo ":: Downloading Symbols Nerd Font..."
    curl -fsSL "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFont-Regular.ttf" -o "$FONT_DIR/SymbolsNerdFont-Regular.ttf" || true
    curl -fsSL "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFontMono-Regular.ttf" -o "$FONT_DIR/SymbolsNerdFontMono-Regular.ttf" || true
fi
fc-cache -fv "$FONT_DIR" >/dev/null 2>&1 || true

# 4. Setup Cursor Theme
echo -e "\033[1;32m:: [3/7] Installing Catppuccin Cursor Theme...\033[0m"
ICON_DEST="$HOME/.local/share/icons"
mkdir -p "$ICON_DEST"
if [ -d "$SCRIPT_DIR/assets/icons/catppuccin-mocha-dark-cursors" ]; then
    cp -rf "$SCRIPT_DIR/assets/icons/catppuccin-mocha-dark-cursors" "$ICON_DEST/"
fi

# 5. Setup Background & Wallpapers
echo -e "\033[1;32m:: [4/7] Deploying Wallpaper Assets...\033[0m"
WALL_DIR="$HOME/Pictures/Background"
mkdir -p "$WALL_DIR"
if [ -f "$SCRIPT_DIR/assets/background/wallpaper.png" ]; then
    cp -f "$SCRIPT_DIR/assets/background/wallpaper.png" "$WALL_DIR/wallpaper.png"
fi

# 6. Backup & Deploy Configuration Files
echo -e "\033[1;32m:: [5/7] Deploying Config Files to ~/.config/...\033[0m"
mkdir -p "$HOME/.config"

CONFIG_TARGETS=(hypr waybar kitty wofi dunst)
for cfg in "${CONFIG_TARGETS[@]}"; do
    if [ -d "$HOME/.config/$cfg" ]; then
        mkdir -p "$BACKUP_DIR"
        echo ":: Backing up existing ~/.config/$cfg to $BACKUP_DIR/"
        mv "$HOME/.config/$cfg" "$BACKUP_DIR/"
    fi
    if [ -d "$SCRIPT_DIR/config/$cfg" ]; then
        cp -rf "$SCRIPT_DIR/config/$cfg" "$HOME/.config/"
    fi
done

# Dolphin config
if [ -f "$SCRIPT_DIR/config/dolphinrc" ]; then
    [ -f "$HOME/.config/dolphinrc" ] && cp -f "$HOME/.config/dolphinrc" "$BACKUP_DIR/" 2>/dev/null || true
    cp -f "$SCRIPT_DIR/config/dolphinrc" "$HOME/.config/dolphinrc"
fi

# Set executable permissions on all helper scripts
echo -e "\033[1;32m:: [6/7] Setting Script Permissions...\033[0m"
chmod +x "$HOME/.config/hypr/scripts/"*.sh 2>/dev/null || true
chmod +x "$HOME/.config/waybar/scripts/"*.sh 2>/dev/null || true

# 7. Setup In-Memory Command History Hook in ~/.bashrc
echo -e "\033[1;32m:: [7/7] Configuring Command History in RAM Hook...\033[0m"
BASHRC="$HOME/.bashrc"
touch "$BASHRC"
if ! grep -q "cmd_history.sh add" "$BASHRC" 2>/dev/null; then
    cat << 'EOF' >> "$BASHRC"

# Hyprland Waybar In-Memory History Hook
if [ -x "$HOME/.config/waybar/scripts/cmd_history.sh" ]; then
    PROMPT_COMMAND='bash "$HOME/.config/waybar/scripts/cmd_history.sh" add "$(HISTTIMEFORMAT= history 1 | sed "s/^[ ]*[0-9]*[ ]*//")"; '"$PROMPT_COMMAND"
fi
EOF
fi

# 8. Reload Running Session (if active)
if [ -n "${WAYLAND_DISPLAY:-}" ]; then
    echo ":: Reloading Hyprland configuration..."
    hyprctl reload 2>/dev/null || true
    if pgrep -x waybar >/dev/null 2>&1; then
        echo ":: Restarting Waybar..."
        pkill -x waybar || true
        sleep 0.5
        waybar -c "$HOME/.config/waybar/config.jsonc" -s "$HOME/.config/waybar/style.css" &>/dev/null &
        disown
    fi
fi

echo -e "\033[1;32m=========================================================\033[0m"
echo -e "\033[1;32m:: Setup completed successfully!\033[0m"
[ -d "$BACKUP_DIR" ] && echo -e "\033[1;33m:: Old configs backed up at: $BACKUP_DIR\033[0m"
echo -e "\033[1;34m:: Enjoy your sleek Hyprland desktop environment!\033[0m"
echo -e "\033[1;32m=========================================================\033[0m"
