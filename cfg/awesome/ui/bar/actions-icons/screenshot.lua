local wibox = require 'wibox'
local beautiful = require 'beautiful'
local awful = require 'awful'
local helpers = require 'helpers'

require 'ui.screenshot-select'

local function get_icon (s)
    local CAMERA_ICON = ''

    local icon = wibox.widget {
        id = 'screenshot_action_icon',
        markup = CAMERA_ICON,
        align = 'center',
        font = beautiful.nerd_font .. ' 14',
        widget = wibox.widget.textbox,
    }

    local tooltip = helpers.make_popup_tooltip('Press to take a screenshot', function (d)
        return awful.placement.bottom_right(d, {
            margins = {
                bottom = beautiful.bar_height + beautiful.useless_gap * 2,
                right = beautiful.useless_gap * 2 + 85,
            }
        })
    end)

    tooltip.attach_to_object(icon)

    icon:add_button(awful.button({}, 1, function ()
        s.screenshot_selecter.toggle()
        tooltip.toggle()

        if s.screenshot_selecter.popup.visible then
            icon:set_markup_silently(helpers.get_colorized_markup(CAMERA_ICON, beautiful.blue))
        else
            icon:set_markup_silently(CAMERA_ICON)
        end
    end))

    return icon
end

return get_icon
