---@diagnostic disable: undefined-global
local awful = require 'awful'

local function _()
    return awful.screen.focused().powermenu
end

awesome.connect_signal('powermenu::toggle', function ()
    _().toggle()
end)

awesome.connect_signal('powermenu::visibility', function (v)
    if v then
        _().open()
    else
        _().hide()
    end
end)
