local gears = require 'gears'
local beautiful = require 'beautiful'

local function setwall()
   screen.connect_signal("request::wallpaper", function (s)
      if beautiful.wallpaper then
         gears.wallpaper.maximized(beautiful.wallpaper, s, false, nil)
      end
   end)
end

setwall()

-- reset wall when screen dimensions changes
screen.connect_signal("property::geometry", setwall)
