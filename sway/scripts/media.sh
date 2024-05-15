#! /usr/bin/env bash
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
  spotify_string="   $media_icon  $media_info $shuffle_icon"
elif [[ "$media_status" = "Paused" ]]
then 
  media_icon=""
  media_info=$(playerctl metadata --format '{{trunc(album,15)}} {{trunc(title,15)}} {{trunc(artist,15)}}' 2>&1 )
  spotify_string=" $media_icon  $media_info $shuffle_icon"
else
  spotify_string=""
fi

echo $spotify_string
