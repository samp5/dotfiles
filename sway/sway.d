include ~/dotfiles/sway/input.d
include ~/dotfiles/sway/borders.d

### Variables
xwayland enable

# Logo key. Use Mod1 for Alt.
set $mod Mod4

# Home row direction keys, like vim
set $left h
set $down j
set $up k
set $right l

# Your preferred terminal emulator
set $term /usr/bin/wezterm
set $term_cwd --directory "$swaycwd 2>/dev/null | echo $HOME"
set $screenclip  grim -g "$(slurp)" ~/Pictures/Screenshots/clip-$(date +"%Y-%m-%d-%H-%M-%S").jpeg
set $term_float $term --class floating_shell

# Your preferred application launcher
# Note: pass the final command to swaymsg so that the resulting window can be opened
set $menu  rofi -show run | xargs swaymsg exec --
set $lock swaylock --config ~/dotfiles/sway/swaylock_config
set $wifi ~/dotfiles/sway/scripts/wifi_script
set $bluetooth ~/dotfiles/sway/scripts/bluetooth_script


### Output configuration
output * {
  scale 1.5
  bg ~/Pictures/backgrounds/water.jpg fill
}

output "Acer Technologies V247Y 0x0000856D" {
  mode 1920x1080@60Hz
  scale 1.0
}

output eDP-1  {
  mode 2880x1800@90Hz
  scale 1.5
}



### Idle configuration
#
# Example configuration:

exec swayidle -w \
          timeout 600 'swaylock -f -C ~/dotfiles/sway/swaylock_config' \
          timeout 1200 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
          before-sleep 'swaylock -f -C ~/dotfiles/sway/swaylock_config'

### Key bindings
# Basics:

    # Start a terminal
    bindsym $mod+Return exec $term

    # Kill focused window
    bindsym $mod+End kill

    # Start your launcher
    bindsym $mod+o exec $menu

    # Drag floating windows by holding down $mod and left mouse button.
    # Resize them with right mouse button + $mod.
    # Despite the name, also works for non-floating windows.
    # Change normal to inverse to use left mouse button for resizing and right
    # mouse button for dragging.
    floating_modifier $mod normal

    # Reload the configuration file
    bindsym $mod+Shift+c reload

# Moving around:
#
    # Move your focus around
    bindsym $mod+$left focus left
    bindsym $mod+$down focus down
    bindsym $mod+$up focus up
    bindsym $mod+$right focus right

    # Move the focused window with the same, but add Shift
    bindsym $mod+Shift+$left move left
    bindsym $mod+Shift+$down move down
    bindsym $mod+Shift+$up move up
    bindsym $mod+Shift+$right move right
#

# Workspaces:


    # workspaces
    set $ws1   "1: "
    set $ws2   "2: "
    set $ws3   "3:󱆀 "
    set $ws4   4
    set $ws5   5
    set $ws6   6
    set $ws7   7
    set $ws8   8
    set $ws9   "9:󰒱"
    set $ws0   "0: "

    assign [class="Spotify"] $ws0 
    assign [class="Slack"] $ws9

    # Relative Switching
    bindsym $mod+Ctrl+l workspace next
    bindsym $mod+Ctrl+h workspace prev

    bindsym $mod+p workspace back_and_forth

    # Switch to workspace
    bindsym $mod+1 workspace $ws1
    bindsym $mod+2 workspace $ws2
    bindsym $mod+3 workspace $ws3
    bindsym $mod+4 workspace $ws4
    bindsym $mod+5 workspace $ws5
    bindsym $mod+6 workspace $ws6
    bindsym $mod+7 workspace $ws7
    bindsym $mod+8 workspace $ws8
    bindsym $mod+9 workspace $ws9
    bindsym $mod+0 workspace $ws0

    # Move focused container to workspace
    bindsym $mod+Shift+1 move container to workspace $ws1
    bindsym $mod+Shift+2 move container to workspace $ws2
    bindsym $mod+Shift+3 move container to workspace $ws3
    bindsym $mod+Shift+0 move container to workspace $ws0
    # Note: workspaces can have any name you want, not just numbers.
    # We just use 1-10 as the default.
#
# Layout stuff:
#
    # You can "split" the current object of your focus with
    # $mod+b or $mod+v, for horizontal and vertical splits
    # respectively.
    bindsym $mod+b splith
    bindsym $mod+n splitv

    # Switch the current container between different layout styles
    bindsym $mod+e layout toggle split

    # Make the current focus fullscreen
    bindsym $mod+f fullscreen

    # Toggle the current focus between tiling and floating mode
    bindsym $mod+Ctrl+space floating toggle

    # Swap focus between the tiling area and the floating area
    bindsym $mod+space focus mode_toggle

    # Move focus to the parent container
    bindsym $mod+a focus parent
#
# Scratchpad:
#
    # Sway has a "scratchpad", which is a bag of holding for windows.
    # You can send windows there and get them back later.

    # Move the currently focused window to the scratchpad
    bindsym $mod+Shift+minus move scratchpad

    # Show the next scratchpad window or hide the focused scratchpad window.
    # If there are multiple scratchpad windows, this command cycles through them.
    bindsym $mod+minus scratchpad show
#
# Resizing containers:
#
mode "resize" {
    # left will shrink the containers width
    # right will grow the containers width
    # up will shrink the containers height
    # down will grow the containers height
    bindsym $left resize shrink width 20px
    bindsym $down resize grow height 20px
    bindsym $up resize shrink height 20px
    bindsym $right resize grow width 20px

    # Return to default mode
    bindsym Return mode "default"
    bindsym Escape mode "default"
}
bindsym $mod+r mode "resize"

set $mode_system  (l)ock, 󰍃 l(o)gout, 󰤄 (s) suspend,  (r) reboot, ⏻ (S)hutdown 

mode "$mode_system" {
    bindsym l exec $lock, mode "default"
    bindsym o exit
    bindsym s exec --no-startup-id systemctl suspend, mode "default"
    bindsym r exec --no-startup-id systemctl reboot, mode "default"
    bindsym Shift+s exec --no-startup-id systemctl poweroff -i, mode "default"

    # Return to default mode
    bindsym Return mode "default"
    bindsym Escape mode "default"
}
bindsym $mod+s mode "$mode_system" 

set $media 󰐎 (p)lay-pause,  (s)huffle, 󰒭 (n)ext, 󰒮 p(r)evious  (j)  (k) 

mode "$media" {

    bindsym p exec playerctl play-pause
    bindsym s exec playerctl shuffle Toggle
    bindsym n exec playerctl next
    bindsym r exec playerctl previous
    bindsym k exec playerctl volume 0.05+
    bindsym j exec playerctl volume 0.05-

    # Return to default mode
    bindsym Return mode "default"
    bindsym Escape mode "default"
}
bindsym $mod+m mode "$media" 

set $connections  (w)ifi  (b)luetooth

mode "$connections" {

    bindsym w exec $wifi
    bindsym b exec $bluetooth

    # Return to default mode
    bindsym Return mode "default"
    bindsym Escape mode "default"
}
bindsym $mod+w mode "$connections" 


# Shortcuts
bindsym Print exec $screenclip
bindsym $mod+i exec librewolf

# Status Bar:
# include ~/dotfiles/sway/custom-bar.d
bar {
  swaybar_command waybar
}
