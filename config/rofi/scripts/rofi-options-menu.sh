#!/usr/bin/env bash

SCRIPT_DIR=$(dirname $(realpath $0))

LOCK=""
SLEEP=""
LOGOUT=""
RESTART=""
SHUTDOWN=""

list_icons() {
    echo $LOCK
    echo $SLEEP
    echo $LOGOUT
    echo $RESTART
    echo $SHUTDOWN
}

handle_option() {
    case "$1" in
        "$LOCK")
            multilockscreen --lock blur
            ;;
        "$SLEEP")
            if $($SCRIPT_DIR/rofi-confirm.sh $SLEEP); then
                multilockscreen --lock blur &
                systemctl suspend
            fi
            ;;
        "$LOGOUT")
            if $($SCRIPT_DIR/rofi-confirm.sh $LOGOUT); then
                i3-msg exit
            fi
            ;;
        "$RESTART")
            if $($SCRIPT_DIR/rofi-confirm.sh $RESTART); then
                reboot
            fi
            ;;
        "$SHUTDOWN")
            if $($SCRIPT_DIR/rofi-confirm.sh $SHUTDOWN); then
                shutdown now
            fi
            ;;
    esac
}

SELECTION="$(list_icons | rofi -dmenu -theme options_menu)"
handle_option $SELECTION &
