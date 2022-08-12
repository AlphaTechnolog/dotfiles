local xresources = require 'beautiful.xresources'
local beautiful = require 'beautiful'
local wibox = require 'wibox'
local gears = require 'gears'
local props = require 'ui.actions.props'

local dpi = xresources.apply_dpi

local helpers = {}

function helpers.percent(n, p)
    return p * n / 100
end

function helpers.mkblock(opts)
    local height = opts.height or helpers.percent(props.height, 15)
    local widget = opts.widget or {}
    local notop = opts.notop or false
    local contrast = opts.contrast or false

    return {
        {
            {
                widget,
                margins = props.gaps,
                widget = wibox.container.margin,
            },
            bg = contrast and beautiful.actions.contrast or beautiful.actions.bg,
            forced_height = dpi(height),
            widget = wibox.container.background,
            shape = function (cr, w, h)
                return gears.shape.rounded_rect(cr, w, h, props.radius)
            end
        },
        top = notop and 0 or props.gaps,
        left = props.gaps,
        right = props.gaps,
        widget = wibox.container.margin,
    }
end

return helpers
