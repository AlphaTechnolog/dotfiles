---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local awful = require 'awful'

local toggler = wibox.widget {
    markup = '',
    align = 'center',
    font = beautiful.nerd_font .. ' 8',
    widget = wibox.widget.textbox
}

local gtray = function ()
    return awful.screen.focused().systray
end

toggler:add_button(awful.button({}, 1, function ()
    awesome.emit_signal('systray::toggle')

    if gtray().popup.visible then
        toggler:set_markup_silently('')
    elseif gtray().popup.visible == false then
        toggler:set_markup_silently('')
    end
end))

return toggler
