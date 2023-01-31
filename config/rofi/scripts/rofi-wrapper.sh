#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
WAYBAR="$HOME/.config/waybar/scripts/waybar-wrapper.sh"

rofi-show() {
    local mode="$1"
    local theme="$2"

    "$WAYBAR" resize 400
    rofi -show "$mode" -theme "$theme" 
    "$WAYBAR" resize 0
}

rofi-toggle() {
    local rofi_pid
    rofi_pid="$(pgrep rofi)"
    if [ -z "$rofi_pid" ]; then
        $0 drun
    else
        kill -9 $rofi_pid
    fi
}

# Workaround to allow this script to be launched from Waybar itself without
# terminating as soon as the SIGUSR2 signal is sent to Waybar (which tries
# to kill all its child processes before restarting).
trap "" TERM

usage() {
    echo "Usage: $0 {run,drun,windows,options,toggle}"
    exit 1
}

case "$1" in
    drun)    rofi-show drun grid;;
    run)     rofi-show run list;;
    windows) rofi-show window list;;
    options) $SCRIPT_DIR/rofi-options-menu.sh;;
    toggle)  rofi-toggle;;
    *)       usage;;
esac
