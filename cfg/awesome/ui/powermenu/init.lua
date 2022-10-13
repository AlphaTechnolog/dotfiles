---@diagnostic disable: undefined-global
local awful = require 'awful'
local wibox = require 'wibox'
local gears = require 'gears'
local beautiful = require 'beautiful'
local helpers = require 'helpers'

local dpi = beautiful.xresources.apply_dpi

require 'ui.powermenu.listener'

local username = wibox.widget {
    markup = '...',
    align = 'center',
    font = beautiful.font_name .. ' 20',
    widget = wibox.widget.textbox,
}

awful.spawn.easy_async_with_shell('whoami', function (whoami)
    username:set_markup_silently('Hey ' ..
        helpers.get_colorized_markup(helpers.capitalize(
            helpers.trim(whoami)
        ), beautiful.blue)
    .. '!')
end)

local function make_powerbutton (opts)
    local default_widget = function (font, align)
        return wibox.widget {
            markup = '⏻',
            font = font,
            align = align,
            widget = wibox.widget.textbox,
        }
    end

    if not opts then
        opts = {
            widget = default_widget,
            onclick = function () end,
            bg = beautiful.bg_lighter,
        }
    end

    -- @DEFAULT_VALUE -> key = `bg`
    opts.bg = opts.bg and opts.bg or beautiful.bg_lighter

    local call_widget = function ()
        local icon_font = beautiful.nerd_font .. ' 32'
        local align = 'center'

        if opts.widget ~= nil then
            return opts.widget(icon_font, align)
        else
            return default_widget(icon_font, align)
        end
    end

    local button = wibox.widget {
        {
            call_widget(),
            top = dpi(2),
            bottom = dpi(2),
            left = dpi(18),
            right = dpi(18),
            widget = wibox.container.margin,
        },
        widget = wibox.container.background,
        bg = opts.bg,
        shape = gears.shape.circle,
    }

    -- add hover support just when background is bg_lighter
    if opts.bg == beautiful.bg_lighter then
        helpers.add_hover(button, beautiful.bg_lighter, beautiful.light_black)
    end

    button:add_button(awful.button({}, 1, function ()
        if opts.onclick then
            opts.onclick()
        end
    end))

    return button
end

local powerbuttons = wibox.widget {
    make_powerbutton {
        widget = function (icon_font, align)
            return wibox.widget {
                {
                    markup = '⏻',
                    align = align,
                    font = icon_font,
                    widget = wibox.widget.textbox,
                },
                fg = beautiful.red,
                widget = wibox.container.background,
            }
        end,
        onclick = function ()
            awful.spawn.with_shell('doas poweroff')
        end,
    },
    make_powerbutton {
        widget = function (font, align)
            return wibox.widget {
                {
                    markup = '勒',
                    align = align,
                    font = font,
                    widget = wibox.widget.textbox,
                },
                fg = beautiful.yellow,
                widget = wibox.container.background,
            }
        end,
        onclick = function ()
            awful.spawn.with_shell('doas reboot')
        end
    },
    make_powerbutton {
        widget = function (font, align)
            return wibox.widget {
                {
                    markup = '',
                    align = align,
                    font = font,
                    widget = wibox.widget.textbox,
                },
                fg = beautiful.magenta,
                widget = wibox.container.background,
            }
        end,
        onclick = function ()
            awful.spawn.with_shell('pkill awesome')
        end
    },
    make_powerbutton {
        widget = function (font, align)
            return wibox.widget {
                {
                    markup = '',
                    align = align,
                    font = font,
                    widget = wibox.widget.textbox,
                },
                fg = beautiful.blue,
                widget = wibox.container.background,
            }
        end,
        onclick = function ()
            awesome.emit_signal('powermenu::visibility', false)
        end
    },
    spacing = dpi(18),
    layout = wibox.layout.fixed.horizontal,
}

awful.screen.connect_for_each_screen(function (s)
    s.powermenu = {}

    s.powermenu.widget = wibox.widget {
        {
            {
                markup = '',
                widget = wibox.widget.textbox,
            },
            bg = '#000000',
            widget = wibox.container.background,
            opacity = 0.12
        },
        {
            {
                {
                    {
                        {
                            image = beautiful.pfp,
                            forced_height = 128,
                            forced_width = 128,
                            halign = 'center',
                            clip_shape = gears.shape.circle,
                            widget = wibox.widget.imagebox,
                        },
                        {
                            username,
                            {
                                markup = 'What do you want to do?',
                                align = 'center',
                                widget = wibox.widget.textbox,
                            },
                            spacing = dpi(2),
                            layout = wibox.layout.fixed.vertical,
                        },
                        {
                            powerbuttons,
                            widget = wibox.container.margin,
                            top = dpi(10),
                        },
                        spacing = dpi(7),
                        layout = wibox.layout.fixed.vertical,
                    },
                    margins = dpi(12),
                    widget = wibox.container.margin,
                },
                fg = beautiful.fg_normal,
                shape = helpers.mkroundedrect(),
                widget = wibox.container.background,
            },
            halign = 'center',
            valign = 'center',
            widget = wibox.container.margin,
            layout = wibox.container.place,
        },
        layout = wibox.layout.stack,
    }

    s.powermenu.splash = wibox {
        widget = s.powermenu.widget,
        screen = s,
        type = 'splash',
        visible = false,
        ontop = true,
        bg = beautiful.bg_normal .. '80',
        height = s.geometry.height,
        width = s.geometry.width,
        x = s.geometry.x,
        y = s.geometry.y,
    }

    local self = s.powermenu.splash

    function s.powermenu.toggle ()
        if self.visible then
            s.powermenu.hide()
        else
            s.powermenu.open()
        end
    end

    function s.powermenu.open ()
        self.visible = true
    end

    function s.powermenu.hide ()
        self.visible = false
    end
end)
