#!/usr/bin/env bash
date_and_week=$(date "+%Y/%m/%d")
current_time=$(date "+%H:%M")
network=$(ip route get 1.1.1.1 | grep -Po '(?<=dev\s)\w+' | cut -f1 -d ' ')

memtotal=$(cat /proc/meminfo | grep 'MemTotal:' | awk '{print $2}')
memavailable=$(cat /proc/meminfo | grep 'MemAvailable:' | awk '{print $2}')
percent=$(echo $(( 100 - (100 * $memavailable  + $memtotal / 2) / $memtotal)))
brightness=$(brightnessctl i | grep -Po "(..%)")

battery_charge=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "percentage" | awk '{print $2}')
battery_status=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "state" | awk '{print $2}')
ping=$(ping -c 1 www.google.es | tail -1| awk '{print $4}' | cut -d '/' -f 2 | cut -d '.' -f 1)
loadavg_5min=$(cat /proc/loadavg | awk -F ' ' '{print $2}')

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

echo "  $network_active $ping ms  󰍛 $loadavg_5min  $percent%  󰃝 $brightness  $battery_pluggedin $battery_charge    $date_and_week  $current_time "
