---@diagnostic disable: undefined-global
local gears = require "gears"
local beautiful = require "beautiful"

local borders = {}

function borders.setup (c)
    if c.maximized then
        c.shape = gears.shape.rectangle
        c.screen.mywibox.width = c.screen.geometry.width
        c.screen.mywibox.shape = gears.shape.rectangle
    else
        c.shape = function (cr, width, height)
            return gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
        end

        c.screen.mywibox.width = c.screen.geometry.width - beautiful.useless_gap * 1.5
        c.screen.mywibox.shape = function (cr, width, height)
            return gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, beautiful.border_radius)
        end
    end
end

client.connect_signal('request::manage', borders.setup)
client.connect_signal('request::border', borders.setup)

return borders
