#!/bin/bash

wget -O /tmp/wallpaper.jpg https://source.unsplash.com/random/1920x1080
gsettings set org.gnome.desktop.background picture-uri-dark "file:///tmp/wallpaper.jpg"
gsettings set org.gnome.desktop.background picture-options "zoom"

dbus-send --session --dest=org.gnome.Shell --type=method_call --print-reply \
/org/gnome/Shell org.gnome.Shell.Eval string:'global.reexec_self()'
