---@diagnostic disable:undefined-global
local awful = require 'awful'
local beautiful = require 'beautiful'
local gears = require 'gears'
local wibox = require 'wibox'
local xresources = require 'beautiful.xresources'

local dpi = xresources.apply_dpi

screen.connect_signal('request::desktop_decoration', function (s)
    -- set number of tags
    awful.tag(
        { '1', '2', '3', '4', '5', '6' },
        s, awful.layout.layouts[1]
    )

    -- launcher, just spawns rofi
    s.launcher = wibox.widget {
        image = beautiful.rofi_spawner_icon,
        buttons = {
            awful.button({}, 1, function ()
                awful.spawn(launcher)
            end),
        },
        widget = wibox.widget.imagebox,
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
                            dpi(20) -- 20px for border radius
                        )
                    end
                end
            end
        }
    }

    -- tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        layout = {
            spacing = dpi(15),
            layout = wibox.layout.fixed.vertical,
        },
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
                wibox.widget.base.make_widget(),
                id = 'background_role',
                forced_width = dpi(2),
                widget = wibox.container.background,
            },
            nil,
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
            layout = wibox.layout.align.horizontal,
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

    -- systray
    s.mysystray = wibox.widget {
        horizontal = false,
        reverse = true,
        widget = wibox.widget.systray,
    }

    -- actions toggler
    s.myactionstoggler = wibox.widget {
        image = beautiful.settings_icon,
        widget = wibox.widget.imagebox,
        buttons = {
            awful.button({}, 1, function ()
                require 'ui.actions'.toggle_popup()
            end)
        }
    }

    -- vertical clock
    s.myverticalclock_hour = wibox.widget {
        markup = '',
        font = beautiful.font_name .. ' 12',
        align = 'center',
        widget = wibox.widget.textbox,
    }

    s.myverticalclock_minutes = wibox.widget {
        markup = '',
        font = beautiful.font_name .. ' 12',
        align = 'center',
        widget = wibox.widget.textbox,
    }

    -- updates markups
    local function trim(s)
        local result = s:gsub("%s+", "")

        return string.gsub(result, "%s+", "")
    end

    local function update_markups()
        awful.spawn.easy_async_with_shell('date +%H', function (hour)
            s.myverticalclock_hour:set_markup_silently('<b>' .. trim(hour) .. '</b>')
        end)

        awful.spawn.easy_async_with_shell('date +%M', function (minutes)
            s.myverticalclock_minutes:set_markup_silently('<b>' .. trim(minutes) .. '</b>')
        end)
    end

    gears.timer {
        timeout = 1,
        call_now = true,
        autostart = true,
        callback = update_markups,
    }

    s.myverticalclock = wibox.widget {
        {
            {
                s.myverticalclock_hour,
                s.myverticalclock_minutes,
                spacing = dpi(1),
                layout = wibox.layout.fixed.vertical,
            },
            left = dpi(2),
            right = dpi(2),
            top = dpi(10),
            bottom = dpi(10),
            widget = wibox.container.margin,
        },
        bg = beautiful.bg_lighter,
        widget = wibox.container.background,
        shape = gears.shape.rounded_bar,
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

    -- the wibar
    s.mywibox = awful.wibar {
        position = "left",
        screen = s,
        width = beautiful.bar_width,
        height = s.geometry.height - beautiful.useless_gap * 4,
        layout = wibox.layout.align.horizontal,
        margins = { left = beautiful.useless_gap * 2 },
        shape = function (cr, width, height)
            return gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
        end,
    }

    -- make widgets
    s.mywibox:setup {
        layout = wibox.layout.stack,
        {
            layout = wibox.layout.align.vertical,
            {
                {
                    s.launcher,
                    top = dpi(15),
                    left = dpi(15),
                    right = dpi(15),
                    bottom = dpi(5),
                    widget = wibox.container.margin,
                },
                {
                    {
                        {
                            s.mytaglist,
                            direction = 'west',
                            widget = wibox.container.rotate,
                        },
                        layout = wibox.layout.fixed.vertical,
                    },
                    margins = dpi(8),
                    widget = wibox.container.margin,
                },
                layout = wibox.layout.fixed.vertical,
            },
            nil,
            {
                {
                    s.mysystray,
                    top = dpi(10),
                    left = dpi(10),
                    right = dpi(10),
                    bottom = dpi(0),
                    widget = wibox.container.margin,
                },
                {
                    s.myactionstoggler,
                    bottom = dpi(12),
                    top = dpi(12),
                    left = dpi(14),
                    right = dpi(14),
                    widget = wibox.container.margin,
                },
                {
                    s.myverticalclock,
                    left = dpi(7),
                    right = dpi(7),
                    widget = wibox.container.margin,
                },
                {
                    s.mylayoutbox,
                    margins = dpi(12),
                    widget = wibox.container.margin,
                },
                layout = wibox.layout.fixed.vertical,
            },
        },
        {
            s.mytasklist,
            widget = wibox.container.margin,
            valign = 'center',
            halign = 'center',
            layout = wibox.container.place,
        },
    }
end)

-- readjust dimensions and margins when a client modify the property maximized
client.connect_signal('property::maximized', function (c)
    local s = c.screen
    if c.maximized then
        s.mywibox.height = s.geometry.height
        s.mywibox.shape = gears.shape.rectangle
        s.mywibox.margins = { left = 0 }
    else
        s.mywibox.height = s.geometry.height - beautiful.useless_gap * 4
        s.mywibox.margins = { left = beautiful.useless_gap * 2 }
        s.mywibox.shape = function (cr, w, h)
            return gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
        end
    end
end)

-- readjust dimensions and margins when the screen is resized
screen.connect_signal('property::geometry', function (s)
    s.mywibox.height = s.geometry.height - beautiful.useless_gap * 4
    s.mywibox.margins = { left = beautiful.useless_gap * 2 }
end)
