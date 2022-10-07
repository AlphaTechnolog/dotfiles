local naughty = require "naughty"
local beautiful = require 'beautiful'
local helpers = require 'helpers'

local dpi = beautiful.xresources.apply_dpi

-- display errors
naughty.connect_signal('request::display_error', function (message, startup)
    naughty.notification {
        urgency = 'critical',
        title = 'An error happened' .. (startup and ' during startup' or ''),
        message = message,
    }
end)

-- display notification
naughty.connect_signal('request::display', function (n)
    naughty.layout.box {
        notification = n,
        position = 'top_right',
        border_width = 0,
        border_color = beautiful.bg_normal .. '00',
        bg = beautiful.bg_normal .. '00',
        fg = beautiful.fg_normal,
        shape = helpers.mkroundedrect(),
        minimum_width = dpi(240),
        widget_template = helpers.get_notification_widget(n)
    }
end)
