#!/usr/bin/env bash
name=$(iwgetid -r)
if [[ "$name" == "" ]]; then
  nmcli con up ifname "$(/usr/bin/ls /sys/class/ieee80211/*/device/net/)"
else
  wifiname=$(nmcli d | grep wifi | sed 's/^.*wifi.*connected//g' | xargs)
  nmcli con down id "${wifiname}"
fi