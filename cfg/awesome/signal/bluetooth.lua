---@diagnostic disable: undefined-global
local awful = require 'awful'
local gears = require 'gears'
local helpers = require 'helpers'
local fs = gears.filesystem

local bluetooth = {}

bluetooth.script_path = fs.get_configuration_dir() .. 'scripts/bluetooth'

function bluetooth._invoke_script(args, cb)
    awful.spawn.easy_async_with_shell(bluetooth.script_path .. ' ' .. args, function (out)
        if cb then
            cb(helpers.trim(out))
        end
    end)
end

function bluetooth.toggle()
    bluetooth._invoke_script('toggle')
end

gears.timer {
    timeout = 5,
    call_now = true,
    autostart = true,
    callback = function ()
        bluetooth._invoke_script('state', function (state)
            awesome.emit_signal('bluetooth::enabled', state == 'on')
        end)
    end
}

return bluetooth
