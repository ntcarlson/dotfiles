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
            if $($SCRIPT_DIR/rofi-confirm.sh "Confirm suspend"); then
                multilockscreen --lock blur &
                systemctl suspend
            fi
            ;;
        "$LOGOUT")
            if $($SCRIPT_DIR/rofi-confirm.sh "Confirm logout"); then
                i3-msg exit
            fi
            ;;
        "$RESTART")
            if $($SCRIPT_DIR/rofi-confirm.sh "Confirm reboot"); then
                reboot
            fi
            ;;
        "$SHUTDOWN")
            if $($SCRIPT_DIR/rofi-confirm.sh "Confirm shutdown"); then
                shutdown now
            fi
            ;;
    esac
}

{
    SELECTION="$(list_icons | rofi -dmenu -theme options-menu)"
    handle_option $SELECTION &
    sleep 0.05
    ~/.config/conky/conky-wrapper.sh show
    wait $!
    ~/.config/conky/conky-wrapper.sh hide
} &
sleep 0.05
~/.config/conky/conky-wrapper.sh show
