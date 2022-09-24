---@diagnostic disable: undefined-global

local gears = require 'gears'
local awful = require 'awful'
local helpers = require 'helpers'

gears.timer {
    timeout = 30,
    call_now = true,
    autostart = true,
    callback = function ()
        awful.spawn.easy_async_with_shell('date "+%H"', function (out)
            awesome.emit_signal('date::hour', helpers.trim(out))
        end)
        awful.spawn.easy_async_with_shell('date "+%M"', function (out)
            awesome.emit_signal('date::minutes', helpers.trim(out))
        end)
    end
}