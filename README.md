# 🌌 Catppuccin Mocha Hyprland Desktop Environment
### *Tailored & Pixel-Optimized for Small Displays (1366×768 / 720p)*

[![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?logo=arch-linux&logoColor=fff&style=for-the-badge)](https://archlinux.org)
[![Hyprland](https://img.shields.io/badge/Hyprland-00AFFF?logo=wayland&logoColor=fff&style=for-the-badge)](https://hyprland.org)
[![Theme](https://img.shields.io/badge/Theme-Catppuccin%20Mocha-CBA6F7?style=for-the-badge)](https://github.com/catppuccin/catppuccin)
[![Font](https://img.shields.io/badge/Font-JetBrains%20Mono%20Nerd%20Font-89B4FA?style=for-the-badge)](https://www.nerdfonts.com/)

---

## 📖 Introduction

This repository contains a complete, handcrafted, and thoroughly unified desktop environment built upon **Arch Linux** and **Hyprland** (0.56.2+ Lua configuration engine). 

Unlike standard dotfiles designed for 1080p or 4K monitors that feel cramped and wasted on smaller screens, this configuration is meticulously scaled and crafted specifically for compact displays (such as **1366×768** laptops). Every margin, padding, bar dimension, font size, and animation has been tuned to provide maximum usable workspace while maintaining stunning aesthetics.

---

## ✨ Key Features & Highlights

### 1. 🪟 Straight Frosted Glass Taskbar (Waybar)
- **Edge-to-edge 32px slim bar** preserving vertical screen real estate.
- **Persistent Supervisor Daemon (`launch-waybar.sh`)**: Guaranteed to always start with Hyprland and automatically recover/restart within 1 second if ever terminated or interrupted.
- **Flock-protected Singleton**: Atomic kernel file-locking prevents duplicate instances across config reloads or service restarts.
- **Smooth Toggle (<kbd>Super</kbd> + <kbd>B</kbd>)**: Toggles bar visibility without terminating the process or supervisor loop.
- **Systemd User Unit Integration**: Includes optional `waybar.service` for systemd graphical session target.
- **Deep compositor layer blur** (`passes = 3, size = 8, vibrancy = 0.25`) creating true frosted glass.
- **Floating pill bubble modules**:
  - `( 1 ) ( 2 )` **Circular Workspaces**: Active workspace glowing with ice-blue border.
  - ` hostname@username`: Centered system badge.
  - `󰋚 <count>` **RAM Command History**: Real-time counter of saved commands.
  - `󰕾 <vol>%` **Interactive Volume**: Scroll to adjust, click to mute, zero latency.
  - `󰤨 WiFi / Network`: Live SSID and status.
  - `󰂯 Bluetooth`: Controller status indicator.
  - `󰥔 Clock & Date`: Calendar on hover.
  - `⏻ Power Menu Bubble`: One-click access to system power options.

### 2. 🔄 Circular Window Cycling (<kbd>Super</kbd> + <kbd>L</kbd> / <kbd>H</kbd>)
- Continuous multi-window focus cycle:
  $$\text{Window 1} \longrightarrow \text{Window 2} \longrightarrow \text{Window 3} \longrightarrow \text{Window 1}$$
- <kbd>Super</kbd> + <kbd>L</kbd> cycles **forward** through all windows on the workspace in a complete loop.
- <kbd>Super</kbd> + <kbd>H</kbd> cycles **backward** through the loop.
- Solves directional focus bottlenecks where navigation gets stuck bouncing back and forth ($1 \leftrightarrow 2$).

### 3. 🧠 In-Memory Command History (Max 15 in RAM)
- Stored exclusively in RAM (`/dev/shm/cmd_history_<user>.txt`), leaving zero disk footprint.
- **Intelligent Auto-Purge**: Automatically detects and strips junk commands (`ls`, `cd`, `pwd`, `clear`, `exit`, empty lines, typos, duplicates) once reaching the 15-entry limit.
- **Clickable Waybar Module**: Hover to see a numbered history tooltip; click to select and re-execute any command via an interactive Wofi menu.
- Shell-integrated via `PROMPT_COMMAND` in `~/.bashrc`.

### 4. 📋 Clipboard Paste History (<kbd>Super</kbd> + <kbd>V</kbd>)
- Powered by `cliphist`, `wl-clipboard`, and `wtype`.
- Automatically captures text and copied content in the background.
- Pressing <kbd>Super</kbd> + <kbd>V</kbd> opens a centered search modal: selecting any entry copies it to clipboard and automatically pastes it into your focused application.

### 5. 🔍 macOS Spotlight-Style App Search (<kbd>Super</kbd> + <kbd>Space</kbd>)
- Centered modal launcher (`wofi`) styled with `JetBrainsMono Nerd Font` and deep frosted glass blur.
- Dismissible at any time with <kbd>Esc</kbd> or by clicking outside.

### 6. 📁 Redesigned Dolphin File Manager
- Overhauled from harsh default white/gray squares into a sleek **Catppuccin Mocha Dark** interface.
- Translucent dark glass styling (`#1e1e2e`), rounded search and path navigators, custom scrollbars, and JetBrainsMono Nerd Font.
- Auto-configured via custom Qt stylesheet (`~/.config/dolphin/style.qss`), KDE color palettes (`kdeglobals`), and wrapper.

### 7. ⚡ One-Touch System Power Menu (<kbd>Super</kbd> + <kbd>Esc</kbd>)
- Clean popup modal for **Shutdown**, **Reboot**, **Suspend**, **Hibernate**, **Lock Session**, and **Logout**.
- Accessible via <kbd>Super</kbd> + <kbd>Esc</kbd> or clicking the red power bubble on the taskbar.

### 8. 🖥️ Show Desktop Toggle (<kbd>Super</kbd> + <kbd>D</kbd>)
- Instantly hides all active windows to display your wallpaper and clean desktop.
- Pressing <kbd>Super</kbd> + <kbd>D</kbd> again immediately resumes all windows with their exact layouts and focus preserved.

### 9. 🔤 Dynamic Terminal Font Scaling (<kbd>Super</kbd> + <kbd>=</kbd> / <kbd>-</kbd>)
- Scale font size up or down on the fly inside Kitty terminal.
- <kbd>Super</kbd> + <kbd>0</kbd> resets back to default.
- Closing and reopening the terminal automatically reverts to the default `10.5pt` font size.

---

## ⌨️ Complete Keybindings Cheat Sheet

### 🚀 Launchers & Applications
| Keybinding | Action |
| :--- | :--- |
| <kbd>Super</kbd> + <kbd>Return</kbd> | Open Kitty Terminal |
| <kbd>Super</kbd> + <kbd>E</kbd> | Open Redesigned Dolphin File Manager |
| <kbd>Super</kbd> + <kbd>Space</kbd> | Spotlight Application Launcher (Wofi) |
| <kbd>Super</kbd> + <kbd>V</kbd> | Clipboard Paste History (Cliphist + Wofi) |
| <kbd>Super</kbd> + <kbd>B</kbd> | Toggle Taskbar (Waybar) Visibility (Show / Hide) |
| <kbd>Super</kbd> + <kbd>Esc</kbd> | System Power Menu (Shutdown, Reboot, etc.) |

### 🪟 Window Management
| Keybinding | Action |
| :--- | :--- |
| <kbd>Super</kbd> + <kbd>Q</kbd> | Close Active Window |
| <kbd>Super</kbd> + <kbd>F</kbd> | Fullscreen Toggle |
| <kbd>Super</kbd> + <kbd>D</kbd> | Show Desktop (Hide all windows / Resume) |
| <kbd>Super</kbd> + <kbd>R</kbd> | Display Mode (Float Half-screen centered ↔ Tile) |
| <kbd>Super</kbd> + <kbd>L</kbd> | Cycle Focus to **Next Window** in Circle ($1 \rightarrow 2 \rightarrow 3 \rightarrow 1$) |
| <kbd>Super</kbd> + <kbd>H</kbd> | Cycle Focus to **Previous Window** in Circle ($3 \rightarrow 2 \rightarrow 1 \rightarrow 3$) |
| <kbd>Super</kbd> + <kbd>Left</kbd> / <kbd>Right</kbd> | Focus Neighbor Window Left / Right |
| <kbd>Super</kbd> + <kbd>Up</kbd> / <kbd>Down</kbd> | Focus Neighbor Window Up / Down |
| <kbd>Super</kbd> + <kbd>J</kbd> / <kbd>K</kbd> | Move Window Up / Down (Snap Top / Bottom when Floating) |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>H</kbd> / <kbd>L</kbd> | Move Window Position Left / Right |

### 🧭 Workspace Navigation
| Keybinding | Action |
| :--- | :--- |
| <kbd>Super</kbd> + <kbd>1</kbd> .. <kbd>9</kbd> | Switch to Workspace 1 through 9 |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>1</kbd> .. <kbd>9</kbd> | Move Active Window to Workspace 1..9 & Follow Focus |
| <kbd>Super</kbd> + <kbd>[</kbd> | Switch to Previous Workspace |
| <kbd>Super</kbd> + <kbd>]</kbd> | Switch to Next Workspace |
| <kbd>Super</kbd> + <kbd>Tab</kbd> | Focus Next Workspace |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>Tab</kbd> | Focus Previous Workspace |
| <kbd>Super</kbd> + Scroll Wheel | Cycle Workspaces Forward / Backward |

### 🔊 Audio, Fonts & Utilities
| Keybinding | Action |
| :--- | :--- |
| <kbd>Super</kbd> + <kbd>M</kbd> | Volume Up (+5%) with Zero-Latency Waybar Update |
| <kbd>Super</kbd> + <kbd>N</kbd> | Volume Down (-5%) with Zero-Latency Waybar Update |
| <kbd>Super</kbd> + <kbd>=</kbd> | Increase Terminal Font Size (Kitty) |
| <kbd>Super</kbd> + <kbd>-</kbd> | Decrease Terminal Font Size (Kitty) |
| <kbd>Super</kbd> + <kbd>0</kbd> | Reset Terminal Font Size to Default |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>S</kbd> | Interactive Region Screenshot (`slurp` + `grim`) |
| <kbd>Print</kbd> | Fullscreen Screenshot |

---

## 📂 Repository File Tree

```text
Setup/
├── bin/
│   └── dolphin                     # Dolphin wrapper applying Catppuccin stylesheet
├── config/
│   ├── hypr/
│   │   ├── hyprland.lua            # Complete Hyprland Lua configuration
│   │   ├── hyprpaper.conf          # Hyprpaper wallpaper configuration
│   │   └── scripts/
│   │       ├── paste-history.sh    # Super + V clipboard history manager
│   │       ├── power-menu.sh       # Super + Esc power options modal
│   │       ├── toggle-spotlight.sh # Super + Space spotlight launcher
│   │       └── screenshot.sh       # Area & fullscreen screenshot handler
│   ├── waybar/
│   │   ├── config.jsonc            # Waybar modules and bubble layout
│   │   ├── style.css               # Frosted glass styling with Catppuccin theme
│   │   └── scripts/
│   │       ├── cmd_history.sh      # In-memory RAM command history engine (max 15)
│   │       ├── user-host.sh        # Hostname & username badge generator
│   │       └── volume.sh           # State-based volume controller & notifier
│   ├── dolphin/
│   │   └── style.qss               # Dark Catppuccin Mocha stylesheet for Dolphin
│   ├── kitty/
│   │   └── kitty.conf              # Font scaling, typography, and Mocha colors
│   ├── wofi/
│   │   ├── config                  # Spotlight & clipboard window configuration
│   │   └── style.css               # Frosted glass styling with JetBrainsMono NF
│   ├── dunst/
│   │   └── dunstrc                 # Compact dark glass notification popups
│   ├── dolphinrc                   # Dolphin view mode & thumbnail configurations
│   └── kdeglobals                  # KDE / Qt6 Catppuccin Mocha global color palette
├── assets/
│   ├── background/
│   │   └── wallpaper.png           # 1366×768 sleek minimalist gradient wallpaper
│   └── icons/
│       └── catppuccin-mocha-dark-cursors # Smooth animated vector cursor theme
├── install.sh                      # Fully automated one-click installer
└── README.md                       # Comprehensive documentation & cheat sheet
```

---

## 🛠️ Installation Guide

### Prerequisites
- Fresh or existing **Arch Linux** installation.
- Working internet connection.

### One-Command Setup
Clone the repository and run the automated installer:

```bash
git clone https://github.com/<YOUR_GITHUB_USERNAME>/hyprland-setup.git ~/Setup
cd ~/Setup
chmod +x install.sh
./install.sh
```

The installer will automatically:
1. Install all official dependencies via `pacman` (`hyprland`, `hyprpaper`, `waybar`, `wofi`, `kitty`, `dolphin`, `breeze`, `cliphist`, `wl-clipboard`, `wtype`, `grim`, `slurp`, `ttf-jetbrains-mono-nerd`, etc.).
2. Fetch and configure `Symbols Nerd Font` and update font caches.
3. Install the Catppuccin Mocha cursor theme and wallpapers.
4. Back up any existing `~/.config` files into a timestamped directory.
5. Deploy all configurations, Qt stylesheets, and scripts with executable permissions.
6. Configure the RAM command history hook in `~/.bashrc`.
7. Reload the desktop environment live.

---

## 📤 Pushing to GitHub

To publish this repository to your own GitHub account:

```bash
cd ~/Setup

# Add your GitHub remote repository
git remote add origin https://github.com/<YOUR_GITHUB_USERNAME>/hyprland-setup.git

# Push the main branch
git push -u origin main
```

---

*Designed and crafted with precision for a smooth, distraction-free Linux desktop experience.*
