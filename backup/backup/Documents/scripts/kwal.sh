#!/bin/bash
if [ "$XDG_CURRENT_DESKTOP" = "KDE" ]; then
	walname=$(<"${HOME}/.cache/wal/wal")
	qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'var allDesktops = desktops(); for (i = 0; i < allDesktops.length; i++) {d = allDesktops[i]; d.wallpaperPlugin = "org.kde.image";d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General"); d.writeConfig("Image", "file://'$walname'")}'
fi
