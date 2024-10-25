#!/bin/bash

filename="/home/dawn/.cache/mycolorscheme"

if [ -f "$filename" ] && [ -s "$filename" ]; then
  colorscheme=$(<"$filename")
else
  colorscheme="Light"
fi

menu() {
  SelectMenu=$(echo -e "Light\nDark" | rofi -dmenu -show run -mesg "Current colorscheme:$colorscheme" -p "Color Scheme" | awk '{print $1}')
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

current_image=${sorted_items[$current_index]}

if [ -n "$1" ]; then
  CurrentSelection=$1
else
  menu
  CurrentSelection=$SelectMenu
fi
case $CurrentSelection in
Light)
  colorscheme="Light"
  echo "$colorscheme" >"$filename"
  notify-send "Set wallpaper" $current_image
  "/home/dawn/.config/rofi/scripts/set-wallpaper.sh" "$current_image"
  kvantummanager --set Fluent
  plasma-apply-colorscheme LightlyMy
  gsettings set org.gnome.desktop.interface gtk-theme Fluent-Light-compact
  # gsettings set org.gnome.desktop.interface gtk-theme Breeze
  gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
  ;;
Dark)
  colorscheme="Dark"
  echo "$colorscheme" >"$filename"
  notify-send "Set wallpaper" $current_image
  "/home/dawn/.config/rofi/scripts/set-wallpaper.sh" "$current_image"
  kvantummanager --set FluentDark
  plasma-apply-colorscheme BreezeDark
  gsettings set org.gnome.desktop.interface gtk-theme Fluent-Dark-compact
  # gsettings set org.gnome.desktop.interface gtk-theme Breeze-Dark
  gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
  ;;
esac
