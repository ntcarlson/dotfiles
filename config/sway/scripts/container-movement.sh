#!/usr/bin/env bash

# Wrapper script to make navigation commands (like focus left) work for moving
# between entire tabbed/stacked containers rather than within them.

is-tabbed() {
    swaymsg -t get_tree | jq -r '..
        | select(.nodes?[]?.focused == true)
        | .layout == "tabbed" or .layout == "stacked"
    '
}

if [ "$(is-tabbed)" == "true" ]; then
    swaymsg "focus parent; $@; focus child"
else
    swaymsg "$@"
fi
