#!/usr/bin/env bash

status () {
  status=$(nmcli radio wifi)
  if [[ $status == "enabled" ]]; then
    echo "off"
  else
    echo "on"
  fi
}

if [[ $1 == "status" ]]; then
  status
fi

if [[ $1 == "toggle" ]]; then
  stat=$(status)
  if [[ $stat == "off" ]]; then
    nmcli radio wifi off
  else
    nmcli radio wifi on
  fi
fi
