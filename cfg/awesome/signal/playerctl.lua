local bling = require 'bling'

local instance = nil

local function new ()
    return bling.signal.playerctl.lib {
        update_on_activity = true,
        player = { "spotify", "mpd", "%any" },
        debounce_delay = 1,
    }
end

if not instance then
    instance = new()
end

return instance
