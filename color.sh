#! /usr/bin/env bash

color=""

if [ "$1" = "light" ]; then
  color="light"
elif [ "$1" = "dark" ]; then
  color="dark"
else
  exit
fi

# sway_borders
cat "/home/sam/dotfiles/sway/${color}_borders.d" > "/home/sam/dotfiles/sway/borders.d"

# nvim
cat "/home/sam/dotfiles/nvim/lua/config/${color}_color.lua" > "/home/sam/dotfiles/nvim/lua/config/color.lua"

# waybar
cat "/home/sam/dotfiles/sway/waybar/${color}.style.css" > "/home/sam/dotfiles/sway/waybar/style.css"

#rofi
cat "/home/sam/dotfiles/rofi/theme.${color}.rasi" > "/home/sam/dotfiles/rofi/theme.rasi"

#wezterm 
cat "/home/sam/dotfiles/${color}.wezterm.lua" > "/home/sam/dotfiles/.wezterm.lua"

# mako
swaymsg reload
