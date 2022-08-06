local xresources = require 'beautiful.xresources'
local beautiful = require 'beautiful'
local awful = require 'awful'

local dpi = xresources.apply_dpi
local screen = awful.screen.focused()

return {
    width = dpi(920),
    height = screen.geometry.height - beautiful.bar_height - beautiful.useless_gap * 4,
    gaps = dpi(16),
    radius = dpi(12),
}
