---@diagnostic disable: undefined-global

local awful = require 'awful'
local gears = require 'gears'
local helpers = require 'helpers'
local fs = gears.filesystem

local redshift = {}

redshift.script_path = fs.get_configuration_dir() .. 'scripts/redshift.sh'

function redshift._invoke_script(args, cb)
    awful.spawn.easy_async_with_shell(redshift.script_path .. ' ' .. args, function (out)
        if cb then
            cb(helpers.trim(out))
        end
    end)
end

function redshift.toggle ()
    redshift._invoke_script('toggle')
end

function redshift.enable()
    redshift._invoke_script('enable')
end

function redshift.disable()
    redshift._invoke_script('disable')
end

gears.timer {
    timeout = 2,
    call_now = true,
    autostart = true,
    callback = function ()
        redshift._invoke_script('state', function (state)
            awesome.emit_signal('redshift::active', state == 'on')
        end)
    end
}

return redshift
