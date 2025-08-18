#!/usr/bin/env bash
set -euo pipefail

eval "$(op signin)" || {
    notify-send "1Password" "Signin failed"
    exit 1
}

items=$(op item list --format=json | jq -r '.[] | "\(.title) [\(.id)]"')

selected=$(printf "%s\n" "$items" | wofi --dmenu -i -p "  login search")

[ -z "$selected" ] && exit 0

uid=$(echo "$selected" | sed -n 's/.*\[\(.*\)\].*/\1/p')

password=$(op item get "$uid" --format=json --fields=password | jq -r '.value')

if [ -z "$password" ]; then
    notify-send "1Password" "No password found"
    exit 1
fi

echo -n "$password" | wl-copy
notify-send "1Password" "Password copied"

(sleep 10; cliphist delete-query "$password")&
