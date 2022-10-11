---@diagnostic disable: undefined-global
local awful = require 'awful'

local function _()
    return awful.screen.focused().screenshot_center
end

-- defines if the popup should be able to be closed by anyone or not
-- this is generally used when the delay input is focused to avoid problems with
-- the key-grabber after popup closing :/
local can_toggle = true

awesome.connect_signal('screenshot-center::delay-input::editing', function (is_editing)
    can_toggle = not is_editing
end)

awesome.connect_signal('screenshot-center::toggle', function ()
    if can_toggle then
        _().toggle()
    end
end)

awesome.connect_signal('screenshot-center::visibility', function (v)
    if can_toggle then
        if v then
            _().show()
        else
            _().hide()
        end
    end
end)
