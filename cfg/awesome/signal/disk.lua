local gears = require 'gears'
local awful = require 'awful'

local cmd = [[df --output=pcent / | tail -n 1 | sed 's/%//g' | xargs]]

gears.timer {
    timeout = 120,
    call_now = true,
    autostart = true,
    callback = function ()
        awful.spawn.easy_async_with_shell(cmd, function (usage)
            awesome.emit_signal('disk::usage', usage)
        end)
    end
}