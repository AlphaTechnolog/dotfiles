#!/bin/bash

# This is a script to autostart some applications like picom
# or merge some Xresources or change the wallpaper, or in This
# case is necesary to start sxhkd

#  NOTE: This is an example file, you can change it with your stuff

xsetroot -cursor_name left_ptr
picom -b
xrdb -merge $HOME/.Xresources

# notification manager
dunst &

# Wallpaper
feh --bg-scale $HOME/.config/bspwm/wallpapers/wallpaper.jpg

# don't remove this please
pkill bspc
pkill eww

launch_sxhkd () {
  sxhkd &
}

pkill sxhkd ; launch_sxhkd
