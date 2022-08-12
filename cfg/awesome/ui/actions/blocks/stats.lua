local wibox = require 'wibox'
local xresources = require 'beautiful.xresources'
local beautiful = require 'beautiful'
local gears = require 'gears'
local awful = require 'awful'

local dpi = xresources.apply_dpi
local height = 105

local stats_widget = wibox.widget {
    {
        {
            {
                markup = '<span foreground="' .. beautiful.red .. '"></span>',
                font = beautiful.nerd_font .. ' 15',
                valign = 'center',
                align = 'center',
                widget = wibox.widget.textbox,
            },
            paddings = {
                right = dpi(6),
            },
            id = 'ram',
            forced_width = dpi(65),
            value = 0,
            color = beautiful.red,
            border_color = beautiful.actions.lighter,
            border_width = dpi(5),
            max_value = 1,
            min_value = 0,
            widget = wibox.container.radialprogressbar,
        },
        left = dpi(35),
        top = dpi(5),
        bottom = dpi(5),
        widget = wibox.container.margin,
    },
    nil,
    {
        {
            {
                markup = '<span foreground="' .. beautiful.yellow .. '"></span>',
                font = beautiful.nerd_font .. ' 11',
                valign = 'center',
                align = 'center',
                widget = wibox.widget.textbox,
            },
            paddings = {
                right = dpi(7),
            },
            id = 'cpu',
            forced_width = dpi(65),
            color = beautiful.yellow,
            border_color = beautiful.actions.lighter,
            border_width = dpi(5),
            value = 0,
            max_value = 1,
            min_value = 0,
            widget = wibox.container.radialprogressbar,
        },
        right = dpi(45),
        top = dpi(5),
        bottom = dpi(5),
        widget = wibox.container.margin,
    },
    layout = wibox.layout.align.horizontal,

    -- val is the free ram, inverting, i want the used ram
    set_ram = function (self, val)
        self:get_children_by_id('ram')[1].value = 1 - (val / 100)
    end,
    set_cpu = function (self, val)
        self:get_children_by_id('cpu')[1].value = val / 100
    end
}

gears.timer {
    timeout = 10,
    call_now = true,
    autostart = true,
    callback = function ()
        awful.spawn.easy_async_with_shell("free | grep Mem | awk '{print $4/$2 * 100.0}' | sed 's/\\./ /g' | awk '{print $1}'", function (out)
            stats_widget.ram = out
        end)
        awful.spawn.easy_async_with_shell("grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}' | sed 's/\\./ /g' | awk '{print $1}'", function (out)
            stats_widget.cpu = out
        end)
    end
}

return {
    height = height,
    widget = stats_widget,
}
