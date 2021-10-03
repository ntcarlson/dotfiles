#!/usr/bin/env bash

cd $(dirname $(realpath $0))

GAME_LAUNCHER_CACHE=$HOME/.cache/rofi-game-launcher

case "$1" in
    drun)     rofi -show drun -theme drun -drun-categories Curated;;
    run)      rofi -show run -theme run;;
    windows)  rofi -show window -theme window;;
    options)  ./rofi-options-menu.sh;;
    games)
        ./update-game-entries.sh -q &

        (
            # Temporarily overwrite XDG_DATA_HOME so that Rofi looks for
            # .desktop files in $GAME_LAUNCHER/applications instead of
            # ~/.local/share/applications
            export XDG_DATA_HOME=$GAME_LAUNCHER_CACHE
            rofi -show drun -theme games -drun-categories SteamLibrary \
                 -cache-dir $GAME_LAUNCHER_CACHE
        )

        # Emulate most recently used history by resetting the count
        # to 0 for each application
        sed -i -e 's/^1/0/' $GAME_LAUNCHER_CACHE/rofi3.druncache
        ;;
    *)  echo "Usage: $0 {run,drun,games,windows,options}"
esac
