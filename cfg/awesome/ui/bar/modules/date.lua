---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local helpers = require 'helpers'
local awful = require 'awful'
local beautiful = require 'beautiful'

local hour = wibox.widget {
    format = '%H',
    align = 'center',
    font = beautiful.font_name .. ' 13',
    widget = wibox.widget.textclock,
}

local minutes = wibox.widget {
    format = '%M',
    align = 'center',
    font = beautiful.font_name .. ' 13',
    widget = wibox.widget.textclock,
}

local clock_container = wibox.widget {
    {
        {
            {
                hour,
                minutes,
                spacing = 1,
                layout = wibox.layout.fixed.vertical,
            },
            top = 5,
            bottom = 5,
            left = 1,
            right = 1,
            widget = wibox.container.margin,
        },
        shape = helpers.mkroundedrect(),
        widget = wibox.container.background,
        bg = beautiful.black,
    },
    left = 5,
    right = 5,
    widget = wibox.container.margin,
}

clock_container:add_button(awful.button({}, 1, function ()
    awesome.emit_signal('calendar::toggle')
end))

return clock_container
