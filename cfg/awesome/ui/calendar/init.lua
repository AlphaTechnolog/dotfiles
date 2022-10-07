local awful = require 'awful'
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local gears = require 'gears'

require 'ui.calendar.listener'

awful.screen.connect_for_each_screen(function (s)
    s.calendar = {}

    local dimensions = {
        width = 270,
        height = 285
    }

    s.calendar.popup = wibox {
        visible = false,
        ontop = true,
        width = dimensions.width,
        height = dimensions.height,
        x = s.geometry.x + beautiful.bar_width + beautiful.useless_gap * 4,
        y = s.geometry.height - beautiful.useless_gap * 2 - dimensions.height,
        bg = beautiful.bg_normal .. '00',
        fg = beautiful.fg_normal,
        screen = s,
    }

    local self = s.calendar.popup

    self:setup {
        {
            {
                {
                    date = os.date('*t'),
                    font = beautiful.font_name .. ' 10',
                    spacing = 2,
                    widget = wibox.widget.calendar.month,
                    fn_embed = function (widget, flag, date)
                        local focus_widget = wibox.widget {
                            text = date.day,
                            align = 'center',
                            widget = wibox.widget.textbox,
                        }

                        local torender = flag == 'focus' and focus_widget or widget

                        local colors = {
                            header = beautiful.blue,
                            focus = beautiful.aqua,
                            weekday = beautiful.cyan
                        }

                        local color = colors[flag] or beautiful.fg_normal

                        return wibox.widget {
                            {
                                torender,
                                margins = 7,
                                widget = wibox.container.margin,
                            },
                            bg = flag == 'focus' and beautiful.black or beautiful.bg_normal,
                            fg = color,
                            widget = wibox.container.background,
                            shape = flag == 'focus' and gears.shape.circle or nil,
                        }
                    end
                },
                spacing = beautiful.useless_gap * 2,
                layout = wibox.layout.fixed.vertical,
            },
            margins = beautiful.useless_gap * 2,
            widget = wibox.container.margin,
        },
        bg = beautiful.bg_normal,
        fg = beautiful.fg_normal,
        widget = wibox.container.background,
    }

    function s.calendar.open()
        self.visible = true
    end

    function s.calendar.hide()
        self.visible = false
    end

    function s.calendar.toggle ()
        if self.visible then
            s.calendar.hide()
        else
            s.calendar.open()
        end
    end
end)
