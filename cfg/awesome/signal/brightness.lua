local gears = require 'gears'
local awful = require 'awful'

local timer = gears.timer {
    timeout = 1,
    call_now = true,
    autostart = true,
}

timer:connect_signal('timeout', function ()
    awful.spawn.easy_async_with_shell('light -G | sed -s "s/\\./ /g" | awk "{print \\$1}"', function (out)
        awesome.emit_signal('brightness::value', tonumber(out))
    end)
end)

local function set(val)
    awful.spawn('light -S ' .. tonumber(val))
end

return { set = set }
