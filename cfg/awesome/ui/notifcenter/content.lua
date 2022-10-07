---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local naughty = require 'naughty'
local helpers = require 'helpers'
local gears = require 'gears'

local list_table = {}

local notif_list = wibox.layout.fixed.vertical {
    spacing = beautiful.useless_gap * 2,
}

naughty.connect_signal('request::display', function (n)
    local widget = wibox.widget {
        {
            {
                id = 'layout_role',
                layout = wibox.layout.fixed.vertical,
            },
            helpers.get_sidebar_notification_widget(n),
            bg = beautiful.black,
            shape = helpers.mkroundedrect(),
            widget = wibox.container.background,
        },
        bottom = beautiful.useless_gap * 2,
        widget = wibox.container.margin,
    }

    local self = widget
    local body_layout = self:get_children_by_id('layout_role')[1]

    notif_list:insert(1, widget)
    table.insert(list_table, 1, widget)

    body_layout:add(helpers.get_sidebar_notification_widget(
        n,
        list_table,
        widget,
        notif_list
    ))
end)

local remove_timer = gears.timer {
    timeout = 1600,
    autostart = true,
    call_now = false,
}

remove_timer:connect_signal('timeout', function ()
    local index = #list_table
    notif_list:remove(index)
    table.remove(list_table, index)
end)

local alert = wibox.widget {
    {
        {
            {
                id = 'icon_role',
                markup = helpers.get_colorized_markup('', beautiful.blue),
                valign = 'center',
                font = beautiful.nerd_font .. ' 22',
                widget = wibox.widget.textbox,
            },
            {
                id = 'text_role',
                markup = '',
                valign = 'center',
                font = beautiful.font_name .. ' 10',
                widget = wibox.widget.textbox,
            },
            spacing = beautiful.useless_gap * 2,
            layout = wibox.layout.fixed.horizontal,
        },
        margins = beautiful.useless_gap * 4,
        widget = wibox.container.margin,
    },
    shape = helpers.mkroundedrect(),
    bg = beautiful.black,
    widget = wibox.container.background,
    set_txt = function (self, txt)
        self:get_children_by_id('text_role')[1].markup = txt
    end,
    visible = false,
}

awesome.connect_signal('notifcenter::message', function (msg)
    alert.txt = '<b>' .. msg .. '</b>'
    alert.visible = true

    local t = gears.timer {
        timeout = 4,
        autostart = true,
        single_shot = true,
        callback = function ()
            alert.visible = false
            alert.txt = ''
        end
    }
end)

return {
    {
        {
            {
                {
                    markup = 'Notifications',
                    align = 'center',
                    valign = 'center',
                    font = beautiful.font_name .. ' 24',
                    widget = wibox.widget.textbox,
                },
                margins = beautiful.useless_gap * 4,
                widget = wibox.container.margin,
            },
            {
                alert,
                notif_list,
                spacing = beautiful.useless_gap * 2,
                layout = wibox.layout.fixed.vertical,
            },
            layout = wibox.layout.fixed.vertical,
        },
        margins = beautiful.useless_gap * 2,
        widget = wibox.container.margin,
    },
    bg = beautiful.bg_normal,
    widget = wibox.container.background,
}
