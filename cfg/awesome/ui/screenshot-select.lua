local wibox = require 'wibox'
local awful = require 'awful'
local beautiful = require 'beautiful'
local helpers = require 'helpers'
local gfs = require 'gears.filesystem'

local dpi = beautiful.xresources.apply_dpi

awful.screen.connect_for_each_screen(function (s)
    s.screenshot_selecter = {}

    local function genbutton(template, tooltip_opts, onclick)
        local button = wibox.widget {
            {
                template,
                margins = dpi(7),
                widget = wibox.container.margin,
            },
            bg = beautiful.bg_normal,
            shape = helpers.mkroundedrect(),
            widget = wibox.container.background,
        }

        helpers.add_hover(button, beautiful.bg_normal, beautiful.black)

        local tooltip = helpers.make_popup_tooltip(tooltip_opts.txt, tooltip_opts.placement)

        tooltip.attach_to_object(button)

        button:add_button(awful.button({}, 1, function ()
            tooltip.hide()
            s.myscreenshot_action_icon:set_markup_silently('')
            if onclick then
                onclick()
            end
        end))

        return button
    end

    s.screenshot_selecter.widget = wibox.widget {
        {
            {
                genbutton({
                    markup = '',
                    font = beautiful.nerd_font .. ' 30',
                    align = 'center',
                    valign = 'center',
                    widget = wibox.widget.textbox,
                }, {
                    txt = 'Full Screenshot',
                    placement = function (d)
                        return awful.placement.bottom_right(d, {
                            margins = {
                                bottom = (beautiful.bar_height + beautiful.useless_gap * 2) + dpi(80) + (beautiful.useless_gap * 2),
                                right = dpi(100) + (dpi(100) / 2.75),
                                top = dpi(220)
                            }
                        })
                    end
                }, function ()
                    s.screenshot_selecter.hide()
                    awful.spawn('bash ' .. gfs.get_configuration_dir() .. 'scripts/screensht full')
                end),
                genbutton({
                    markup = '',
                    font = beautiful.nerd_font .. ' 30',
                    align = 'center',
                    valign = 'center',
                    widget = wibox.widget.textbox,
                }, {
                    txt = 'Area Screenshot',
                    placement = function (d)
                        return awful.placement.bottom_right(d, {
                            margins = {
                                bottom = (beautiful.bar_height + beautiful.useless_gap * 2) + dpi(80) + (beautiful.useless_gap * 2),
                                right = dpi(100) + (dpi(100) / 2.75),
                                top = dpi(220)
                            }
                        })
                    end
                }, function ()
                    s.screenshot_selecter.hide()
                    awful.spawn('bash ' .. gfs.get_configuration_dir() .. 'scripts/screensht select')
                end),
                spacing = dpi(12),
                layout = wibox.layout.flex.horizontal,
            },
            margins = dpi(7),
            widget = wibox.container.margin,
        },
        bg = beautiful.bg_normal,
        shape = helpers.mkroundedrect(),
        widget = wibox.container.background,
    }

    s.screenshot_selecter.popup = awful.popup {
        ontop = true,
        placement = function (d)
            return awful.placement.bottom_right(d, {
                margins = {
                    right = dpi(100),
                    bottom = beautiful.bar_height + beautiful.useless_gap * 2,
                }
            })
        end,
        bg = beautiful.bg_normal .. '00',
        fg = beautiful.fg_normal,
        shape = helpers.mkroundedrect(),
        visible = false,
        screen = s,
        minimum_width = dpi(200),
        minimum_height = dpi(80),
        widget = s.screenshot_selecter.widget,
    }

    function s.screenshot_selecter.toggle ()
        if s.screenshot_selecter.popup.visible then
            s.screenshot_selecter.hide()
        else
            s.screenshot_selecter.show()
        end
    end

    function s.screenshot_selecter.hide ()
        s.screenshot_selecter.popup.visible = false
    end

    function s.screenshot_selecter.show ()
        s.screenshot_selecter.popup.visible = true
    end
end)
