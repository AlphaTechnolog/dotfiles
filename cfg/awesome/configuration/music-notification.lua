local bling = require 'modules.bling'
local naughty = require 'naughty'
local playerctl = bling.signal.playerctl.lib()

local previous = naughty.action { name = 'Previous' }
local next = naughty.action { name = 'Next' }

previous:connect_signal('invoked', function ()
    playerctl:previous()
end)

next:connect_signal('invoked', function ()
    playerctl:next()
end)

local actions = {
    previous,
    next
}

playerctl:connect_signal('metadata', function (_, title, artist, album_path, _, new)
    if new then
        naughty.notify {
            title = title,
            text = artist,
            image = album_path,
            app_name = 'Music',
            app_icon = album_path,
            actions = actions,
        }
    end
end)
