#!/bin/bash

# TOG: current sound status: "on" or "off" (i.e. mute)
TOG=`amixer get Master | awk '$0~/%/{print $6}' | tr -d '[]%'| head -1`

# Perform volume adjustment based on parameters: up, down or toggle
case $1 in
  up) # vol up
    if [ $TOG = "off" ]; then
      /usr/bin/amixer -q sset 'Master' playback toggle
      TOG="on"
    else
      /usr/bin/amixer -q sset 'Master' playback 5%+
    fi
    ;;
  down) # vol down
    if [ $TOG = "off" ]; then
      /usr/bin/amixer -q sset 'Master' playback toggle
      TOG="on"
    else
      /usr/bin/amixer -q sset 'Master' playback 5%-
    fi
    ;;
  toggle) # toggle mute
    /usr/bin/amixer -q sset 'Master' playback toggle
    TOG=`amixer get Master | awk '$0~/%/{print $6}' | tr -d '[]%'| head -1`
    ;;
  *)
    ;;
esac

# CURVOL: current volume
CURVOL=`amixer get Master | awk '$0~/%/{print $5}' | tr -d '[]%'| head -1`

# Display notification
if [ $TOG = "on" ]; then
  
  # Set icon
  if [ $CURVOL -gt 67 ]; then
    ICOVOL="audio-volume-high"
  elif  [ $CURVOL -gt 33 ]; then
    ICOVOL="audio-volume-medium"
  elif  [ $CURVOL -gt 0 ]; then
    ICOVOL="audio-volume-low"
  else
    ICOVOL="stock_volume-0"
  fi
  
  # Set volume bar
  x=$(expr $CURVOL / 4)
  y=$(expr 25 - $x)
  if [ $x -eq 0 ]; then
    x=''
    y='░░░░░░░░░░░░░░░░░░░░░░░░░░░░░'
  elif [ $y -eq 0 ]; then
    y=''
    x='▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓'
  else
    x=$(printf '▓%.0s' $(seq 1 $x))
    y=$(printf '░%.0s' $(seq -1 $y))
  fi
  
  # Send notification
  dunstify  -t 2000 -r 3434 --icon="$ICOVOL" "Volume-Status: $CURVOL%" "$x$y"
  
else
  # If muted
  ICOVOL="audio-volume-muted-blocking"
  dunstify  -t 2000 -r 3434 --icon="$ICOVOL" "Volume-Status: MUTED" "▒░▒░▒░▒░▒░▒░▒░▒░▒░▒░▒░▒░▒░▒░▒"
fi

# Play notification sound
canberra-gtk-play -i audio-volume-change &