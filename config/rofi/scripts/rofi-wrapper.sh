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

usage() {
    echo "Usage: $0 {run,drun,windows,options}"
    exit 1
}

case "$1" in
    drun)    rofi-show drun grid;;
    run)     rofi-show run list;;
    windows) rofi-show window list;;
    options) $SCRIPT_DIR/rofi-options-menu.sh;;
    *)       usage;;
esac
