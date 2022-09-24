---@diagnostic disable: undefined-global
local gears = require 'gears'
local awful = require 'awful'

local script = 'light -G | sed -s "s/\\./ /g" | awk "{print \\$1}"'

gears.timer {
    timeout = 5,
    call_now = true,
    autostart = true,
    callback = function ()
        awful.spawn.easy_async_with_shell(script, function (out)
            awesome.emit_signal('brightness::value', tonumber(out))
        end)
    end
}

local function set(val)
    awful.spawn('light -S ' .. tonumber(val))
end

return { set = set }
