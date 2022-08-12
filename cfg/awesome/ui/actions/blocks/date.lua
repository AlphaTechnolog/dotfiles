local wibox = require 'wibox'
local beautiful = require 'beautiful'
local gears = require 'gears'
local awful = require 'awful'
local helpers = require 'ui.actions.helpers'
local xresources = require 'beautiful.xresources'

local dpi = xresources.apply_dpi

local height = 200

local hour = wibox.widget {
    markup = '',
    align = 'center',
    valign = 'center',
    font = beautiful.font_name ..  ' 40',
    widget = wibox.widget.textbox,
}

local minutes = wibox.widget {
    markup = '',
    align = 'center',
    valign = 'center',
    font = beautiful.font_name .. ' 40',
    widget = wibox.widget.textbox,
}

local date = wibox.widget {
    markup = '',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
}

local function trim(s)
    local result = s:gsub("%s+", "")

    return string.gsub(result, "%s+", "")
end

gears.timer {
    timeout = 1,
    call_now = true,
    autostart = true,
    callback = function ()
        awful.spawn.easy_async_with_shell('date +%H', function (h)
            hour:set_markup_silently(trim(h))
        end)
        awful.spawn.easy_async_with_shell('date +%M', function (m)
            minutes:set_markup_silently(trim(m))
        end)
        awful.spawn.easy_async_with_shell('date "+%A, %B %d"', function (d)
            date:set_markup_silently(d)
        end)
    end
}

local gen_block = function (background)
    if not background then
        background = beautiful.blue
    end

    return wibox.widget {
        bg = background,
        shape = gears.shape.rectangle,
        forced_width = dpi(1),
        forced_height = dpi(16),
        valign = 'center',
        halign = 'center',
        align = 'center',
        widget = wibox.container.background,
    }
end

local divider = wibox.widget {
    gen_block(beautiful.magenta),
    gen_block(beautiful.blue),
    gen_block(beautiful.red),
    layout = wibox.layout.align.vertical,
}

local date_widget = wibox.widget {
    {
        {
            {
                {
                    hour,
                    left = dpi(28),
                    widget = wibox.container.margin,
                },
                nil,
                {
                    minutes,
                    right = dpi(35),
                    widget = wibox.container.margin,
                },
                layout = wibox.layout.align.horizontal,
            },
            {
                divider,
                halign = 'center',
                valign = 'center',
                widget = wibox.container.margin,
                layout = wibox.container.place,
            },
            layout = wibox.layout.stack,
        },
        top = helpers.percent(height, 18),
        bottom = dpi(12),
        widget = wibox.container.margin,
    },
    date,
    layout = wibox.layout.fixed.vertical,
}

return {
    height = height,
    contrast = true,
    notop = true,
    widget = date_widget,
}
