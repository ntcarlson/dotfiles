#!/usr/bin/env bash

SCRIPT_DIR="$(dirname $(realpath $0))"

GAME_LAUNCHER_CACHE=$HOME/.cache/rofi-game-launcher
APP_PATH=~/.local/share/applications/rofi-game-launcher

case "$1" in
    drun)     rofi -show drun -theme drun -drun-categories Curated;;
    run)      rofi -show run -theme sidebar;;
    windows)  rofi -show window -theme sidebar;;
    options)  $SCRIPT_DIR/rofi-options-menu.sh;;
    games)
        $SCRIPT_DIR/update-game-entries.sh -q &

        # Temporarily link then unlink the *.desktop files to the directory
        # where rofi looks for them to avoid having them appear when using
        # rofi normally
        if [ ! -e $APP_PATH ]; then
            ln -s $GAME_LAUNCHER_CACHE/applications $APP_PATH
        fi

        rofi -show drun -theme games -drun-categories SteamLibrary \
             -cache-dir $GAME_LAUNCHER_CACHE

        if [ -h $APP_PATH ]; then
            rm $APP_PATH
        fi

        # Emulate most recently used history by resetting the count
        # to 0 for each application
        sed -i -e 's/^1/0/' $GAME_LAUNCHER_CACHE/rofi3.druncache
        ;;
    *)  echo "Usage: $0 {run,drun,games,windows,options}"
esac
