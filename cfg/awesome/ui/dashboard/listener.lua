---@diagnostic disable: undefined-global

local awful = require 'awful'

local function get_dashboard_object()
    return awful.screen.focused().dashboard
end

-- listens for requests to toggle the dashboad in focused screen.
awesome.connect_signal('dashboard::toggle', function ()
    get_dashboard_object().toggle()
end)

awesome.connect_signal('dashboard::visibility', function (v)
    if v then
        get_dashboard_object().show()
    else
        get_dashboard_object().hide()
    end
end)
