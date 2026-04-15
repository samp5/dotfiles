#!/bin/bash

fdfind --no-ignore --type f -e pdf . /home/sam|sed -e 's|\/home\/sam\/||' | fuzzel --dmenu -i --prompt="FILES: " --width=100% | sed -e 's|^|\/home\/sam\/|'| xargs -I {} xdg-open {}

OKULAR_ID=$(niri msg -j windows | jq ".[] | select(.app_id == \"org.kde.okular\") | .id")
niri msg focus-window --id "$OKULAR_ID"

