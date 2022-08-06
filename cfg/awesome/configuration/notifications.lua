local naughty = require "naughty"

local handle_errors = function ()
    naughty.connect_signal("request::display_error", function (message, startup)
        naughty.notification {
            urgency = "critical",
            title = "Opps, an error happened" .. (startup and " during startup!" or "!"),
            message = message,
        }
    end)

    naughty.connect_signal("request::display", function (n)
        naughty.layout.box { notification = n }
    end)
end

handle_errors()
