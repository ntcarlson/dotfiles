#!/usr/bin/env bash

BACKLIGHT="/sys/class/leds/chromeos::kbd_backlight/brightness"

clamp() {
    if [[ $1 -lt 0 ]]; then 
        echo 0
    elif [[ $1 -ge 100 ]]; then
        echo 100
    else
        echo "$1"
    fi
}

current=$(cat $BACKLIGHT)
offset=10
case "$1" in
    "up")
        new=$(clamp $(( current + offset )))
        echo "$new" > $BACKLIGHT
        ;;
    "down")
        new=$(clamp $(( current - offset )))
        echo "$new" > $BACKLIGHT
        ;;
    "set")
        level=$2
        new=$(clamp "$level")
        echo "$new" > $BACKLIGHT
        ;;
    "get")
        cat $BACKLIGHT
        ;;
    *)
        echo "Usage: $0 <up|down|set <level>|get>"
esac
