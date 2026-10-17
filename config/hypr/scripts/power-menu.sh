#!/bin/bash
# Power Menu for Hyprland using Wofi
# Supports Shutdown, Reboot, Suspend, Hibernate, Lock, Logout

# Toggle: if wofi is already running, close it
if pidof wofi >/dev/null; then
    pkill -9 wofi
    exit 0
fi

shutdown="󰐥  Shutdown"
reboot="󰜉  Reboot"
suspend="󰤄  Suspend"
hibernate="󰒲  Hibernate"
lock="󰌾  Lock"
logout="󰗽  Logout"

options="$shutdown\n$reboot\n$suspend\n$hibernate\n$lock\n$logout"

chosen=$(echo -e "$options" | wofi --dmenu \
    --prompt "System Power" \
    --width 260 \
    --height 290 \
    --location center \
    --hide-scroll \
    --insensitive \
    --style /home/ming/.config/wofi/style.css \
    --define=key_exit=Escape \
    --define=close_on_focus_loss=true)

case "$chosen" in
    "$shutdown")
        systemctl poweroff
        ;;
    "$reboot")
        systemctl reboot
        ;;
    "$suspend")
        systemctl suspend
        ;;
    "$hibernate")
        systemctl hibernate
        ;;
    "$lock")
        loginctl lock-session 2>/dev/null || hyprlock 2>/dev/null || true
        ;;
    "$logout")
        hyprctl dispatch 'hl.dsp.exit()' 2>/dev/null || hyprctl dispatch exit || true
        ;;
esac
