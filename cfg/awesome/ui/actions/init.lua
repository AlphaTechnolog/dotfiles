local awful = require 'awful'
local gears = require 'gears'
local xresources = require 'beautiful.xresources'
local beautiful = require 'beautiful'
local wibox = require 'wibox'
local helpers = require 'ui.actions.helpers'
local props = require 'ui.actions.props'

local dpi = xresources.apply_dpi

local actions = {}

actions.popup = awful.popup {
    widget = {},
    screen = awful.screen.focused(),
    minimum_width = dpi(10),
    minimum_height = props.height,
    type = 'dock',
    shape = function (cr, width, height)
        return gears.shape.rounded_rect(cr, width, height, props.radius)
    end,
    placement = function (d)
        return awful.placement.left(d, {
            margins = {
                left = beautiful.bar_width + beautiful.useless_gap * 4,
            }
        })
    end,
    ontop = true,
    visible = false,
    bg = beautiful.actions.bg,
    fg = beautiful.actions.fg,
}

function actions.toggle_popup()
    if not actions.popup.visible then
        actions.popup.widget = wibox.widget{
            helpers.mkblock(require 'ui.actions.blocks.date'),
            helpers.mkblock(require 'ui.actions.blocks.music'),
            helpers.mkblock(require 'ui.actions.blocks.user'),
            helpers.mkblock(require 'ui.actions.blocks.stats'),
            helpers.mkblock(require 'ui.actions.blocks.controls'),
            require 'ui.actions.blocks.powerbuttons',
            layout = wibox.layout.fixed.vertical,
        }
        actions.popup.screen = awful.screen.focused()
        actions.popup.visible = true
    else
        actions.popup.widget = nil
        actions.popup.visible = false
        collectgarbage('collect')
    end
end

return actions
