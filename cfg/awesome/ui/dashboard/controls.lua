---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local helpers = require 'helpers'
local beautiful = require 'beautiful'
local gears = require 'gears'
local dpi = beautiful.xresources.apply_dpi

local function base_slider (icon)
    return wibox.widget {
        {
            {
                id = 'slider',
                bar_shape = gears.shape.rounded_bar,
                bar_height = 25,
                bar_active_color = beautiful.blue,
                bar_color = beautiful.black,
                handle_color = beautiful.blue,
                handle_shape = gears.shape.circle,
                handle_width = 25,
                handle_border_width = 1,
                value = 0,
                forced_width = 190,
                forced_height = 1,
                widget = wibox.widget.slider,
            },
            {
                {
                    {
                        id = 'icon_role',
                        markup = icon,
                        valign = 'center',
                        align = 'left',
                        font = beautiful.nerd_font .. ' 15',
                        widget = wibox.widget.textbox,
                    },
                    fg = beautiful.bg_normal,
                    widget = wibox.container.background,
                },
                left = dpi(7),
                widget = wibox.container.margin,
            },
            layout = wibox.layout.stack,
        },
        layout = wibox.layout.fixed.horizontal,
        set_value = function (self, value)
            self:get_children_by_id('slider')[1].value = value
        end,
        set_icon = function (self, new_icon)
            self:get_children_by_id('icon_role')[1].markup = new_icon
        end,
        get_slider = function (self)
            return self:get_children_by_id('slider')[1]
        end
    }
end

-- volume
local volume_slider = base_slider('')

volume_slider.slider:connect_signal('property::value', function (_, value)
    VolumeSignal.set(value, false)
end)

awesome.connect_signal('volume::value', function (sysvol)
    volume_slider.value = sysvol
end)

awesome.connect_signal('volume::muted', function (is_muted)
    volume_slider.icon = is_muted and '婢' or ''
end)

-- brightness
local brightness_slider = base_slider('')

-- 100 by-default.
if brightness_slider.slider.value == 0 then
    brightness_slider.value = 100
end

-- signals
brightness_slider.slider:connect_signal('property::value', function (_, new_br)
    BrightnessSignal.set(new_br)
end)

awesome.connect_signal('brightness::value', function (brightness)
    brightness_slider.value = brightness
    brightness_slider.icon = brightness == 0 and '' or ''
end)

local controls = wibox.widget {
    {
        {
            {
                {
                    {
                        {
                            markup = 'Controls',
                            widget = wibox.widget.textbox,
                        },
                        bottom = dpi(8),
                        widget = wibox.container.margin,
                    },
                    fg = beautiful.light_black,
                    widget = wibox.container.background,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            {
                volume_slider,
                brightness_slider,
                spacing = dpi(12),
                layout = wibox.layout.fixed.vertical,
            },
            nil,
            layout = wibox.layout.align.vertical,
        },
        margins = dpi(12),
        widget = wibox.container.margin,
    },
    shape = helpers.mkroundedrect(),
    bg = beautiful.bg_contrast,
    widget = wibox.container.background,
}

return controls
