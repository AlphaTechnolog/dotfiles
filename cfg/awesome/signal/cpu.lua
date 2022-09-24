local awful = require 'awful'
local gears = require 'gears'
local helpers = require 'helpers'

local cmd = [[grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}' | sed 's/\./ /g' | awk '{print $1}']]

gears.timer {
    timeout = 5,
    call_now = true,
    autostart = true,
    callback = function ()
        awful.spawn.easy_async_with_shell(cmd, function (cpu)
            awesome.emit_signal('cpu::percent', helpers.trim(cpu))
        end)
    end
}
