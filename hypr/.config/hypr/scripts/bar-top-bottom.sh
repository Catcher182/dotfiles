#!/bin/bash

CONFIG_FILE="/home/dawn/.config/waybar/config"

if grep -q '"position": "bottom",' "$CONFIG_FILE"; then
  sed -i 's/"position": "bottom",/"position": "top",/' "$CONFIG_FILE"
  killall waybar
  waybar &
elif grep -q '"position": "top",' "$CONFIG_FILE"; then
  sed -i 's/"position": "top",/"position": "bottom",/' "$CONFIG_FILE"
  killall waybar
  waybar &
fi

# STYLE_FILE="/home/dawn/.config/waybar/style.css"
# CONFIG_FILE="/home/dawn/.config/waybar/config"
# HYPRLAND_CONF="/home/dawn/.config/hypr/config/general.conf"
#
# if grep -q '@import "./style-bottom.css";' "$STYLE_FILE"; then
# 	sed -i 's/@import "\.\/style-bottom\.css";/@import "\.\/style-top\.css";/' "$STYLE_FILE"
# 	sed -i 's/"position": "bottom",/"position": "top",/' "$CONFIG_FILE"
# 	sed -i 's/no_gaps_when_only = 1/no_gaps_when_only = 0/' "$HYPRLAND_CONF"
# 	killall waybar
# 	waybar &
# elif grep -q '@import "./style-top.css";' "$STYLE_FILE"; then
# 	sed -i 's/@import "\.\/style-top\.css";/@import "\.\/style-bottom\.css";/' "$STYLE_FILE"
# 	sed -i 's/"position": "top",/"position": "bottom",/' "$CONFIG_FILE"
# 	sed -i 's/no_gaps_when_only = 0/no_gaps_when_only = 1/' "$HYPRLAND_CONF"
# 	killall waybar
# 	waybar &
# fi
