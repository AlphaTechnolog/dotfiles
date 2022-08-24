#!/usr/bin/env bash

declare -a profiles_photos=("$HOME/.face.jpg" "$HOME/.face.png")

for pfp in ${profiles_photos[@]}; do
  if test -f $pfp; then
    echo $pfp
    exit 0
  fi
done

echo $HOME/.config/dk/eww/assets/default-pfp.png
