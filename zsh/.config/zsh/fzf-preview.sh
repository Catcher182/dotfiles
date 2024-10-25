#!/usr/bin/env bash

if [[ $# -ne 1 ]]; then
  >&2 echo "usage: $0 FILENAME"
  exit 1
fi

file=${1/#\~\//$HOME/}

dim=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}
if [[ $dim = x ]]; then
  dim=$(stty size </dev/tty | awk '{print $2 "x" $1}')
elif ! [[ $KITTY_WINDOW_ID ]] && ((FZF_PREVIEW_TOP + FZF_PREVIEW_LINES == $(stty size </dev/tty | awk '{print $1}'))); then
  # Avoid scrolling issue when the Sixel image touches the bottom of the screen
  # * https://github.com/junegunn/fzf/issues/2544
  dim=${FZF_PREVIEW_COLUMNS}x$((FZF_PREVIEW_LINES - 1))
fi

# 1. Use kitty icat on kitty terminal
if [[ $KITTY_WINDOW_ID ]]; then
  # 1. 'memory' is the fastest option but if you want the image to be scrollable,
  #    you have to use 'stream'.
  #
  # 2. The last line of the output is the ANSI reset code without newline.
  #    This confuses fzf and makes it render scroll offset indicator.
  #    So we remove the last line and append the reset code to its previous line.
  kitty icat --clear --transfer-mode=memory --unicode-placeholder --stdin=no --place="$dim@0x0" "$file" | sed '$d' | sed $'$s/$/\e[m/'

# 2. Use chafa with Sixel output
elif command -v chafa >/dev/null; then
  chafa -s "$dim" "$file"
  # Add a new line character so that fzf can display multiple images in the preview window
  echo
else
  exiftool "$file"
fi
