local bling = require 'bling'
local awful = require 'awful'
local beautiful = require 'beautiful'
local xresources = require 'beautiful.xresources'
local wibox = require 'wibox'
local dpi = xresources.apply_dpi

bling.widget.task_preview.enable {
    height = dpi(300),
    width = dpi(300),
    placement_fn = function (c)
        awful.placement.bottom(c, {
            margins = {
                bottom = beautiful.bar_height + beautiful.useless_gap * 2,
            }
        })
    end,
    widget_structure = {
        {
            {
                {
                    id = 'icon_role',
                    widget = awful.widget.clienticon, -- The client icon
                },
                {
                    id = 'name_role', -- The client name / title
                    widget = wibox.widget.textbox,
                },
                layout = wibox.layout.flex.horizontal
            },
            widget = wibox.container.margin,
            margins = 5
        },
        {
            id = 'image_role', -- The client preview
            resize = true,
            valign = 'center',
            halign = 'center',
            widget = wibox.widget.imagebox,
        },
        layout = wibox.layout.fixed.vertical
    }
}
