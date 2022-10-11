---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local awful = require 'awful'
local beautiful = require 'beautiful'
local naughty = require 'naughty'

local launchers = {}

local function make_launcher(opts)
    local launcher = wibox.widget {
        markup = opts.markup,
        align = 'center',
        font = opts.font and opts.font or beautiful.nerd_font .. ' 17',
        widget = wibox.widget.textbox,
    }

    launcher:add_button(awful.button({}, 1, function ()
        if opts.onclick then
            opts.onclick()
        end
    end))

    return launcher
end

local function donotif(prog)
    naughty.notify {
        app_name = 'Launchers',
        title = 'Launching!',
        text = "Launching " .. prog .. ", please wait..."
    }
end

local rofi = make_launcher {
    markup = '異',
    onclick = function ()
        awful.spawn('rofi -show drun')
    end
}

local screenshot = make_launcher {
    markup = '',
    onclick = function ()
        awesome.emit_signal('screenshot-center::toggle')
    end
}

local firefox = make_launcher {
    markup = '',
    onclick = function ()
        donotif('browser')
        awful.spawn(browser) -- comes from `user_likes.lua`
    end
}

local terminal = make_launcher {
    markup = '',
    onclick = function ()
        donotif('terminal')
        awful.spawn(terminal) -- comes from `user_likes.lua`
    end
}

local explorer = make_launcher {
    markup = '',
    onclick = function ()
        donotif('explorer')
        awful.spawn(explorer) -- comes from `user_likes.lua`'
    end
}

-- add here the list of all the wanted launchers.
launchers.dict = {
    rofi,
    screenshot,
    firefox,
    terminal,
    explorer
}

launchers.get_launchers_widget = function ()
    local widget_template = {
        layout = wibox.layout.fixed.vertical,
        spacing = 5,
    }

    for _, launcher in ipairs(launchers.dict) do
        table.insert(widget_template, launcher)
    end

    return wibox.widget(widget_template)
end

return launchers
