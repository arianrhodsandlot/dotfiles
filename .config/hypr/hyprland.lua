hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("easy", { type = "spring", mass = 1, stiffness = 500, dampening = 35 })
hl.animation({ leaf = "global", enabled = true, speed = 3, bezier = "quick" })
hl.animation({ leaf = "global", enabled = true, speed = 3, bezier = "quick" })
hl.animation({ leaf = "windows", enabled = true, speed = 3, spring = "easy", style = "slide" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "quick", style = "slide" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 2, bezier = "quick", style = "slide top" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 2, bezier = "quick", style = "slide bottom" })

HYPRLAND_COLOR1   = "rgb(0,168,244)"
HYPRLAND_COLOR2   = "rgb(0,229,208)"
WHITE             = "#fff"
GRAY              = "#808080"
ACTIVE_COLOR      = { colors = { HYPRLAND_COLOR1, HYPRLAND_COLOR2 } }
INACTIVE_COLOR    = { colors = { WHITE, GRAY } }
TRANSPARENT_COLOR = "#00000000"

hl.config({
    general = {
        gaps_in = 4,
        gaps_out = 4,
        border_size = 4,
        extend_border_grab_area = 10,
        resize_on_border = true,
        col = {
            active_border = {
                colors = { HYPRLAND_COLOR1, HYPRLAND_COLOR2 },
                angle = 45,
            },
            inactive_border = INACTIVE_COLOR,
        },
    },
    group = {
        col = {
            border_active = ACTIVE_COLOR,
            border_inactive = INACTIVE_COLOR,
            border_locked_active = ACTIVE_COLOR,
            border_locked_inactive = INACTIVE_COLOR,
        },
        groupbar = {
            font_size = 14,
            height = 28,
            indicator_height = 4,
            keep_upper_gap = false,
            col = {
                active = ACTIVE_COLOR,
                inactive = TRANSPARENT_COLOR,
                locked_active = ACTIVE_COLOR,
                locked_inactive = INACTIVE_COLOR,
            },
        },
    },
    decoration = {
        blur = { size = 5, passes = 10, special = true },
        dim_special = 0.3,
        rounding = 4,
    },
    dwindle = { preserve_split = true, },
    ecosystem = { no_update_news = true, no_donation_nag = true, },
    render = { direct_scanout = 2, },
    xwayland = { force_zero_scaling = true },
})

-- ===========================================================================
-- Programs / Monitors / Workspaces
-- ===========================================================================

TERMINAL        = "ghostty"
FILE_MANAGER    = "luciole"
BROWSER         = "microsoft-edge-stable"
EDITOR          = "zeditor"
-- Monitors
MONITOR1        = ""
MONITOR2        = ""
MONITOR3        = ""
PRIMARY_MONITOR = MONITOR1

-- Workspaces
NUM_WPM         = 4 -- Number of workspaces per monitor (Max 10)

-- ===========================================================================
-- Autostart
-- ===========================================================================
-- if you dont use UWSM add your auto start programs here, otherwise use XDG autostart https://wiki.archlinux.org/title/XDG_Autostart

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("xhost +SI:localuser:root")
end)

hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down", action = "close" })
hl.gesture({ fingers = 3, direction = "up", action = "fullscreen" })
hl.gesture({ fingers = 3, direction = "left", action = "float" })

-- ===========================================================================
-- Keybindings
-- ===========================================================================

local mainMod = "SUPER"
local noctCall = "noctalia msg "
local launchPrefix = "uwsm app -- " -- if you are not using UWSM, make this empty (e.g. "")

-- AZERTY fix: the number-row keys emit symbols (& é " ' ...) without Shift, so
-- binding to the digit characters fails. Bind by physical keycode instead.
-- Digit d -> evdev keycode: 1..9 => 10..18, 0 => 19
local function digitCode(d)
    return "code:" .. (d == 0 and 19 or (9 + d))
end

---------------------------
---- WINDOW MANAGEMENT ----
---------------------------

-- Window manipulation
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("hyprctl kill"))
hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + CONTROL + Return", hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- Change focus
hl.bind(mainMod .. " + Left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + Up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + Down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd(noctCall .. "window-switcher"))
hl.bind("ALT + Tab", hl.dsp.window.cycle_next())

-- Move active window around workspaces & monitors
hl.bind(mainMod .. " + SHIFT + Up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + Left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + Down", hl.dsp.window.move({ direction = "d" }))

-- Move & Resize with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

------------------
---- LAUNCHER ----
------------------

hl.bind(mainMod .. " + 1", hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER))
hl.bind(mainMod .. " + 2", hl.dsp.exec_cmd(launchPrefix .. BROWSER))
hl.bind(mainMod .. " + 3", hl.dsp.exec_cmd(launchPrefix .. EDITOR))
hl.bind(mainMod .. " + 4", hl.dsp.exec_cmd(launchPrefix .. TERMINAL))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(launchPrefix .. BROWSER))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(launchPrefix .. EDITOR))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(launchPrefix .. TERMINAL))

hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd(noctCall .. "panel-toggle session"))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(noctCall .. "session lock"))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher"))
hl.bind(mainMod .. " + semicolon", hl.dsp.exec_cmd(noctCall .. "settings-toggle"))

-- changegroupactive
hl.bind(mainMod .. " + G", hl.dsp.group.toggle(), { description = "Toggle group" })
hl.bind(mainMod .. " + ALT + Left", hl.dsp.group.prev())
hl.bind(mainMod .. " + ALT + Right", hl.dsp.group.next())
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.window.move({ out_of_group = true }))

hl.bind("Print", hl.dsp.exec_cmd(noctCall .. "screenshot-region"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(noctCall .. "panel-toggle clipboard"))
---------------------------
---- HARDWARE CONTROLS ----
---------------------------
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(noctCall .. "volume-down"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(noctCall .. "mic-mute"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(noctCall .. "volume-mute"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(noctCall .. "media next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(noctCall .. "media toggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(noctCall .. "media toggle"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(noctCall .. "media previous"), { locked = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(noctCall .. "volume-up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(noctCall .. "brightness-down"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(noctCall .. "brightness-up"), { locked = true, repeating = true })

-------------------------------
---- WORKSPACES & MONITORS ----
-------------------------------

-- Focus on workspace number
-- Absolute
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + ALT + " .. digitCode(key), hl.dsp.focus({ workspace = i }))
end
-- Relative
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + CONTROL + " .. digitCode(key), hl.dsp.focus({ workspace = "m~" .. i }))
end

-- Scroll through existing workspaces & monitors
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + CONTROL + Right", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + CONTROL + Left", hl.dsp.focus({ workspace = "m-1" }))

hl.workspace_rule({ workspace = "name:gaming", monitor = PRIMARY_MONITOR, default = true })
for i = 1, NUM_WPM do
    hl.workspace_rule({ workspace = tostring(i), monitor = MONITOR1, default = true, persistent = true })
end

-- Window rules wiki https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Generic floating position
hl.window_rule({ match = { float = true }, persistent_size = true })

-- Picture-in-Picture
hl.window_rule({
    match             = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" },
    float             = true,
    keep_aspect_ratio = true,
    size              = { "max(monitor_w, monitor_h)*0.25", "min(monitor_w, monitor_h)*0.25" },
    pin               = true,
})

-- Gaming
local gamingApps = "^(steam_app.*|gamescope)$"
local gamingWorkspace = "name:gaming"

hl.window_rule({ match = { content = "game" }, workspace = gamingWorkspace })
hl.window_rule({
    match = { xdg_tag = "^(.*game.*)$" },
    workspace = gamingWorkspace,
    fullscreen_state = 2,
    content =
    "game",
    sync_fullscreen = true
})
hl.window_rule({ match = { class = gamingApps }, workspace = gamingWorkspace })
hl.window_rule({ match = { class = "^(steam)$", title = "^(Friends List)$" }, float = true })
hl.window_rule({
    match = { class = "^(steam)$", title = "^(Launching\\.{3})$" },
    float = true,
    center = true,
    workspace =
        gamingWorkspace
})
hl.window_rule({
    match            = { class = gamingApps, title = "^(.+)$", initial_title = "negative:^(.*\\\\home\\\\.*)$", },
    content          = "game",
    decorate         = false,
    fullscreen_state = 2,
    size             = { "monitor_w", "monitor_h" },
    sync_fullscreen  = true,
})
hl.window_rule({
    match            = { class = "^(steam_app.*)$", initial_title = "^$", },
    center           = true,
    float            = true,
    fullscreen       = false,
    fullscreen_state = 0,
    workspace        = gamingWorkspace,
})

-- Apps
hl.window_rule({ match = { class = "^(.*[Cc]alc.*)$" }, float = true, size = { "max(monitor_w, monitor_h)*0.17", "min(monitor_w, monitor_h)*0.43" } })
hl.window_rule({ match = { class = "^(.*[Ll]auncher.*)$" }, float = true, monitor = PRIMARY_MONITOR })
hl.window_rule({ match = { class = "^(.*\\.exe)$", float = true }, monitor = PRIMARY_MONITOR, center = true, fullscreen_state = 0 })
hl.window_rule({ match = { class = "^(.*swash)$", title = "^(Swash)$" }, min_size = { "max(monitor_w, monitor_h)*0.35", "min(monitor_w, monitor_h)*0.35" }, float = true })
hl.window_rule({ match = { class = "^(dev\\.)?(noctalia\\.Noctalia(\\.Settings)?)$" }, float = true, size = { "monitor_w*0.70", "monitor_h*0.70" } })
hl.window_rule({ match = { class = "^(microsoft-edge)$" }, fullscreen_state = 0 })
hl.window_rule({
    match = {
        class = "^(org\\.kde\\.dolphin\\)$",
        title =
        "negative:^(Moving.*|Create New.*|Extract.*|Compress.*|Copying.*|Progress.*|Configure.*|Properties.*|Choose\\sApplication.*)$",
    },
    float = true,
    size = { "max(monitor_w, monitor_h)*0.50", "min(monitor_w, monitor_h)*0.55" },
    move = {
        "max(20, min(cursor_x - (window_w*0.50), monitor_w - window_w + 20))", -- X axis clamping
        "max(20, min(cursor_y - 50, monitor_h - window_h + 20))"               -- Y axis clamping
    },
})

-- Float Utility Windows
local floatApps = {
    { class = "^(.*dialog.*)$" },
    { class = "^([Xx]dg-desktop-portal-gtk)$" },
    { class = "^(hyprland-share-picker)$" },
    { class = "^(kvantummanager|qt[56]ct|nwg-look)$" },
    { class = "^(org.pulseaudio.pavucontrol|blueman-manager|nm-applet|nm-connection-editor)$" },
    { initial_title = "^(Open File)$" },
    { title = "^(.*dialog.*)$" },
    { title = "^(File Upload|Choose wallpaper|Library)(.*)$" },
    { title = "^(Open|Authentication Required|Add Folder to Workspace|Choose Files|Save As|Confirm to replace files|File Operation Progress)$" },
    { title = "^(Winetricks.*|Protontricks.*)$" },
    { class = "^(wechat|com\\.tencent\\.wechatappex)$" },
}
for _, m in ipairs(floatApps) do hl.window_rule({ match = m, float = true }) end

-- Ignore maximize requests from all apps. You'll probably like this.
hl.window_rule({ name = "suppress-maximize-events", match = { class = ".*" }, suppress_event = "maximize", })

-- Fix some dragging issues with XWayland
hl.window_rule({ name = "fix-xwayland-drags", match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false, }, no_focus = true, })

-- Noctalia layer rule
hl.layer_rule({
    name = "noctalia",
    match = { namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$", },
    no_anim = true,
    ignore_alpha = 0.5,
    blur = true,
    blur_popups = true,
})
