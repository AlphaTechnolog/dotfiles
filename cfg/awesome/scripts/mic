#!/usr/bin/env bash

# @requires: pactl

SINK=$(pactl list short sinks | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,' | head -n 1)

status () {
  status=$(pactl get-source-mute $SINK | awk '{print $2}')
  if [[ $status == 'yes' ]]; then
    echo no
  else
    echo yes
  fi
}

set_volume () {
  local max_db=65536
  local percent=$1

  # getting the $percent% of $max_db
  local value=$(jq -n ${percent}/100*${max_db} | sed 's/\./ /g' | awk '{print $1}')

  # set volume
  pacmd set-source-volume $SINK $value
}

get () {
  local enabled=$(status)
  if [[ $enabled == 'no' ]]; then
    echo '0'
  else
    pacmd list short sinks | grep volume:\ front | tail -n 1 | awk '{print $5}' | sed 's/%//g'
  fi
}

percentage () {
  local val=$(get)
  echo "${val}%"
}

_ () {
  ${@}
  exit 0
}

if [[ $1 == "status" ]]; then
  _ status
fi

if [[ $1 == "toggle" ]]; then
  _ pactl set-source-mute $SINK toggle
fi

if [[ $1 == "set" ]]; then
  _ set_volume ${2}
fi

if [[ $1 == "get" ]]; then
  _ get
fi

if [[ $1 == "percent" ]]; then
  _ percentage
fi
