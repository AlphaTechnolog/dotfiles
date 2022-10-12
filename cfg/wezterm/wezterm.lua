local wezterm = require 'wezterm'
local colors = require 'colors'

local function window_padding(margins)
    return {
        top = margins,
        bottom = margins,
        left = margins,
        right = margins
    }
end

return {
    font = wezterm.font 'CaskaydiaCove Nerd Font',
    font_size = 10,
    line_height = 1.3,
    enable_tab_bar = false,
    colors = colors,
    window_padding = window_padding(16)
}
