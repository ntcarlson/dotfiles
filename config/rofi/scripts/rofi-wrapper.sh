#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

rofi-show() {
    local mode="$1"
    local theme="$2"

    local rofi_pid
    pkill -SIGRTMIN+1 waybar
    rofi_pid="$(pgrep -f "rofi -show $mode")"
    if [ -n "$rofi_pid" ]; then
        kill -9 $rofi_pid
    else
        rofi_pid="$(pgrep rofi)"
        [ -n "$rofi_pid" ] && kill -9 $rofi_pid
        rofi -show "$mode" -theme "$theme"
    fi
    pkill -SIGRTMIN+1 waybar
}

waybar-icon() {
    local mode="$1"
    local icon tooltip class
    case "$mode" in
        drun)
            icon=""
            tooltip="Application launcher"
            ;;
        run)
            icon=""
            tooltip="Run command"
            ;;
        windows)
            icon=""
            tooltip="Window list"
            ;;
        options)
            icon=""
            tooltip="Options menu"
            ;;
        *) usage;;
    esac

    rofi_pid="$(pgrep -f "$0 $mode")"
    if [ -n "$rofi_pid" ]; then
        class="open"
    else
        class="closed"
    fi

cat <<EOF
{"text": "$icon", "tooltip": "$tooltip", "class": "$class" }
EOF
}

usage() {
    echo "Usage: $0 [icon] {run,drun,windows,options}"
    exit 1
}

case "$1" in
    drun)    rofi-show drun grid;;
    run)     rofi-show run list;;
    windows) rofi-show window list;;
    options) $SCRIPT_DIR/rofi-options-menu.sh;;
    icon)    waybar-icon "$2";;
    *)       usage;;
esac
