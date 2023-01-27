#!/usr/bin/env bash

# Script to show/hide conky info panel as part of the options menu

WINDOW_ID_CONKY=/tmp/conky_window_id

conky_launch() {
    killall conky
    sleep 0.1

    conky &
    local win_id="$(xdotool search --sync --class "conky")"
    xdotool set_window --overrideredirect 1 "$win_id"
    xdotool windowunmap "$win_id"
    echo "$win_id" > $WINDOW_ID_CONKY
}

conky_show() {
    local win_id="$(cat $WINDOW_ID_CONKY)"
    xdotool windowmap "$win_id"
    xdotool windowraise "$win_id"
}

conky_hide() {
    local win_id="$(cat $WINDOW_ID_CONKY)"
    xdotool windowunmap "$win_id"
}

case "$1" in
    launch) conky_launch;;
    show)   conky_show;;
    hide)   conky_hide;;
    *)      echo "Usage: $0 {launch,show,hide}"
esac
