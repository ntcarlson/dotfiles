#!/usr/bin/env bash

# Script to show/hide conky info panel as part of the options menu

WINDOW_ID_CONKY=/tmp/conky_window_id

conky_launch() {
    killall conky
    # xdotool search can't find Conky's window but fortunately Conky outputs it
    conky 2> /tmp/conky_out
    # Extract the hex window id from Conky's output
    local win_id=$(awk '/drawing to created window/ {print $NF}' /tmp/conky_out | tr -d '()')
    xdotool windowunmap $win_id
    echo $win_id > $WINDOW_ID_CONKY
}

conky_show() {
    local win_id=$(cat $WINDOW_ID_CONKY)
    xdotool windowmap $win_id
    xdotool windowraise $win_id
}

conky_hide() {
    local win_id=$(cat $WINDOW_ID_CONKY)
    xdotool windowunmap $win_id
}

case "$1" in
    launch) conky_launch;;
    show)   conky_show;;
    hide)   conky_hide;;
    *)      echo "Usage: $0 {launch,show,hide}"
esac
