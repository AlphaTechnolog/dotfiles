---@diagnostic disable: undefined-global
local gears = require "gears"
local beautiful = require "beautiful"

-- apply rounded borders to the given client, also checks the maximized state
local function rounded_borders(c)
    c.shape = c.maximized and gears.shape.rectangle or function (cr, w, h)
        return gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
    end
end

-- readjust the wibar if the given client is maximized or not
local function readjust_wibar_geometry(c)
    local screen = c.screen
    local mywibox = screen.mywibox

    if c.maximized then
        mywibox.width = screen.geometry.width
        mywibox.shape = gears.shape.rectangle
    else
        mywibox.width = screen.geometry.width - beautiful.useless_gap * 1.5
        mywibox.shape = function (cr, w, h)
            return gears.shape.partially_rounded_rect(cr, w, h, true, true, false, false, beautiful.border_radius)
        end
    end
end

-- applying rounded corners when a new client is added
client.connect_signal('request::manage', rounded_borders)

-- applying rounded corners to the existent clients (useful when reloading AwesomeWM)
for _, c in ipairs(client.get()) do
    rounded_borders(c)
end

-- readjusting wibar dimensions when the client border is updated
client.connect_signal('request::border', function (c)
    rounded_borders(c)
    readjust_wibar_geometry(c)
end)
