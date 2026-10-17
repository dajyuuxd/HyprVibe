# Catppuccin Mocha Hyprland Setup (Small Screen Edition)

A minimalist, high-performance, and aesthetic desktop environment built on **Arch Linux** using **Hyprland** (0.56.2+ Lua configuration). Carefully tailored and optimized for compact displays (such as 1366x768) with smooth animations, deep frosted glass blur, and intuitive keybindings.

---

## 📸 Overview & Features

- **Tailored for Small Displays**: 32px slim taskbar, compact window gaps (3px/6px), streamlined paddings.
- **Straight Frosted Glass Taskbar (Waybar)**:
  - Deep background layer blur (`passes = 3, size = 8`).
  - Floating rounded bubble modules for Workspaces, Host badge, History, Volume, WiFi, Bluetooth, Tray, Clock, and Power.
- **In-Memory Command History (Max 15)**:
  - Stores terminal commands exclusively in RAM (`/dev/shm`), leaving no disk trace.
  - Automatically filters and purges junk commands (`ls`, `cd`, `pwd`, `clear`, `exit`, typos).
  - Clickable Waybar bubble to view history and re-execute commands via Wofi.
- **macOS Spotlight-style Launcher**:
  - Bound to <kbd>Super</kbd> + <kbd>Space</kbd> with JetBrainsMono Nerd Font and smooth blur.
  - Dismissible with <kbd>Esc</kbd> or clicking outside.
- **Power Menu**:
  - Quick popup for Shutdown, Reboot, Suspend, Hibernate, Lock, and Logout via <kbd>Super</kbd> + <kbd>Esc</kbd> or the taskbar power bubble.
- **Show Desktop**:
  - <kbd>Super</kbd> + <kbd>D</kbd> cleanly hides all windows to show the clean wallpaper; press again to resume all windows in place.
- **Dynamic Terminal Font Scaling**:
  - Scale font in Kitty with <kbd>Super</kbd> + <kbd>=</kbd> and <kbd>Super</kbd> + <kbd>-</kbd> (resets to default 10.5 on exit).

---

## ⌨️ Keybindings Cheat Sheet

| Keybinding | Action |
| :--- | :--- |
| <kbd>Super</kbd> + <kbd>Return</kbd> | Open Kitty Terminal |
| <kbd>Super</kbd> + <kbd>E</kbd> | Open File Manager (Dolphin) |
| <kbd>Super</kbd> + <kbd>Space</kbd> | Spotlight Application Launcher (Wofi) |
| <kbd>Super</kbd> + <kbd>Q</kbd> | Close Active Window |
| <kbd>Super</kbd> + <kbd>F</kbd> | Fullscreen Toggle |
| <kbd>Super</kbd> + <kbd>D</kbd> | Show Desktop (Hide all windows / Resume) |
| <kbd>Super</kbd> + <kbd>R</kbd> | Window Display Mode (Float Half-screen ↔ Tile) |
| <kbd>Super</kbd> + <kbd>H</kbd> | Switch to Previous Workspace |
| <kbd>Super</kbd> + <kbd>L</kbd> | Switch to Next Workspace |
| <kbd>Super</kbd> + <kbd>Left</kbd> / <kbd>Right</kbd> | Focus Neighbor Window Left / Right |
| <kbd>Super</kbd> + <kbd>Up</kbd> / <kbd>Down</kbd> | Focus Neighbor Window Up / Down |
| <kbd>Super</kbd> + <kbd>1</kbd> .. <kbd>9</kbd> | Switch to Workspace 1 through 9 |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>1</kbd> .. <kbd>9</kbd> | Move Active Window to Workspace 1..9 & Follow Focus |
| <kbd>Super</kbd> + <kbd>Tab</kbd> | Focus Next Workspace |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>Tab</kbd> | Focus Previous Workspace |
| <kbd>Super</kbd> + <kbd>M</kbd> | Increase Audio Volume (+5%) |
| <kbd>Super</kbd> + <kbd>N</kbd> | Decrease Audio Volume (-5%) |
| <kbd>Super</kbd> + <kbd>=</kbd> / <kbd>-</kbd> | Increase / Decrease Terminal Font Size (Kitty) |
| <kbd>Super</kbd> + <kbd>0</kbd> | Reset Terminal Font Size to Default |
| <kbd>Super</kbd> + <kbd>Esc</kbd> | System Power Menu (Shutdown, Reboot, Hibernate, etc.) |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>S</kbd> | Interactive Region Screenshot |
| <kbd>Print</kbd> | Fullscreen Screenshot |

---

## 📦 Directory Structure

```text
Setup/
├── config/
│   ├── hypr/
│   │   ├── hyprland.lua       # Main Hyprland Lua configuration
│   │   ├── hyprpaper.conf      # Hyprpaper wallpaper configuration
│   │   └── scripts/            # Spotlight, Power Menu, Screenshot scripts
│   ├── waybar/
│   │   ├── config.jsonc        # Straight frosted glass bar & bubble modules
│   │   ├── style.css           # Catppuccin Mocha glass styling
│   │   └── scripts/            # Volume, user badge, RAM command history
│   ├── kitty/
│   │   └── kitty.conf          # Font scaling, Catppuccin Mocha colors
│   ├── wofi/
│   │   ├── config              # Spotlight configuration
│   │   └── style.css           # Glassmorphism theme with JetBrainsMono NF
│   ├── dunst/
│   │   └── dunstrc             # Dark glass notifications
│   └── dolphinrc               # Dolphin file manager settings
├── assets/
│   ├── background/             # 1366x768 gradient wallpaper
│   └── icons/                  # Catppuccin Mocha Dark cursor theme
├── install.sh                  # Automated one-click installer
└── README.md
```

---

## 🚀 Installation

Run the automated installer on any fresh Arch Linux system:

```bash
chmod +x install.sh
./install.sh
```
