#!/bin/bash
NAME="rofi-color-picker"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

if [ -n "$WAYLAND_DISPLAY" ]; then
  clip_cmd="wl-copy"
elif [ -n "$DISPLAY" ]; then
  clip_cmd="xclip -sel clip"
else
  echo "Error: No Wayland or X11 display detected" >&2
  exit 1
fi

COLORS_FILE="$DIR/../data/colors-name.txt"

LISTFILE="${LISTFILE:-$COLORS_FILE}"
ROFI_PROMPT="${ROFI_PROMPT:-""}"
[[ ! -f "$LISTFILE" ]] &&
  echo "$LISTFILE not found" &&
  exit 1

(($# > 1)) && shift $((--OPTIND))

ROFI_MAGIC='-dmenu -i -markup-rows'

output=${1:-icon}

file_contents=$(<"$LISTFILE")

output=""

if [ $XDG_SESSION_TYPE = "wayland" ]; then
  res=$(echo -en $(wl-paste) | pastel format hsl)
  if [ -n "$res" ]; then
    formatcolor=$(pastel format hex "$(wl-paste)")
    output+="<span color='$formatcolor' weight='normal'>  $(wl-paste)</span>\n"
    output+="Color_to_hex\n"
    output+="Color_to_rgb\n"
    output+="Color_to_hsl\n"
  fi
else
  res=$(echo -en $(xclip -o -selection clipboard) | pastel format hsl)
  if [ -n "$res" ]; then
    formatcolor=$(pastel format hex "$(xclip -o -selection clipboard)")
    output+="<span color='$formatcolor' weight='normal'>  $(xclip -o -selection clipboard)</span>\n"
    output+="Color_to_hex\n"
    output+="Color_to_rgb\n"
    output+="Color_to_hsl\n"
  fi
fi

if [[ "$XDG_CURRENT_DESKTOP" == "Hyprland" || "$XDG_SESSION_TYPE" == "x11" ]]; then
  output+="Pick_color\n"
  output+="Pick_color_rgb\n"
  output+="Pick_color_hsl\n"
  output+="Pick_color_in_5s\n"
fi

selected="$(echo -e "$output$file_contents" |
  rofi ${ROFI_MAGIC} ${ROFI_OPTIONS} -p Colors "${ROFI_PROMPT}")"

# Exit if nothing is selected
[[ -z $selected ]] && exit 1

# echo "$selected"

color_handle() {
  case "$1" in
  Pick_color)
    sleep 1s
    hyprpicker | pastel format hex | tr -d '\n' | wl-copy
    ;;
  Pick_color_rgb)
    sleep 1s
    hyprpicker | pastel format rgb | tr -d '\n' | wl-copy
    ;;
  Pick_color_hsl)
    sleep 1s
    hyprpicker | pastel format hsl | tr -d '\n' | wl-copy
    ;;
  Pick_color_in_5s)
    countdown '5' 'Pick Color'
    sleep 1s
    hyprpicker | pastel format hex | tr -d '\n' | wl-copy
    ;;
  Color_to_hex)
    (echo -en $(wl-paste)) | pastel format hex | tr -d '\n' | wl-copy
    ;;
  Color_to_rgb)
    (echo -en $(wl-paste)) | pastel format rgb | tr -d '\n' | wl-copy
    ;;
  Color_to_hsl)
    (echo -en $(wl-paste)) | pastel format hsl | tr -d '\n' | wl-copy
    ;;
  *)
    echo -n "$(echo "$selected" |
      cut -d\' -f2)" |
      $clip_cmd
    ;;
  esac
}

color_handle_x11() {
  case "$1" in
  Pick_color)
    sleep 1s
    gpick -so | pastel format hex | tr -d '\n' | xclip -i -selection clipboard
    ;;
  Pick_color_rgb)
    sleep 1s
    gpick -so | pastel format rgb | tr -d '\n' | xclip -i -selection clipboard
    ;;
  Pick_color_hsl)
    sleep 1s
    gpick -so | pastel format hsl | tr -d '\n' | xclip -i -selection clipboard
    ;;
  Pick_color_in_5s)
    countdown '5' 'Pick Color'
    sleep 1s
    gpick -so | pastel format hex | tr -d '\n' | xclip -i -selection clipboard
    ;;
  Color_to_hex)
    echo -en $(xclip -o -selection clipboard) | pastel format hex | tr -d '\n' | xclip -i -selection clipboard >/dev/null
    ;;
  Color_to_rgb)
    echo -en $(xclip -o -selection clipboard) | pastel format rgb | tr -d '\n' | xclip -i -selection clipboard >/dev/null
    ;;
  Color_to_hsl)
    echo -en $(xclip -o -selection clipboard) | pastel format hsl | tr -d '\n' | xclip -i -selection clipboard >/dev/null
    ;;
  *)
    echo -n "$(echo "$selected" |
      cut -d\' -f2)" |
      $clip_cmd
    ;;
  esac
}

if [ $XDG_SESSION_TYPE = "wayland" ]; then
  color_handle $selected
else
  color_handle_x11 $selected
fi
