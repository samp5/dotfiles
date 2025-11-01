#!/usr/bin/env bash

if swaymsg -t get_tree | grep -q '"class": "obsidian"'; then
    swaymsg '[class="obsidian"] focus'
else
    /squashfs-root-obsidian/AppRun &
    sleep 0.5 && swaymsg '[class="obsidian"] focus'
fi

