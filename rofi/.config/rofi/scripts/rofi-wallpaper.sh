#!/bin/bash

SCRIPT_PATH="$(
	cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit
	pwd -P
)"

ROFI_CMD="${ROFI_CMD:-rofi -dmenu -i}"
GRID_ROWS=${GRID_ROWS:-2}
GRID_COLS=${GRID_COLS:-5}
ICON_SIZE=${ICON_SIZE:-5}

build_theme() {
	rows=$1
	cols=$2
	icon_size=$3

	echo "element{orientation:vertical;}element-text{horizontal-align:0.5;}element-icon{size:$icon_size.2000em;}listview{lines:$rows;columns:$cols;}"
}

folder="/home/dawn/dotfiles/wallpapers/Pictures/walls"
items=()
while IFS= read -r -d $'\0' file; do
	if file -b "$file" | grep -q 'image'; then
		items+=("$file")
	fi
done < <(find "$folder" -maxdepth 1 -type f -print0)
sorted_items=($(printf "%s\n" "${items[@]}" | sort))

current_index=$(<"$folder/.current")
array_length=${#sorted_items[@]}
next_index=$((current_index + 1))
prev_index=$((current_index - 1))
if [ $next_index -eq $array_length ]; then
	next_index=0
fi
if [ $prev_index -lt 0 ]; then
	prev_index=$((array_length - 1))
fi

images=""
for i in ${sorted_items[@]}; do
	item=${i##*/}
	images="$images$item\x00icon\x1f$i\n"
done

choice=$(
	echo -en "Next\0icon\x1f${sorted_items[next_index]}\n""Previous\0icon\x1f${sorted_items[prev_index]}\n""$images" |
		$ROFI_CMD -show-icons -theme-str $(build_theme $GRID_ROWS $GRID_COLS $ICON_SIZE) -p "Wallpaper"
)

if [ -z "$choice" ]; then
	exit 1
fi

case "$choice" in
Next)
	echo $next_index >"$folder/.current"
	current_image=${sorted_items[$next_index]}
	;;
Previous)
	echo $prev_index >"$folder/.current"
	current_image=${sorted_items[$prev_index]}
	;;
*)
	index=-1
	for ((i = 0; i < ${#sorted_items[@]}; i++)); do
		item=${sorted_items[$i]}
		if [ "${item##*/}" = "$choice" ]; then
			index=$i
			break
		fi
	done
	echo $index >"$folder/.current"
	current_image=${sorted_items[$index]}
	;;
esac

notify-send "Set wallpaper" $current_image

"$SCRIPT_PATH/set-wallpaper.sh" "$current_image"
