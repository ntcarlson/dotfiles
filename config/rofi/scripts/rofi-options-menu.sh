#!/bin/bash

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
            if $(rofi_confirm $SLEEP); then
                multilockscreen --lock blur &
                systemctl suspend
            fi
            ;;
        "$LOGOUT")
            if $(rofi_confirm $LOGOUT); then
                i3-msg exit
            fi
            ;;
        "$RESTART")
            if $(rofi_confirm $RESTART); then
                reboot
            fi
            ;;
        "$SHUTDOWN")
            if $(rofi_confirm $SHUTDOWN); then
                shutdown now
            fi
            ;;
    esac
}

SELECTION="$(list_icons | rofi -dmenu -theme options_menu)"
handle_option $SELECTION &
