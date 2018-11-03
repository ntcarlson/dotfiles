#!/bin/bash

WINDOW_ID_CONKY=/tmp/conky_window_id

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

launch() {
    conky_launch
    sleep 0.2
    killall polybar
    polybar panel &
    BAR_ID=$!
    rm -f /tmp/polybar_mqueue_panel
    ln -s /tmp/polybar_mqueue.$BAR_ID /tmp/polybar_mqueue_panel
    sleep 0.2
    echo "cmd:hide" >> /tmp/polybar_mqueue_panel
    polybar top &
    BAR_ID=$!
    rm -f /tmp/polybar_mqueue_top
    ln -s /tmp/polybar_mqueue.$BAR_ID /tmp/polybar_mqueue_top
}

rofi_open() {
    options_close
    rofi -show run -location 0 -width 1924 -padding 700 -lines 10 -yoffset 0 -font 'DejaVu Sans 16'
}

search_open() {
    rofi -show window -location 1
}

options_open() {
    echo "hook:module/option_menu1" >> /tmp/polybar_mqueue_top
    echo "cmd:show" >> /tmp/polybar_mqueue_panel
    echo "open" > /tmp/polybar_side_panel_state
    ID_CONKY=$(cat $WINDOW_ID_CONKY)
    xdotool windowmap $ID_CONKY
    xdotool windowraise $ID_CONKY
    ~/.config/i3/scripts/music_player show_applet
}

options_close() {
    ID_CONKY=$(cat $WINDOW_ID_CONKY)
    xdotool windowunmap $ID_CONKY
    ~/.config/i3/scripts/music_player hide_applet
    echo "hook:module/option_menu1" >> /tmp/polybar_mqueue_top
    echo "cmd:hide" >> /tmp/polybar_mqueue_panel
    echo "close" > /tmp/polybar_side_panel_state
}

options_toggle() {
    if [ "$(cat /tmp/polybar_side_panel_state)" == "open" ]; then
        options_close
    else
        options_open
    fi
}

options_icon() {
    COLOR_NORMAL="%{F$(xrdb -query | awk '/^*foreground/ {print $2}')}"
    COLOR_ACTIVE="%{F$(xrdb -query | awk '/^*primary/ {print $2}')}"
    COLOR_END="%{F-}"

    if [ "$(cat /tmp/polybar_side_panel_state)" == "open" ]; then
        echo "$COLOR_ACTIVE$COLOR_END"
    else
        echo "$COLOR_NORMAL$COLOR_END"
    fi
}

case "$1" in
    rofi)
        rofi_open;;
    search)
        search_open;;
    options)
        options_toggle;;
    options_icon)
        options_icon;;
    launch)
        launch;;
    hide)
        echo "cmd:hide" >> /tmp/polybar_mqueue_top;;
    show)
        echo "cmd:show" >> /tmp/polybar_mqueue_top;;
esac
