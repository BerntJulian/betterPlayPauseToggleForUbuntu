#!/bin/bash

#map this script to Custom Shortcuts at the bottom under Settings->Devices->Keyboard
#Name:      w/e
#Command:   /home/{username}/bin/betterSpotifyToggle.sh   //tilde is not supported!
#TODO: move spotify at the bottom of the window manager focus

#Check if spotify is not running, if not open it.
if ! ps --no-headers -C spotify -o args,state; then
    windowId=$(xdotool getactivewindow)
    SECONDS=0
    timeForSpotifyToOpen=5
    (spotify &) 
    while (( SECONDS < timeForSpotifyToOpen )); do pidof spotify && { sleep 1;break; } done
    xdotool windowfocus $windowId
    xdotool windowactivate $windowId
fi

dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
sleep 0.3
pacmd list-sink-inputs | grep spotify && exit

spotifyWid=$(wmctrl -l | grep -P "\bSpotify( Premium)?$" | cut -f 1 -d " ")
xdotool windowfocus $spotifyWid
xdotool windowactivate $spotifyWid
