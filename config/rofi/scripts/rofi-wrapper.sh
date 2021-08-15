#!/usr/bin/env bash

cd $(dirname $(realpath $0))

case "$1" in
    drun)     rofi -show drun -theme drun -drun-categories Curated
        ;;
    games)    rofi -show drun -theme games -drun-categories SteamLibrary \
                   -cache-dir ~/.cache/rofi-game-launcher
        ;;
    run)      rofi -show run -theme run
        ;;
    windows)  rofi -show window -theme window
        ;;
    options)  ./rofi-options-menu.sh
        ;;
    *)      echo "Usage: $0 {run,drun,games,windows,options}"
esac
