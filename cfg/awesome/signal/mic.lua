---@diagnostic disable: undefined-global

local awful = require 'awful'
local gears = require 'gears'
local helpers = require 'helpers'
local fs = gears.filesystem

local mic = {}

mic.script_path = fs.get_configuration_dir() .. 'scripts/mic'

function mic._invoke_script(args, cb)
    awful.spawn.easy_async_with_shell(mic.script_path .. ' ' .. args, function (out)
        if cb then
            cb(helpers.trim(out))
        end
    end)
end

function mic.toggle ()
    mic._invoke_script('toggle')
end

gears.timer {
    timeout = 2,
    call_now = true,
    autostart = true,
    callback = function ()
        mic._invoke_script('status', function (state)
            awesome.emit_signal('mic::active', state == 'yes')
        end)
        mic._invoke_script('get', function (value)
            awesome.emit_signal('mic::volume', value)
        end)
    end
}

return mic
