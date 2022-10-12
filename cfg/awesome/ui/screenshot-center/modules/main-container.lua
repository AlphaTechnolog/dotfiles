-- AwesomeWM Libraries
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local helpers = require 'helpers'
local awful = require 'awful'
local naughty = require 'naughty'

-- modules
local screenshot = require 'modules.screenshot'

-- meta info
local popup_dimensions = require 'ui.screenshot-center.dimensions'

-- returns the base of a block-button.
local function base_button(icon, onclick)
    local button = wibox.widget {
        {
            id = 'background_role',
            forced_height = 78,
            forced_width = 90,
            shape = helpers.mkroundedrect(),
            bg = beautiful.bg_lighter,
            widget = wibox.container.background,
        },
        {
            id = 'icon_role',
            markup = helpers.get_colorized_markup(icon, beautiful.fg_normal),
            font = beautiful.nerd_font .. ' 32',
            align = 'center',
            valign = 'center',
            widget = wibox.widget.textbox,
        },
        layout = wibox.layout.stack,
        set_bg = function (self, bg)
            self:get_children_by_id('background_role')[1].bg = bg
        end,
        get_active = function (self)
            return self:get_children_by_id('background_role')[1].bg == beautiful.blue
        end,
        set_active = function (self, active)
            local background = self:get_children_by_id('background_role')[1]
            local icon_element = self:get_children_by_id('icon_role')[1]

            local transition = helpers.apply_transition {
                bg = beautiful.bg_lighter,
                hbg = beautiful.blue,
                element = background,
                prop = 'bg',
            }

            if active then
                transition.on()
                icon_element:set_markup_silently(helpers.get_colorized_markup(icon, beautiful.bg_normal))
            else
                transition.off()
                icon_element:set_markup_silently(helpers.get_colorized_markup(icon, beautiful.fg_normal))
            end
        end
    }

    button:add_button(awful.button({}, 1, function ()
        if onclick then
            onclick(button)
        end
    end))

    return button
end

-- defines the index of the selected button.
local selected_index = 1

-- buttons defining.
local full_screenshot = base_button('', function (_)
    selected_index = 1
    ---@diagnostic disable-next-line: undefined-global
    awesome.emit_signal('screenshot-center::area-selector::buttons::update-state')
end)

-- tooltip for the `full-screenshot` button.
local full_screenshot_tooltip = helpers.make_popup_tooltip('Full Screenshot', function (d)
    return awful.placement.centered(d, {
        margins = {
            top = popup_dimensions.height + beautiful.useless_gap * 12,
        }
    })
end)

full_screenshot_tooltip.attach_to_object(full_screenshot)

-- closing tooltip when popup is in a closing-state
---@diagnostic disable-next-line: undefined-global
awesome.connect_signal('screenshot-center::popup::closing', function ()
    full_screenshot_tooltip.hide()
end)

-- area-screenshot button.
local area_screenshot = base_button('', function (_)
    selected_index = 2
    ---@diagnostic disable-next-line: undefined-global
    awesome.emit_signal('screenshot-center::area-selector::buttons::update-state')
end)

-- tooltip for the `area-screenshot` button.
local area_screenshot_tooltip = helpers.make_popup_tooltip('Area Screenshot', function (d)
    return awful.placement.centered(d, {
        margins = {
            top = popup_dimensions.height + beautiful.useless_gap * 12,
        }
    })
end)

area_screenshot_tooltip.attach_to_object(area_screenshot)

-- closing tooltip when popup is in a closing-state
---@diagnostic disable-next-line: undefined-global
awesome.connect_signal('screenshot-center::popup::closing', function ()
    area_screenshot_tooltip.hide()
end)

local function update_buttons()
    local buttons = {full_screenshot, area_screenshot}

    for i, btn in ipairs(buttons) do
        btn.active = i == selected_index
    end
end

-- the signal-name is pretty stupid ikr lol
-- it's made with signals to avoid the lua-scope-issues in the buttons `onclick`s.
---@diagnostic disable-next-line: undefined-global
awesome.connect_signal('screenshot-center::area-selector::buttons::update-state', function ()
    update_buttons()
end)

-- update active state by-default.
---@diagnostic disable-next-line: undefined-global
awesome.emit_signal('screenshot-center::area-selector::buttons::update-state')

-- delay input main widget
local delay_input = wibox.widget {
    {
        {
            id = 'textbox_role',
            markup = 'Delay In Seconds: 0',
            widget = wibox.widget.textbox,
        },
        top = 10,
        bottom = 10,
        left = 12,
        widget = wibox.container.margin,
    },
    forced_width = 115,
    bg = beautiful.bg_lighter,
    shape = helpers.mkroundedrect(),
    widget = wibox.container.background,
    get_textbox = function (self)
        return self:get_children_by_id('textbox_role')[1]
    end
}

-- meta variables for the delay input
local timeout = 0
local is_editing_delay = false

delay_input:add_button(awful.button({}, 1, function ()
    -- defines is the delay input is being edited.
    is_editing_delay = true

    ---@diagnostic disable-next-line: undefined-global
    awesome.emit_signal('screenshot-center::delay-input::editing', true)

    -- runs the prompt in `delay_input.textbox`
    awful.prompt.run {
        prompt = 'Delay In Seconds: ',
        text = tostring(timeout),
        bg_cursor = beautiful.blue,
        textbox = delay_input.textbox,
        hook = function (command)
            if command ~= tostring(tonumber(command)) then
                return command:sub(0, #command - 1)
            end
        end,
        done_callback = function ()
            delay_input.textbox.text = 'Delay In Seconds: ' .. tostring(timeout)
            is_editing_delay = false

            ---@diagnostic disable-next-line: undefined-global
            awesome.emit_signal('screenshot-center::delay-input::editing', false)
        end,
        exe_callback = function (input)
            if not input or #input == 0 then
                return
            end

            if input ~= tostring(tonumber(input)) then
                return naughty.notify {
                    app_name = 'Screenshot',
                    title = 'Error!',
                    text = 'Input is not a valid number!',
                }
            end

            ---@diagnostic disable-next-line: cast-local-type
            timeout = tonumber(input)
        end,
    }
end))

-- submit button
local submit_button = wibox.widget {
    {
        {
            {
                id = 'icon_role',
                markup = selected_index == 1 and '' or '',
                -- aument the font_size using `beautiful.font_size`
                font = beautiful.nerd_font .. ' ' .. tostring(tonumber(beautiful.font_size) + 4),
                widget = wibox.widget.textbox,
            },
            {
                markup = 'Go and Enjoy!',
                widget = wibox.widget.textbox,
            },
            spacing = 5,
            layout = wibox.layout.fixed.horizontal,
        },
        top = 5,
        bottom = 5,
        left = 12,
        right = 12,
        widget = wibox.container.margin,
    },
    bg = beautiful.green,
    fg = beautiful.bg_normal,
    shape = helpers.mkroundedrect(),
    widget = wibox.container.background,
    set_icon = function (self, icon)
        self:get_children_by_id('icon_role')[1].markup = icon
    end,
    set_disabled = function (self, val)
        self.bg = val and beautiful.bg_lighter or beautiful.green
        self.fg = val and beautiful.fg_normal or beautiful.bg_normal
    end
}

-- update the icon when the selected screenshot area is changed.
---@diagnostic disable-next-line: undefined-global
awesome.connect_signal('screenshot-center::area-selector::buttons::update-state', function ()
    submit_button.icon = selected_index == 1 and '' or ''
end)

-- disabling the submit button when the delay-input is in an edition process
---@diagnostic disable-next-line: undefined-global
awesome.connect_signal('screenshot-center::delay-input::editing', function (is_editing)
    submit_button.disabled = is_editing
end)

-- calls the screenshot module to make the screenshot
submit_button:add_button(awful.button({}, 1, function ()
    -- disables the button action when editing the delay input
    if not is_editing_delay then
        ---@diagnostic disable-next-line: undefined-global
        awesome.emit_signal('screenshot-center::visibility', false)

        -- do the screenshot using the options-api.
        screenshot.with_options {
            type = selected_index == 1 and 'full' or 'area',
            timeout = timeout,
            notify = true
        }
    end
end))

-- main widget
return {
    {
        {
            markup = '<b>Take a Screenshot!</b>',
            font = beautiful.font_name .. ' 18',
            align = 'center',
            valign = 'center',
            widget = wibox.widget.textbox,
        },
        {
            {
                {
                    full_screenshot,
                    area_screenshot,
                    spacing = beautiful.useless_gap * 4,
                    layout = wibox.layout.fixed.horizontal,
                },
                delay_input,
                spacing = beautiful.useless_gap * 4,
                layout = wibox.layout.fixed.vertical,
            },
            halign = 'center',
            layout = wibox.container.place,
        },
        {
            submit_button,
            halign = 'center',
            layout = wibox.container.place,
        },
        spacing = beautiful.useless_gap * 4,
        layout = wibox.layout.fixed.vertical,
    },
    halign = 'center',
    valign = 'center',
    layout = wibox.container.place,
}
