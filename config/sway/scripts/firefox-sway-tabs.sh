#!/usr/bin/env bash

# Native Sway tabs are used in lieu of Firefox tabs
# This script ensures that Firefox windows get arranged in a tabbed layout
# without affecting any other windows


# Parse Sway window tree for the following information:
# is_firefox: Focused window is a Firefox window
# con_layout: Layout of parent container of focused window
# ws_layout: Default layout of the entire workspace
# is_firefox_container: A Firefox container is a container exclusively holding
#                       one or more Firefox windows. Other windows should not
#                       get placed in such containers.
eval $(
    swaymsg -t get_tree | jq -r '

        def app_id: select(.focused? == true).app_id;
        def parent: select(.nodes?[]?.focused == true);
        def siblings: parent | .nodes[];
        def current_workspace:
            select(.type? == "workspace")
            | select(.. | .focused? == true)
        ;
        def is_firefox_container:
            [.. | siblings | .app_id == "firefox" or .focused == true]
            | contains([false]) or length < 2
            | not
        ;
        

        (.. | (
            "is_firefox=" + (app_id == "firefox" | tostring),
            "con_layout=" + (parent | .layout),
            "ws_layout=" + (current_workspace | .layout)
        )),
        "is_firefox_container=" + (is_firefox_container | tostring)
    '
)

if [ "$is_firefox" == "true" ]; then
    if [ "$con_layout" != "tabbed" ] && [ "$con_layout" != "stacked" ]; then
        # Create a new tabbed container for lone Firefox windows
        swaymsg "split h; layout tabbed"
    fi
else
    if [ "$is_firefox_container" == "true" ] && [ "$ws_layout" != "tabbed" ]; then

        # Unless the workspace uses a tabbed layout by default, move the
        # non-Firefox window out of the Firefox container
        swaymsg "focus parent; split v; focus child; move down; move right"
    fi
fi
