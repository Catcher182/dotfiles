#!/bin/bash
# This is a fork of https://github.com/luyves/polybar-rofi-usb-mount

menu() {
	currentselect=$(powerprofilesctl | awk '/\*/ {print $2}' | sed 's/:$//')
	SelectMenu=$(echo -e "Performance\nBalanced\nPower-saver" | rofi -dmenu -show run -mesg "Active profile:$currentselect" -p "Power-profiles" | awk '{print $1}')
}

menu
case $SelectMenu in
Performance)
	powerprofilesctl set performance
	notify-send "Set Power-profiles" "performance" && exit
	;;
Balanced)
	powerprofilesctl set balanced
	notify-send "Set Power-profiles" "balanced" && exit
	;;
Power-saver)
	powerprofilesctl set power-saver
	notify-send "Set Power-profiles" "power-saver" && exit
	;;
esac
