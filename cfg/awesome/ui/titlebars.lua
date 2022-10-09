---@diagnostic disable: undefined-global
local awful = require 'awful'
local wibox = require 'wibox'
local helpers = require 'helpers'

client.connect_signal('request::titlebars', function (c)
   if c.requests_no_titlebar then
      return
   end

    local titlebar = awful.titlebar(c, {
        position = 'left',
        size = 36,
    })

    local titlebars_buttons = {
        awful.button({}, 1, function ()
            c:activate {
                context = 'titlebar',
                action = 'mouse_move',
            }
        end),
        awful.button({}, 3, function ()
            c:activate {
                context = 'titlebar',
                action = 'mouse_resize',
            }
        end)
    }

    local buttons_loader = {
        layout = wibox.layout.fixed.vertical,
        buttons = titlebars_buttons,
    }

    titlebar:setup {
        {
            helpers.apply_margin(awful.titlebar.widget.closebutton(c), {
                left = 11,
                right = 11,
                top = 10,
                bottom = 5,
            }),
            helpers.apply_margin(awful.titlebar.widget.maximizedbutton(c), {
                left = 11,
                right = 11,
                top = 4,
                bottom = 5,
            }),
            helpers.apply_margin(awful.titlebar.widget.minimizebutton(c), {
                left = 11,
                right = 11,
                top = 4,
                bottom = 5,
            }),
            layout = wibox.layout.fixed.vertical,
        },
        buttons_loader,
        buttons_loader,
        layout = wibox.layout.align.vertical,
    }
end)
