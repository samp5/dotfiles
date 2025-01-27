include ~/dotfiles/sway/colors.d

# Window Borders
default_border pixel 3
default_floating_border normal
smart_borders off
gaps inner 5
gaps outer 0

# Border colors
# class                     border         backgnd   text       indicator    child_border
client.focused              $springViolet1 $Base $Text $Blue $Lavender
client.unfocused            $sumiInk4      $Crust $Subtext1  $Blue $Surface0
client.focused_tab_title    $springViolet2 $Base     $Text 
client.focused_inactive     $sumiInk4      $Crust    $Subtext1 
