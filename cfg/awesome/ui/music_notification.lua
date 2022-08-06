local playerctl = require 'signal.playerctl'
local naughty = require 'naughty'

playerctl:connect_signal('metadata', function (_, title, artist, album_path, album, new, player_name)
    if new == true then
        naughty.notify {
            app_name = 'Music',
            title = title,
            text = artist,
            image = album_path
        }
    end
end)
