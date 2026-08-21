local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

return function(vars, menu)
    local widgets = require("config/widgets")
    local mykeyboardlayout = awful.widget.keyboardlayout()
    local mytextclock = wibox.widget.textclock()

    local taglist_buttons = gears.table.join(
                        awful.button({ }, 1, function(t) t:view_only() end),
                        awful.button({ vars.modkey }, 1, function(t)
                                                  if client.focus then
                                                      client.focus:move_to_tag(t)
                                                  end
                                              end),
                        awful.button({ }, 3, awful.tag.viewtoggle),
                        awful.button({ vars.modkey }, 3, function(t)
                                                  if client.focus then
                                                      client.focus:toggle_tag(t)
                                                  end
                                              end),
                        awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                        awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                    )

    local tasklist_buttons = gears.table.join(
                         awful.button({ }, 1, function (c)
                                                  if c == client.focus then
                                                      c.minimized = true
                                                  else
                                                      c:emit_signal(
                                                          "request::activate",
                                                          "tasklist",
                                                          {raise = true}
                                                      )
                                                  end
                                              end),
                         awful.button({ }, 3, function()
                                                  awful.menu.client_list({ theme = { width = 250 } })
                                              end),
                         awful.button({ }, 4, function ()
                                                  awful.client.focus.byidx(1)
                                              end),
                         awful.button({ }, 5, function ()
                                                  awful.client.focus.byidx(-1)
                                              end))

    local function set_wallpaper(s)
        if beautiful.wallpaper then
            local wallpaper = beautiful.wallpaper
            if type(wallpaper) == "function" then
                wallpaper = wallpaper(s)
            end
            gears.wallpaper.maximized(wallpaper, s, true)
        end
    end

    screen.connect_signal("property::geometry", set_wallpaper)

    awful.screen.connect_for_each_screen(function(s)
        set_wallpaper(s)

        awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

        s.mypromptbox = awful.widget.prompt()
        s.mylayoutbox = awful.widget.layoutbox(s)
        s.mylayoutbox:buttons(gears.table.join(
                               awful.button({ }, 1, function () awful.layout.inc( 1) end),
                               awful.button({ }, 3, function () awful.layout.inc(-1) end),
                               awful.button({ }, 4, function () awful.layout.inc( 1) end),
                               awful.button({ }, 5, function () awful.layout.inc(-1) end)))
        s.mytaglist = awful.widget.taglist {
            screen  = s,
            filter  = awful.widget.taglist.filter.all,
            buttons = taglist_buttons
        }

        s.mytasklist = awful.widget.tasklist {
            screen  = s,
            filter  = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_buttons
        }

        s.mywibox = awful.wibar({ position = "top", screen = s })

        s.mywibox:setup {
            layout = wibox.layout.align.horizontal,
            {
                layout = wibox.layout.fixed.horizontal,
                menu.mylauncher,
                s.mytaglist,
                s.mypromptbox,
            },
            s.mytasklist,
            {
                layout = wibox.layout.fixed.horizontal,
                mykeyboardlayout,
                wibox.widget.systray(),
                widgets.net,
                widgets.ram,
                widgets.cpu,
                widgets.volume,
                widgets.battery,
                mytextclock,
                s.mylayoutbox,
            },
        }
    end)
end
