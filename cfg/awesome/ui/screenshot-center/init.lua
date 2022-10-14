local awful = require 'awful'
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local rubato = require 'modules.rubato'

local dimensions = require 'ui.screenshot-center.dimensions'

require 'ui.screenshot-center.listener'

awful.screen.connect_for_each_screen(function (s)
    s.screenshot_center = {}

    s.screenshot_center.popup = wibox {
        width = dimensions.width,
        height = 1,
        ontop = true,
        bg = beautiful.bg_normal .. '00',
        fg = beautiful.fg_normal,
        visible = false,
        screen = s,
    }

    -- initial center-state
    awful.placement.centered(s.screenshot_center.popup)

    -- main-content of the widget
    local content_template = require 'ui.screenshot-center.content'

    -- widget that don't render something to hide the content when closing the popup
    local null_widget = {
        {
            markup = '',
            valign = 'center',
            align = 'center',
            widget = wibox.widget.textbox,
        },
        bg = beautiful.bg_normal,
        fg = beautiful.fg_normal,
        widget = wibox.container.background
    }

    -- don't render something in initial-load
    s.screenshot_center.popup:setup(null_widget)

    local self = s.screenshot_center.popup

    -- NOTE: Here is just an animation for height, which looks pretty cool but
    -- maybe could look pretty cool an animation for the width as well.
    self.animate = rubato.timed {
        duration = 0.15,
        override_dt = true,
        rate = 60,
    }

    self.status = 'undefined'

    -- 0 isn't a valid number to wibox ig
    self.animate:subscribe(function (h)
        -- animation is closing + it's finished
        if h < 1 and self.status == 'closing' then
            self.visible = false
            self.status = 'undefined'
            return -- done
        end

        -- removing the content when closing and re-starting it when opening
        if self.status == 'closing' then
            self:setup(null_widget)
        elseif self.status == 'opening' and h > dimensions.height - 10 then
            self:setup(content_template)
        end

        -- set height to the popup
        if h > 0 then
            self.height = h
            awful.placement.centered(self) -- re-center the popup on height update
        end
    end)

    function s.screenshot_center.show ()
        self.visible = true
        self.status = 'opening'
        self.animate.target = dimensions.height

        -- telling others module that the popup is in an opening-state.
        ---@diagnostic disable-next-line: undefined-global
        awesome.emit_signal('screenshot-center::popup::opening')
    end

    function s.screenshot_center.hide ()
        self.status = 'closing'
        self.animate.target = 0

        -- telling others module that the popup is in a closing-state.
        ---@diagnostic disable-next-line: undefined-global
        awesome.emit_signal('screenshot-center::popup::closing')
    end

    function s.screenshot_center.toggle ()
        if self.visible then
            s.screenshot_center.hide()
        else
            s.screenshot_center.show()
        end
    end
end)
