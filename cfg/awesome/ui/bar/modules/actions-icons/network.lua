---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local gfs = require 'gears.filesystem'
local awful = require 'awful'

require "signal.network"

local network = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.nerd_font .. ' 17',
    align = 'center',
    markup = beautiful.network_connected
}

network:add_button(awful.button({}, 1, function ()
    awful.spawn('bash ' .. gfs.get_configuration_dir() .. 'scripts/toggle-network.sh')
end))

awesome.connect_signal('network::connected', function (is_connected)
    network.markup = is_connected
        and beautiful.network_connected
        or beautiful.network_disconnected
end)

return network
