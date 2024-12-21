#!/bin/bash

CONFIG_FILE="/home/dawn/.config/waybar/config"

if grep -q '"position": "bottom",' "$CONFIG_FILE"; then
  sed -i 's/"position": "bottom",/"position": "top",/' "$CONFIG_FILE"
  sed -i 's/"margin":"0 4 4 4",/"margin":"4 4 0 4",/' "$CONFIG_FILE"
  killall waybar
  waybar &
elif grep -q '"position": "top",' "$CONFIG_FILE"; then
  sed -i 's/"position": "top",/"position": "bottom",/' "$CONFIG_FILE"
  sed -i 's/"margin":"4 4 0 4",/"margin":"0 4 4 4",/' "$CONFIG_FILE"
  killall waybar
  waybar &
fi
