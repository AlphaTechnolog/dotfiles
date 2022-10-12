local awful = require 'awful'
local beautiful = require 'beautiful'
local wibox = require 'wibox'
local rubato = require 'modules.rubato'

-- call opening listeners
require 'ui.dashboard.listener'

awful.screen.connect_for_each_screen(function (s)
    s.dashboard = {}

    local width = 530
    local stop_offset = width - 5

    s.dashboard.popup = wibox {
        screen = s,
        ontop = true,
        visible = false,
        bg = beautiful.bg_normal .. '00',
        fg = beautiful.fg_normal,
        width = 1,
        height = s.geometry.height - beautiful.useless_gap * 4,
        x = s.geometry.x + beautiful.useless_gap * 4 + beautiful.bar_width,
        y = s.geometry.y + beautiful.useless_gap * 2,
    }

    local null_widget = {
        {
            markup = '',
            widget = wibox.widget.textbox,
        },
        bg = beautiful.bg_normal,
        widget = wibox.container.background,
    }

    local content = require 'ui.dashboard.content'

    s.dashboard.popup:setup(content)

    local self = s.dashboard.popup

    self.status = 'undefined'

    self.animate = rubato.timed {
        duration = 0.25,
        rate = 60,
        override_dt = true
    }

    local function update_struts(factor)
        if beautiful.dashboard_update_struts then
            self:struts {
                left = beautiful.bar_width + beautiful.useless_gap * 2 + (factor or 0)
            }
        end
    end

    self.animate:subscribe(function (animfactor)
        local function do_anim()
            self.width = animfactor
            update_struts(animfactor + beautiful.useless_gap * 2)
            if animfactor <= stop_offset then
                self:setup(null_widget)
            else
                self:setup(content)
            end
        end

        local function hide()
            update_struts(0)
            self.visible = false
            self.status = 'undefined'
        end

        if self.status ~= 'undefined' then
            if animfactor > 0 then do_anim() end
            if self.status == 'closing' and animfactor < 1 then hide()
            elseif self.status == 'closing' and not self.animate.running then hide () end
        end
    end)

    function s.dashboard.open()
        self.status = 'opening'
        self.visible = true
        self.animate.target = width
    end

    function s.dashboard.hide()
        self.status = 'closing'
        self.animate.target = 0
    end

    function s.dashboard.toggle()
        if self.visible then
            s.dashboard.hide()
        else
            s.dashboard.open()
        end
    end
end)
