#!/usr/bin/env bash

# Open a Rofi options menu to lock the screen, logout, suspend, etc.

# Populate arrays containing the menu information
declare -a entries
declare -A operation icon confirm
create-menu-entries() {
    local entry_struct
    local menu=(
        # Entry        Icon Operation                   Require confirmation
        '("Lock"       ""  "swaymsg exec \$lock"       "false")'
        '("Logout"     "󰍃"  "swaymsg exit"              "true")'
        '("Suspend"    ""  "systemctl suspend"         "true")'
        '("Reboot"     ""  "reboot"                    "true")'
        '("Shutdown"   ""  "shutdown now"              "true")'
        '("Screenshot" ""  "swaymsg exec \$screenshot" "false")'
    )

    # Create associative arrays out of the fake multidimensional array
    for entry in "${menu[@]}"; do
        eval entry_struct="${entry[*]}"
        name="${entry_struct[0]}"
        entries+=("$name")
        icon[$name]="${entry_struct[1]}"
        operation[$name]="${entry_struct[2]}"
        confirm[$name]="${entry_struct[3]}"
    done
}

# Open the Rofi options menu
rofi-menu() {
    for entry in "${entries[@]}"; do
        echo -e "${icon[$entry]}\t$entry"
    done | rofi -dmenu -theme options_menu
}

# Execute the command corresponding with the selected menu entry
rofi-select() {
    local selection="${1##*$'\t'}"
    [ -z "$selection" ] && exit 1
    if [ "${confirm[$selection]}" == "true" ]; then
        rofi-confirm "$selection" && eval "${operation[$selection]}"
    else
        eval '${operation[$selection]}'
    fi
}

# Open a Rofi menu to prompt for confirmation before executing a command
rofi-confirm() {
    local message="Confirm $1?"
    local options="\t Cancel\n\t Confirm"
    local selection

    selection="$(echo -e "$options" | \
        rofi -dmenu -theme options_menu -mesg "$message" )"
    if [ "${selection##* }" == "Confirm" ]; then
        return 0
    else
        return 1
    fi
}

create-menu-entries
rofi-select "$(rofi-menu)"
