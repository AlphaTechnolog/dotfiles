local wibox = require 'wibox'
local gears = require 'gears'
local beautiful = require 'beautiful'
local xresources = require 'beautiful.xresources'
local props = require 'ui.actions.props'
local awful = require 'awful'

local dpi = xresources.apply_dpi

local shutdown_button = wibox.widget {
    {
        {
            image = beautiful.shutdown,
            forced_height = dpi(16),
            forced_width = dpi(16),
            halign = 'center',
            valign = 'center',
            widget = wibox.widget.imagebox,
        },
        margins = dpi(6),
        widget = wibox.container.margin,
    },
    bg = beautiful.bg_contrast,
    widget = wibox.container.background,
    buttons = {
        awful.button({}, 1, function ()
            awful.spawn('doas poweroff')
        end)
    },
    shape = function (cr, w, h)
        return gears.shape.rounded_rect(cr, w, h, dpi(7))
    end
}

-- hover
shutdown_button:connect_signal('mouse::enter', function (self)
    self.bg = beautiful.bg_lighter
end)

shutdown_button:connect_signal('mouse::leave', function (self)
    self.bg = beautiful.bg_contrast
end)

-- tooltip
local shutdown_tooltip = awful.tooltip {
    fg = beautiful.fg_normal,
    bg = beautiful.bg_normal,
    shape = function (cr, w, h)
        return gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
    end
}

shutdown_tooltip:add_to_object(shutdown_button)

shutdown_button:connect_signal('mouse::enter', function ()
    shutdown_tooltip:set_text("Press to shutdown")
end)

local reboot_button = wibox.widget {
    {
        {
            image = beautiful.reboot,
            forced_height = dpi(13),
            forced_width = dpi(13),
            align = 'center',
            valign = 'center',
            widget = wibox.widget.imagebox,
        },
        top = dpi(6),
        left = dpi(6),
        right = dpi(6),
        bottom = dpi(4),
        widget = wibox.container.margin,
    },
    bg = beautiful.bg_contrast,
    widget = wibox.container.background,
    buttons = {
        awful.button({}, 1, function ()
            awful.spawn('doas reboot')
        end)
    },
    shape = function (cr, w, h)
        return gears.shape.rounded_rect(cr, w, h, dpi(7))
    end
}

-- hover
reboot_button:connect_signal('mouse::enter', function (self)
    self.bg = beautiful.bg_lighter
end)

reboot_button:connect_signal('mouse::leave', function (self)
    self.bg = beautiful.bg_contrast
end)

-- tooltip
local reboot_tooltip = awful.tooltip {
    fg = beautiful.fg_normal,
    bg = beautiful.bg_normal,
}

reboot_tooltip:add_to_object(reboot_button)

reboot_button:connect_signal('mouse::enter', function ()
    reboot_tooltip:set_text("Press to reboot")
end)

local buttons = wibox.widget {
    shutdown_button,
    reboot_button,
    spacing = dpi(20),
    layout = wibox.layout.fixed.horizontal,
}

local powerbuttons_widget = wibox.widget {
    {
        nil,
        {
            buttons,
            halign = 'center',
            valign = 'center',
            widget = wibox.container.margin,
            layout = wibox.container.place,
        },
        layout = wibox.layout.stack,
    },
    margins = props.gaps,
    widget = wibox.container.margin,
}

return powerbuttons_widget
