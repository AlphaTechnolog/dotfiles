local wibox = require 'wibox'
local gears = require 'gears'
local beautiful = require 'beautiful'
local xresources = require 'beautiful.xresources'

local volume_signal = require 'signal.volume'
local br_signal = require 'signal.brightness'

local dpi = xresources.apply_dpi

local height = 90

local volume = wibox.widget {
    forced_width = dpi(160),
    forced_height = dpi(16),
    bar_shape = gears.shape.rounded_bar,
    bar_height = dpi(6),
    bar_color = beautiful.bg_lighter,
    bar_active_color = beautiful.green,
    handle_shape = gears.shape.circle,
    handle_color = beautiful.green,
    handle_width = dpi(16),
    value = 0,
    widget = wibox.widget.slider,
}

-- update volume widget value
awesome.connect_signal('volume::value', function (vol)
    volume:set_value(vol)
end)

-- update volume on change slider
volume:connect_signal('property::value', function (_, value)
    volume_signal.set(value)
end)

local brightness = wibox.widget {
    forced_width = dpi(160),
    forced_height = dpi(16),
    bar_shape = gears.shape.rounded_bar,
    bar_height = dpi(6),
    bar_color = beautiful.bg_lighter,
    bar_active_color = beautiful.yellow,
    handle_shape = gears.shape.circle,
    handle_color = beautiful.yellow,
    handle_width = dpi(16),
    value = 0,
    widget = wibox.widget.slider,
}

-- update brightness value
awesome.connect_signal('brightness::value', function (br)
    brightness:set_value(br)
end)

-- update brightness on slider change
brightness:connect_signal('property::value', function (_, value)
    br_signal.set(value)
end)

local controls_widget = wibox.widget {
    {
        nil,
        nil,
        nil,
        layout = wibox.layout.align.horizontal,
    },
    {
        {
            volume,
            brightness,
            spacing = dpi(15),
            layout = wibox.layout.fixed.vertical,
        },
        align = 'center',
        valign = 'center',
        widget = wibox.container.margin,
        layout = wibox.container.place,
    },
    layout = wibox.layout.stack,
}

return {
    height = height,
    widget = controls_widget,
}
