#!/usr/bin/env bash
SINK=$(pactl list short sinks | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,' | head -n 1)
pactl set-sink-volume $SINK $1%
