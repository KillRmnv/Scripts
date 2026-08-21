local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local function net_widget()
    local widget = wibox.widget.textbox()
    local prev_rx = nil
    local prev_tx = nil

    gears.timer {
        timeout = 3,
        call_now = true,
        autostart = true,
        callback = function()
            awful.spawn.easy_async("grep 'eth0' /proc/net/dev", function(stdout)
                local rx, tx = stdout:match("eth0:%s+(%d+).-%s(%d+)%s")
                rx, tx = tonumber(rx) or 0, tonumber(tx) or 0
                if prev_rx then
                    local drx = (rx - prev_rx) / 3
                    local dtx = (tx - prev_tx) / 3
                    local function fmt(b)
                        if b > 1048576 then
                            return string.format("%.1f MiB/s", b / 1048576)
                        elseif b > 1024 then
                            return string.format("%.0f KiB/s", b / 1024)
                        else
                            return string.format("%.0f B/s", b)
                        end
                    end
                    widget:set_text(" d:" .. fmt(drx) .. " u:" .. fmt(dtx) .. " ")
                end
                prev_rx, prev_tx = rx, tx
            end)
        end
    }
    return widget
end

local function ram_widget()
    local widget = wibox.widget.textbox()

    gears.timer {
        timeout = 3,
        call_now = true,
        autostart = true,
        callback = function()
            awful.spawn.easy_async("free -m", function(stdout)
                local total, used = stdout:match("Mem:%s+(%d+)%s+(%d+)%s+")
                if used and total then
                    widget:set_text(string.format(" RAM %d/%d MiB ", used, total))
                end
            end)
        end
    }
    return widget
end

local function cpu_widget()
    local widget = wibox.widget.textbox()
    local prev_idle = 0
    local prev_total = 0

    gears.timer {
        timeout = 3,
        call_now = true,
        autostart = true,
        callback = function()
            awful.spawn.easy_async("cat /proc/stat", function(stdout)
                local line = stdout:match("cpu  .-\n")
                if not line then return end
                local user, nice, system, idle, iowait, irq, softirq, steal =
                    line:match("cpu%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)")
                if user then
                    local idle_now = tonumber(idle) + tonumber(iowait)
                    local total_now = tonumber(user) + tonumber(nice) + tonumber(system) +
                        tonumber(idle) + tonumber(iowait) + tonumber(irq) + tonumber(softirq) + tonumber(steal)
                    local d_idle = idle_now - prev_idle
                    local d_total = total_now - prev_total
                    if d_total > 0 then
                        local usage = math.floor((1 - d_idle / d_total) * 100 + 0.5)
                        widget:set_text(string.format(" CPU %d%% ", usage))
                    end
                    prev_idle, prev_total = idle_now, total_now
                end
            end)
        end
    }
    return widget
end

local function battery_widget()
    local widget = wibox.widget.textbox()

    gears.timer {
        timeout = 3,
        call_now = true,
        autostart = true,
        callback = function()
            awful.spawn.easy_async("cat /sys/class/power_supply/BAT*/capacity 2>/dev/null", function(stdout)
                local cap = stdout:match("(%d+)")
                if cap then
                    widget:set_text(string.format(" Battery %s%% ", cap))
                else
                    widget:set_text(" Battery 100%% ")
                end
            end)
        end
    }
    return widget
end

local function volume_widget()
    local widget = wibox.widget.textbox()

    local function update()
        awful.spawn.easy_async("pactl get-sink-volume @DEFAULT_SINK@", function(stdout)
            local vol = stdout:match("(%d+)%%")
            awful.spawn.easy_async("pactl get-sink-mute @DEFAULT_SINK@", function(mute_out)
                local muted = mute_out:match("MUTE:%s+(%S+)")
                if vol then
                    if muted == "yes" then
                        widget:set_text(string.format(" Vol %s%% [M] ", vol))
                    else
                        widget:set_text(string.format(" Vol %s%% ", vol))
                    end
                else
                    widget:set_text(" Vol N/A ")
                end
            end)
        end)
    end

    widget:connect_signal("button::press", function(_, _, _, button)
        if button == 4 then
            awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
            gears.timer { timeout = 0.1, call_now = true, callback = update }
        elseif button == 5 then
            awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
            gears.timer { timeout = 0.1, call_now = true, callback = update }
        elseif button == 2 then
            awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
            gears.timer { timeout = 0.1, call_now = true, callback = update }
        end
    end)

    gears.timer { timeout = 3, call_now = true, autostart = true, callback = update }
    return widget
end

return {
    net = net_widget(),
    ram = ram_widget(),
    cpu = cpu_widget(),
    battery = battery_widget(),
    volume = volume_widget(),
}
