#!/usr/bin/env bash
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

get_ram () {
  free -m | grep Mem | awk '{print ($3/$2)*100}' | tr '.' ' ' | awk '{print $1}'
}

get_percent () {
  echo $(get_ram)%
}

get_class () {
  local percent=$(get_percent)
  echo $(percentage "$percent" "yellow" "magenta" "purple" "red")
}

if [[ $1 == "ram" ]]; then
  get_ram
fi

if [[ $1 == "percent" ]]; then
  get_percent
fi

if [[ $1 == "class" ]]; then
  get_class
fi