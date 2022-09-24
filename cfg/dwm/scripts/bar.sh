#!/usr/bin/env bash

SINK=$(pactl list short sinks | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,' | head -n 1)
DWM=$HOME/.config/dwm
SCRIPTS=$DWM/scripts

import () {
  . $SCRIPTS/${@}.sh
}

import bar-colors

# reset statusbar
xsetroot -name ' '

updates () {
  local updates=$(xbps-install -un | wc -l) # void
  # local updates=$(checkupdates | wc -l) # arch, requires pacman-contrib
  # local updates=$(aptitude search '~U' | wc -l) # apt (ubuntu, debian and others that uses apt)

  if [ -z "$updates" ]; then
    updates="Fully updated"
  else
    updates="${updates} updates"
  fi

  printf "^b$bg^^c$green^ $updates^b$bg^ "
}

is_muted () {
  pacmd list-sinks | awk '/muted/ { print $2 }'
}

volume () {
  local muted=$(is_muted)
  if [[ $muted == 'yes' ]]; then
    local per="0"
    local icon="婢"
  else
    local icon=""
    local per=$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
  fi
  printf "^b$bg^^c$cyan^$icon $per%% "
}

ram () {
  local ram=$(free | grep Mem | awk '{print $3/$2 * 100.0}' | sed 's/\./ /g' | awk '{print $1}')
  printf "^b$yellow^^c$bg^  ^b$lighter^^c$fg^ $ram%% ^b$bg^ "
}

cpu () {
  local cpu=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}' | sed 's/\./ /g' | awk '{print $1}')
  printf "^b$magenta^^c$bg^  ^b$lighter^^c$fg^ $cpu%% ^b$bg^ "
}

network () {
  ssid=$(iwgetid -r)
  if [[ $ssid == "" ]]; then
    local icon="睊"
    local color=$red
    ssid="  Disconnected"
  else
    local icon=""
    local color=$blue
    ssid=$(echo "  $ssid")
  fi
  printf "^b$bg^^c$color^$icon$ssid "
}

clock () {
  printf "^b$green^^c$bg^  $(date '+%H:%M') "
}

do_render() {
  xsetroot -name " ^b$bg^$(updates) $(ram) $(cpu) $(volume) $(network) $(clock)^b$bg^   "
}

while true; do
  do_render
  sleep 1
done &
