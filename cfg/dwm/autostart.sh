#!/usr/bin/env bash

pkill picom
pkill eww
ps -aux | grep bar | grep -v grep | grep dwm | awk '{print $2}' | while read -r line; do kill -9 $line; done

xrdb merge $HOME/.Xresources
picom --config=./picom.conf -b
feh --bg-scale $HOME/.config/dwm/wallpaper.jpg
$HOME/.config/dwm/scripts/bar.sh
eww -c $HOME/.config/dwm/eww daemon
