---@diagnostic disable: undefined-global

local awful = require 'awful'
local wibox = require 'wibox'
local xresources = require 'beautiful.xresources'

local dpi = xresources.apply_dpi

client.connect_signal('request::titlebars', function (c)
    local titlebar = awful.titlebar(c, {
        position = 'top',
        size = 34
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
        layout = wibox.layout.fixed.horizontal,
        buttons = titlebars_buttons,
    }

    local function paddined_button(button, margins)
        margins = margins or {
            top = 10,
            bottom = 10,
            left = 4,
            right = 4
        }

        return wibox.widget {
            button,
            top = margins.top,
            bottom = margins.bottom,
            left = margins.left,
            right = margins.right,
            widget = wibox.container.margin,
        }
    end

    titlebar:setup {
        {
            paddined_button(awful.titlebar.widget.closebutton(c), {
                top = 10,
                bottom = 10,
                right = 4,
                left = 11
            }),
            paddined_button(awful.titlebar.widget.maximizedbutton(c)),
            paddined_button(awful.titlebar.widget.minimizebutton(c)),
            layout = wibox.layout.fixed.horizontal,
        },
        buttons_loader,
        buttons_loader,
        layout = wibox.layout.align.horizontal
    }
end)
