---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local awful = require 'awful'

local toggler = wibox.widget {
    markup = '',
    align = 'center',
    font = beautiful.nerd_font .. ' 21',
    widget = wibox.widget.textbox,
}

toggler:add_button(awful.button({}, 1, function ()
    awesome.emit_signal('dashboard::toggle')
end))

return toggler
