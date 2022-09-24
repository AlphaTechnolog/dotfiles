---@diagnostic disable:undefined-global

local awful = require 'awful'

client.connect_signal('request::manage', function (c)
    awful.placement.centered(c, {
        honor_workarea = true
    })
end)