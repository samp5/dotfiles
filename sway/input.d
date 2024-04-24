input "1:1:AT_Translated_Set_2_keyboard" {
  repeat_delay 250
  repeat_rate 50
  xkb_layout us
  xkb_options ctrl:swapcaps
}

input "1739:52914:SYNA8017:00_06CB:CEB2_Touchpad" {
  dwt enabled
  tap enabled
  scroll_factor 1
  natural_scroll enabled
  middle_emulation enabled
}

bindsym XF86AudioRaiseVolume exec amixer set Master 5%+
bindsym XF86AudioLowerVolume exec amixer set Master 5%-
bindsym XF86AudioMute exec amixer -D pulse set Master 1+ toggle


bindsym XF86MonBrightnessDown exec brightnessctl set 5%-
bindsym XF86MonBrightnessUp exec brightnessctl set +5%
