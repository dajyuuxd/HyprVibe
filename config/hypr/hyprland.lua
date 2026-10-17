-- =============================================================================
-- Hyprland Lua Configuration
-- Tailored for compact displays (1366x768) with a modern aesthetic
-- =============================================================================

--------------------------------------------------------------------------------
-- 1. MONITORS
--------------------------------------------------------------------------------
hl.monitor({
    output   = "DP-1",
    mode     = "1366x768@59.79",
    position = "0x0",
    scale    = 1,
})

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

--------------------------------------------------------------------------------
-- 2. ENVIRONMENT VARIABLES
--------------------------------------------------------------------------------
hl.env("HYPRCURSOR_THEME", "catppuccin-mocha-dark-cursors")
hl.env("XCURSOR_THEME", "catppuccin-mocha-dark-cursors")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_SIZE", "24")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_STYLE_OVERRIDE", "Breeze")
hl.env("QT_PLUGIN_PATH", "/home/ming/.local/usr/lib/qt6/plugins:/usr/lib/qt6/plugins")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("PATH", "/home/ming/.local/bin:/home/ming/.local/usr/bin:" .. (os.getenv("PATH") or ""))
hl.env("LD_LIBRARY_PATH", "/home/ming/.local/usr/lib")

--------------------------------------------------------------------------------
-- 3. AUTOSTART
--------------------------------------------------------------------------------
hl.on("hyprland.start", function()
    -- Sync systemd & DBus environments
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Core desktop services
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1 &")
    hl.exec_cmd("dunst &")
    hl.exec_cmd("/home/ming/.local/usr/bin/hyprpaper -c /home/ming/.config/hypr/hyprpaper.conf &")
    hl.exec_cmd("/home/ming/.config/waybar/scripts/launch-waybar.sh &")
    hl.exec_cmd("/home/ming/.config/hypr/scripts/launch-clipboard.sh &")
    hl.exec_cmd("/home/ming/.config/hypr/scripts/launch-audio.sh &")
    hl.exec_cmd("/home/ming/.config/hypr/scripts/launch-wallpaper.sh &")
end)

-- Ensure supervisor daemons are running even on live reload (flock guarantees singleton)
hl.exec_cmd("/home/ming/.config/waybar/scripts/launch-waybar.sh &")
hl.exec_cmd("/home/ming/.config/hypr/scripts/launch-clipboard.sh &")
hl.exec_cmd("/home/ming/.config/hypr/scripts/launch-audio.sh &")
hl.exec_cmd("/home/ming/.config/hypr/scripts/launch-wallpaper.sh &")

--------------------------------------------------------------------------------
-- 4. LOOK AND FEEL (Optimized for small screens)
--------------------------------------------------------------------------------
hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 6,
        border_size = 2,
        col = {
            active_border   = "rgba(89b4faee)",
            inactive_border = "rgba(205, 214, 244, 0.28)",
        },
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 10,
        active_opacity = 1.0,
        inactive_opacity = 0.92,
        shadow = {
            enabled = true,
            range = 8,
            render_power = 2,
            color = "rgba(11111b88)",
        },
        blur = {
            enabled = true,
            size = 8,
            passes = 3,
            vibrancy = 0.25,
        },
    },
    cursor = {
        no_hardware_cursors = true,
        enable_hyprcursor = true,
        use_cpu_buffer = 2,
        warp_on_change_workspace = true,
    },
    animations = {
        enabled = true,
    },
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    },
})

-- Smooth responsive curves
hl.curve("smoothOut", { type = "bezier", points = { {0.16, 1}, {0.3, 1} } })
hl.animation({ leaf = "global",     enabled = true, speed = 4, bezier = "smoothOut" })
hl.animation({ leaf = "windows",    enabled = true, speed = 3, bezier = "smoothOut" })
hl.animation({ leaf = "windowsIn",  enabled = true, speed = 3, bezier = "smoothOut", style = "popin 90%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "smoothOut", style = "popin 90%" })
hl.animation({ leaf = "fade",       enabled = true, speed = 3, bezier = "smoothOut" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "smoothOut", style = "slide" })

--------------------------------------------------------------------------------
-- 5. INPUT
--------------------------------------------------------------------------------
hl.config({
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
        },
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

--------------------------------------------------------------------------------
-- 6. KEYBINDINGS
--------------------------------------------------------------------------------
local mainMod = "SUPER"

-- Applications
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd("dolphin"))
hl.bind(mainMod .. " + SPACE",   hl.dsp.exec_cmd("/home/ming/.config/hypr/scripts/toggle-spotlight.sh"))
hl.bind("CTRL + SPACE",          hl.dsp.exec_cmd("/home/ming/.config/hypr/scripts/toggle-spotlight.sh"))
hl.bind(mainMod .. " + V",      hl.dsp.exec_cmd("/home/ming/.config/hypr/scripts/paste-history.sh"))
hl.bind(mainMod .. " + B",      hl.dsp.exec_cmd("/home/ming/.config/waybar/scripts/toggle-waybar.sh"))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("/home/ming/.config/hypr/scripts/power-menu.sh"))

-- Window Actions
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

-- Super + D: Show Desktop (Hide all windows / Resume to normal)
local desktop_state = {
    active = false,
    prev_ws = 1,
}

local function toggle_desktop()
    local cur_ws = hl.get_active_workspace()
    local cur_id = cur_ws and cur_ws.id or 1

    if cur_id == 99 then
        desktop_state.active = false
        hl.dispatch(hl.dsp.focus({ workspace = desktop_state.prev_ws }))
    else
        desktop_state.prev_ws = cur_id
        desktop_state.active = true
        hl.dispatch(hl.dsp.focus({ workspace = 99 }))
    end
end
hl.bind(mainMod .. " + D", toggle_desktop)

-- Window Display Toggle (Super + R)
-- Default first click floats and sizes to half screen centered; second click tiles back
local function toggle_display()
    local win = hl.get_active_window()
    if win then
        if win.floating then
            hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
        else
            hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
            hl.dispatch(hl.dsp.window.resize({ x = 683, y = 480 }))
            hl.dispatch(hl.dsp.window.center())
        end
    end
end
hl.bind(mainMod .. " + R", toggle_display)

-- Super + H / L (and Super + Space + H / L):
-- When floating in half-screen mode, snaps window to Left / Right half of screen!
-- When tiled, focuses the neighbor window left / right.
local function snap_or_focus(direction)
    local win = hl.get_active_window()
    if win then
        if win.floating then
            if direction == "left" then
                hl.dispatch(hl.dsp.window.resize({ x = 674, y = 724 }))
                hl.dispatch(hl.dsp.window.move({ x = 6, y = 38 }))
            elseif direction == "right" then
                hl.dispatch(hl.dsp.window.resize({ x = 674, y = 724 }))
                hl.dispatch(hl.dsp.window.move({ x = 686, y = 38 }))
            end
        else
            hl.dispatch(hl.dsp.focus({ direction = direction }))
        end
    end
end

-- Super + J / K:
-- When floating, snaps window to Top / Bottom half of screen!
-- When tiled, moves window up / down.
local function snap_or_move(direction)
    local win = hl.get_active_window()
    if win then
        if win.floating then
            if direction == "up" then
                hl.dispatch(hl.dsp.window.resize({ x = 1354, y = 356 }))
                hl.dispatch(hl.dsp.window.move({ x = 6, y = 38 }))
            elseif direction == "down" then
                hl.dispatch(hl.dsp.window.resize({ x = 1354, y = 356 }))
                hl.dispatch(hl.dsp.window.move({ x = 6, y = 400 }))
            end
        else
            hl.dispatch(hl.dsp.window.move({ direction = direction }))
        end
    end
end

-- Workspace Navigation: Change focus between workspaces
local function cycle_workspace(step)
    local cur_ws = hl.get_active_workspace()
    local cur_id = cur_ws and cur_ws.id or 1
    local target_id = cur_id + step
    if target_id < 1 then target_id = 1 end
    if target_id > 9 then target_id = 9 end
    hl.dispatch(hl.dsp.focus({ workspace = target_id }))
end

-- Super + [ / ]: Previous / Next workspace
hl.bind(mainMod .. " + bracketleft",  function() cycle_workspace(-1) end)
hl.bind(mainMod .. " + bracketright", function() cycle_workspace(1) end)

hl.bind(mainMod .. " + Tab",          function() cycle_workspace(1) end)
hl.bind(mainMod .. " + SHIFT + Tab",  function() cycle_workspace(-1) end)
hl.bind(mainMod .. " + CTRL + Right", function() cycle_workspace(1) end)
hl.bind(mainMod .. " + CTRL + Left",  function() cycle_workspace(-1) end)

-- Circular Window Focus (Super + H / L):
-- If 2 or more windows exist, cycles focus continuously through ALL windows in a circle:
-- Super + L: Next window in cycle (e.g. Terminal 1 -> Terminal 2 -> Chrome -> Terminal 1)
-- Super + H: Previous window in cycle (e.g. Chrome -> Terminal 2 -> Terminal 1 -> Chrome)
local function cycle_or_snap(forward)
    local win = hl.get_active_window()
    local ws = hl.get_active_workspace()
    local win_count = ws and ws.windows or 0

    if win and win.floating and win_count <= 1 then
        if forward then
            hl.dispatch(hl.dsp.window.resize({ x = 674, y = 724 }))
            hl.dispatch(hl.dsp.window.move({ x = 686, y = 38 }))
        else
            hl.dispatch(hl.dsp.window.resize({ x = 674, y = 724 }))
            hl.dispatch(hl.dsp.window.move({ x = 6, y = 38 }))
        end
    else
        hl.dispatch(hl.dsp.window.cycle_next({ forward = forward }))
    end
end

-- Super + H / L: focus the window on the LEFT / RIGHT of the active window.
-- If the active window is floating, it snaps to that half of the screen instead.
hl.bind(mainMod .. " + H", function() snap_or_focus("left") end)
hl.bind(mainMod .. " + L", function() snap_or_focus("right") end)

-- Bonus: continuous circular window cycling is also available on Alt + Tab.
hl.bind("ALT + TAB",         function() cycle_or_snap(true) end)
hl.bind("ALT + SHIFT + TAB", function() cycle_or_snap(false) end)
hl.bind(mainMod .. " + Left",   function() snap_or_focus("left") end)
hl.bind(mainMod .. " + Right",  function() snap_or_focus("right") end)
hl.bind(mainMod .. " + Up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + Down",  hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + J", function() snap_or_move("up") end)
hl.bind(mainMod .. " + K", function() snap_or_move("down") end)

-- Move window horizontally: Super + Shift + H / L / Arrows
hl.bind(mainMod .. " + SHIFT + H",     hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L",     hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + Left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + Up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + Down",  hl.dsp.window.move({ direction = "down" }))

-- Move current window to detail workspace and switch focus
local function move_window_to_ws(target_ws)
    local win = hl.get_active_window()
    if win then
        hl.dispatch(hl.dsp.window.move({ workspace = target_ws }))
        hl.dispatch(hl.dsp.focus({ workspace = target_ws }))
    end
end

-- Keybinds for Workspaces 1-9:
-- Super + [1..9]: focus workspace
-- Super + Shift + [1..9]: move active window to detail workspace
local shift_symbols = {
    [1] = "exclam",
    [2] = "at",
    [3] = "numbersign",
    [4] = "dollar",
    [5] = "percent",
    [6] = "asciicircum",
    [7] = "ampersand",
    [8] = "asterisk",
    [9] = "parenleft",
}

for i = 1, 9 do
    -- Switch focus to workspace 1..9
    hl.bind(mainMod .. " + " .. i,    function() hl.dispatch(hl.dsp.focus({ workspace = i })) end)
    hl.bind(mainMod .. " + KP_" .. i, function() hl.dispatch(hl.dsp.focus({ workspace = i })) end)

    -- Move current window to detail workspace
    local sym = shift_symbols[i]
    hl.bind(mainMod .. " + SHIFT + " .. i,    function() move_window_to_ws(i) end)
    hl.bind(mainMod .. " + SHIFT + KP_" .. i, function() move_window_to_ws(i) end)
    if sym then
        hl.bind(mainMod .. " + SHIFT + " .. sym, function() move_window_to_ws(i) end)
        hl.bind(mainMod .. " + " .. sym,         function() move_window_to_ws(i) end)
    end
end

-- Screenshots: Super + Shift + S (interactive region) or Print (fullscreen)
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("/home/ming/.config/hypr/scripts/screenshot.sh area"))
hl.bind("Print",                   hl.dsp.exec_cmd("/home/ming/.config/hypr/scripts/screenshot.sh full"))

-- Multimedia keys (Audio & Brightness)
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("/home/ming/.config/waybar/scripts/volume.sh down && pkill -SIGRTMIN+1 waybar || true"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("/home/ming/.config/waybar/scripts/volume.sh up && pkill -SIGRTMIN+1 waybar || true"))

hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("/home/ming/.config/waybar/scripts/volume.sh up && pkill -SIGRTMIN+1 waybar || true"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("/home/ming/.config/waybar/scripts/volume.sh down && pkill -SIGRTMIN+1 waybar || true"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("/home/ming/.config/waybar/scripts/volume.sh mute && pkill -SIGRTMIN+1 waybar || true"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+ 2>/dev/null || true"),      { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%- 2>/dev/null || true"),      { locked = true, repeating = true })

-- Mouse Controls
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Exit Hyprland
hl.bind(mainMod .. " + SHIFT + Escape", hl.dsp.exit())

--------------------------------------------------------------------------------
-- 7. WINDOW & LAYER RULES
--------------------------------------------------------------------------------
hl.window_rule({
    name = "suppress-maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Float dialogs and file choosers
hl.window_rule({
    name = "float-dialogs",
    match = { title = "^(Open|Save|Choose|Select|Confirm).*" },
    float = true,
})

-- Polkit KDE agent window
hl.window_rule({
    name = "float-polkit",
    match = { class = "org.kde.polkit-kde-authentication-agent-1" },
    float = true,
})

-- Dolphin file manager styling (rounded Catppuccin dark glass)
hl.window_rule({
    name = "dolphin-styling",
    match = { class = "org.kde.dolphin" },
    rounding = 14,
    opacity = 0.95,
})

-- Blur effects for waybar and wofi
hl.layer_rule({ name = "waybar-blur", match = { namespace = "waybar" }, blur = true })
hl.layer_rule({ name = "wofi-blur",   match = { namespace = "wofi" },   blur = true })
