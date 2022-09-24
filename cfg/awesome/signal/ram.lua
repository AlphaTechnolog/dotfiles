local gears = require 'gears'
local awful = require 'awful'

local cmd = [[free | grep Mem | awk '{print $3/$2 * 100.0}' | sed 's/\./ /g' | awk '{print $1}']]

gears.timer {
    timeout = 5,
    call_now = true,
    autostart = true,
    callback = function ()
        awful.spawn.easy_async_with_shell(cmd, function (used)
            awesome.emit_signal('ram::used', used)
        end)
    end
}
