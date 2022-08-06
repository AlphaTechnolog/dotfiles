local wibox = require 'wibox'
local beautiful = require 'beautiful'
local gears = require 'gears'
local awful = require 'awful'
local helpers = require 'ui.actions.helpers'

local height = 200

local function update_prop(self, id, txt)
    self:get_children_by_id(id)[1].text = txt
end

local date_widget = wibox.widget {
    {
        {
            {
                id = 'time',
                text = '',
                align = 'center',
                font = beautiful.font_name .. ' 45',
                widget = wibox.widget.textbox,
            },
            top = helpers.percent(height, 18),
            widget = wibox.container.margin,
        },
        layout = wibox.layout.stack,
    },
    {
        {
            id = 'date',
            text = '',
            align = 'center',
            widget = wibox.widget.textbox,
        },
        layout = wibox.layout.stack,
    },
    layout = wibox.layout.fixed.vertical,
    set_time = function (self, val) update_prop(self, 'time', val) end,
    set_date = function (self, val) update_prop(self, 'date', val) end,
}

-- filling texts
gears.timer {
    timeout = 1,
    call_now = true,
    autostart = true,
    callback = function ()
        awful.spawn.easy_async_with_shell('date "+%I:%M %p"', function (out)
            date_widget.time = out
        end)
        awful.spawn.easy_async_with_shell('date "+%A, %B %d"', function (out)
            date_widget.date = out
        end)
    end
}

return {
    height = height,
    widget = date_widget,
}
