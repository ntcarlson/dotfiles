#!/usr/bin/env bash

cd $(dirname $(realpath $0))
source update-game-entries.sh
source update-banner.sh

PLAY=""
OPTIONS=""
STEAM=""
BACK=""

APPID=$1

list-icons() {
    echo $PLAY Play
    echo $OPTIONS Options
    echo $STEAM Steam page
    echo $BACK Back
}

handle-option() {
    case $1 in
        "$PLAY")
            steam steam://rungameid/$APPID
            ;;
        "$OPTIONS")
            # This will open the Steam properties window for this game
            echo todo
            ;;
        "$STEAM")
            # This will open the Steam library page for this game
            echo todo
            ;;
        "$BACK")
            # This will return to the game browser menu (can search query
            # be preserved?)
            echo todo
            ;;
        *)
            update-game-entries
    esac
}

update-banner -w 3440 -h 360 -a $APPID
SELECTION="$(list-icons | rofi -dmenu -theme game_splash_menu)"
handle-option $SELECTION &
