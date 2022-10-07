local wibox = require 'wibox'
local awful = require 'awful'
local beautiful = require 'beautiful'

-- listening awesomewm events
require 'ui.systray.listener'

awful.screen.connect_for_each_screen(function (s)
    s.systray = {}

    local dimensions = {
        width = 200,
        height = 150,
    }

    s.systray.popup = wibox {
        visible = false,
        ontop = true,
        width = dimensions.width,
        height = dimensions.height,
        bg = beautiful.bg_normal .. '00',
        fg = beautiful.fg_normal,
        x = s.geometry.x + beautiful.bar_width + beautiful.useless_gap * 4,
        y = s.geometry.height - s.geometry.height / 7 - dimensions.height - beautiful.useless_gap * 2,
    }

    local self = s.systray.popup

    self:setup {
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
            margins = 12,
            widget = wibox.container.margin,
        },
        bg = beautiful.bg_normal,
        fg = beautiful.fg_normal,
        widget = wibox.container.background,
    }

    function s.systray.toggle()
        if self.visible then
            s.systray.hide()
        else
            s.systray.show()
        end
    end

    function s.systray.show()
        self.visible = true
    end

    function s.systray.hide()
        self.visible = false
    end
end)
