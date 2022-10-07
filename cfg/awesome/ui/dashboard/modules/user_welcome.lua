---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local helpers = require 'helpers'
local beautiful = require 'beautiful'
local gears = require 'gears'
local awful = require 'awful'

local dpi = beautiful.xresources.apply_dpi
local util = require 'ui.dashboard.modules.util'

-- dynamic content
local profile_username = wibox.widget {
    markup = 'Welcome',
    align = 'center',
    valign = 'center',
    font = beautiful.font_name .. ' 14',
    widget = wibox.widget.textbox,
}

awful.spawn.easy_async_with_shell('whoami', function (name)
    profile_username:set_markup_silently('Welcome ' .. helpers.capitalize(helpers.trim(name)))
end)

local uptime = wibox.widget {
    markup = '',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
}

-- update uptime lol
gears.timer {
    timeout = 10,
    call_now = true,
    autostart = true,
    callback = function ()
        awful.spawn.easy_async_with_shell('uptime -p', function (time)
            uptime:set_markup_silently(time)
        end)
    end
}

-- main widget
return util.make_card({
    {
        {
            {
                {
                    image = beautiful.pfp,
                    valign = 'center',
                    halign = 'center',
                    forced_height = 64,
                    forced_width = 64,
                    clip_shape = helpers.mkroundedrect(),
                    widget = wibox.widget.imagebox,
                },
                {
                    {
                        profile_username,
                        uptime,
                        spacing = 5,
                        layout = wibox.layout.fixed.vertical,
                    },
                    top = 10,
                    widget = wibox.container.margin,
                },
                nil,
                layout = wibox.layout.align.horizontal,
            },
            margins = beautiful.useless_gap * 2,
            widget = wibox.container.margin,
        },
        bg = beautiful.bg_lighter,
        widget = wibox.container.background,
        shape = function (cr, w, h)
            return gears.shape.partially_rounded_rect(cr, w, h, false, false, true, true, dpi(7))
        end
    },
    {
        {
            {
                util.make_button({
                    markup = helpers.get_colorized_markup('拉', beautiful.blue),
                    font = beautiful.nerd_font .. ' 16',
                    align = 'center',
                    valign = 'center',
                    widget = wibox.widget.textbox
                }, function ()
                    awesome.emit_signal('powermenu::toggle')
                end),
                nil,
                {
                    util.make_button({
                        markup = helpers.get_colorized_markup('勒', beautiful.magenta),
                        font = beautiful.nerd_font .. ' 16',
                        align = 'center',
                        valign = 'center',
                        widget = wibox.widget.textbox,
                    }, function ()
                        awful.spawn('doas reboot')
                    end),
                    util.make_button({
                        markup = helpers.get_colorized_markup('⏻', beautiful.red),
                        font = beautiful.nerd_font .. ' 16',
                        align = 'center',
                        valign = 'center',
                        widget = wibox.widget.textbox,
                    }, function ()
                        awful.spawn('doas poweroff')
                    end),
                    spacing = beautiful.useless_gap * 2,
                    layout = wibox.layout.fixed.horizontal,
                },
                layout = wibox.layout.align.horizontal,
            },
            left = 12,
            right = 12,
            top = 8,
            bottom = 8,
            widget = wibox.container.margin,
        },
        bg = beautiful.black,
        widget = wibox.container.background,
    },
    layout = wibox.layout.fixed.vertical,
}, beautiful.black, false)
