---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local gears = require 'gears'

local util = require 'ui.dashboard.modules.util'
local brightness_signal = require 'signal.brightness'

local function mkslider(icon)
    return wibox.widget {
        {
            id = 'slider_role',
            value = 100,
            handle_shape = gears.shape.circle,
            handle_color = beautiful.blue,
            handle_width = 37,
            bar_border_width = 0,
            bar_active_color = beautiful.blue,
            bar_color = beautiful.blue .. '4D', -- 30% of transparency
            bar_shape = gears.shape.rounded_bar,
            widget = wibox.widget.slider,
            bar_height = 37,
            forced_height = 37,
            forced_width = 230,
        },
        {
            {
                {
                    id = 'icon_role',
                    markup = icon,
                    font = beautiful.nerd_font .. ' 18',
                    align = 'start',
                    valign = 'center',
                    widget = wibox.widget.textbox,
                },
                left = beautiful.useless_gap * 3,
                widget = wibox.container.margin,
            },
            fg = beautiful.bg_normal,
            widget = wibox.container.background,
        },
        layout = wibox.layout.stack,
        get_slider = function (self)
            return self:get_children_by_id('slider_role')[1]
        end,
        set_value = function (self, val)
            self.slider.value = val
        end,
        set_icon = function (self, new_icon)
            self:get_children_by_id('icon_role')[1].markup = new_icon
        end
    }
end

local volume = mkslider('')

volume.slider:connect_signal('property::value', function (_, value)
    VolumeSignal.set(value, false)
end)

awesome.connect_signal('volume::value', function (volval)
    volume.value = volval
end)

awesome.connect_signal('volume::muted', function (muted)
    volume.icon = muted
        and '婢'
        or ''
end)

local brightness = mkslider('')

brightness.slider:connect_signal('property::value', function (_, value)
    brightness_signal.set(value)
end)

awesome.connect_signal('brightness::value', function (br_value)
    brightness.value = br_value
end)

-- main widget
return util.make_card {
    {
        {
            {
                markup = 'Controls',
                align = 'start',
                widget = wibox.widget.textbox,
            },
            fg = beautiful.light_black,
            widget = wibox.container.background,
        },
        left = beautiful.useless_gap,
        widget = wibox.container.margin,
    },
    {
        {
            {
                volume,
                brightness,
                spacing = beautiful.useless_gap * 4,
                layout = wibox.layout.flex.vertical,
            },
            halign = 'center',
            layout = wibox.container.place,
        },
        margins = beautiful.useless_gap * 2,
        widget = wibox.container.margin,
    },
    spacing = beautiful.useless_gap * 2,
    layout = wibox.layout.fixed.vertical,
}
