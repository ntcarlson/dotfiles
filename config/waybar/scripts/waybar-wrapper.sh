#!/usr/bin/env bash

STYLE_SRC="$HOME/.config/waybar/style.css"
STYLE_OUT=/tmp/waybar_style.css

waybar-launch() {
    killall waybar
    cat "$STYLE_SRC" > "$STYLE_OUT"
    waybar -s "$STYLE_OUT" &
}

waybar-resize() {
    cat "$STYLE_SRC" > "$STYLE_OUT"
    cat << EOF >> "$STYLE_OUT"
box.vertical.modules-left,
box.vertical.modules-right {
    margin: 0px $1px 0px 0px;
}
EOF
    killall waybar -SIGUSR2
}

usage() {
    echo "$0 {launch,resize <size>}"
    exit 1
}

case "$1" in
    "launch") waybar-launch;;
    "resize")
        if [ -z "$2" ]; then
            usage
        fi
        waybar-resize "$2"
        ;;
    *) usage;;
esac
