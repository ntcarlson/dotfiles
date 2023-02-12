#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Script to control workspaces for multiple varied monitors
# (e.g. an 11" internal display with a 34" external monitor)
# Workspaces have different defaults depending on output geometry
# * Small screens will use a tabbed layout by default
# * Large screens will be padded so single windows don't fill the entire output

usage() {
    echo "Wrapper script to control output specific workspaces"
    echo "$0: {focus,move} <workspace>"
    exit 1
}

[ $# -ne 2 ] && usage

# Workspaces below this width will get a tabbed layout by default
tab_width_threshold=1800

# Workspaces will get padded so that single windows do not exceed this width
max_window_width=2200

# Parse the following workspace information:
# ws_new:     Name of the new workspace
# ws_current: Name of the current workspace
# ws_exists:  Flag set if the new workspace already exists
# ws_tabbed:  Flag set if the workspace should have a default tabbed layout
# ws_padding: The padding to apply to the workspace
# con_id:     Container ID of the selected container
# con_layout: Layout of the currently selected container
eval $(
    cat <(swaymsg -t get_workspaces)                 \
        <(swaymsg -t get_outputs)                    \
        <(swaymsg -t get_tree)                       \
        | jq --slurp --raw-output                    \
            --arg name "$2"                          \
            --arg _tab_thresh "$tab_width_threshold" \
            --arg _max_width  "$max_window_width"    \
    '
    flatten(1)
    | (.[] | select(.type == "output"    and .focused)) as $ws_output
    | (.[] | select(.type == "workspace" and .focused)) as $ws_current
    | ($name + "-" + $ws_output.name + ":" + $name)     as $ws_new
    | (.[].nodes? | .. | select(.focused?))             as $focused_con
    | (contains([{name: $ws_new}]))                     as $ws_exists
    | ($ws_output.rect.width)                           as $ws_width
    | ($_tab_thresh | tonumber)                         as $tab_thresh
    | ($_max_width  | tonumber)                         as $max_width
    | (
        "ws_current=\"" + $ws_current.name + "\"",
        "ws_new=\""     + $ws_new          + "\"",
        "con_id="     + ($focused_con.id | tostring),
        "con_layout=" + $focused_con.layout,
        if $ws_exists               then "ws_exists=1" else empty end,
        if $ws_width <= $tab_thresh then "ws_tabbed=1" else empty end,
        if $ws_width > $max_width
            then "ws_padding=" + (($ws_width - $max_width)/2 | tostring)
            else "ws_padding=0"
        end
    )
    '
)

case "$1" in
    "focus")
        swaymsg "gaps horizontal $ws_padding; workspace $ws_new"
        if [ -z "$ws_exists" ] && [ -n "$ws_tabbed" ]; then
            # Set layout of empty workspace to tabbed
            swaymsg "focus parent; layout tabbed"
        fi
        ;;
    "move")
        swaymsg "gaps horizontal $ws_padding"
        if [ -z "$ws_exists" ]; then
            # If the container we are moving is a single window, first create
            # a tabbed parent container and the move the parent container.
            # The new workspace will inherit this tabbed layout.
            # If the container we are moving is more complicated (like a 
            # horizontal split) we don't alter it.
            if [ -n "$ws_tabbed" ] && [ "$con_layout" == "none" ]; then
                swaymsg "split v; layout tabbed; focus parent"
            elif [ -z "$ws_tabbed" ] && [ "$con_layout" == "tabbed" ]; then
                swaymsg "split h; layout splith; focus parent"
            fi
        fi
        swaymsg "move workspace $ws_new"
        "$SCRIPT_DIR/firefox-sway-tabs.sh" "$con_id"
        ;;
    *) usage;;
esac
