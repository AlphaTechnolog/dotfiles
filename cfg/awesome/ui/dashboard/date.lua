---@diagnostic disable: undefined-global

local wibox = require 'wibox'
local beautiful = require 'beautiful'
local gears = require 'gears'

local dpi = beautiful.xresources.apply_dpi

-- enable signals
require 'signal.date'

local hour = wibox.widget {
    markup = '00',
    font = beautiful.font_name .. ' 40',
    widget = wibox.widget.textbox,
}

awesome.connect_signal('date::hour', function (hour_val)
    hour.markup = hour_val
end)

local minutes = wibox.widget {
    markup = '00',
    font = beautiful.font_name .. ' 40',
    widget = wibox.widget.textbox,
}

awesome.connect_signal('date::minutes', function (minutes_val)
    minutes.markup = minutes_val
end)

local function mksquare(color)
    return wibox.widget {
        {
            left = dpi(6),
            right = dpi(6),
            widget = wibox.container.margin,
        },
        shape = gears.shape.hexagon,
        bg = color,
        widget = wibox.container.background,
    }
end

local sep = wibox.widget {
    mksquare(beautiful.red),
    mksquare(beautiful.magenta),
    mksquare(beautiful.blue),
    spacing = dpi(8),
    layout = wibox.layout.flex.vertical,
}

local date = wibox.widget {
    {
        hour,
        {
            sep,
            top = dpi(7),
            bottom = dpi(7),
            widget = wibox.container.margin,
        },
        minutes,
        spacing = dpi(17),
        layout = wibox.layout.fixed.horizontal,
    },
    halign = 'center',
    widget = wibox.container.margin,
    layout = wibox.container.place,
}

return date
