local beautiful = require 'beautiful'
local awful = require 'awful'

local dpi = beautiful.xresources.apply_dpi
local screen = awful.screen.focused()

return {
    height = screen.geometry.height - beautiful.useless_gap * 1.5,
    gaps = dpi(16),
    radius = dpi(12),
}
