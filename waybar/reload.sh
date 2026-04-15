#! /usr/bin/env bash
inotifywait -e modify .

if [ $? -eq 0 ]; then
  echo "Reloading waybar"
  killall waybar
  waybar > /dev/null &
else 
  echo "Exit code was $?"
fi

exec ./reload.sh
