---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local helpers = require 'helpers'
local beautiful = require 'beautiful'
local gears = require 'gears'
local awful = require 'awful'

local user_welcome = require 'ui.dashboard.modules.user_welcome'
local music = require 'ui.dashboard.modules.music'
local controls = require 'ui.dashboard.modules.controls'
local actions = require 'ui.dashboard.modules.actions'
local charts = require 'ui.dashboard.modules.charts'

local dpi = beautiful.xresources.apply_dpi

local username = wibox.widget {
    markup = 'Hello',
    widget = wibox.widget.textbox,
}

awful.spawn.easy_async_with_shell('whoami', function (name)
    username:set_markup_silently('Hello ' .. helpers.capitalize(helpers.trim(name)))
end)

local searchbox = wibox.widget {
    {
        {
            {
                {
                    markup = helpers.get_colorized_markup('', beautiful.blue),
                    font = beautiful.nerd_font .. ' 14',
                    widget = wibox.widget.textbox,
                },
                {
                    markup = helpers.get_colorized_markup('Search...', beautiful.light_black),
                    widget = wibox.widget.textbox,
                },
                spacing = 7,
                layout = wibox.layout.fixed.horizontal,
            },
            top = 2,
            bottom = 2,
            left = 10,
            widget = wibox.container.margin,
        },
        shape = gears.shape.rounded_bar,
        fg = beautiful.fg_normal,
        bg = beautiful.bg_normal,
        widget = wibox.container.background,
    },
    top = 2,
    bottom = 2,
    left = 15,
    right = 2,
    widget = wibox.container.margin,
}

searchbox:add_button(awful.button({}, 1, function ()
    awesome.emit_signal('dashboard::toggle')
    awful.spawn(launcher) -- comes from user_likes.lua
end))

local headerbox = wibox.widget {
    {
        {
            {
                {
                    image = beautiful.pfp,
                    forced_height = 24,
                    forced_width = 24,
                    valign = 'center',
                    widget = wibox.widget.imagebox,
                    clip_shape = gears.shape.circle,
                },
                username,
                spacing = 6,
                layout = wibox.layout.fixed.horizontal,
            },
            searchbox,
            nil,
            layout = wibox.layout.align.horizontal,
        },
        top = 8,
        bottom = 8,
        left = 12,
        right = 12,
        widget = wibox.container.margin,
    },
    bg = beautiful.bg_lighter,
    widget = wibox.container.background,
}

local mainbox = wibox.widget {
    {
        {
            {
                {
                    user_welcome,
                    controls,
                    spacing = beautiful.useless_gap * 2,
                    layout = wibox.layout.fixed.vertical,
                },
                {
                    music,
                    actions,
                    spacing = beautiful.useless_gap * 2,
                    layout = wibox.layout.fixed.vertical,
                },
                spacing = beautiful.useless_gap * 2,
                layout = wibox.layout.flex.horizontal,
            },
            charts,
            nil,
            layout = wibox.layout.align.vertical,
        },
        margins = beautiful.useless_gap * 2,
        widget = wibox.container.margin,
    },
    bg = beautiful.bg_normal,
    widget = wibox.container.background,
    shape = function (cr, w, h)
        return gears.shape.partially_rounded_rect(cr, w, h, true, true, false, false, dpi(14))
    end
}

local widget = {
    {
        headerbox,
        mainbox,
        nil,
        layout = wibox.layout.align.vertical,
    },
    bg = beautiful.bg_lighter,
    widget = wibox.container.background,
}

return widget
