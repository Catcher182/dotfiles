#!/usr/bin/env bash

# Original Author : Aditya Shakya (adi1090x)
#
# this script manages backlight brightness control for connected displays using xrandr (X11)

ROFI_CMD="${ROFI_CMD:-rofi -dmenu -i}"

current_bright_perc() {
	printf "%.0f\n" $(light -G)
}

options="Increase\nDecrease\nOptimal"

## Main
selected_row=0

while chosen="$(echo -e "$options" | $ROFI_CMD -p "Brightness $(current_bright_perc)%" -selected-row $selected_row)"; do
	case $chosen in
	"Increase")
		light -A 5
		selected_row=0
		;;
	"Decrease")
		light -U 5
		selected_row=1
		;;
	"Optimal")
		light -S 25
		selected_row=2
		;;
	esac
done

exit 1
