#!/usr/bin/bash

if [ -z "$1" ]; then
	echo "请输入图片路径"
	exit 1
fi

mime_type=$(file -b --mime-type "$1")
# 检查MIME类型是否不以"image/"开头
if [[ $mime_type != image/* ]]; then
	echo "输入的路径不是图片路径"
	exit 1
fi

filename="/home/dawn/.cache/mycolorscheme"

if [ -f "$filename" ] && [ -s "$filename" ]; then
	colorscheme=$(<"$filename")
else
	colorscheme="light"
	echo "$colorscheme" >"$filename"
fi

if [ "$colorscheme" = "light" ]; then
	# -s Skip changing colors in terminals
	# -l Generate a light colorscheme.
	wal --backend colorthief -l -a 60 -i $1 >/dev/null
else
	wal --backend colorthief -a 60 -i $1 >/dev/null
fi

wallpaper="$(<"${HOME}/.cache/wal/wal")"

if [ -z "$(<"${HOME}/.cache/wal/wal")" ]; then
	exit 1
fi

if [ $XDG_SESSION_DESKTOP = "Hyprland" ]; then
	killall -SIGUSR2 waybar >/dev/null
	swaync-client -rs >/dev/null
	swww img "$wallpaper" >/dev/null
	exit 0
elif [ $XDG_SESSION_DESKTOP = "Wayfire" ]; then
	killall -SIGUSR2 waybar >/dev/null
	swaync-client -rs >/dev/null
	swww img "$wallpaper" >/dev/null
	exit 0
elif [ "$XDG_CURRENT_DESKTOP" = "KDE" ]; then
	qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "var allDesktops = desktops();print (allDesktops);for (i=0;i<allDesktops.length;i++) {d = allDesktops[i];d.wallpaperPlugin = \"org.kde.image\";d.currentConfigGroup = Array(\"Wallpaper\", \"org.kde.image\", \"General\");d.writeConfig(\"Image\", \"file:$wallpaper\")}"
	qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "var allDesktops = desktops();print (allDesktops);for (i=0;i<allDesktops.length;i++) {d = allDesktops[i];d.wallpaperPlugin = \"org.kde.image\";d.currentConfigGroup = Array(\"Wallpaper\", \"org.kde.image\", \"General\");d.writeConfig(\"Image\", \"file:$wallpaper\")}"
	exit 0
elif [ "$XDG_CURRENT_DESKTOP" = "GNOME" ]; then
	gsettings set org.gnome.desktop.background picture-uri "file://$wallpaper"
	gsettings set org.gnome.desktop.background picture-uri-dark "file://$wallpaper"
	exit 0
elif [ "$XDG_CURRENT_DESKTOP" = "sway" ]; then
	swaymsg output "*" bg "$wallpaper" "stretch"
	exit 0
else
	# fallback on feh
	if ! command -v feh &>/dev/null; then
		rofi -e "Install 'feh'"
		exit 1
	fi
	feh --bg-scale "$wallpaper"
	exit 0
fi
