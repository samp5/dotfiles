#!/bin/bash

fdfind --type f -e pdf . /home/sam|sed -e 's|\/home\/sam\/||' | wofi --dmenu -i --prompt=FILES | sed -e 's|^|\/home\/sam\/|'| xargs -I {} xdg-open {}

