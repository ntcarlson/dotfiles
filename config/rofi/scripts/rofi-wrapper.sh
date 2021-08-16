#!/usr/bin/env bash

cd $(dirname $(realpath $0))

case "$1" in
    drun)     rofi -show drun -theme drun -drun-categories Curated;;
    run)      rofi -show run -theme run;;
    windows)  rofi -show window -theme window;;
    options)  ./rofi-options-menu.sh;;
    games)
              ./update-game-entries.sh -q &
              rofi -show drun -theme games -drun-categories SteamLibrary \
                   -cache-dir ~/.cache/rofi-game-launcher

              # Emulate most recently used history by resetting the count
              # to 0 for each application
              sed -i -e 's/^1/0/' ~/.cache/rofi-game-launcher/rofi3.druncache
        ;;
    *)      echo "Usage: $0 {run,drun,games,windows,options}"
esac
