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
    placement = awful.placement.bottom_left,
    ontop = true,
    visible = false,
    bg = beautiful.actions.bg,
    fg = beautiful.actions.fg,
    shape = function (cr, w, h)
        return gears.shape.partially_rounded_rect(cr, w, h, false, true, false, false, beautiful.border_radius)
    end
}

function actions.toggle_popup()
    if not actions.popup.visible then
        actions.popup.widget = wibox.widget{
            require 'ui.actions.blocks.header',
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
