local xresources = require("beautiful.xresources")
local gears = require "gears"
local gfs = require("gears.filesystem")

local dpi = xresources.apply_dpi

-- paths
local themes_path = gfs.get_themes_dir()
local assets_path = gfs.get_configuration_dir() .. "assets/"

-- assets
local icons_path = assets_path .. "icons/"
local shapes_path = assets_path .. "shapes/"
local titlebar_assets_path = assets_path .. "titlebar/"
local actions_assets_path = assets_path .. "actions/"
local dock_assets = assets_path .. "dock-pinned/"

local theme = {}

-- fonts
theme.font_name = 'Product Sans'
theme.nerd_font = 'Iosevka Nerd Font'
theme.font_size = '10'
theme.font = theme.font_name .. ' ' .. theme.font_size

-- base colors
theme.black = '#1c1e27'
theme.light_black = '#262831'
theme.red = '#dd6777'
theme.yellow = '#ecd3a0'
theme.magenta = '#c296eb'
theme.green = '#90ceaa'
theme.blue = '#86aaec'
theme.cyan = '#93cee9'

-- backgrounds
theme.bg_normal     = "#0d0f18"
theme.bg_contrast   = "#0f111a"
theme.bg_lighter    = "#11131c"

-- elements bg
theme.bg_focus      = theme.bg_normal
theme.bg_urgent     = theme.red
theme.bg_minimize   = theme.bg_normal
theme.bg_systray    = theme.bg_lighter

-- foregrounds
theme.fg_normal     = "#a5b6cf"
theme.fg_focus      = theme.fg_nromal
theme.fg_urgent     = theme.fg_normal
theme.fg_minimize   = theme.fg_normal

-- some actions bg colors
theme.actions = {
    bg = theme.bg_normal,
    contrast = theme.bg_contrast,
    lighter = theme.bg_lighter,
    fg = theme.fg_normal,
}

-- bar
theme.bar_width = dpi(45)
theme.bar_height = dpi(40)

-- gaps and borders
theme.useless_gap         = dpi(6)
theme.border_width        = dpi(0)
theme.border_color_normal = theme.bg_normal
theme.border_color_active = theme.bg_normal
theme.border_color_marked = theme.bg_normal
theme.border_radius = dpi(10)

-- tasklist
theme.tasklist_plain_task_name = true
theme.tasklist_bg = theme.black
theme.tasklist_bg_focus = theme.blue

-- taglist
theme.taglist_bg = theme.bg_lighter
theme.taglist_bg_focus = theme.blue
theme.taglist_bg_occupied = theme.cyan
theme.taglist_bg_empty = theme.black

-- systray
theme.systray_icon_spacing = dpi(3)

-- menu
theme.menu_font = theme.font
theme.menu_submenu_icon = gears.color.recolor_image(shapes_path .. "triangle.png", theme.fg_normal)
theme.menu_height = dpi(35)
theme.menu_width  = dpi(180)
theme.menu_bg_focus = theme.bg_lighter

-- titlebar
theme.titlebar_bg = theme.bg_contrast
theme.titlebar_bg_focus = theme.bg_normal
theme.titlebar_fg = theme.fg_normal

theme.titlebar_close_button_normal = gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.red)
theme.titlebar_close_button_focus = gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.red)

theme.titlebar_maximized_button_normal_inactive = gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.yellow)
theme.titlebar_maximized_button_focus_inactive = gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.yellow)
theme.titlebar_maximized_button_normal_active = gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.yellow)
theme.titlebar_maximized_button_focus_active = gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.yellow)

theme.titlebar_minimize_button_normal = gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.green)
theme.titlebar_minimize_button_focus = gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.green)

theme.titlebar_floating_button_normal_inactive = gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.cyan)
theme.titlebar_floating_button_focus_inactive = gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.cyan)
theme.titlebar_floating_button_normal_active = gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.cyan)
theme.titlebar_floating_button_focus_active = gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.cyan)

-- wallpaper
theme.wallpaper = assets_path .. "wallpaper.png"

-- layouts
theme.layout_fairh = gears.color.recolor_image(themes_path.."default/layouts/fairhw.png", theme.fg_normal)
theme.layout_fairv = gears.color.recolor_image(themes_path.."default/layouts/fairvw.png", theme.fg_normal)
theme.layout_floating  = gears.color.recolor_image(themes_path.."default/layouts/floatingw.png", theme.fg_normal)
theme.layout_magnifier = gears.color.recolor_image(themes_path.."default/layouts/magnifierw.png", theme.fg_normal)
theme.layout_max = gears.color.recolor_image(themes_path.."default/layouts/maxw.png", theme.fg_normal)
theme.layout_fullscreen = gears.color.recolor_image(themes_path.."default/layouts/fullscreenw.png", theme.fg_normal)
theme.layout_tilebottom = gears.color.recolor_image(themes_path.."default/layouts/tilebottomw.png", theme.fg_normal)
theme.layout_tileleft   = gears.color.recolor_image(themes_path.."default/layouts/tileleftw.png", theme.fg_normal)
theme.layout_tile = gears.color.recolor_image(themes_path.."default/layouts/tilew.png", theme.fg_normal)
theme.layout_tiletop = gears.color.recolor_image(themes_path.."default/layouts/tiletopw.png", theme.fg_normal)
theme.layout_spiral  = gears.color.recolor_image(themes_path.."default/layouts/spiralw.png", theme.fg_normal)
theme.layout_dwindle = gears.color.recolor_image(themes_path.."default/layouts/dwindlew.png", theme.fg_normal)
theme.layout_cornernw = gears.color.recolor_image(themes_path.."default/layouts/cornernww.png", theme.fg_normal)
theme.layout_cornerne = gears.color.recolor_image(themes_path.."default/layouts/cornernew.png", theme.fg_normal)
theme.layout_cornersw = gears.color.recolor_image(themes_path.."default/layouts/cornersww.png", theme.fg_normal)
theme.layout_cornerse = gears.color.recolor_image(themes_path.."default/layouts/cornersew.png", theme.fg_normal)

-- icons
theme.rofi_spawner_icon = gears.color.recolor_image(icons_path .. "rocket.svg", theme.fg_normal)
theme.settings_icon = gears.color.recolor_image(icons_path .. "gear-solid.svg", theme.fg_normal)

-- actions icons
theme.fallback_music_image = actions_assets_path .. "music/fallback.png"
theme.previous_music = gears.color.recolor_image(actions_assets_path .. "music/previous.svg", theme.fg_normal)
theme.pause_music = gears.color.recolor_image(actions_assets_path .. "music/pause.svg", theme.fg_normal)
theme.play_music = gears.color.recolor_image(actions_assets_path .. "music/play.svg", theme.fg_normal)
theme.next_music = gears.color.recolor_image(actions_assets_path .. "music/next.svg", theme.fg_normal)
theme.shutdown = gears.color.recolor_image(actions_assets_path .. "powerbuttons/shutdown.svg", theme.red)
theme.reboot = gears.color.recolor_image(actions_assets_path .. "powerbuttons/reboot.svg", theme.yellow)
theme.pfp = actions_assets_path .. "user/pfp.png"

-- disable icon theme
theme.icon_theme = nil

-- task preview
theme.task_preview_widget_border_radius = dpi(7)
theme.task_preview_widget_bg = theme.bg_normal
theme.task_preview_widget_border_color = theme.bg_normal
theme.task_preview_widget_border_width = 0
theme.task_preview_widget_margin = dpi(10)

-- tag preview
theme.tag_preview_widget_border_radius = dpi(7)
theme.tag_preview_client_border_radius = dpi(7)
theme.tag_preview_client_opacity = 0.5
theme.tag_preview_client_bg = theme.bg_lighter
theme.tag_preview_client_border_color = theme.blue
theme.tag_preview_client_border_width = 1
theme.tag_preview_widget_bg = theme.bg_normal
theme.tag_preview_widget_border_color = theme.bg_normal
theme.tag_preview_widget_border_width = 0
theme.tag_preview_widget_margin = dpi(7)

-- taskbar pinneds
theme.thunar = dock_assets .. "thunar.svg"
theme.firefox = dock_assets .. "firefox.svg"
theme.kitty = dock_assets .. 'kitty.svg'
theme.vscode = dock_assets .. 'code.svg'

return theme
