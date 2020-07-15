#!/bin/bash

#map this script to Custom Shortcuts  at the bottom under Settings->Devices->Keyboard
#Name:      w/e
#Command:   sh /home/username/bin/betterSpotifyToggle   //tilde is not supported!

#TODO: move spotify at the bottom of the window manager focus

#Check if spotify is running
if ! ps --no-headers -C spotify -o args,state; then
    
    #Used for getting spotify out of focus
    windowId=$(xdotool getactivewindow)
    (spotify &)
    sleep 0.5;

    #Press play 
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
    sleep 0.5;

    #If not playing dont put spotify out of focus
    if pacmd list-sink-inputs | grep spotify; then
        xdotool windowfocus $windowId
        xdotool windowactivate $windowId
    fi

#If spotify are running, toggle play/pause
else
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
fi