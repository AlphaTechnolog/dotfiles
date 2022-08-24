#!/usr/bin/env bash

# thanks to rxyhn

path () {
  local temp_path=null
  for i in /sys/class/hwmon/hwmon*/temp*_input;
  do
    temp_path="$(echo "$(<$(dirname $i)/name): $(cat ${i%_*}_label 2>/dev/null ||
      echo $(basename ${i%_*})) $(readlink -f $i)");"
    label="$(echo $temp_path | awk '{print $2}')"
    if [ "$label" = "Package" ];
    then
      echo ${temp_path} | awk '{print $5}' | tr -d ';\n'
      exit;
    fi
  done
}

get () {
  local path=$(path)
  if [[ $path == "" ]]; then
    path="/sys/class/thermal/thermal_zone0/temp"
  fi

  local max_temp=100
  local temp=$(cat $path)

  jq -n $(jq -n $temp/1000)/$max_temp*100
}

_ () {
  ${@}
  exit 0
}

if [[ $1 == "get" ]]; then
  _ get
fi