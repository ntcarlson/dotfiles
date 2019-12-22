#!/bin/bash

DIR=$(dirname $(realpath $0))

WINDOW_ID_CONKY=/tmp/conky_window_id
WINDOW_ID_TOP=/tmp/polybar_top_window_id
WINDOW_ID_EXPANDED=/tmp/polybar_expanded_window_id

conky_launch() {
    # Hacky X11 magic to make Conky appear above polybar
    killall conky
    # xdotool search can't find Conky's window but fortunately Conky outputs it
    conky -c ~/.config/conky/config 2> /tmp/conky_out
    # Extract the hex window id from Conky's output
    HEX=$(awk '/drawing to created window/ {print $NF}' /tmp/conky_out | tr -d '()' | awk -Fx '{print $2}')
    WIN_ID=$(( 16#$HEX )) # convert to decimal
    xdotool windowunmap $WIN_ID
    echo $WIN_ID > $WINDOW_ID_CONKY
}

polybar_launch() {
    killall polybar

    polybar top &
    xdotool search --sync --pid $! > $WINDOW_ID_TOP

    polybar expanded &
    xdotool search --sync --pid $! > $WINDOW_ID_EXPANDED

    bar_collapse
}

launch() {
    # Temporarily disable conky until I update the config
    # conky_launch
    # sleep 0.2
    polybar_launch
}

bar_expand() {
    xdotool windowmap $(cat $WINDOW_ID_EXPANDED)
    xdotool windowunmap $(cat $WINDOW_ID_TOP)
}

bar_collapse() {
    xdotool windowunmap $(cat $WINDOW_ID_EXPANDED)
    xdotool windowmap $(cat $WINDOW_ID_TOP)
}

rofi_open() {
    options_close
    bar_expand &
    rofi -modi run -show run
    bar_collapse
}

drun_open() {
    bar_expand &
    rofi -theme drun -modi drun -show drun -drun-categories Custom
    bar_collapse
}

search_open() {
    options_close
    bar_expand &
    rofi -theme window -modi window -show window 
    bar_collapse
}

options_open() {
    bar_expand
    $DIR/rofi_option_menu 
    bar_collapse
    # echo "open" > /tmp/polybar_side_panel_state
    # ID_CONKY=$(cat $WINDOW_ID_CONKY)
    # xdotool windowmap $ID_CONKY
    # xdotool windowraise $ID_CONKY
    # ~/.config/i3/scripts/music_player show_applet
}

case "$1" in
    rofi)
        rofi_open;;
    search)
        search_open;;
    drun)
        drun_open;;
    options)
        options_open;;
    launch)
        launch;;
esac
