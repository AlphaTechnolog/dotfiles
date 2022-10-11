local wibox = require 'wibox'
local beautiful = require 'beautiful'

local titlebar = require 'ui.screenshot-center.modules.titlebar'
local main_container = require 'ui.screenshot-center.modules.main-container'

return {
    {
        titlebar,
        {
            main_container,
            margins = beautiful.useless_gap * 2,
            widget = wibox.container.margin,
        },
        {
            {
                {
                    markup = '',
                    widget = wibox.widget.textbox,
                },
                margins = 12,
                widget = wibox.container.margin,
            },
            bg = beautiful.bg_normal,
            fg=  beautiful.fg_normal,
            widget = wibox.container.background,
        },
        layout = wibox.layout.align.horizontal,
    },
    fg = beautiful.fg_normal,
    bg = beautiful.bg_normal,
    widget = wibox.container.background,
}
