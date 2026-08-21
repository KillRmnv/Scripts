local awful = require("awful")
local beautiful = require("beautiful")

return function(keys)
    awful.rules.rules = {
        { rule = { },
          properties = { border_width = beautiful.border_width,
                         border_color = beautiful.border_normal,
                         focus = awful.client.focus.filter,
                         raise = true,
                         keys = keys.clientkeys,
                         buttons = keys.clientbuttons,
                         screen = awful.screen.preferred,
                         placement = awful.placement.no_overlap+awful.placement.no_offscreen
         }
        },

        { rule_any = {
            instance = {
              "DTA",
              "copyq",
              "pinentry",
            },
            class = {
              "Arandr",
              "Blueman-manager",
              "Gpick",
              "Kruler",
              "MessageWin",
              "Sxiv",
              "Tor Browser",
              "Wpa_gui",
              "veromix",
              "xtightvncviewer"},

            name = {
              "Event Tester",
            },
            role = {
              "AlarmWindow",
              "ConfigManager",
              "pop-up",
            }
          }, properties = { floating = true }},

        { rule_any = {type = { "normal", "dialog" }
          }, properties = { titlebars_enabled = true }
        },
    }
end
