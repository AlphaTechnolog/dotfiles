local wibox = require 'wibox'
local beautiful = require 'beautiful'
local gears = require 'gears'
local helpers = require 'helpers'
local awful = require 'awful'
local bling = require 'modules.bling'

local dpi = beautiful.xresources.apply_dpi
local util = require 'ui.dashboard.modules.util'

local function action_button (template)
    local button = wibox.widget {
        {
            template,
            top = 2,
            bottom = 2,
            left = 9,
            right = 9,
            widget = wibox.container.margin,
        },
        bg = beautiful.black,
        shape = helpers.mkroundedrect(4),
        widget = wibox.container.background,
        set_markup = function (self, markup)
            self:get_children_by_id('markup_role')[1].markup = markup
        end,
        get_markup = function (self)
            return self:get_children_by_id('markup_role')[1].markup
        end
    }

    helpers.add_hover(button, beautiful.black, beautiful.dimblack)

    return button
end

local pctl = bling.signal.playerctl.lib()

-- information
local music_picture = wibox.widget {
    image = beautiful.fallback_music,
    valign = 'center',
    halign = 'center',
    forced_height = 64,
    forced_width = 64,
    clip_shape = helpers.mkroundedrect(),
    widget = wibox.widget.imagebox,
}

local music_name = wibox.widget {
    markup = 'No title',
    font = beautiful.font_size .. ' 12',
    widget = wibox.widget.textbox,
}

local music_artist = wibox.widget {
    markup = 'No artist',
    widget = wibox.widget.textbox,
}

-- info-connection
pctl:connect_signal('metadata', function (_, title, artist, picture)
    music_picture:set_image(gears.surface.load_uncached(picture))
    music_name:set_markup_silently(helpers.limit_by_length(title == '' and 'No title' or title, 17, true))
    music_artist:set_markup_silently(helpers.limit_by_length(artist == '' and 'No artist' or artist, 23, true))
end)

-- buttons
local previous = action_button {
    id = 'markup_role',
    markup = '玲',
    align = 'center',
    valign = 'center',
    font = beautiful.nerd_font .. ' 13',
    widget = wibox.widget.textbox,
}

previous:add_button(awful.button({}, 1, function ()
    pctl:previous()
end))

local pause = action_button {
    id = 'markup_role',
    markup = '',
    align = 'center',
    valign = 'center',
    font = beautiful.nerd_font .. ' 19',
    widget = wibox.widget.textbox,
}

pctl:connect_signal('playback_status', function (_, playing)
    pause.markup = playing
        and ''
        or ''
end)

pause:add_button(awful.button({}, 1, function ()
    pctl:play_pause()
end))

local next = action_button {
    id = 'markup_role',
    markup = '怜',
    align = 'center',
    valign = 'center',
    font = beautiful.nerd_font .. ' 13',
    widget = wibox.widget.textbox,
}

next:add_button(awful.button({}, 1, function ()
    pctl:next()
end))

-- reset stuff
pctl:connect_signal('no_players', function ()
    music_picture.image = beautiful.fallback_music
    music_name.markup = 'Not playing'
    music_artist.markup = 'No artist'
    pause.markup = ''
end)

return util.make_card({
    {
        {
            {
                music_picture,
                {
                    {
                        music_name,
                        music_artist,
                        spacing = beautiful.useless_gap,
                        layout = wibox.layout.fixed.vertical,
                    },
                    valign = 'center',
                    layout = wibox.container.place,
                },
                spacing = beautiful.useless_gap * 2,
                layout = wibox.layout.fixed.horizontal,
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
                {
                    previous,
                    pause,
                    next,
                    spacing = beautiful.useless_gap * 4,
                    layout = wibox.layout.fixed.horizontal,
                },
                halign = 'center',
                valign = 'center',
                layout = wibox.container.place,
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
