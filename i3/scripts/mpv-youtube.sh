#!/bin/fish
# originally by Kris Occhipinti
# https://www.youtube.com/watch?v=FsQuGplQvrw

notify-send -t 3000 "Playing Video" "$(xclip -o)";
mpv --ytdl-format=bestvideo+bestaudio/best --fs --speed=1 --af=rubberband=pitch-scale=0.981818181818181 "$(xclip -o)"