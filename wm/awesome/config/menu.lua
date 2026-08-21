local awful = require("awful")
local beautiful = require("beautiful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

return function(vars)
    local myawesomemenu = {
       { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
       { "manual", vars.terminal .. " -e man awesome" },
       { "edit config", vars.editor_cmd .. " " .. awesome.conffile },
       { "restart", awesome.restart },
       { "quit", function() awesome.quit() end },
    }

    local mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                        { "open terminal", vars.terminal }
                                      }
                            })

    local mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                         menu = mymainmenu })

    menubar.utils.terminal = vars.terminal

    return {
        mymainmenu = mymainmenu,
        mylauncher = mylauncher,
    }
end
