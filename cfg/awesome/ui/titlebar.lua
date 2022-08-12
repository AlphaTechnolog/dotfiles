---@diagnostic disable: undefined-global
local awful = require "awful"
local wibox = require "wibox"

client.connect_signal("request::titlebars", function (c)
  local titlebar = awful.titlebar(c, {
     position = 'left',
     size = 30
  })

  local function separate_button(b, opts)
    opts = opts or {}
    return wibox.widget {
        b,
        top = opts.top or 4,
        bottom = opts.bottom or 4,
        left = opts.left or 8,
        right = opts.right or 8,
        widget = wibox.container.margin,
    }
  end

  titlebar:setup {
     { -- Top
        separate_button(awful.titlebar.widget.closebutton(c), { top = 9 }),
        separate_button(awful.titlebar.widget.maximizedbutton(c)),
        separate_button(awful.titlebar.widget.minimizebutton(c)),
        layout = wibox.layout.fixed.vertical
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
