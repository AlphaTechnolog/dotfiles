---@diagnostic disable: undefined-global
local awful = require 'awful'
local beautiful = require 'beautiful'
local gears = require 'gears'
local wibox = require 'wibox'
local helpers = require 'helpers'
local dpi = beautiful.xresources.apply_dpi

-- enable visibility listener.
require 'ui.dashboard.listener'

awful.screen.connect_for_each_screen(function (s)
    s.dashboard = {}

    local username = wibox.widget {
        markup = '...',
        widget = wibox.widget.textbox
    }

    awful.spawn.easy_async_with_shell('whoami', function (whoami)
        username:set_markup_silently('Hello ' .. helpers.capitalize(helpers.trim(whoami)))
    end)

    -- making it as a function to make sure it's loaded when i want.
    local function mkwidget ()
        local date = require 'ui.dashboard.date'
        local charts = require 'ui.dashboard.charts'
        local music = require 'ui.dashboard.music-player'
        local controls = require 'ui.dashboard.controls'
        local actions = require 'ui.dashboard.actions'

        return wibox.widget {
            {
                {
                    {
                        {
                            {
                                image = beautiful.pfp,
                                forced_height = dpi(24),
                                forced_width = dpi(24),
                                valign = 'center',
                                halign = 'center',
                                clip_shape = gears.shape.circle,
                                widget = wibox.widget.imagebox,
                            },
                            username,
                            spacing = dpi(7),
                            layout = wibox.layout.fixed.horizontal,
                        },
                        {
                            {
                                {
                                    {
                                        {
                                            image = beautiful.launcher_icon,
                                            forced_height = dpi(12),
                                            forced_width = dpi(12),
                                            valign = 'center',
                                            halign = 'center',
                                            widget = wibox.widget.imagebox,
                                        },
                                        {
                                            markup = helpers.get_colorized_markup('Search Apps', beautiful.light_black),
                                            widget = wibox.widget.textbox,
                                        },
                                        spacing = dpi(5),
                                        layout = wibox.layout.fixed.horizontal,
                                    },
                                    top = dpi(2),
                                    bottom = dpi(2),
                                    left = dpi(8),
                                    right = dpi(8),
                                    widget = wibox.container.margin,
                                },
                                bg = beautiful.bg_normal,
                                widget = wibox.container.background,
                                shape = gears.shape.rounded_bar,
                                buttons = awful.button({}, 1, function ()
                                    awful.spawn(launcher)
                                end)
                            },
                            left = dpi(46),
                            widget = wibox.container.margin,
                        },
                        nil,
                        layout = wibox.layout.align.horizontal,
                    },
                    top = dpi(5),
                    bottom = dpi(5),
                    left = dpi(7),
                    right = dpi(7),
                    widget = wibox.container.margin,
                },
                {
                    {
                        {
                            date,
                            {
                                controls,
                                music,
                                spacing = dpi(12),
                                layout = wibox.layout.flex.horizontal,
                            },
                            charts,
                            {
                                {
                                    {
                                        actions.network,
                                        actions.airplane,
                                        actions.volume,
                                        actions.redshift,
                                        actions.bluetooth,
                                        spacing = dpi(10),
                                        layout = wibox.layout.flex.horizontal,
                                    },
                                    margins = dpi(15),
                                    widget = wibox.container.margin,
                                },
                                shape = helpers.mkroundedrect(dpi(15)),
                                bg = beautiful.bg_lighter,
                                widget = wibox.container.background,
                            },
                            spacing = dpi(15),
                            layout = wibox.layout.fixed.vertical,
                        },
                        margins = dpi(15),
                        widget = wibox.container.margin,
                    },
                    bg = beautiful.bg_normal,
                    widget = wibox.container.background,
                    shape = function (cr, w, h)
                        return gears.shape.partially_rounded_rect(cr, w, h, true, true, false, false, dpi(12))
                    end
                },
                nil,
                spacing = dpi(15),
                layout = wibox.layout.align.vertical,
            },
            bg = beautiful.bg_lighter,
            fg = beautiful.fg_normal,
            widget = wibox.container.background,
            shape = helpers.mkroundedrect(),
        }
    end

    s.dashboard.popup = awful.popup {
        placement = function (d)
            return awful.placement.bottom(d, {
                margins = {
                    bottom = beautiful.bar_height + beautiful.useless_gap * 2,
                },
            })
        end,
        ontop = true,
        visible = false,
        shape = helpers.mkroundedrect(),
        bg = '#00000000',
        minimum_width = dpi(455),
        fg = beautiful.fg_normal,
        screen = s,
        widget = wibox.widget {
            bg = beautiful.bg_normal,
            widget = wibox.container.background,
        },
    }

    local self = s.dashboard.popup

    -- the next functions are made like this to solve
    -- performace issues with the lot of signals inside the dashboard.
    function s.dashboard.toggle()
        if self.visible then
            s.dashboard.hide()
        else
            s.dashboard.show()
        end
    end

    function s.dashboard.show()
        if not PlayerctlSignal then
            PlayerctlSignal = require 'bling'.signal.playerctl.lib()
        end
        if not PlayerctlCli then
            PlayerctlCli = require 'bling'.signal.playerctl.cli()
        end
        self.widget = mkwidget()
        self.visible = true
    end

    function s.dashboard.hide()
        self.visible = false
        if PlayerctlCli then
            PlayerctlCli:disable()
            PlayerctlCli = nil
        end
        self.widget = wibox.widget {
            bg = beautiful.bg_normal,
            widget = wibox.container.background
        }
        collectgarbage('collect')
    end
end)
