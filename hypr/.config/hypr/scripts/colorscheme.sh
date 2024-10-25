#!/bin/bash

filename="/home/dawn/.cache/mycolorscheme"

if [ -f "$filename" ] && [ -s "$filename" ]; then
  colorscheme=$(<"$filename")
else
  colorscheme="Light"
fi

if [ "$colorscheme" = "Light" ]; then
  colorscheme="Dark"
else
  colorscheme="Light"
fi

/home/dawn/.config/rofi/scripts/rofi-colorscheme.sh "$colorscheme"
