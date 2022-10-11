---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local gears = require 'gears'
local awful = require 'awful'

local close_button = wibox.widget {
    {
        markup = '',
        widget = wibox.widget.textbox,
    },
    forced_height = 14,
    forced_width = 14,
    shape = gears.shape.circle,
    bg = beautiful.red,
    widget = wibox.container.background
}

close_button:add_button(awful.button({}, 1, function ()
    awesome.emit_signal('screenshot-center::visibility', false)
end))

return wibox.widget {
    {
        {
            close_button,
            layout = wibox.layout.fixed.vertical,
        },
        margins = 10,
        widget = wibox.container.margin,
    },
    bg = beautiful.bg_darker,
    fg = beautiful.fg_normal,
    widget = wibox.container.background,
}
