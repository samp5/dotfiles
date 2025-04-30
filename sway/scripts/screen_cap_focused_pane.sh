#! /usr/bin/fish
notify-send "Focused pane started recording" && wf-recorder -g $(swaymsg -t get_tree | jq -j '.. | select(.type?) | select(.focused).rect | "\(.x),\(.y) \(.width)x\(.height)"')  --file="/home/sam/Pictures/Screenshots/vid-$(date +"%Y-%m-%d-%H-%M-%S").mp4"
