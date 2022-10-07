---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local awful = require 'awful'
local helpers = require 'helpers'
local beautiful = require 'beautiful'

local function get_layoutbox(s)
    local layoutbox = awful.widget.layoutbox {
        screen = s,
        forced_height = 16,
        forced_width = 16,
    }

    layoutbox._layoutbox_tooltip:remove_from_object(layoutbox)

    local function get_layoutname()
        return 'Layout ' .. helpers.capitalize(awful.layout.get(s).name)
    end

    local layoutbox_tooltip = helpers.make_popup_tooltip(get_layoutname(), function (d)
        return awful.placement.bottom_left(d, {
            margins = {
                left = beautiful.useless_gap * 4 + beautiful.bar_width,
                bottom = beautiful.useless_gap * 9
            }
        })
    end)

    layoutbox_tooltip.attach_to_object(layoutbox)

    local function update_content()
        layoutbox_tooltip.widget.text = get_layoutname()
    end

    tag.connect_signal('property::layout', update_content)
    tag.connect_signal('property::selected', update_content)

    helpers.add_buttons(layoutbox, {
        awful.button({}, 1, function () awful.layout.inc(1) end),
        awful.button({}, 3, function () awful.layout.inc(-1) end),
        awful.button({}, 4, function () awful.layout.inc(-1) end),
        awful.button({}, 5, function () awful.layout.inc(1) end),
    })

    return wibox.widget {
        {
            layoutbox,
            halign = 'center',
            layout = wibox.container.place,
        },
        bottom = 5,
        top = 8,
        left = 2,
        widget = wibox.container.margin,
    }
end

return get_layoutbox
