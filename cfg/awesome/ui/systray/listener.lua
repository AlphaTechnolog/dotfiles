---@diagnostic disable: undefined-global
local awful = require 'awful'

local function _()
    return awful.screen.focused().systray
end

awesome.connect_signal('systray::toggle', function ()
    _().toggle()
end)

awesome.connect_signal('systray::visibility', function (v)
    if v then
        _().show()
    else
        _().hide()
    end
end)
