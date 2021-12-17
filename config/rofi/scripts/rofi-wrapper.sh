#!/usr/bin/env bash

SCRIPT_DIR="$(dirname $(realpath $0))"

case "$1" in
    drun)     rofi -show drun -theme drun -drun-categories Curated;;
    run)      rofi -show run -theme sidebar;;
    windows)  rofi -show switcher \
                   -modi "switcher:$SCRIPT_DIR/rofi-sway-window-switcher.sh" \
                   -theme sidebar;;
    options)  $SCRIPT_DIR/rofi-options-menu.sh;;
    *)  echo "Usage: $0 {run,drun,windows,options}"
esac
