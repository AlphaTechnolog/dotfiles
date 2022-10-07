local awful = require 'awful'
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local rubato = require 'modules.rubato'

-- call opening listeners
require 'ui.notifcenter.listener'

awful.screen.connect_for_each_screen(function (s)
    s.notifcenter = {}

    local width = 350

    s.notifcenter.popup = wibox {
        screen = s,
        ontop = true,
        visible = false,
        bg = beautiful.bg_normal,
        fg = beautiful.fg_normal,
        width = width,
        height = s.geometry.height - beautiful.useless_gap * 4,
        x = s.geometry.width + width + beautiful.useless_gap * 2,
        y = s.geometry.y + beautiful.useless_gap * 2,
    }

    local content = require 'ui.notifcenter.content'

    s.notifcenter.popup:setup(content)

    local self = s.notifcenter.popup

    self.animate = rubato.timed {
        duration = 0.35,
        rate = 60,
        override_dt = true,
    }

    self.status = 'undefined'

    self.animate:subscribe(function (pos)
        self.x = pos
        if self.x == s.geometry.width + width + beautiful.useless_gap * 2 and self.status == 'closing' then
            self.visible = false
        end
    end)

    self.animate.target = s.geometry.width + width + beautiful.useless_gap * 2

    function s.notifcenter.open ()
        self.status = 'opening'
        self.visible = true
        self.animate.target = s.geometry.width - width - beautiful.useless_gap * 2
    end

    function s.notifcenter.hide ()
        self.status = 'closing'
        self.animate.target = s.geometry.width + width + beautiful.useless_gap * 2
    end

    function s.notifcenter.toggle ()
        if self.visible then
            s.notifcenter.hide()
        else
            s.notifcenter.open()
        end
    end
end)
