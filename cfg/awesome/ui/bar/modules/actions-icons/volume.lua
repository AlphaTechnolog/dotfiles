---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local awful = require 'awful'

local volume = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.nerd_font .. ' 17',
    align = 'center',
    markup = ''
}

volume:add_button(awful.button({}, 1, function ()
    VolumeSignal.toggle_muted()
end))

awesome.connect_signal('volume::muted', function (is_muted)
    volume.markup = is_muted
        and '婢'
        or ''
end)

return volume
