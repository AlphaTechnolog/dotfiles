#!/bin/bash

# @requires: brightnessctl

percentage () {
  local val=$(echo $1 | tr '%' ' ' | awk '{print $1}')
  local icon1=$2
  local icon2=$3
  local icon3=$4
  local icon4=$5
  if [ "$val" -le 15 ]; then
    echo $icon1
  elif [ "$val" -le 30 ]; then
    echo $icon2
  elif [ "$val" -le 60 ]; then
    echo $icon3
  else
    echo $icon4
  fi
}

get_brightness () {
  (( br = $(brightnessctl get) * 100 / $(brightnessctl max) ))
  echo $br
}

get_percent () {
  echo $(get_brightness)%
}

get_icon () {
  local br=$(get_percent)
  echo $(percentage "$br" "" "" "" "")
}

if [[ $1 == "br" ]]; then
  get_brightness
fi

if [[ $1 == "percent" ]]; then
  get_percent
fi

if [[ $1 == "icon" ]]; then
  get_icon
fi