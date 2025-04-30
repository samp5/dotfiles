#!/bin/bash

fdfind --type f -e pdf . /home/sam|sed -e 's|\/home\/sam\/||' | rofi -keep-right -dmenu -i -p FILES | sed -e 's|^|\/home\/sam\/|'| xargs -I {} xdg-open {}

