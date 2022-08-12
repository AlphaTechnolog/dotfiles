local wibox = require 'wibox'
local beautiful = require 'beautiful'
local gears = require 'gears'
local awful = require 'awful'
local dpi = beautiful.xresources.apply_dpi

local gaps = dpi(20)

local close_button = wibox.widget {
    {
        margins = 2,
        widget = wibox.container.margin,
    },
    bg = beautiful.red,
    shape = gears.shape.circle,
    forced_width = dpi(14),
    forced_height = dpi(14),
    widget = wibox.container.background,
    buttons = awful.button({}, 1, function ()
        require 'ui.actions'.toggle_popup()
    end)
}

local header_widget = wibox.widget {
    {
        close_button,
        top = gaps / 2,
        bottom = gaps / 2,
        right = gaps / 2,
        widget = wibox.container.margin,
    },
    valign = 'center',
    halign = 'right',
    layout = wibox.container.place,
}

return header_widget
