#!/usr/bin/env bash

# Script to control workspaces for multiple varied monitors
# (e.g. an 11" internal display with a 34" external monitor)
# Workspaces have different defaults depending on output geometry
# * Small screens will use a tabbed layout by default
# * Large screens will be padded so single windows don't fill the entire output

# Workspaces below this width will get a tabbed layout by default
tab_width_threshold=1800

# Workspaces will get padded so that single windows do not exceed this width
max_window_width=2000

focused-output() {
    swaymsg -t get_outputs | \
        jq '.[] | select(.focused == true).name' --raw-output
}

workspace-exists() {
    name="$1"
    swaymsg -t get_workspaces | \
        jq ".[] | select(.name == \"$name\")" --exit-status \
        > /dev/null
}

workspace-width() {
    name="$1"
    swaymsg -t get_workspaces | \
        jq ".[] | select(.name == \"$name\").rect.width"
}

apply-defaults() {
    name="$1"
    width="$(workspace-width "$name")"

    echo $width
    # Tabbed layout by default for small workspaces
    if [ "$width" -le "$tab_width_threshold" ]; then
        echo test
        swaymsg "layout tabbed"
    fi

    # Use smart gaps to control the size of windows in large workspaces
    if [ "$width" -gt "$max_window_width" ]; then
        smart_gaps=$(( (width - max_window_width)/2 ))
        swaymsg "gaps horizontal current set $smart_gaps"
    fi
}

usage() {
    echo "$0: {focus,move} <workspace>"
    exit 1
}


[ $# -ne 2 ] && usage

output="$(focused-output)"
workspace="$2-$output:$2"

if ! workspace-exists "$workspace"; then
    create_workspace=1
fi

case "$1" in
    "focus")
        swaymsg "workspace $workspace"
        if [ -n "$create_workspace" ]; then
            apply-defaults "$workspace"
        fi
        ;;
    "move")
        swaymsg "move container to workspace $workspace"
        swaymsg "workspace --no-auto-back-and-forth $workspace"
        if [ -n "$create_workspace" ]; then
            apply-defaults "$workspace"
        fi
        ;;
    *) usage;;
esac
