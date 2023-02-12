#!/usr/bin/env bash

# Native Sway tabs are used in lieu of Firefox tabs
# This script ensures that Firefox windows get arranged in a tabbed layout
# without affecting any other windows

con_id="$1"

# Parse Sway window tree for the following information:
# is_firefox: Selected container is a Firefox window
# con_layout: Layout of parent container of selected container
# parent_id:  ID of parent container of selected container
# ws_layout:  Default layout of the entire workspace
# is_firefox_container: A Firefox container is a container exclusively holding
#                       one or more Firefox windows. Other windows should not
#                       get placed in such containers.
eval $(
    swaymsg -t get_tree | jq --raw-output --arg con_id "$con_id" '

        def app_id($con_id): .. | select(.id? == $con_id).app_id;
        def parent($con_id): .. | select(.nodes?[]?.id == $con_id);
        def siblings($con_id): parent($con_id) | .nodes[];
        def workspace($con_id):
            ..
            | select(.type? == "workspace")
            | select(.. | .id? == $con_id)
        ;
        def is_firefox_container($con_id):
            [siblings($con_id) | .app_id == "firefox" or .id == $con_id]
            | contains([false]) or length < 2
            | not
        ;

        (if $con_id == ""
            then (.. | select(.focused?).id)
            else ($con_id | tonumber)
        end) as $id
        | (
            if (app_id($id) == "firefox") then "is_firefox=1" else empty end,
            "con_layout=" + (parent($id) | .layout),
            "parent_id="  + (parent($id) | .id | tostring),
            "ws_layout="  + (workspace($id) | .layout)
        ),
        if is_firefox_container($id) then "is_firefox_container=1" else empty end
    '
)

if [ -n "$is_firefox" ]; then
    if [ "$con_layout" != "tabbed" ] && [ "$con_layout" != "stacked" ]; then
        # Create a new tabbed container for lone Firefox windows
        if [ -n "$con_id" ]; then
            swaymsg "[con_id=$con_id] split h, layout tabbed"
        else
            swaymsg "split h; layout tabbed"
        fi
    fi
else
    if [ -n "$is_firefox_container" ] && [ "$ws_layout" != "tabbed" ]; then
        # Unless the workspace uses a tabbed layout by default, move the
        # non-Firefox window out of the Firefox container
        if [ -n "$con_id" ]; then
            swaymsg "[con_id=$parent_id] split v; [con_id=$con_id] move down, move right"
            swaymsg "workspace back_and_forth"
        else
            swaymsg "focus parent; split v; focus child; move down; move right"
        fi
    fi
fi
