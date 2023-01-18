#!/usr/bin/env bash

BACKLIGHT="/sys/class/leds/chromeos::kbd_backlight/brightness"
SAVED_STATE="/tmp/backlight_restore_state"

clamp() {
    if [[ $1 -lt 0 ]]; then 
        echo 0
    elif [[ $1 -ge 100 ]]; then
        echo 100
    else
        echo "$1"
    fi
}

transition() {
    start=$1
    end=$2
    step_size=1
    steps=$(( (start - end)/step_size ))
    [ $steps -le 0 ] && steps=$((-steps))
    for i in $(seq 1 $((steps-1)) ); do
        echo "$((start + i*(end - start)/steps))"
        sleep 0.2
    done
    echo "$end"
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
    "dim")
        old=$(cat $BACKLIGHT)
        echo "$old" > $SAVED_STATE
        transition $old 0 >> $BACKLIGHT
        ;;
    "restore")
        if [ -e $SAVED_STATE ]; then
            new=$(cat $SAVED_STATE)
        else
            new=0
        fi
        for pid in $(pgrep -f "bash $0"); do
            if [ ! $pid == $$ ]; then
                kill -9 $pid
            fi
        done
        old=$(cat $BACKLIGHT)
        echo "$new" > $BACKLIGHT
        ;;
    *)
        echo "Usage: $0 <up|down|set <level>|get|dim|restore>"
esac
