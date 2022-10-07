---@diagnostic disable: undefined-global

local awful = require 'awful'

local function _()
    return awful.screen.focused().dashboard
end

awesome.connect_signal('dashboard::toggle', function ()
    _().toggle()
end)

awesome.connect_signal('dashboard::visibility', function (visibility)
    if visibility then
        _().open()
    else
        _().hide()
    end
end)

