#!/bin/bash

#map this script to Custom Shortcuts  at the bottom under Settings->Devices->Keyboard
#Name:      w/e
#Command:   sh /home/username/bin/betterSpotifyToggle   //tilde is not supported!

#TODO: move spotify at the bottom of the window manager focus

#Used for getting the windowfocus back to what program the original focus was. 
windowId=$(xdotool getactivewindow)

#Check if spotify is not running, if not open it.
if ! ps --no-headers -C spotify -o args,state; then    
    (spotify &)
    sleep 0.5;
fi

#Press play until soptify is open
while ! dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
do
    :
done
sleep 0.5;

#If spotify does not play music after play is pressed, keep spotify in focus.
if ! pacmd list-sink-inputs | grep spotify; then
    pid=$(pgrep spotify | head -n 1)                  
    windowId=$(xdotool search --pid "$pid" | tail -2) #-2 magic
fi

#Bring either original window or spotify in focus.
xdotool windowfocus $windowId
xdotool windowactivate $windowId
