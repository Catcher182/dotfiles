#!/usr/bin/bash
str=$(hyprctl -j getoption general:layout | jq '.str')
str_value="${str//\"/}"
if [ "$str_value" = "master" ]; then
	hyprctl keyword general:layout dwindle
else
	hyprctl keyword general:layout master
fi
