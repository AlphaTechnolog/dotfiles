local awful = require 'awful'
local gears = require 'gears'
local helpers = require 'helpers'
local fs = gears.filesystem

local temperature = {}

temperature.script_path = fs.get_configuration_dir() .. 'scripts/temp.sh'

function temperature._invoke_script(args, cb)
    awful.spawn.easy_async_with_shell(temperature.script_path .. ' ' .. args, function (out)
        if cb then
            cb(helpers.trim(out))
        end
    end)
end

function temperature.async_get(cb)
    temperature._invoke_script('get', cb)
end

gears.timer {
    timeout = 10,
    call_now = true,
    autostart = true,
    callback = function ()
        temperature.async_get(function (temp)
            awesome.emit_signal('temperature::value', tonumber(temp))
        end)
    end
}

return temperature
