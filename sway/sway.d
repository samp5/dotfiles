include ~/dotfiles/sway/input.d
include /etc/sway/config.d/*
include ~/dotfiles/sway/borders.d

font pango:Atkinson-Hyperlegible-Bold-102 10
mouse_warping output

### Autostart 
exec /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1
exec systemctl --user import-environment
exec --no-startup-id mako
exec_always /home/sam/.cargo/bin/wl-gammarelay-rs
exec layman
exec_always wl-paste --watch cliphist store

### Variables
xwayland enable

# Logo key. Use Mod1 for Alt.
set $mod Mod4

### Notifications
bindsym $mod+Space exec makoctl dismiss

# Home row direction keys, like vim
set $left h
set $down j
set $up k
set $right l

set $term /usr/bin/alacritty
 
# Your preferred application launcher
# Note: pass the final command to swaymsg so that the resulting window can be opened
set $menu  wofi --show drun | xargs swaymsg exec --

set $lock swaylock --config ~/dotfiles/sway/swaylock_config
set $wifi ~/dotfiles/sway/scripts/wifi_script
set $window_picker ~/dotfiles/sway/scripts/tree-switcher.sh
set $bluetooth ~/dotfiles/sway/scripts/rofi-bluetooth/rofi-bluetooth
set $window_picker ~/dotfiles/sway/scripts/tree-switcher.sh
set $mark ~/dotfiles/sway/scripts/mark.sh
set $pick_mark ~/dotfiles/sway/scripts/mark-switch.sh
set $color_switcher ~/dotfiles/color.sh
set $pdf_pick ~/dotfiles/sway/scripts/open_pdf.sh
set $clip_board rofi -modi clipboard:~/dotfiles/sway/scripts/cliphist_rofi -show clipboard -show-icons
set $password_search alacritty -e ~/dotfiles/sway/scripts/get_password.sh
bindsym $mod+a exec $password_search


bindsym $mod+Shift+n exec ~/dotfiles/sway/scripts/obsidian.sh
bindsym $mod+w exec $window_picker
bindsym $mod+m exec $mark
bindsym $mod+u exec $pick_mark
bindsym $mod+Shift+o exec $pdf_pick
bindsym $mod+c exec $clip_board

# Misc Options
popup_during_fullscreen leave_fullscreen

### Output configuration
output * {
  bg ~/Pictures/wallpapers/water.jpg fill
  render_bit_depth 8
}


output eDP-1  {
  mode 2880x1800@90Hz
  scale 1.5
}

output HDMI-A-1 {
}




### Idle configuration
#
# Example configuration:

# exec swayidle -w \
#          timeout 600 'swaylock -f -C ~/dotfiles/sway/swaylock_config' \
#          timeout 1200 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
#          before-sleep 'swaylock -f -C ~/dotfiles/sway/swaylock_config'

### Key bindings
# Basics:

    # Start a terminal
    bindsym $mod+Return exec $term
    bindsym $mod+Ctrl+k exec /usr/bin/wezterm start keep --always-new-process

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
    bindsym $mod+Shift+$left nop layman move left
    bindsym $mod+Shift+$down nop layman move down
    bindsym $mod+Shift+$up nop layman move up
    bindsym $mod+Shift+$right nop layman move right

# Workspaces:

    # workspaces
    set $ws1   "1: "
    set $ws2   "2:󰖟"
    set $ws3   "3:󰎚"
    set $ws4   "4:󰅫"
    set $ws5   "5:󰍺 "
    workspace $ws5 output HDMI-A-1
    set $ws6   6
    set $ws7   7
    set $ws8   "8:󱧌 "
    set $ws9   "9:󰒱"
    set $ws0   "10: 󰝚 "

    assign [class="Cider"] $ws0 
    assign [class="obsidian"] $ws3 
    assign [class="Slack"] $ws9
    assign [class="Signal"] $ws8

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
    bindsym $mod+Shift+4 move container to workspace $ws4
    bindsym $mod+Shift+5 move container to workspace $ws5
    bindsym $mod+Shift+6 move container to workspace $ws6
    bindsym $mod+Shift+7 move container to workspace $ws7
    bindsym $mod+Shift+8 move container to workspace $ws8
    bindsym $mod+Shift+9 move container to workspace $ws9
    bindsym $mod+Shift+0 move container to workspace $ws0

    # Note: workspaces can have any name you want, not just numbers.
#
# Layout stuff:
#
    # You can "split" the current object of your focus with
    # $mod+b or $mod+v, for horizontal and vertical splits
    # respectively.
    bindsym $mod+n splith
    bindsym $mod+b splitv

    # toggle between splits
    bindsym $mod+e layout toggle split

    # Make the current focus fullscreen
    bindsym $mod+f fullscreen

    # Toggle the current focus between tiling and floating mode
    bindsym $mod+Ctrl+space floating toggle

    bindsym $mod+t layout toggle stacking split

    # Move focus to the parent container
    # bindsym $mod+a focus parent
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
set $resize "󰩨 : [h] [j] [k] [l]"
mode $resize  {
    # left will shrink the containers width
    # right will grow the containers width
    # up will shrink the containers height
    # down will grow the containers height
    bindsym $left resize shrink width 30px
    bindsym $down resize grow height 30px
    bindsym $up resize shrink height 30px
    bindsym $right resize grow width 30px

    # Return to default mode
    bindsym Return mode "default"
    bindsym Escape mode "default"
}
bindsym $mod+r mode $resize

set $wl-present ~/dotfiles/sway/scripts/wl-present
set $present "[m]irror [o]utput [r]egion [S-r]egion unset [s]caling [f]reeze"
mode $present {
    # command starts mirroring
    bindsym m mode "default"; exec $wl-present mirror
    # these commands modify an already running mirroring window
    bindsym o mode "default"; exec $wl-present set-output
    bindsym r mode "default"; exec $wl-present set-region
    bindsym Shift+r mode "default"; exec $wl-present unset-region
    bindsym s mode "default"; exec $wl-present set-scaling
    bindsym f mode "default"; exec $wl-present toggle-freeze

    # return to default mode
    bindsym Return mode "default"
    bindsym Escape mode "default"
}
bindsym $mod+Shift+p mode $present

# various screenshot options
set $screenclipsave  grim -g "$(slurp)" ~/Pictures/Screenshots/clip-$(date +"%Y-%m-%d-%H-%M-%S").jpeg && notify-send "Screenshot saved as clip-$(date +"%Y-%m-%d-%H-%M-%S")"
set $screenclip grim -g "$(slurp)" - | wl-copy -t image/png && notify-send "Screenshot saved to clipboard"
set $stop_recording killall wf-recorder

set $screenshot  "[s]elect [S]ave [f]ocused [p]ick color [r]ecord  [e]nd record"
mode $screenshot {

    bindsym s exec $screenclip
    bindsym Shift+s exec $screenclipsave
    bindsym p exec ~/dotfiles/sway/scripts/pick_color.sh
    bindsym f exec ~/dotfiles/sway/scripts/screenshotfocusedpane
    bindsym r exec ~/dotfiles/sway/scripts/screen_cap_focused_pane.sh
    bindsym e exec $stop_recording

    # Return to default mode
    bindsym Escape mode "default"
}
bindsym $mod+Print mode $screenshot


# Shortcuts
bindsym Print exec $screenclip
bindsym $mod+i exec /usr/bin/zen
bindsym $mod+Shift+i exec /usr/bin/glide
bindsym $mod+s exec spotify

# Status Bar:
# include ~/dotfiles/sway/custom-bar.d
bar {
  swaybar_command waybar
}
