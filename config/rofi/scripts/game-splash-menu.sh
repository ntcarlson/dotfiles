#!/usr/bin/env bash

# Wrapper script to open the game splash menu for a given appid

cd $(dirname $(realpath $0))
source update-banner.sh

PLAY=""
OPTIONS=""
LIBRARY=""
ACHIEVEMENTS=""
NEWS=""
BACK=""

APPID=$1

list-icons() {
    echo $PLAY Play
    echo $LIBRARY Open in library
    echo $ACHIEVEMENTS Achievements
    echo $NEWS News
    echo $BACK Back
}

# See https://developer.valvesoftware.com/wiki/Steam_browser_protocol
# for a list of all commands that can be sent to Steam

handle-option() {
    case $1 in
        "$PLAY")          steam steam://rungameid/$APPID;;
        "$LIBRARY")       steam steam://nav/games/details/$APPID;;
        "$ACHIEVEMENTS")  steam steam://url/SteamIDAchievementsPage/$APPID;;
        "$NEWS")          steam steam://appnews/$APPID;;
        "$BACK")          ./rofi-wrapper.sh games;;
    esac
}

update-banner -w 3440 -h 360 -a $APPID
SELECTION="$(list-icons | rofi -dmenu -theme game-splash-menu)"
handle-option $SELECTION &
