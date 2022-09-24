---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local helpers = require 'helpers'
local gears = require 'gears'
local awful = require 'awful'

local playerctl = PlayerctlSignal
local playerctl_cli = PlayerctlCli

local dpi = beautiful.xresources.apply_dpi

local picture = wibox.widget {
    image = beautiful.fallback_music,
    halign = 'center',
    forced_width = dpi(48),
    forced_height = dpi(48),
    horizontal_fit_policy = 'fit',
    vertical_fit_policy = 'fit',
    valign = 'center',
    clip_shape = helpers.mkroundedrect(),
    widget = wibox.widget.imagebox,
}

local title = wibox.widget {
    markup = '<b>No playing</b>',
    align = 'center',
    widget = wibox.widget.textbox,
}

local artist = wibox.widget {
    markup = 'No artist',
    font = beautiful.font_name .. ' ' .. tostring(tonumber(beautiful.font_size) - 1),
    widget = wibox.widget.textbox,
}

-- controls
local function base_control_button (default_icon, font)
    local btn = wibox.widget {
        {
            {
                id = 'icon_role',
                markup = default_icon,
                align = 'center',
                font = font or beautiful.nerd_font .. ' 14',
                widget = wibox.widget.textbox,
            },
            top = dpi(1),
            bottom = dpi(1),
            left = dpi(11),
            right = dpi(11),
            widget = wibox.container.margin,
        },
        shape = helpers.mkroundedrect(dpi(4)),
        bg = beautiful.black,
        widget = wibox.widget.background,
        set_txt = function (self, value)
            self:get_children_by_id('icon_role')[1].markup = value
        end
    }

    helpers.add_hover(btn, beautiful.black, beautiful.dimblack)

    return btn
end

local previous = base_control_button('玲')
local pause = base_control_button('', beautiful.nerd_font .. ' 18')
local next = base_control_button('怜')

-- WIP
local shuffle = base_control_button('怜')

-- controls buttons
previous:add_button(awful.button({}, 1, function ()
    playerctl_cli:previous()
end))

pause:add_button(awful.button({}, 1, function ()
    playerctl_cli:play_pause()
end))

next:add_button(awful.button({}, 1, function ()
    playerctl_cli:next()
end))

local progress_slider = wibox.widget {
    bar_shape = gears.shape.rounded_bar,
    bar_height = 3,
    bar_active_color = beautiful.blue,
    bar_color = beautiful.dimblack,
    handle_width = 0,
    forced_width = 3,
    forced_height = 3,
    value = 0,
    minimum = 0,
    maximum = 100,
    widget = wibox.widget.slider,
}

-- make connection to playerctl
playerctl:connect_signal('metadata', function (_, music_title, music_artist, music_album_path)
    title:set_markup_silently('<b>' .. helpers.limit_by_length(music_title, 16, true) .. '</b>')
    artist:set_markup_silently('By ' .. helpers.limit_by_length(music_artist, 19, true))
    picture:set_image(gears.surface.load_uncached(music_album_path))
end)

playerctl:connect_signal('no_players', function ()
    title:set_markup_silently('No music')
    artist:set_markup_silently('No artist')
    picture:set_image(gears.surface.load_uncached(beautiful.fallback_music))
    pause:set_markup('')
    progress_slider.maximum = 100
    progress_slider.value = 0
end)

playerctl:connect_signal('playback_status', function (_, playing)
    pause.txt = playing
        and ''
        or ''
end)

local interval, length = nil, nil

playerctl:connect_signal('position', function (_, interval_sec, length_sec)
    length = length_sec
    interval = interval_sec
    progress_slider.maximum = length
    progress_slider.value = interval
end)

progress_slider:connect_signal('property::value', function (_, val)
    if interval ~= nil and length ~= nil and val ~= interval then
        playerctl_cli:set_position(val)
    end
end)

local music_player = wibox.widget {
    {
        nil,
        {
            {
                picture,
                {
                    {
                        {
                            markup = '',
                            widget = wibox.widget.textbox,
                        },
                        {
                            {
                                title,
                                artist,
                                spacing = dpi(5),
                                layout = wibox.layout.fixed.vertical,
                            },
                            halign = 'center',
                            valign = 'center',
                            widget = wibox.container.margin,
                            layout = wibox.container.place,
                        },
                        layout = wibox.layout.stack,
                    },
                    left = dpi(7),
                    widget = wibox.container.margin,
                },
                nil,
                layout = wibox.layout.align.horizontal,
            },
            margins = dpi(12),
            widget = wibox.container.margin,
        },
        progress_slider,
        {
            {
                {
                    {
                        previous,
                        nil,
                        next,
                        layout = wibox.layout.align.horizontal,
                    },
                    {
                        pause,
                        halign = 'center',
                        valign = 'center',
                        widget = wibox.container.margin,
                        layout = wibox.container.place,
                    },
                    layout = wibox.layout.stack,
                },
                top = dpi(5),
                bottom = dpi(5),
                left = dpi(17),
                right = dpi(17),
                widget = wibox.container.margin,
            },
            bg = beautiful.black,
            widget = wibox.container.background,
            shape = function (cr, w, h)
                return gears.shape.partially_rounded_rect(cr, w, h, false, false, true, true, dpi(7))
            end
        },
        layout = wibox.layout.fixed.vertical,
    },
    shape = helpers.mkroundedrect(),
    bg = beautiful.bg_contrast,
    widget = wibox.container.background,
}

return music_player
