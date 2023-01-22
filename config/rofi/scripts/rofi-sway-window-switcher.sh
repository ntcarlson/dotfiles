#!/usr/bin/env bash

# Gets a list of windows in a format ready to feed into Rofi. The output
# consists of headers listing the active window and urgent windows (if any).
# Then, it lists the window names with the con_id in the info field (accessed
# via $ROFI_INFO variable on selection).
window-list() {
    swaymsg -t get_tree | jq -r '
    def active: 
        "\u0000active\u001f" + (
            map(.focused == true) | index(true) | tostring
        )
    ;

    def urgent: 
        "\u0000urgent\u001f" + (
            map(.urgent == true) | indices(true) | .[] | tostring
        )
    ;

    def entries:
        .[] | .name + "\u0000" + "info" + "\u001f" + (.id | tostring)
    ;

    [
        recurse(.nodes[]?, .floating_nodes[]?)
        | select(.type=="con" or .type=="floating_con")
        | select(.name!=null)
    ] | active, urgent, entries
    '
}

# Rofi initially calls the script with no arguments to populate the menu.
#
# When an entry is selected, Rofi calls the script again with the selected
# entry as an argument (in this case, the window title). All we care about
# here is the ROFI_INFO variable which is set to the contents of the info
# column of the selected entry (in this case, the sway window ID)
if [ -z "$*" ]; then
    window-list
else
    swaymsg "[con_id=$ROFI_INFO]" focus > /dev/null
fi
