#!/bin/bash
if file "$1" | grep -qE 'image'; then
  # exiftool "$1"
  /home/dawn/.config/zsh/fzf-preview.sh "$1"
elif file "$1" | grep -qE 'Media'; then
  exiftool "$1"
elif file "$1" | grep -qE 'Matroska'; then
  exiftool "$1"
else
  ctpv "$1"
fi
