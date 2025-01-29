include ~/dotfiles/sway/colors.d

# Window Borders
default_border pixel 3
default_floating_border normal
smart_borders off
gaps inner 5
gaps outer 0

# Border colors
# class                     border         backgnd   text       indicator    child_border
client.focused              $springViolet1 $sumiInk2 $fujiWhite $crystalBlue $sumiInk4
client.unfocused            $sumiInk4      $sumiInk1 $fujiGray  $crystalBlue $sumiInk1
client.focused_tab_title    $springViolet2 $sumiInk2 $fujiWhite 
client.focused_inactive     $sumiInk4      $sumiInk0 $fujiGray 
