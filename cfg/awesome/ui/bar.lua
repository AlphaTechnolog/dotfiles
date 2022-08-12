---@diagnostic disable:undefined-global

local awful = require 'awful'
local beautiful = require 'beautiful'
local gears = require 'gears'
local wibox = require 'wibox'
local xresources = require 'beautiful.xresources'

local dpi = xresources.apply_dpi

screen.connect_signal('request::desktop_decoration', function (s)
    awful.tag(
        { '1', '2', '3', '4', '5', '6' },
        s, awful.layout.layouts[1]
    )

    s.mylauncher = wibox.widget {
        {
            {
                widget = wibox.widget.imagebox,
                image = beautiful.rofi_spawner_icon,
                forced_height = dpi(16),
                forced_width = dpi(16),
                halign = 'center',
                valign = 'center',
            },
            left = dpi(7),
            right = dpi(7),
            top = dpi(5),
            bottom = dpi(5),
            widget = wibox.container.margin,
        },
        bg = beautiful.bg_lighter,
        widget = wibox.container.background,
        shape = function (cr, w, h)
            return gears.shape.rounded_rect(cr, w, h, dpi(5))
        end,
        buttons = {
            awful.button({}, 1, function ()
                awful.spawn('rofi -show drun')
            end)
        }
    }

    s.mylauncher:connect_signal('mouse::enter', function ()
        s.mylauncher.bg = beautiful.black
    end)

    s.mylauncher:connect_signal('mouse::leave', function ()
        s.mylauncher.bg = beautiful.bg_lighter
    end)

    s.mydateraw = wibox.widget {
        format = '%I:%M %p',
        widget = wibox.widget.textclock,
    }

    local calendar = require 'ui.calendar'

    s.mydate = wibox.widget {
        s.mydateraw,
        layout = wibox.layout.fixed.horizontal,
        buttons = awful.button({}, 1, function ()
            s.mydateraw.toggled = s.mydateraw.toggled and s.mydateraw.toggled or false
            s.mydateraw.format = s.mydateraw.toggled and '%I:%M %p' or '%A %B %d'
            s.mydateraw.toggled = not s.mydateraw.toggled
        end)
    }

    -- WIP limitations

    --[[
    s.mydate:connect_signal('mouse::enter', function ()
        calendar.toggle()
    end)

    s.mydate:connect_signal('mouse::leave', function ()
        calendar.toggle()
    end)]]--

    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        style = {
            shape = gears.shape.circle,
        },
        layout = {
            layout = wibox.layout.fixed.horizontal,
        },
        buttons = {
            -- clicks
            awful.button({}, 1, function (t)
                t:view_only()
            end),

            -- scroll
            awful.button({}, 4, function (t)
                awful.tag.viewprev(t.screen)
            end),
            awful.button({}, 5, function (t)
                awful.tag.viewnext(t.screen)
            end)
        },
        widget_template = {
            {
                {
                    id = 'background_role',
                    forced_height = dpi(12),
                    forced_width = dpi(12),
                    widget = wibox.container.background,
                },
                id = 'tag_margin',
                left = dpi(6),
                right = dpi(6),
                top = dpi(6),
                bottom = dpi(6),
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

                if index == 1 then
                    self.shape = function (cr, w, h)
                        return gears.shape.partially_rounded_rect(cr, w, h, true, false, false, true, dpi(20))
                    end

                    self:get_children_by_id('tag_margin')[1].left = dpi(10)
                end

                if index == #tagsList then
                    self.shape = function (cr, w, h)
                        return gears.shape.partially_rounded_rect(cr, w, h, false, true, true, false, dpi(20))
                    end

                    self:get_children_by_id('tag_margin')[1].right = dpi(10)
                end
            end
        }
    }

    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.allscreen,
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

                -- handle click
                self:add_button(awful.button({
                    modifiers = {},
                    button = 1,
                    on_press = function ()
                        if not c.active then
                            c:activate {
                                context = 'through_dock',
                                switch_to_tag = true,
                            }
                        else
                            c.minimized = true
                        end
                    end
                }))
            end
        }
    }

    s.mysystray = wibox.widget {
        horizontal = true,
        widget = wibox.widget.systray,
    }

    s.myverticalsep = wibox.widget {
        {
            widget = wibox.container.background,
            forced_width = dpi(1),
            bg = beautiful.black,
        },
        top = dpi(5),
        bottom = dpi(5),
        left = dpi(5),
        widget = wibox.container.margin,
    }

    s.myactiontoggler = wibox.widget {
        {
            {
                widget = wibox.widget.imagebox,
                image = beautiful.settings_icon,
                forced_height = dpi(16),
                forced_width = dpi(16),
                halign = 'center',
                valign = 'center',
            },
            left = dpi(7),
            right = dpi(7),
            top = dpi(5),
            bottom = dpi(5),
            widget = wibox.container.margin,
        },
        bg = beautiful.bg_lighter,
        widget = wibox.container.background,
        shape = function (cr, w, h)
            return gears.shape.rounded_rect(cr, w, h, dpi(5))
        end,
        buttons = {
            awful.button({}, 1, function ()
                require 'ui.actions'.toggle_popup()
            end)
        }
    }

    s.myactiontoggler:connect_signal('mouse::enter', function ()
        s.myactiontoggler.bg = beautiful.black
    end)

    s.myactiontoggler:connect_signal('mouse::leave', function ()
        s.myactiontoggler.bg = beautiful.bg_lighter
    end)

    s.mylayoutbox = awful.widget.layoutbox {
        screen = s,
        buttons = {
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc(-1) end),
            awful.button({ }, 5, function () awful.layout.inc( 1) end),
        }
    }

    s.mywibox = awful.wibar {
        position = 'bottom',
        screen = s,
        height = beautiful.bar_height,
        width = s.geometry.width - beautiful.useless_gap * 1.8,
        shape = function (cr, w, h)
            return gears.shape.partially_rounded_rect(cr, w, h, true, true, false, false, beautiful.border_radius)
        end
    }

    s.mywibox:setup {
        {
            layout = wibox.layout.align.horizontal,
            {
                {
                    {
                        s.mylauncher,
                        s.mytaglist,
                        s.myactiontoggler,
                        layout = wibox.layout.fixed.horizontal,
                        spacing = dpi(10),
                    },
                    top = dpi(7),
                    bottom = dpi(7),
                    widget = wibox.container.margin,
                },
                left = dpi(12),
                widget = wibox.container.margin,
            },
            nil,
            {
                {
                    {
                        {
                            {
                                {
                                    s.mysystray,
                                    s.myverticalsep,
                                    {
                                        s.mydate,
                                        left = dpi(5),
                                        right = dpi(5),
                                        widget = wibox.container.margin,
                                    },
                                    layout = wibox.layout.fixed.horizontal,
                                    spacing = dpi(5),
                                },
                                widget = wibox.container.margin,
                                left = dpi(10),
                                right = dpi(10),
                            },
                            bg = beautiful.bg_lighter,
                            widget = wibox.container.background,
                            shape = gears.shape.rounded_bar,
                        },
                        top = dpi(7),
                        bottom = dpi(7),
                        widget = wibox.container.margin,
                    },
                    {
                        s.mylayoutbox,
                        top = dpi(10),
                        bottom = dpi(10),
                        widget = wibox.container.margin,
                    },
                    spacing = dpi(10),
                    layout = wibox.layout.fixed.horizontal,
                },
                right = dpi(12),
                widget = wibox.container.margin,
            }
        },
        {
            s.mytasklist,
            halign = 'center',
            widget = wibox.widget.margin,
            layout = wibox.container.place,
        },
        layout = wibox.layout.stack,
    }
end)
