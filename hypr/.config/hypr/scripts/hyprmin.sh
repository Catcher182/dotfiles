#!/bin/sh

handle() {
	case $1 in
	minimize*)
		# data=$(echo $1 | cut -d'>' -f3)
		# IFS="," read -ra items <<< "$data"
		# echo first:${items[0]} second=${items[1]}
		result=$(hyprctl activewindow | grep workspace | grep -)
		if [ -n "$result" ]; then
			hyprctl dispatch movetoworkspace +0
		else
			hyprctl dispatch movetoworkspacesilent special
		fi
		;;
	esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
