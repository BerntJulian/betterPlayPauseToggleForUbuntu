#!/bin/bash

#map this script to Custom Shortcuts at the bottom under Settings->Devices->Keyboard
#Name:      w/e
#Command:   /home/{username}/bin/betterSpotifyToggle.sh   //tilde is not supported!

#Check if spotify is not running, if not open it.
if ! ps --no-headers -C spotify -o args,state; then
    windowId=$(xdotool getactivewindow)

    SECONDS=0; timeForSpotifyToOpen=7
    (spotify &) 

    while (( SECONDS < timeForSpotifyToOpen )); do
        wmctrl -l | cut -d" "  -f5- | grep -P "\bSpotify( Premium)?$" && break
    done
    (( SECONDS >= timeForSpotifyToOpen )) && notify-send "Could not open spotify" && exit

    spotifyWid=$(wmctrl -l | grep -P "\bSpotify( Premium)?$" | cut -f 1 -d " ")
    xdotool windowminimize $spotifyWid
    
    sleep 1
    
    xdotool windowfocus $windowId
    xdotool windowactivate $windowId
fi

dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
sleep 0.3

pacmd list-sink-inputs | grep spotify && exit

spotifyWid=$(wmctrl -l | grep -P "\bSpotify( Premium)?$" | cut -f 1 -d " ")
xdotool windowfocus $spotifyWid
xdotool windowactivate $spotifyWid
