local naughty = require "naughty"
local beautiful = require 'beautiful'
local gears = require 'gears'
local awful = require 'awful'

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
        position = 'bottom_right',
        shape = function (cr, w, h)
            return gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
        end
    }
end)
