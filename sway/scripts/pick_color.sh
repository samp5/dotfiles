#! /usr/bin/fish 
notify-send (set STR (grim -g (slurp -p) -t ppm - | convert - -format '%[pixel:p{0,0}]' txt:- |tail -n1 | awk '{print $3}') && echo $STR && wl-copy $STR)
