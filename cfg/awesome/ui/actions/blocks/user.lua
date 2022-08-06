local wibox = require 'wibox'
local gears = require 'gears'
local beautiful = require 'beautiful'
local xresources = require 'beautiful.xresources'
local awful = require 'awful'

local dpi = xresources.apply_dpi
local height = 95

local pfp = wibox.widget {
    image = beautiful.pfp,
    forced_width = dpi(64),
    forced_height = dpi(64),
    clip_shape = gears.shape.circle,
    widget = wibox.widget.imagebox,
}

local username = wibox.widget {
    markup = '',
    align = 'center',
    valign = 'center',
    font = beautiful.font_name .. ' 12',
    widget = wibox.widget.textbox,
}

awful.spawn.easy_async_with_shell('whoami', function (user)
    username:set_markup_silently('<span foreground="' .. beautiful.blue .. '">Welcome ' .. user .. '</span>')
end)

local user_widget = wibox.widget {
    {
        pfp,
        left = dpi(12),
        widget = wibox.container.margin,
    },
    {
        nil,
        {
            username,
            top = dpi(16),
            widget = wibox.container.margin,
        },
        layout = wibox.layout.align.vertical,
    },
    layout = wibox.layout.align.horizontal,
}

return {
    height = height,
    widget = user_widget,
}
