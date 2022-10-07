local wibox = require 'wibox'
local beautiful = require 'beautiful'
local helpers = require 'helpers'
local awful = require 'awful'

local util = {}

function util.make_card(children, background, apply_gaps)
    return wibox.widget {
        {
            children,
            margins = (apply_gaps == true and apply_gaps or (apply_gaps == nil and true or false)) and beautiful.useless_gap * 2 or 0,
            widget = wibox.container.margin,
        },
        bg = background and background or beautiful.bg_lighter,
        shape = helpers.mkroundedrect(),
        widget = wibox.container.background,
    }
end

function util.make_button(template, onclick)
    local button = wibox.widget {
        {
            template,
            top = 1,
            bottom = 1,
            left = 8,
            right = 8,
            widget = wibox.container.margin,
        },
        bg = beautiful.dimblack,
        shape = helpers.mkroundedrect(),
        widget = wibox.container.background,
    }

    helpers.add_hover(button, beautiful.dimblack, beautiful.light_black)

    button:add_button(awful.button({}, 1, function ()
        if onclick then
            onclick()
        end
    end))

    return button
end

return util
