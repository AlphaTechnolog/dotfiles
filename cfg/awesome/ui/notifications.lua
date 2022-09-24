local naughty = require "naughty"
local beautiful = require 'beautiful'
local helpers = require 'helpers'
local wibox = require 'wibox'
local gears = require 'gears'

local dpi = beautiful.xresources.apply_dpi

-- display errors
naughty.connect_signal('request::display_error', function (message, startup)
    naughty.notification {
        urgency = 'critical',
        title = 'An error happened' .. (startup and ' during startup' or ''),
        message = message,
    }
end)

-- display notification
naughty.connect_signal('request::display', function (n)
    naughty.layout.box {
        notification = n,
        position = 'top_right',
        border_width = 0,
        border_color = beautiful.bg_normal .. '00',
        bg = beautiful.bg_normal .. '00',
        fg = beautiful.fg_normal,
        shape = helpers.mkroundedrect(),
        minimum_width = dpi(240),
        widget_template = {
            {
                {
                    {
                        {
                            {
                                image = n.app_icon or beautiful.fallback_notif_icon,
                                forced_height = 32,
                                forced_width = 32,
                                valign = 'center',
                                align = 'center',
                                clip_shape = gears.shape.circle,
                                widget = wibox.widget.imagebox,
                            },
                            {
                                markup = helpers.complex_capitalizing(n.app_name == '' and 'Cannot detect app' or n.app_name),
                                align = 'left',
                                valign = 'center',
                                widget = wibox.widget.textbox,
                            },
                            spacing = dpi(10),
                            layout = wibox.layout.fixed.horizontal,
                        },
                        margins = dpi(10),
                        widget = wibox.container.margin,
                    },
                    {
                        {
                            {
                                markup = '',
                                widget = wibox.widget.textbox,
                            },
                            top = 1,
                            widget = wibox.container.margin,
                        },
                        bg = beautiful.light_black,
                        widget = wibox.container.background,
                    },
                    layout = wibox.layout.fixed.vertical,
                },
                {
                    {
                        n.title == '' and nil or {
                            markup = '<b>' .. helpers.complex_capitalizing(n.title) .. '</b>',
                            align = 'center',
                            valign = 'center',
                            widget = wibox.widget.textbox,
                        },
                        {
                            markup = n.title == '' and '<b>' .. n.message .. '</b>' or n.message,
                            align = 'center',
                            valign = 'center',
                            widget = wibox.widget.textbox,
                        },
                        spacing = dpi(5),
                        layout = wibox.layout.fixed.vertical,
                    },
                    top = dpi(25),
                    left = dpi(12),
                    right = dpi(12),
                    bottom = dpi(15),
                    widget = wibox.container.margin,
                },
                {
                    {
                        base_layout = wibox.widget {
                            spacing = dpi(12),
                            layout = wibox.layout.flex.horizontal,
                        },
                        widget_template = {
                            {
                                {
                                    {
                                        id = 'text_role',
                                        widget = wibox.widget.textbox,
                                    },
                                    widget = wibox.container.place,
                                },
                                top = dpi(7),
                                bottom = dpi(7),
                                left = dpi(4),
                                right = dpi(4),
                                widget = wibox.container.margin,
                            },
                            shape = gears.shape.rounded_bar,
                            bg = beautiful.black,
                            widget = wibox.container.background,
                        },
                        widget = naughty.list.actions,
                    },
                    margins = dpi(12),
                    widget = wibox.container.margin,
                },
                spacing = dpi(7),
                layout = wibox.layout.align.vertical,
            },
            widget = wibox.container.background,
            bg = beautiful.bg_normal,
            shape = helpers.mkroundedrect(),
            fg = beautiful.fg_normal,
        }
    }
end)
