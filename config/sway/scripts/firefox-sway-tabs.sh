#!/usr/bin/env bash

# Native Sway tabs are used in lieu of Firefox tabs
# This script ensures that Firefox windows get arranged in a tabbed layout
# without affecting any other windows

focused-appid() {
    swaymsg -t get_tree | jq -r '
        .. | select(.focused? == true).app_id
    '
}

focused-layout() {
    swaymsg -t get_tree | jq -r '
        .. | select(.nodes?[]?.focused == true).layout
    '
}

workspace-layout() {
    swaymsg -t get_workspaces | jq -r '
        .[] | select(.focused == true).layout
    '
}


# Checks if all the other windows in the parent container are Firefox windows
is-firefox-container() {
    swaymsg -t get_tree | jq '
        [
            ..
            | select(.nodes?[]?.focused == true).nodes[]
            | .app_id == "firefox" or .focused == true
        ] 
        | contains([false]) or length < 2
        | not
    '
}

grandparent-container() {
    swaymsg -t get_tree | jq '..
        | select(.nodes?[]?.nodes?[]?.focused == true).id
    '
}

appid="$(focused-appid)"
echo "$appid $layout" >> ~/foobar

if [ "$appid" == "firefox" ]; then
    layout="$(focused-layout)"
    echo "$layout"
    if [ "$layout" != "tabbed" ] && [ "$layout" != "stacked" ]; then
        swaymsg "split h; layout tabbed"
    fi
else
    if [ "$(is-firefox-container)" == "true" ] && [ "$(workspace-layout)" != "tabbed" ]; then
        swaymsg "focus parent; split v; focus child; move down; move right"
    fi
fi
