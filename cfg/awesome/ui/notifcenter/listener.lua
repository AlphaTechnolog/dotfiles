--@diagnostic disable: undefined-global

local awful = require 'awful'

local function _()
    return awful.screen.focused().notifcenter
end

awesome.connect_signal('notifcenter::toggle', function ()
    _().toggle()
end)

awesome.connect_signal('notifcenter::visibility', function (visibility)
    if visibility then
        _().open()
    else
        _().hide()
    end
end)

