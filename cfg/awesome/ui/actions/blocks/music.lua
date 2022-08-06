-- BRUH, idk what i'm doing in this widget, but it should works xd, so if it works it works lol

local wibox = require 'wibox'
local beautiful = require 'beautiful'
local xresources = require 'beautiful.xresources'
local gears = require 'gears'
local playerctl = require 'signal.playerctl'
local awful = require 'awful'
local bling = require 'bling'

local dpi = xresources.apply_dpi

local height = 120

-- base widgets
local image = wibox.widget {
    image = beautiful.fallback_music_image,
    align = 'center',
    valign = 'center',
    forced_width = dpi(64),
    forced_height = dpi(64),
    widget = wibox.widget.imagebox,
    clip_shape = function (cr, w, h)
        return gears.shape.rounded_rect(cr, w, h, dpi(7))
    end
}

local title = wibox.widget {
    markup = 'Not Playing',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
}

local position = wibox.widget {
    max_value = 100,
    value = 0,
    forced_height = dpi(1),
    forced_width = dpi(3),
    border_width = 0,
    bar_border_width = 0,
    color = beautiful.blue,
    background_color = beautiful.bg_lighter,
    widget = wibox.widget.progressbar,
}

-- buttons
local playerctl_cli = bling.signal.playerctl.cli()

local previous_button = wibox.widget {
    image = beautiful.previous_music,
    forced_width = dpi(16),
    forced_height = dpi(16),
    widget = wibox.widget.imagebox,
    buttons = {
        awful.button({}, 1, function ()
            playerctl_cli:previous('spotify')
        end)
    }
}

local pause_button = wibox.widget {
    image = beautiful.play_music,
    forced_width = dpi(16),
    forced_height = dpi(16),
    widget = wibox.widget.imagebox,
    buttons = {
        awful.button({}, 1, function ()
            playerctl_cli:play_pause('spotify')
        end)
    }
}

local next_button = wibox.widget {
    image = beautiful.next_music,
    forced_width = dpi(16),
    forced_height = dpi(16),
    widget = wibox.widget.imagebox,
    buttons = {
        awful.button({}, 1, function ()
            playerctl_cli:next('spotify')
        end)
    }
}

-- connection to playerctl
local function limit_by(txt, len)
    if #txt >= len then
        txt = txt:sub(1, len - 3) .. "..."
    end

    return txt
end

playerctl:connect_signal('metadata', function (_, music_title, artist, album_path, album, new, player_name)
    image:set_image(gears.surface.load_uncached(album_path))
    title:set_markup_silently(limit_by(music_title, 22))
end)

playerctl:connect_signal('no_players', function ()
    title:set_markup_silently('No playing')
    image:set_image(gears.surface.load_uncached(beautiful.fallback_music_image))
    position:set_max_value(100)
    position:set_value(0)
    pause_button:set_image(gears.surface.load_uncached(beautiful.play_music))
end)

playerctl:connect_signal('position', function (_, interval_sec, length_sec)
    position:set_max_value(length_sec)
    position:set_value(interval_sec)
end)

playerctl:connect_signal('playback_status', function (_, playing)
    pause_button:set_image(gears.surface.load_uncached(
        playing
            and beautiful.pause_music
            or beautiful.play_music
    ))
end)

-- making the widget
local music_widget = wibox.widget {
    {
        image,
        left = dpi(12),
        widget = wibox.container.margin,
    },
    {
        {
            title,
            top = dpi(15),
            widget = wibox.container.margin,
        },
        {
            position,
            left = dpi(25),
            right = dpi(25),
            top = dpi(10),
            widget = wibox.container.margin
        },
        {
            {
                {
                    previous_button,
                    {
                        left = dpi(30),
                        widget = wibox.container.margin,
                    },
                    next_button,
                    layout = wibox.layout.align.horizontal,
                },
                {
                    pause_button,
                    valign = 'center',
                    align = 'center',
                    widget = wibox.container.margin,
                    layout = wibox.container.place,
                },
                layout = wibox.layout.stack,
            },
            top = dpi(12),
            left = dpi(50),
            right = dpi(50),
            widget = wibox.container.margin,
        },
        layout = wibox.layout.fixed.vertical,
    },
    layout = wibox.layout.align.horizontal,
}

return {
    widget = music_widget,
    flat = true,
    height = height
}
