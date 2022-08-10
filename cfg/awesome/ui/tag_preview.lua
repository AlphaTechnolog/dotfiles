local bling = require 'bling'
local awful = require 'awful'
local wibox = require 'wibox'
local beautiful = require 'beautiful'

bling.widget.tag_preview.enable {
    show_client_content = false,
    scale = 0.25,
    honor_padding = false,
    honor_workarea = false,
    placement_fn = function (c)
        awful.placement.top_left(c, {
            margins = {
                top = beautiful.useless_gap * 2,
                left = beautiful.bar_width + beautiful.useless_gap * 4,
            },
        })
    end,
    background_widget = wibox.widget {
        image = beautiful.wallpaper,
        horizontal_fit_policy = 'fit',
        vertical_fit_policy   = 'fit',
        widget = wibox.widget.imagebox,
    }
}
