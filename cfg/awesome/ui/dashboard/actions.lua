---@diagnostic disable: undefined-global

local awful = require 'awful'
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local gears = require 'gears'
local helpers = require 'helpers'

local gfs = gears.filesystem
local dpi = beautiful.xresources.apply_dpi

-- enable signals
require 'signal.network'

local redshift_mngr = require 'signal.redshift'
local airplane_mngr = require 'signal.airplane'
local bluetooth_mngr = require 'signal.bluetooth'

local function make_button(options)
    local default_icon = options.default_icon
    local callback = options.callback
    local signal = options.signal.name
    local signal_callback = options.signal.callback
    local styles = options.styles or { font = beautiful.nerd_font .. ' 23' }
    local font = styles.font

    local button = wibox.widget {
        {
            {
                id = 'icon_role',
                markup = default_icon,
                align = 'center',
                font = font,
                widget = wibox.widget.textbox,
            },
            right = dpi(1),
            widget = wibox.container.margin,
        },
        shape = gears.shape.circle,
        bg = beautiful.black,
        widget = wibox.container.background,
        set_icon = function (self, icon)
            self:get_children_by_id('icon_role')[1].markup = icon
        end
    }

    awesome.connect_signal(signal, function (payload)
        signal_callback(button, payload)
    end)

    button:add_button(awful.button({}, 1, callback))

    return button
end

-- network
local network = make_button {
    default_icon = '睊',
    callback = function ()
        awful.spawn('bash ' .. gfs.get_configuration_dir() .. 'scripts/toggle-network.sh')
    end,
    signal = {
        name = 'network::connected',
        callback = function (self, is_connected)
            self.icon = is_connected and '' or '睊'
            self.bg = is_connected and beautiful.blue or beautiful.black
            self.fg = is_connected and beautiful.bg_normal or beautiful.fg_normal
        end
    }
}

-- volume
local volume = make_button {
    default_icon = '',
    callback = VolumeSignal.toggle_muted,
    signal = {
        name = 'volume::muted',
        callback = function (self, is_muted)
            self.icon = is_muted and '婢' or ''
            self.bg = is_muted and beautiful.black or beautiful.blue
            self.fg = is_muted and beautiful.fg_normal or beautiful.bg_normal
        end
    }
}

-- redshift
local redshift = make_button {
    default_icon = '',
    callback = redshift_mngr.toggle,
    signal = {
        name = 'redshift::active',
        callback = function (self, is_active)
            self.icon = is_active and '' or ''
            self.bg = is_active and beautiful.blue or beautiful.black
            self.fg = is_active and beautiful.bg_normal or beautiful.fg_normal
        end
    }
}

-- airplane
local airplane = make_button {
    default_icon = '',
    callback = airplane_mngr.toggle,
    signal = {
        name = 'airplane::enabled',
        callback = function (self, is_enabled)
            self.icon = is_enabled and '' or ''
            self.bg = is_enabled and beautiful.blue or beautiful.black
            self.fg = is_enabled and beautiful.bg_normal or beautiful.fg_normal
        end
    }
}

-- bluetooth
local bluetooth = make_button {
    default_icon = '',
    callback = bluetooth_mngr.toggle,
    styles = {
        font = beautiful.nerd_font .. ' 17',
    },
    signal = {
        name = 'bluetooth::enabled',
        callback = function (self, is_enabled)
            self.icon = is_enabled and '' or ''
            self.bg = is_enabled and beautiful.blue or beautiful.black
            self.fg = is_enabled and beautiful.bg_normal or beautiful.fg_normal
        end
    },
}

return {
    network = network,
    volume = volume,
    redshift = redshift,
    airplane = airplane,
    bluetooth = bluetooth,
}
