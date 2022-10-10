---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local helpers = require 'helpers'

local dpi = beautiful.xresources.apply_dpi

-- signals
require 'signal.cpu'
require 'signal.ram'
require 'signal.disk'
require 'signal.temperature'

-- cahrts
local function mkchart(header, icon)
    return wibox.widget {
        {
            {
                {
                    {
                        {
                            markup = header,
                            widget = wibox.widget.textbox,
                        },
                        fg = beautiful.light_black,
                        widget = wibox.container.background,
                    },
                    left = beautiful.useless_gap * 2,
                    widget = wibox.container.margin,
                },
                {
                    {
                        {
                            {
                                {
                                    {
                                        markup = icon,
                                        font = beautiful.nerd_font .. ' 34',
                                        widget = wibox.widget.textbox,
                                    },
                                    direction = 'west',
                                    widget = wibox.container.rotate,
                                },
                                halign = 'center',
                                valign = 'center',
                                layout = wibox.container.place,
                            },
                            id = 'chart',
                            value = 0,
                            max_value = 1,
                            min_value = 0,
                            forced_height = 124,
                            forced_width = 124,
                            widget = wibox.container.radialprogressbar,
                            border_color = beautiful.dimblack,
                            color = beautiful.blue,
                            border_width = dpi(10),
                        },
                        direction = 'east',
                        widget = wibox.container.rotate,
                    },
                    halign = 'center',
                    layout = wibox.container.place,
                },
                nil,
                layout = wibox.layout.align.vertical,
            },
            margins = beautiful.useless_gap * 2,
            widget = wibox.container.margin,
        },
        shape = helpers.mkroundedrect(),
        bg = beautiful.bg_contrast,
        widget = wibox.container.background,
        set_chart_value = function (self, value)
            self:get_children_by_id('chart')[1].value = value
        end
    }
end

-- initialize charts
local cpu = mkchart('CPU', '')
local mem = mkchart('RAM', '')
local disk = mkchart('Disk', '')
local temp = mkchart('Temp', '')

-- give charts values
awesome.connect_signal('cpu::percent', function (percent)
    -- cpu chart could break sometimes, idk why, but throws some errors
    -- sometimes, so, i'll handle errors lol.
    local function get_percent()
        return percent / 100
    end

    if pcall(get_percent) then
        cpu.chart_value = get_percent()
    end
end)

awesome.connect_signal('ram::used', function (used)
    mem.chart_value = used / 100
end)

awesome.connect_signal('disk::usage', function (used)
    disk.chart_value = used / 100
end)

awesome.connect_signal('temperature::value', function (temperature)
    -- temp chart could break sometimes, idk why, but throws some errors
    -- sometimes, so, i'll handle errors lol.
    local function get_value()
        return temperature / 100
    end

    if pcall(get_value) then
        temp.chart_value = get_value()
    end
end)

-- main widget
return wibox.widget {
    {
        {
            cpu,
            mem,
            spacing = beautiful.useless_gap * 2,
            layout = wibox.layout.flex.horizontal,
        },
        {
            temp,
            disk,
            spacing = beautiful.useless_gap * 2,
            layout = wibox.layout.flex.horizontal,
        },
        spacing = beautiful.useless_gap * 2,
        layout = wibox.layout.flex.vertical,
    },
    top = beautiful.useless_gap * 2,
    widget = wibox.container.margin,
}
