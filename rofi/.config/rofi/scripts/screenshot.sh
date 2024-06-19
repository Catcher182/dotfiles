#!/usr/bin/env bash

# Import Current Theme
theme="$HOME/.config/rofi/themes/screenshot.rasi"

# Theme Elements
prompt='Screenshot'
mesg="DIR: $XDG_SCREENSHOTS_DIR"

list_col='1'
list_row='6'
win_width='600px'

option_0="Ocr"
option_1="Capture Desktop"
option_2="Capture Area"
option_3="Capture Window"
option_4="Capture in 5s"
option_5="Capture in 10s"

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "window {width: $win_width;}" \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_0\n$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

# countdown
countdown() {
	for sec in $(seq $1 -1 1); do
		dunstify -t 1000 --replace=699 "Taking shot in : $sec"
		sleep 1
	done
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt0' ]]; then
		rm ~/.cache/com.pot-app.desktop/pot_screenshot_cut.png >/dev/null
		grim -g "$(slurp)" ~/.cache/com.pot-app.desktop/pot_screenshot_cut.png && curl "127.0.0.1:60828/ocr_recognize?screenshot=false" >/dev/null
	elif [[ "$1" == '--opt1' ]]; then
		sleep 1s
		grimblast --notify copysave screen
	elif [[ "$1" == '--opt2' ]]; then
		grimblast --notify copysave area
	elif [[ "$1" == '--opt3' ]]; then
		sleep 1s
		grimblast --notify copysave active
	elif [[ "$1" == '--opt4' ]]; then
		countdown '5'
		flameshot gui
	elif [[ "$1" == '--opt5' ]]; then
		countdown '10'
		flameshot gui
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
$option_0)
	run_cmd --opt0
	;;
$option_1)
	run_cmd --opt1
	;;
$option_2)
	run_cmd --opt2
	;;
$option_3)
	run_cmd --opt3
	;;
$option_4)
	run_cmd --opt4
	;;
$option_5)
	run_cmd --opt5
	;;
esac
