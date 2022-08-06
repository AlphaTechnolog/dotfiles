local awful = require "awful"
local wibox = require "wibox"

local function setup_titlebars ()
   client.connect_signal("request::titlebars", function (c)
      local titlebar = awful.titlebar(c, {
         position = 'left',
         size = 30
      })

      titlebar:setup {
         { -- Top
             {
                 {
                      awful.titlebar.widget.closebutton(c),
                      margins = 5,
                      bottom = 4,
                      widget = wibox.container.margin,
                 },
                 {
                      awful.titlebar.widget.maximizedbutton(c),
                      margins = 5,
                      top = 4,
                      bottom = 3,
                      widget = wibox.container.margin,
                 },
                 {
                      awful.titlebar.widget.minimizebutton(c),
                      margins = 5,
                      top = 5,
                      widget = wibox.container.margin,
                 },
                 layout = wibox.layout.fixed.vertical
             },
             margins = 3,
             widget = wibox.container.margin,
         },
         { -- middle, just loads the titlebar buttons
            layout = wibox.layout.fixed.vertical,
            buttons = {
                awful.button({}, 1, function ()
                    c:activate { context = "titlebar", action = "mouse_move" }
                end),
                awful.button({}, 3, function ()
                    c:activate { context = "titlebar", action = "mouse_resize" }
                end)
            },
         },
         { -- Bottom
            {
               {
                  awful.titlebar.widget.floatingbutton(c),
                  margins = 5,
                  widget = wibox.container.margin,
               },
               layout = wibox.layout.fixed.vertical,
            },
            margins = 3,
            widget = wibox.container.margin,
         },
         layout = wibox.layout.align.vertical
     }
   end)
end

setup_titlebars()
