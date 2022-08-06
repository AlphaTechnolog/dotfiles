local awful = require 'awful'
local beautiful = require 'beautiful'
local gears = require 'gears'

local menu = {}

menu.awesome = {
   { "Edit Config", editor_cmd .. " " .. awesome.conffile },
   { "Edit Config (GUI)", visual_editor .. " " .. awesome.conffile },
   { "Restart", awesome.restart },
   { "Close Session", function () awesome.quit() end }
}

menu.mainmenu = awful.menu {
   items = {
      { "Terminal", terminal },
      { "Browser", browser },
      { "Editor", editor_cmd },
      { "GUI Editor", visual_editor },
      { "AwesomeWM", menu.awesome },
   }
}

-- apply rounded corners to menus, thanks to u/signalsourcesexy
local rounded_borders = function (cr, width, height)
   return gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
end

menu.mainmenu.wibox.shape = rounded_borders

-- apply rounded corners to submenus, thanks to u/signalsourcesexy
awful.menu.original_new = awful.menu.new

function awful.menu.new(...)
   local ret = awful.menu.original_new(...)
   ret.wibox.shape = rounded_borders

   return ret
end

return menu
