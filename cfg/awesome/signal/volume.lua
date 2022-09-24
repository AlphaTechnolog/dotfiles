---@diagnostic disable: undefined-global

-- just works for pulseaudio

local gears = require 'gears'
local awful = require 'awful'
local gfs = require 'gears.filesystem'
local helpers = require 'helpers'

local volume = {}

local sink_part = "SINK=$(pactl list short sinks | sed -e 's,^\\([0-9][0-9]*\\)[^0-9].*,\\1,' | head -n 1 | awk '{print $1}');"
local script = sink_part .. "pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \\([0-9][0-9]*\\)%.*,\\1,'"
local how_to_know_if_muted = "pacmd list-sinks | awk '/muted/ { print $2 }'"

function volume.re_emit_volume_value_signal()
    awful.spawn.easy_async_with_shell(script, function(out)
        awesome.emit_signal('volume::value', tonumber(out))
    end)
end

function volume.re_emit_muted_signal ()
    awful.spawn.easy_async_with_shell(how_to_know_if_muted, function (out)
        awesome.emit_signal('volume::muted', helpers.trim(out) == 'yes')
    end)
end

function volume.set(vol, reemit)
    awful.spawn(gfs.get_configuration_dir () .. 'scripts/set-volume.sh ' .. tonumber(vol))
    if reemit then
        volume.re_emit_volume_value_signal()
    end
end

function volume.toggle_muted ()
    awful.spawn.with_shell(sink_part .. "pactl set-sink-mute $SINK toggle")
    volume.re_emit_muted_signal()
end

gears.timer {
    timeout = 3,
    call_now = true,
    autostart = true,
    callback = volume.re_emit_volume_value_signal
}

gears.timer {
    timeout = 3,
    call_now = true,
    autostart = true,
    callback = volume.re_emit_muted_signal,
}

return volume
