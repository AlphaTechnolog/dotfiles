---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local awful = require 'awful'
local helpers = require 'helpers'
local dpi = beautiful.xresources.apply_dpi

local volume = wibox.widget {
    widget = wibox.widget.imagebox,
    forced_height = dpi(12),
    forced_width = dpi(12),
    image = beautiful.volume_on,
    halign = 'center',
    valign = 'bottom',
}

local tooltip = helpers.make_popup_tooltip('Press to mute/unmute', function (d)
    return awful.placement.bottom_right(d, {
        margins = {
            bottom = beautiful.bar_height + beautiful.useless_gap * 2,
            right = beautiful.useless_gap * 2 + 75,
        }
    })
end)

tooltip.attach_to_object(volume)

volume:add_button(awful.button({}, 1, function ()
    VolumeSignal.toggle_muted()
end))

awesome.connect_signal('volume::muted', function (is_muted)
    volume.image = is_muted
        and beautiful.volume_muted
        or beautiful.volume_on
end)

return volume
