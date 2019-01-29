#!/bin/bash

# Controls the app launcher (Plank) used in tablet mode

SCRIPT_DIR=$(dirname $(realpath $0))
APP_WIN_ID=/tmp/plank_win_id
APP_PID=/tmp/plank_pid

start() {
    plank &
    echo $! > $APP_PID
    APP_WIN=$(xdotool search --sync --onlyvisible --class "plank")
    xdotool set_window --overrideredirect 1 $APP_WIN
    xdotool windowsize $APP_WIN x 160
    xdotool windowunmap $APP_WIN
    echo $APP_WIN > $APP_WIN_ID
}

show() {
    local win=$(cat $APP_WIN_ID)
    xdotool windowmap $win
    xdotool set_window --overrideredirect 1 $win
    xdotool windowraise $win
}

hide() {
    local win=$(cat $APP_WIN_ID)
    xdotool windowunmap $win
}

set_height() {
    local win=$(cat $APP_WIN_ID)
    xdotool windowmove $win x $1
}

close() {
    local pid=$(cat $APP_PID)
    $SCRIPT_DIR/polybar expand 0
    if [ "$(ps -p $pid -o comm=)" == "plank" ]; then
        kill $pid
    fi
}

case "$1" in
    start)
        start;;
    show)
        show;;
    hide)
        hide;;
    close)
        close;;
    set_height)
        set_height $2;;
esac
