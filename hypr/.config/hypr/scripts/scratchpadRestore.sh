#!/bin/bash
hyprctl dispatch togglespecialworkspace
# hyprctl dispatch movetoworkspace $(hyprctl monitors | grep active | awk '{print $3}')
hyprctl dispatch movetoworkspace +0
# if [ -n "$(hyprctl monitors | grep 'special')" ]; then
# 	hyprctl dispatch togglespecialworkspace
# fi
