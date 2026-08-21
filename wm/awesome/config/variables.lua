local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.useless_gap = 3

local terminal = "xterm"
local editor = os.getenv("EDITOR") or "nano"
local editor_cmd = terminal .. " -e " .. editor
local modkey = "Mod4"

awful.spawn.with_shell("setxkbmap us,ru -option grp:alt_shift_toggle")

awful.layout.layouts = {
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
}

return {
    terminal = terminal,
    editor = editor,
    editor_cmd = editor_cmd,
    modkey = modkey,
    home = os.getenv("HOME"),
}
