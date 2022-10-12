#!/usr/bin/env bash

SINK=$(pactl list short sinks | sed -e 's,^\\([0-9][0-9]*\\)[^0-9].*,\\1,' | head -n 1 | awk '{print $1}');

get () {
    pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | awk '{print $5}' | tr '%' ' ' | xargs
}

mute () {
    pactl set-sink-mute $SINK toggle
}

if [[ $1 == "get" ]]; then
    get
fi

if [[ $1 == "mute" ]]; then
    mute
fi
