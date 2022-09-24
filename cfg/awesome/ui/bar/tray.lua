---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local awful = require 'awful'
local beautiful = require 'beautiful'
local helpers = require 'helpers'

local dpi = beautiful.xresources.apply_dpi

-- listens for requests to open/hide the systray popup in the focused screen ofc.
local function get_tray()
    return awful.screen.focused().tray
end

awesome.connect_signal('tray::toggle', function ()
    get_tray().toggle()
end)

awesome.connect_signal('tray::visibility', function (v)
    if v then
        get_tray().show()
    else
        get_tray().hide()
    end
end)

awful.screen.connect_for_each_screen(function (s)
    s.tray = {}

    s.tray.widget = wibox.widget {
        {
            {
                {
                    widget = wibox.widget.systray,
                    horizontal = false,
                    screen = s,
                    base_size = 16,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            margins = dpi(12),
            widget = wibox.container.margin,
        },
        bg = beautiful.bg_normal,
        fg = beautiful.fg_normal,
        widget = wibox.container.background,
        shape = helpers.mkroundedrect(),
    }

    s.tray.popup = awful.popup {
        widget = s.tray.widget,
        screen = s,
        visible = false,
        ontop = true,
        bg = beautiful.bg_normal .. '00',
        fg = beautiful.fg_normal,
        minimum_width = dpi(200),
        minimum_height = dpi(150),
        shape = helpers.mkroundedrect(),
        placement = function (d)
            return awful.placement.bottom_right(d, {
                margins = {
                    right = beautiful.useless_gap * 33,
                    bottom = beautiful.bar_height + beautiful.useless_gap * 2,
                }
            })
        end,
    }

    local self, tray = s.tray.popup, s.tray

    function tray.toggle ()
        if self.visible then
            tray.hide()
        else
            tray.show()
        end
    end

    function tray.show ()
        self.visible = true
    end

    function tray.hide ()
        self.visible = false
    end
end)
