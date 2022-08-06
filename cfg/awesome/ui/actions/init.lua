local awful = require 'awful'
local gears = require 'gears'
local xresources = require 'beautiful.xresources'
local beautiful = require 'beautiful'
local wibox = require 'wibox'
local helpers = require 'ui.actions.helpers'
local props = require 'ui.actions.props'

local dpi = xresources.apply_dpi

local date = require 'ui.actions.blocks.date'
local stats = require 'ui.actions.blocks.stats'
local music = require 'ui.actions.blocks.music'
local user = require 'ui.actions.blocks.user'
local controls = require 'ui.actions.blocks.controls'

local actions = {}

actions.popup = awful.popup {
    widget = {
        helpers.mkblock(date),
        helpers.mkblock(music),
        helpers.mkblock(user),
        helpers.mkblock(stats),
        helpers.mkblock(controls),
        layout = wibox.layout.fixed.vertical,
    },
    screen = awful.screen.focused(),
    minimum_width = dpi(10),
    minimum_height = props.height,
    type = 'dock',
    shape = function (cr, width, height)
        return gears.shape.rounded_rect(cr, width, height, props.radius)
    end,
    placement = function (drawable)
        return awful.placement.left(drawable, {
            margins = {
                bottom = beautiful.bar_height,
                left = beautiful.useless_gap * 2
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
        actions.popup.screen = awful.screen.focused()
    end
    actions.popup.visible = not actions.popup.visible
end

return actions
