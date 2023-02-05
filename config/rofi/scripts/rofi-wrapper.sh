#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

declare -A rofi_command
rofi_command=(
    [drun]="rofi -show drun -theme grid"
    [run]="rofi -show run -theme list"
    [window]="rofi -show window -theme list"
    [options]="bash $SCRIPT_DIR/rofi-options-menu.sh"
)

rofi-toggle() {
    local mode="$1"
    local theme="$2"

    if rofi-is-open "$mode"; then
        killall rofi
    else
        killall rofi
        eval "${rofi_command[$mode]}" &

        waybar-signal
        wait $!
        waybar-signal
    fi
}

rofi-is-open() {
    local mode="$1"
    local rofi_pid
    rofi_pid="$(pgrep -f "^${rofi_command[$mode]}")"
    test -n "$rofi_pid"
}

waybar-signal() {
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
        window)
            icon=""
            tooltip="Window list"
            ;;
        options)
            icon=""
            tooltip="Options menu"
            ;;
        *) usage;;
    esac

    if rofi-is-open "$mode"; then
        class="open"
    else
        class="closed"
    fi

cat <<EOF
{"text": "$icon", "tooltip": "$tooltip", "class": "$class" }
EOF
}

usage() {
    echo "Usage: $0 [icon] {run,drun,window,options}"
    exit 1
}

case "$1" in
    drun)    rofi-toggle drun;;
    run)     rofi-toggle run;;
    window)  rofi-toggle window;;
    options) rofi-toggle options;;
    icon)    waybar-icon "$2";;
    *)       usage;;
esac
