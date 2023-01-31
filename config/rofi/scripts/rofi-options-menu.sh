#!/usr/bin/env bash

DIR=$(dirname $(realpath $0))

items=(
    # Entry        Icon Operation            Require confirmation
    '("Lock"       ""  "swaylock"           "false")'
    '("Logout"     ""  "swaymsg exit"       "true")'
    '("Suspend"    ""  "systemctl suspend"  "true")'
    '("Reboot"     ""  "reboot"             "true")'
    '("Shutdown"   ""  "shutdown now"       "true")'
    '("Screenshot" ""  "(sleep 0.1; grim)&" "false")'
)

declare -A operation icon confirm
declare -a entries

# Create associative arrays out of the fake multidimensional array
for item in "${items[@]}"; do
    eval list=${item[@]}
    name="${list[0]}"
    entries+=($name)
    icon[$name]="${list[1]}"
    operation[$name]="${list[2]}"
    confirm[$name]="${list[3]}"
done

rofi-menu() {
    for entry in ${entries[@]}; do
        echo -e "${icon[$entry]}\t $entry"
    done
}

rofi-select() {
    local selection="${1##* }"
    [ -z "$selection" ] && exit 1
    if [ "${confirm[$selection]}" == "true" ]; then
        rofi-confirm "$selection" && eval "${operation[$selection]}"
    else
        eval "${operation[$selection]}"
    fi
}

rofi-confirm() {
    local message="Confirm $1?"
    local options="\t Cancel\n\t Confirm"
    local selection

    selection="$(echo -e "$options" | rofi -dmenu -theme options_menu -mesg "$message" )"
    if [ "${selection##* }" == "Confirm" ]; then
        return 0
    else
        return 1
    fi
}

selection="$(rofi-menu | rofi -dmenu -theme options_menu)"
rofi-select "$selection"
