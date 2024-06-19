#!/bin/bash

if [ -z "$1" ]; then
	echo "No input provided"
else
	case "$1" in
	"lock")
		swaync-client -t -sw
		hyprlock
		;;
	"pickcolor")
		swaync-client -t -sw
		sleep 0.5s
		hyprpicker | pastel format hex | tr -d '\n' | wl-copy
		;;
	"pickcolorrgb")
		swaync-client -t -sw
		sleep 0.5s
		hyprpicker | pastel format rgb | tr -d '\n' | wl-copy
		;;
	"pickcolorin5")
		swaync-client -t -sw
		sleep 5s
		hyprpicker | pastel format hex | tr -d '\n' | wl-copy
		;;
	"capture_desktop")
		swaync-client -t -sw
		sleep 0.5s
		grimblast --notify copysave screen
		;;
	"capture_area")
		swaync-client -t -sw
		sleep 0.5s
		grimblast --notify copysave area
		;;
	"capturein5")
		swaync-client -t -sw
		sleep 5s
		flameshot gui
		;;
	"networkmanager")
		swaync-client -t -sw
		sleep 0.5s
		networkmanager_dmenu
		;;
	"blueman")
		swaync-client -t -sw
		sleep 0.5s
		blueman-manager
		;;
	"record")
		swaync-client -t -sw
		sleep 0.5s
		obs
		;;
	*)
		# 默认情况下的命令
		;;
	esac
fi
