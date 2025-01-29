#! /usr/bin/env bash
color=$(printf "  - light\n  - dark" | rofi -dmenu -l 2 | awk '{print $3}') 

if [ "$color" = "" ]; then
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

# tmux
cat "/home/sam/dotfiles/${color}.tmux.conf" > "/home/sam/dotfiles/.tmux.conf"

tmux source-file  /home/sam/dotfiles/.tmux.conf

# mako
killall wl-gammarelay-rs

# obsidian
cat "/home/sam/obsidian/school/.obsidian/${color}_apperance.json" > "/home/sam/obsidian/school/.obsidian/appearance.json"

swaymsg reload

swaymsg "output * background ~/Pictures/wallpapers/${color}.jpg fill"
