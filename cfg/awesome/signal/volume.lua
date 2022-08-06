local gears = require 'gears'
local awful = require 'awful'
local gfs = require 'gears.filesystem'

local script = "SINK=$(pactl list short sinks | sed -e 's,^\\([0-9][0-9]*\\)[^0-9].*,\\1,' | head -n 1); pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \\([0-9][0-9]*\\)%.*,\\1,'"

local timer = gears.timer {
    timeout = 1,
    call_now = true,
    autostart = true,
}

timer:connect_signal('timeout', function ()
    awful.spawn.easy_async_with_shell(script, function (out)
        awesome.emit_signal('volume::value', tonumber(out))
    end)
end)

local function set(vol)
    awful.spawn(gfs.get_configuration_dir () .. 'scripts/set-volume.sh ' .. tonumber(vol))
end

return {
    set = set,
}
