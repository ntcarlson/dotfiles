#!/usr/bin/env bash

# Wrapper script invoke various Rofi menus with integration into Waybar

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

declare -A rofi_command
rofi_command=(
    [drun]="rofi -show drun -theme grid"
    [run]="rofi -show run -theme list"
    [window]="rofi -show window -theme list"
    [options]="bash $SCRIPT_DIR/rofi-options-menu.sh"
    [games]="bash $SCRIPT_DIR/rofi-game-launcher/open.sh"
)

# Toggle the given Rofi menu, first closing any other Rofi menus if necessary
rofi-toggle() {
    local mode="$1"

    if rofi-is-open "$mode"; then
        killall rofi
    else
        killall rofi
        eval "${rofi_command[$mode]}" &

        waybar-signal
        wait $!
        waybar-signal
    fi
}

# Check if the corresponding Rofi menu is already open
rofi-is-open() {
    local mode="$1"
    local rofi_pid
    rofi_pid="$(pgrep -f "^${rofi_command[$mode]}")"
    test -n "$rofi_pid"
}

# Signal Waybar to update its Rofi modules.
# SIGRTMIN+1 corresponds to "signal": 1 in the Waybar config
waybar-signal() {
    pkill -SIGRTMIN+1 waybar
}

# Output a JSON object that is used in the Waybar Rofi modules
waybar-icon() {
    local mode="$1"
    local icon tooltip class
    case "$mode" in
        drun)
            icon="󰕰"
            tooltip="Application launcher"
            ;;
        run)
            icon=""
            tooltip="Run command"
            ;;
        window)
            icon=""
            tooltip="Window list"
            ;;
        games)
            icon=""
            tooltip="Game launcher"
            ;;
        options)
            icon=""
            tooltip="Options menu"
            ;;
        *) usage;;
    esac

    if rofi-is-open "$mode"; then
        class="open"
    else
        class="closed"
    fi

cat <<EOF
{"text": "$icon", "tooltip": "$tooltip", "class": "$class" }
EOF
}

usage() {
    echo "Open the specified Rofi menu"
    echo "Usage: $0 [options] [icon] {run,drun,window,games,options}"
    exit 1
}

while getopts "f:b:o:t:a:u:-:" OPT; do
    if [ "$OPT" == "-" ]; then
        # Split long argument on = into argument name and value
        OPT="${OPTARG%%=*}"
        OPTARG="${OPTARG#*=}"
    fi
    case "$OPT" in
        f | font)               export ROFI_FONT="\"$OPTARG\"";;
        b | background-color)   export ROFI_BACKGROUND_COLOR="$OPTARG";;
        o | background-opacity) opacity="$OPTARG";;
        t | text-color)         export ROFI_TEXT_COLOR="$OPTARG";;
        a | accent-color)       export ROFI_ACCENT_COLOR="$OPTARG";;
        u | urgent-color)       export ROFI_URGENT_COLOR="$OPTARG";;
        ??*) echo "Unknown option --$OPT"; usage;;
        ?) usage;;
  esac
done
shift $((OPTIND-1))

if [ -n "$opacity" ] && [ -n "$ROFI_BACKGROUND_COLOR" ]; then
    # Convert opacity as a percentage to the alpha component of RGBA
    hex_opacity="$(printf "%x" $(echo "255 * ${opacity%\%} / 100" | bc))"
    export ROFI_BACKGROUND_TRANSPARENT="${ROFI_BACKGROUND_COLOR}${hex_opacity}"
fi

case "$1" in
    drun)   ;&
    run)    ;&
    window) ;&
    games)  ;&
    options) rofi-toggle "$1";;
    icon)    waybar-icon "$2";;
    *)       usage;;
esac
