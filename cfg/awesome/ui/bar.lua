---@diagnostic disable: undefined-global
local awful = require 'awful'
local xresources = require 'beautiful.xresources'
local beautiful = require 'beautiful'
local wibox = require 'wibox'
local gears = require 'gears'
local helpers = require 'helpers'

local dpi = xresources.apply_dpi

screen.connect_signal('request::desktop_decoration', function (s)
    -- set tags
    awful.tag(
        { '1', '2', '3', '4', '5', '6' },
        s, awful.layout.layouts[1]
    )

    -- launcher, spawns rofi
    s.launcher = wibox.widget {
        image = beautiful.rofi_spawner_icon,
        buttons = {
            awful.button({}, 1, function ()
                awful.spawn(launcher)
            end),
        },
        widget = wibox.widget.imagebox
    }

    -- taglist widget
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = {
            -- just enables click in tags and scroll
            awful.button({}, 1, function (t)
                t:view_only()
            end),
            awful.button({}, 4, function (t)
                awful.tag.viewprev(t.screen)
            end),
            awful.button({}, 5, function (t)
                awful.tag.viewnext(t.screen)
            end)
        },
        style = {
            shape = gears.shape.circle,
        },
        widget_template = {
            {
                {
                    {
                        {
                            widget = wibox.widget.textbox
                        },
                        margins = 6,
                        widget = wibox.container.margin,
                    },
                    id = 'background_role',
                    widget = wibox.container.background,
                },
                margins = {
                    right = 6,
                    left = 6,
                },
                widget = wibox.container.margin,
            },
            bg = beautiful.taglist_bg,
            widget = wibox.container.background,
            create_callback = function (self, c3, index, tagsList)
                -- bling taglist preview
                self:connect_signal('mouse::enter', function ()
                    if #c3:clients() > 0 then
                        awesome.emit_signal('bling::tag_preview::update', c3)
                        awesome.emit_signal('bling::tag_preview::visibility', s, true)
                    end
                end)

                self:connect_signal('mouse::leave', function ()
                    awesome.emit_signal('bling::tag_preview::visibility', s, false)
                end)

                -- enables rounded borders to first and last tag
                if index == 1 or index == 6 then
                    self.shape = function (cr, width, height)
                        -- top left and bottom left in first tag
                        -- top right and bottom right in last tag
                        local tl = index == 1
                        local tr = index == 6
                        local br = index == 6
                        local bl = index == 1

                        return gears.shape.partially_rounded_rect(
                            cr, width, height,
                            tl, tr, br, bl,
                            dpi(10) -- 10px for border radius
                        )
                    end
                end
            end
        }
    }

    -- layoutbox
    s.mylayoutbox = awful.widget.layoutbox {
        screen = s,
        buttons = {
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc(-1) end),
            awful.button({ }, 5, function () awful.layout.inc( 1) end),
        }
    }

    -- tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button({ }, 1, function (c)
                c:activate { context = "tasklist", action = "toggle_minimization" }
            end),
            awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
            awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
            awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
        },
        widget_template = {
            {
                {
                    forced_width = dpi(26),
                    forced_height = dpi(26),
                    widget = awful.widget.clienticon,
                },
                top = dpi(3),
                bottom = dpi(3),
                left = dpi(7),
                right = dpi(7),
                widget = wibox.container.margin,
            },
            nil,
            {
                wibox.widget.base.make_widget(),
                id = 'background_role',
                forced_height = dpi(2),
                widget = wibox.container.background,
            },
            layout = wibox.layout.align.vertical,
            create_callback = function (self, c, index, objects)
                self:connect_signal('mouse::enter', function ()
                    awesome.emit_signal('bling::task_preview::visibility', s, true, c)
                end)
                self:connect_signal('mouse::leave', function ()
                    awesome.emit_signal('bling::task_preview::visibility', s, false, c)
                end)
            end
        }
    }

    -- textclock
    s.mytextclock_raw = wibox.widget {
       format = "%I:%M %p",
       refresh = 1,
       buttons = {
          awful.button({}, 1, function ()
             if s.mytextclock_raw.format == '%I:%M %p' then
                s.mytextclock_raw.format = '%d/%m/%y'
             else
                s.mytextclock_raw.format = '%I:%M %p'
             end
          end)
       },
       widget = wibox.widget.textclock,
    }

    s.mytextclock = wibox.widget {
       {
          s.mytextclock_raw,
          left = dpi(15),
          right = dpi(15),
          widget = wibox.container.margin,
       },
       bg = beautiful.bg_contrast,
       shape = gears.shape.rounded_bar,
       widget = wibox.container.background,
    }

    -- actions toggler, settings button, just toggle the actions popup
    s.myactiontoggler = wibox.widget {
       {
          {
             image = beautiful.settings_icon,
             forced_height = dpi(16),
             forced_width = dpi(16),
             valign = 'center',
             buttons = {
                awful.button({}, 1, function ()
                   require 'ui.actions'.toggle_popup()
                end)
             },
             widget = wibox.widget.imagebox,
          },
          left = dpi(12),
          right = dpi(12),
          widget = wibox.container.margin,
       },
       shape = gears.shape.circle,
       bg = beautiful.bg_contrast,
       widget = wibox.container.background
    }

    -- add hover feedback to actions toggler
    helpers.add_feedback(s.myactiontoggler, beautiful.bg_contrast, beautiful.bg_lighter)

   -- systray widget
   s.mysystray = wibox.widget.systray {
      horizontal = true,
      screen = s,
   }

   -- create bar
    s.mywibox = awful.wibar {
        position = "bottom",
        screen = s,
        width = s.geometry.width - beautiful.useless_gap * 1.5,
        height = beautiful.bar_height,
        layout = wibox.layout.align.horizontal,
        shape = function (cr, width, height)
            return gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, beautiful.border_radius)
        end,
    }

    s.mywibox:setup {
         layout = wibox.layout.stack,
         {
             layout = wibox.layout.align.horizontal,
             {
                 layout = wibox.layout.fixed.horizontal,
                 { -- left widgets
                     {
                         {
                             s.launcher,
                             margins = dpi(4),
                             left = dpi(7),
                             widget = wibox.container.margin,
                         },
                         {
                             s.mytaglist,
                             left = dpi(10),
                             widget = wibox.container.margin,
                         },
                         s.myactiontoggler,
                         layout = wibox.layout.fixed.horizontal,
                     },
                     margins = dpi(8),
                     widget = wibox.container.margin,
                 },
             },
             nil,
             { -- Right widgets
                 layout = wibox.layout.fixed.horizontal,
                 {
                     {
                        layout = wibox.layout.fixed.horizontal,
                        s.mysystray,
                        {
                           s.mytextclock,
                           left = dpi(10),
                           right = dpi(18),
                           widget = wibox.container.margin,
                        },
                        s.mylayoutbox,
                     },
                     margins = dpi(8),
                     widget = wibox.container.margin,
                 },
             },
         },
         {
            s.mytasklist,
            widget = wibox.container.margin,
            valign = "center",
            halign = "center",
            layout = wibox.container.place
         }
     }
end)

screen.connect_signal('property::geometry', function (s)
    s.mywibox.width = s.geometry.width - beautiful.useless_gap * 1.5
end)

client.connect_signal('request::border', function (c)
    local s = c.screen

    if c.maximized then
        s.mywibox.shape = gears.shape.rectangle
        s.mywibox.width = s.geometry.width
    else
        s.mywibox.width = s.geometry.width - beautiful.useless_gap * 1.5
        s.mywibox.shape = function (cr, w, h)
            return gears.shape.partially_rounded_rect(cr, w, h, true, true, false, false, beautiful.border_radius)
        end
    end
end)
