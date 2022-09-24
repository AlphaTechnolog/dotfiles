---@diagnostic disable: undefined-global
local awful = require 'awful'
local helpers = require 'helpers'
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local gears = require 'gears'

local function enable_tag_preview(self, c3)
    self:connect_signal('mouse::enter', function ()
        if #c3:clients() > 0 then
            awesome.emit_signal('bling::tag_preview::update', c3)
            awesome.emit_signal('bling::tag_preview::visibility', s, true)
        end
    end)
    self:connect_signal('mouse::leave', function ()
        awesome.emit_signal('bling::tag_preview::visibility', s, false)
    end)
end

local function update_tags(self, index, s)
    local markup_role = self:get_children_by_id('markup_role')[1]

    if s.selected_tag.index == index then
        markup_role:set_markup_silently(
            helpers.get_colorized_markup(
                beautiful.selected_tag_format,
                beautiful.taglist_fg_focus
            )
        )
    else
        markup_role:set_markup_silently(
            helpers.get_colorized_markup(
                beautiful.normal_tag_format,
                beautiful.taglist_fg
            )
        )
        for _, c in ipairs(client.get(s)) do
            for _, t in ipairs(c:tags()) do
                if t.index == index then
                    markup_role:set_markup_silently(
                        helpers.get_colorized_markup(
                            beautiful.occupied_tag_format,
                            beautiful.taglist_fg_occupied
                        )
                    )
                end
            end
        end
    end
end

local function get_taglist(s)
    return awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        layout = {
            layout = wibox.layout.fixed.horizontal,
            spacing = 13,
        },
        style = {
            shape = gears.shape.circle,
        },
        buttons = {
            awful.button({}, 1, function (t)
                t:view_only()
            end),
            awful.button({}, 4, function (t)
                awful.tag.viewprev(t.screen)
            end),
            awful.button({}, 5, function (t)
                awful.tag.viewnext(t.screen)
            end)
        },
        widget_template = {
            {
                id = 'markup_role',
                markup = '',
                align = 'center',
                valign = 'center',
                font = beautiful.taglist_font,
                widget = wibox.widget.textbox,
            },
            id = 'background_role',
            widget = wibox.container.background,
            shape = gears.shape.circle,
            update_callback = function (self, _, index)
                update_tags(self, index, s)
            end,
            create_callback = function (self, c3, index)
                enable_tag_preview(self, c3)
                update_tags(self, index, s)
            end,
        },
    }
end

return get_taglist
