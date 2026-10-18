#!/usr/bin/env bash
echo -e "\033[1;34m=========================================================\033[0m"
echo -e "\033[1;34m:: Setting up Complete Audio Stack (PipeWire + WirePlumber)\033[0m"
echo -e "\033[1;34m=========================================================\033[0m"

echo -e "\033[1;33m:: Installing packages via pacman (requires sudo password)...\033[0m"
sudo pacman -S --needed pipewire-audio pipewire-pulse pipewire-alsa wireplumber alsa-utils pavucontrol

echo -e "\033[1;32m:: Enabling and starting audio services...\033[0m"
systemctl --user enable --now pipewire pipewire-pulse wireplumber

echo -e "\033[1;32m:: Initializing audio volume to 100% and unmuting...\033[0m"
sleep 1
wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 2>/dev/null || true
wpctl set-volume @DEFAULT_AUDIO_SINK@ 1.0 2>/dev/null || true

# Refresh Waybar volume
pkill -SIGRTMIN+1 waybar 2>/dev/null || true

echo -e "\033[1;32m=========================================================\033[0m"
echo -e "\033[1;32m:: Audio successfully restored & volume set to 100%!\033[0m"
echo -e "\033[1;32m=========================================================\033[0m"
echo "Press Enter to exit..."
read -r
