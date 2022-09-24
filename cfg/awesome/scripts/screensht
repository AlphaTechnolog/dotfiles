#!/usr/bin/env bash

if [[ "$1" == "" ]]; then
    exit 1
fi

TMP_PATH="$HOME/Pictures/screenshot-$(date '+%s').png"

if ! test -f "$TMP_PATH"; then
    touch "$TMP_PATH"
fi

if [[ $1 == "select" ]]; then
    maim --select "$TMP_PATH"
elif [[ $1 == "full" ]]; then
    sleep 0.5
    maim "$TMP_PATH"
fi

action=$(dunstify --icon "$TMP_PATH" -a "Screenshot" \
    --action "copy,Copy" \
    --action "delete,Delete" \
    "Screenshot is ready!" "Screenshot saved successfully. See your Pictures.")

if [[ "$action" == "copy" ]]; then
    xclip -sel clip -target image/png "$TMP_PATH"
    notify-send -i "$TMP_PATH" -a "Screenshot" "Screenshot" "Screenshot copied successfully."
elif [[ "$action" == "delete" ]]; then
    rm "$TMP_PATH"
    notify-send -i "$TMP_PATH" -a "Screenshot" "Screenshot" "Screenshot removed successfully."
fi
