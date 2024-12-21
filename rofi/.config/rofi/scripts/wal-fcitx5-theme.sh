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

color_file="/home/dawn/.local/share/fcitx5/themes/Wal-With-Border/color.conf"
color_file_dark="/home/dawn/.local/share/fcitx5/themes/Wal-Dark-With-Border/color.conf"
theme_file="/home/dawn/.local/share/fcitx5/themes/Wal-With-Border/theme.conf"
theme_file_dark="/home/dawn/.local/share/fcitx5/themes/Wal-Dark-With-Border/theme.conf"

# 读取文件一内容
color=$(<"$color_file")
color_dark=$(<"$color_file_dark")

# 判断变量color是否存在
if [[ -z "$color" ]]; then
  exit 1
fi
if [[ -z "$color_dark" ]]; then
  exit 1
fi

if [ -f "$theme_file" ]; then
  sed -i "s|$color|$mycolor|g" "$theme_file"
fi
echo "$mycolor" >"$color_file"

if [ -f "$theme_file_dark" ]; then
  sed -i "s|$color_dark|$mycolor|g" "$theme_file_dark"
fi
echo "$mycolor" >"$color_file_dark"
