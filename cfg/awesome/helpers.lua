---@diagnostic disable:undefined-global

local gears = require 'gears'
local wibox = require 'wibox'
local awful = require 'awful'
local beautiful = require 'beautiful'
local dpi = beautiful.xresources.apply_dpi

local helpers = {}

-- colorize a text using pango markup
function helpers.get_colorized_markup(content, fg)
    fg = fg or beautiful.blue
    content = content or ''

    return '<span foreground="' .. fg .. '">' .. content .. '</span>'
end

-- add hover support to wibox.container.background-based elements
function helpers.add_hover(element, bg, hbg)
    element:connect_signal('mouse::enter', function (self)
        self.bg = hbg
    end)
    element:connect_signal('mouse::leave', function (self)
        self.bg = bg
    end)
end

-- create a rounded rect using a custom radius
function helpers.mkroundedrect(radius)
    radius = radius or dpi(7)
    return function (cr, w, h)
        return gears.shape.rounded_rect(cr, w, h, radius)
    end
end

-- create a simple rounded-like button with hover support
function helpers.mkbtn(template, bg, hbg, radius)
    local button = wibox.widget {
        {
            template,
            margins = dpi(7),
            widget = wibox.container.margin,
        },
        bg = bg,
        widget = wibox.container.background,
        shape = helpers.mkroundedrect(radius),
    }

    if bg and hbg then
        helpers.add_hover(button, bg, hbg)
    end

    return button
end

-- add a list of buttons using :add_button to `widget`.
function helpers.add_buttons(widget, buttons)
    for _, button in ipairs(buttons) do
        widget:add_button(button)
    end
end

-- trim strings
function helpers.trim(input)
    local result = input:gsub("%s+", "")
    return string.gsub(result, "%s+", "")
end

-- make a rounded container for make work the antialiasing.
function helpers.mkroundedcontainer(template, bg)
    return wibox.widget {
        template,
        shape = helpers.mkroundedrect(),
        bg = bg,
        widget = wibox.container.background,
    }
end

-- make an awful.popup that's used to replace the native AwesomeWM tooltip component
function helpers.make_popup_tooltip(text, placement)
    local ret = {}

    ret.widget = wibox.widget {
        {
            {
                id = 'image',
                image = beautiful.hints_icon,
                forced_height = dpi(12),
                forced_width = dpi(12),
                halign = 'center',
                valign = 'center',
                widget = wibox.widget.imagebox,
            },
            {
                id = 'text',
                markup = text or '',
                align = 'center',
                widget = wibox.widget.textbox,
            },
            spacing = dpi(7),
            layout = wibox.layout.fixed.horizontal,
        },
        margins = dpi(12),
        widget = wibox.container.margin,
        set_text = function (self, t)
            self:get_children_by_id('text')[1].markup = t
        end,
        set_image = function (self, i)
            self:get_children_by_id('image')[1].image = i
        end
    }

    ret.popup = awful.popup {
        visible = false,
        shape = helpers.mkroundedrect(),
        bg = beautiful.bg_normal .. '00',
        fg = beautiful.fg_normal,
        ontop = true,
        placement = placement or awful.placement.centered,
        screen = awful.screen.focused(),
        widget = helpers.mkroundedcontainer(ret.widget, beautiful.bg_normal),
    }

    local self = ret.popup

    function ret.show()
        self.screen = awful.screen.focused()
        self.visible = true
    end

    function ret.hide()
        self.visible = false
    end

    function ret.toggle()
        if not self.visible and self.screen ~= awful.screen.focused() then
            self.screen = awful.screen.focused()
        end
        self.visible = not self.visible
    end

    function ret.attach_to_object(object)
        object:connect_signal('mouse::enter', ret.show)
        object:connect_signal('mouse::leave', ret.hide)
    end

    return ret
end

-- capitalize a string
function helpers.capitalize (txt)
    return string.upper(string.sub(txt, 1, 1))
        .. string.sub(txt, 2, #txt)
end

-- a fully capitalizing helper.
function helpers.complex_capitalizing (s)
    local r, i = '', 0
    for w in s:gsub('-', ' '):gmatch('%S+') do
        local cs = helpers.capitalize(w)
        if i == 0 then
            r = cs
        else
            r = r .. ' ' .. cs
        end
        i = i + 1
    end

    return r
end

-- limit a string by a length and put ... at the final if the
-- `max_length` is exceded `str`
function helpers.limit_by_length (str, max_length, use_pango)
    local sufix = ''
    local toput = '...'

    if #str > max_length - #toput then
        str = string.sub(str, 1, max_length - 3)
        sufix = toput
    end

    if use_pango and sufix == toput then
        sufix = helpers.get_colorized_markup(sufix, beautiful.light_black)
    end

    return str .. sufix
end

-- apply a margin container to a given widget
function helpers.apply_margin(widget, margins, top, bottom, right, left)
    return wibox.widget {
        widget,
        margins = margins,
        left = left,
        right = right,
        top = top,
        bottom = bottom,
        widget = wibox.container.margin,
    }
end

return helpers
