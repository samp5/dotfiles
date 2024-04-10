#!/usr/bin/env bash

date_and_week=$(date "+%Y/%m/%d")
current_time=$(date "+%H:%M")
network=$(ip route get 1.1.1.1 | grep -Po '(?<=dev\s)\w+' | cut -f1 -d ' ')

memtotal=$(cat /proc/meminfo | grep 'MemTotal:' | awk '{print $2}')
memavailable=$(cat /proc/meminfo | grep 'MemAvailable:' | awk '{print $2}')
percent=$(echo $(( 100 - (100 * $memavailable  + $memtotal / 2) / $memtotal)))
brightness=$(brightnessctl i | grep -Po "(..%)")


# player ctl is dumb and outputs on the standard error instead of standard output? 

media_status=$(playerctl status 2>&1)
shuffle_status=$(playerctl shuffle 2>&1)

if [[ "$shuffle_status" = "On" ]];
then
  shuffle_icon=""
else
  shuffle_icon=""
fi

if [[ "$media_status" = "Playing" ]];
then
  media_icon=""
  media_info=$(playerctl metadata --format '{{trunc(album,15)}} {{trunc(title,15)}} {{trunc(artist,15)}}' 2>&1 )
elif [[ "$media_status" = "Paused" ]]
then 
  media_icon=""
  media_info=$(playerctl metadata --format '{{trunc(album,15)}} {{trunc(title,15)}} {{trunc(artist,15)}}' 2>&1 )
else
  media_icon=""
  media_info=""
fi

if [[ "$media_status" != "No players found" ]]
then
  spotify_string="   $media_icon  $media_info $shuffle_icon"
else
  spotify_string=""
fi


battery_charge=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "percentage" | awk '{print $2}')
battery_status=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "state" | awk '{print $2}')
ping=$(ping -c 1 www.google.es | tail -1| awk '{print $4}' | cut -d '/' -f 2 | cut -d '.' -f 1)
loadavg_5min=$(cat /proc/loadavg | awk -F ' ' '{print $2}')
cpu_temp=$(sensors | head -n3 | grep -Po ".....C" | head -n1)

if [ "$battery_status" = "discharging" ]; then
    battery_pluggedin='󱧥'
else
    battery_pluggedin='󰂄'
fi

if ! [ $network ]; then
   network_active="󰤮"
else
   network_active="⇆"
fi

echo "  $network_active $ping ms   $cpu_temp 󰍛 $loadavg_5min  $percent%  󰃝 $brightness  $battery_pluggedin $battery_charge$spotify_string    $date_and_week  $current_time "
