#!/bin/bash

# plank support
bspc rule -a Plank layer=above manage=on border=off

# make applications floating
bspc rule --add network state=floating # nmtui spawned by eww bar
bspc rule --add Pavucontrol state=floating
bspc rule --add Gnome-screenshot state=floating
