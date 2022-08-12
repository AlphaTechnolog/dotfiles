local awful = require 'awful'
local beautiful = require 'beautiful'
local dpi = beautiful.xresources.apply_dpi
local gears = require 'gears'
local wibox = require 'wibox'

local calendar = {}

calendar.popup = awful.popup {
    widget = wibox.widget {
        widget = wibox.widget.textbox,
        text = 'hello',
        halign = 'center',
        valign = 'center',
        layout = wibox.container.place,
    },
    type = 'dock',
    ontop = true,
    visible = false,
    minimum_width = dpi(200),
    minimum_height = dpi(150),
    shape = function (cr, w, h)
        return gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
    end,
    placement = function (d)
        return awful.placement.bottom_right(d, {
            margins = {
                right = beautiful.useless_gap * 2,
                bottom = beautiful.bar_height + beautiful.useless_gap * 2,
            }
        })
    end,
    screen = awful.screen.focused(),
    bg = beautiful.bg_normal,
    fg = beautiful.fg_normal,
}

calendar.toggle = function ()
    if not calendar.popup.visible then
        calendar.popup.screen = awful.screen.focused()
    end

    calendar.popup.visible = not calendar.popup.visible
end

return calendar
