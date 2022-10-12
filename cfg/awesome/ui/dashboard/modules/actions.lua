---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local awful = require 'awful'
local beautiful = require 'beautiful'
local gears = require 'gears'

local color = require 'modules.color'
local rubato = require 'modules.rubato'
local screenshot = require 'modules.screenshot'

local gfs = gears.filesystem
local util = require 'ui.dashboard.modules.util'

-- signals
local airplane_signal = require 'signal.airplane'
local redshift_signal = require 'signal.redshift'
local bluetooth_signal = require 'signal.bluetooth'
local mic_signal = require 'signal.mic'

-- helper
local function mkactionicon(icon, font)
    return wibox.widget {
        {
            {
                id = 'icon_role',
                markup = icon,
                font = font and font or beautiful.nerd_font .. ' 22',
                widget = wibox.widget.textbox,
            },
            halign = 'center',
            valign = 'center',
            layout = wibox.container.place,
        },
        id = 'background_role',
        fg = beautiful.fg_normal,
        bg = beautiful.dimblack,
        shape = gears.shape.circle,
        forced_height = 48,
        forced_width = 48,
        widget = wibox.container.background,
        set_active = function (self, is_active)
            local background = self:get_children_by_id('background_role')[1]

            local blue = color.color { hex = beautiful.blue }
            local dimblack = color.color { hex = beautiful.dimblack }

            -- method -> rgb
            local by_percent = color.transition(dimblack, blue, 0)

            if not self.fading then
                self.fading = rubato.timed {
                    duration = 0.30,
                }

                self.fading:subscribe(function (percent)
                    background.bg = by_percent(percent / 100).hex
                end)
            end

            if is_active then
                self.fading.target = 100 -- go to blue
                background.fg = beautiful.bg_normal
            else
                self.fading.target = 0 -- go to dimblack
                background.fg = beautiful.fg_normal
            end
        end,
        set_icon = function (self, new_icon)
            self:get_children_by_id('icon_role')[1].markup = new_icon
        end,
        set_font = function (self, new_font)
            self:get_children_by_id('icon_role')[1].font = new_font
        end
    }
end

-- actions buttons
local wifi = mkactionicon('')

wifi:add_button(awful.button({}, 1, function ()
    awful.spawn('bash ' .. gfs.get_configuration_dir() .. 'scripts/toggle-network.sh')
end))

awesome.connect_signal('network::connected', function (is_connected)
    wifi.active = is_connected
    wifi.icon = is_connected and '' or '睊'
end)

local volume = mkactionicon('')

volume:add_button(awful.button({}, 1, function ()
    VolumeSignal.toggle_muted()
end))

awesome.connect_signal('volume::muted', function (is_muted)
    volume.active = not is_muted
    volume.icon = is_muted and '婢' or ''
end)

local airplane = mkactionicon('')

airplane:add_button(awful.button({}, 1, function ()
    airplane_signal.toggle()
end))

awesome.connect_signal('airplane::enabled', function (enabled)
    airplane.active = enabled
    airplane.icon = enabled and '' or ''
end)

local redshift = mkactionicon('盛')

redshift:add_button(awful.button({}, 1, function ()
    redshift_signal.toggle()
end))

awesome.connect_signal('redshift::active', function (enabled)
    redshift.active = enabled
    redshift.icon = enabled and '' or '盛'
end)

local bluetooth = mkactionicon('', beautiful.nerd_font .. ' 19')

bluetooth:add_button(awful.button({}, 1, function ()
    bluetooth_signal.toggle()
end))

awesome.connect_signal('bluetooth::enabled', function (enabled)
    bluetooth.active = enabled
    bluetooth.icon = enabled and '' or ''
    if enabled then
        bluetooth.font = beautiful.nerd_font .. ' 16'
    else
        bluetooth.font = beautiful.nerd_font .. ' 19'
    end
end)

local mic = mkactionicon('', beautiful.nerd_font .. ' 16')

mic:add_button(awful.button({}, 1, function ()
    mic_signal.toggle()
end))

awesome.connect_signal('mic::active', function (enabled)
    mic.active = enabled
    mic.icon = enabled and '' or ''
    if enabled then
        mic.font = beautiful.nerd_font .. ' 16'
    else
        mic.font = beautiful.nerd_font .. ' 18'
    end
end)

local fully_screenshot = mkactionicon('')

fully_screenshot:add_button(awful.button({}, 1, function ()
    screenshot.full({ notify = true })
end))

local area_screenshot = mkactionicon('')

area_screenshot:add_button(awful.button({}, 1, function ()
    screenshot.area({ notify = true })
end))

-- main widget
return util.make_card {
    {
        {
            markup = 'Actions',
            align = 'start',
            widget = wibox.widget.textbox,
        },
        fg = beautiful.dimblack,
        widget = wibox.container.background,
    },
    {
        {
            {
                wifi,
                volume,
                airplane,
                redshift,
                spacing = beautiful.useless_gap * 2,
                layout = wibox.layout.flex.horizontal,
            },
            {
                bluetooth,
                mic,
                fully_screenshot,
                area_screenshot,
                spacing = beautiful.useless_gap * 2,
                layout = wibox.layout.flex.horizontal,
            },
            spacing = beautiful.useless_gap * 2,
            layout = wibox.layout.fixed.vertical,
        },
        margins = beautiful.useless_gap * 2,
        widget = wibox.container.margin,
    },
    spacing = beautiful.useless_gap * 2,
    layout = wibox.layout.fixed.vertical,
}
