#!/bin/bash
# dmenu_ffmpeg
# Copyright (c) 2021 M. Nabil Adani <nblid48[at]gmail[dot]com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# required
# - ffmpeg
# - rofi
# - libpulse
# - xorg-xdpyinfo
# - jq
# - pulseaudo/pipewire-pulse
# - x264

ROFI_CMD="${ROFI_CMD:-rofi -dmenu -i}"
VIDEO_FOLDER="${VIDEO_FOLDER:-$HOME/Videos/record}"
AUDIO_FOLDER="${AUDIO_FOLDER:-$HOME/Music/record}"
VIDEO_CODEC="${VIDEO_CODEC:-h264}" # h264

VIDEO_EXTENSION=".webm"

if [ "$VIDEO_CODEC" = "h264" ]; then
	VIDEO_EXTENSION=".mp4"
fi

recordid="/tmp/recordid"

function audioVideo() {
	filename="$VIDEO_FOLDER/video-$(date '+%Y%m%d-%H%M%S')"$VIDEO_EXTENSION

	if [ $XDG_SESSION_TYPE = "wayland" ]; then
		notify-send "Start Recording" "With:\nVideo On\nAudio On"
		wf-recorder --audio -g "$(slurp)" --file=$filename &
		echo $! >$recordid
	else
		notify-send "Start Recording" "With:\nVideo On\nAudio On"
		ffmpeg -f x11grab -video_size 1920x1080 -i :0.0 -f pulse -ac 2 -i default $filename &
		echo $! >$recordid
	fi

}

function video() {
	filename="$VIDEO_FOLDER/video-$(date '+%Y%m%d-%H%M%S')"$VIDEO_EXTENSION

	if [ $XDG_SESSION_TYPE = "wayland" ]; then
		notify-send "Start Recording" "With:\nVideo On\nAudio Off"
		wf-recorder -g "$(slurp)" --file=$filename &
		echo $! >$recordid
	else
		notify-send "Start Recording" "With:\nVideo On\nAudio Off"
		ffmpeg -video_size 1920x1080 -framerate 25 -f x11grab -i :0.0 $filename &
		echo $! >$recordid
	fi
}

function audio() {
	filename="$AUDIO_FOLDER/audio-$(date '+%Y%m%d-%H%M%S').wav"
	notify-send "Start Recording" "With:\nVideo Off\nAudio On"
	arecord -f cd -r 44100 -t wav $filename &
	echo $! >$recordid
}

function stoprecord() {
	if [ -f $recordid ]; then
		kill -15 $(cat $recordid)
		rm $recordid
	fi

	sleep 5
	if [ "$(pidof ffmpeg)" != "" ]; then
		pkill ffmpeg
	fi
}

function endrecord() {
	OPTIONS='["Yes", "No"]'
	select=$(echo $OPTIONS | jq -r ".[]" | $ROFI_CMD -p "Record" -mesg "Stop Recording" -theme-str 'window {width: 30%;} listview {lines: 2;}')
	[ "$select" == "Yes" ] && stoprecord
}

function startrecord() {
	OPTIONS='''
    [
        ["Audio & Video",      "audioVideo"],
        ["Video Only",         "video"],
        ["Audio Only",         "audio"]
    ]
    '''
	select=$(echo $OPTIONS | jq -r ".[][0]" | $ROFI_CMD -p "Record" -theme-str 'window {width: 30%;} listview {lines: 8;}')

	if [ ${#select} -gt 0 ]; then
		eval $(echo $OPTIONS | jq -r ".[] | select(.[0] == \"$select\") | .[1]")
	else
		exit 1
	fi
}

function createSaveFolder() {
	if [ ! -d $VIDEO_FOLDER ]; then
		mkdir -p $VIDEO_FOLDER
	fi
	if [ ! -d $AUDIO_FOLDER ]; then
		mkdir -p $AUDIO_FOLDER
	fi
}

createSaveFolder

if [ -f $recordid ]; then
	endrecord
else
	startrecord
fi
