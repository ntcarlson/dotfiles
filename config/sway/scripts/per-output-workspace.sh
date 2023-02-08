#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Script to control workspaces for multiple varied monitors
# (e.g. an 11" internal display with a 34" external monitor)
# Workspaces have different defaults depending on output geometry
# * Small screens will use a tabbed layout by default
# * Large screens will be padded so single windows don't fill the entire output

# Workspaces below this width will get a tabbed layout by default
tab_width_threshold=1800

# Workspaces will get padded so that single windows do not exceed this width
max_window_width=2000

# Gets get the following workspace information:
# ws_new: Name of the new workspace
# ws_exists: Whether or not the new workspace already exists
# ws_current: The name of the current workspace
get-workspace-info() {
    swaymsg -t get_workspaces | jq -r --arg name "$1" '
        (.[] | select(.focused == true).output) as $ws_output
        | ($name + "-" + $ws_output + ":" + $name) as $ws_new
        | (
            "ws_new=\""     + $ws_new + "\"",
            "ws_exists=\""  + (contains([{name: $ws_new}]) | tostring) + "\"",
            "ws_current=\"" + (.[] | select(.focused == true).name) + "\""
        )
    '
}

# Gets the width of the current output
get-output-width() {
    swaymsg -t get_outputs | jq '.[]
        | select(.focused == true).current_mode.width
    '
}

# Apply default settings for a new workspace depending on its size
apply-defaults() {
    width="$1"

    # Tabbed layout by default for small workspaces
    if [ "$width" -le "$tab_width_threshold" ]; then
        swaymsg "focus parent; split v; layout tabbed; focus child"
    else 
        swaymsg "focus parent; split h; layout splith; focus child"
    fi

    # Use smart gaps to control the size of windows in large workspaces
    if [ "$width" -gt "$max_window_width" ]; then
        smart_gaps=$(( (width - max_window_width)/2 ))
        swaymsg "gaps horizontal current set $smart_gaps"
    fi
}

usage() {
    echo "Wrapper script to control output specific workspaces"
    echo "$0: {focus,move} <workspace>"
    exit 1
}


[ $# -ne 2 ] && usage

eval "$(get-workspace-info "$2")"
output_width="$(get-output-width)"

case "$1" in
    "focus")
        swaymsg "workspace $ws_new"
        if [ "$ws_exists" == "false" ]; then
            apply-defaults "$output_width"
        fi
        ;;
    "move")
        swaymsg "move workspace $ws_new"
        swaymsg "workspace $ws_new"
        "$SCRIPT_DIR/firefox-sway-tabs.sh"
        if [ "$ws_exists" == "false" ]; then
            apply-defaults "$output_width"
        fi
        swaymsg "workspace back_and_forth"
        ;;
    *) usage;;
esac
