---@diagnostic disable: undefined-global
local awful = require 'awful'

local function _()
    return awful.screen.focused().calendar
end

awesome.connect_signal('calendar::toggle', function ()
    _().toggle()
end)

awesome.connect_signal('calendar::visibility', function (v)
    if v then
        _().open()
    else
        _().hide()
    end
end)
