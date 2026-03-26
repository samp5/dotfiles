#!/bin/bash

fdfind --no-ignore --type f -e pdf . /home/sam|sed -e 's|\/home\/sam\/||' | fuzzel --dmenu -i --prompt="FILES: " --width=50% | sed -e 's|^|\/home\/sam\/|'| xargs -I {} xdg-open {}

