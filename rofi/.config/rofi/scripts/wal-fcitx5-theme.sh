#!/bin/bash

source ~/.cache/wal/colors-hex.sh

mycolor=$color1

if [ -n "$1" ]; then
	if [[ $1 =~ ^\#[0-9a-fA-F]{6}$ ]]; then
		mycolor=$1
	fi
fi

if [ -z "$mycolor" ]; then
	exit 1
fi

file="/home/dawn/.local/share/fcitx5/themes/Wal-With-Border/highlight.svg"
if [ -f "$file" ]; then
	sed -i "s/\(<stop offset=\"100%\" stop-color=\"\)#....../\1$mycolor/g" "$file"
fi

file="/home/dawn/.local/share/fcitx5/themes/Wal-With-Border/panel.svg"
if [ -f "$file" ]; then
	sed -i "s/\(<stop offset=\"100%\" stop-color=\"\)#....../\1$mycolor/g" "$file"
fi

file="/home/dawn/.local/share/fcitx5/themes/Wal-Dark-With-Border/highlight.svg"
if [ -f "$file" ]; then
	sed -i "s/\(<stop offset=\"100%\" stop-color=\"\)#....../\1$mycolor/g" "$file"
fi

file="/home/dawn/.local/share/fcitx5/themes/Wal-Dark-With-Border/panel.svg"
if [ -f "$file" ]; then
	sed -i "s/\(<stop offset=\"100%\" stop-color=\"\)#....../\1$mycolor/g" "$file"
fi
