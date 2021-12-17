#!/usr/bin/env bash


# Gets a list of windows in a tab separated table containing
# Sway window id, application name, window title, and focused status 
get-windows() {
    swaymsg -t get_tree | \
        jq -r 'recurse(.nodes[]?) | recurse(.floating_nodes[]?) 
                | select(.type=="con"),select(.type=="floating_con")
                | "ID=" + (.id|tostring) 
                + "\tAPPID=\"" + .app_id + "\""
                + "\tTITLE=\"" + .name + "\""
                + "\tFOCUSED=" + (.focused|tostring)'
}

desktop-entries() {
    find {~/.local/share/applications,/usr/share/applications} -name "*.desktop"
}

# Try to match an application name or window name to a .desktop file in
# /usr/share/applications and grab the corresponding icon
get-icon() {
    APPID="$1"
    TITLE="$2"

    # First, try to guess the application based on the app_id reported by sway
    # Sometimes, this field is empty
    if [ -n "$APPID" ]; then
        SEARCH=$(tr -d "-" <<< "$APPID")
        APP=$(desktop-entries | fzf -i -f "$SEARCH" | head -n 1)
        if [ -n "$APP" ]; then 
            grep -Poe '(?<=Icon=).*' $APP
            return
        fi
    fi

    # If that fails, try to guess the application based on window title based
    # on the title convention where the application name is separated by a -
    # e.g. <page title> - Mozilla Firefox or <file name> - GVim
    SEARCH=$(awk -F"-" '{print $NF}' <<< "$TITLE")
    APP=$(desktop-entries | fzf -i -f "$SEARCH" | head -n 1)
    if [ -n "$APP" ]; then 
        grep -Poe '(?<=Icon=).*' $APP
    fi

}

# Rofi initially calls the script with no options
if [ -z "$@" ]; then
    while read -r window; do
        # Set the ID, APPID, TITLE, and FOCUSED variables defined in the 
        # window string
        eval $(tr "\t" "\n" <<< "$window")

        ICON=$(get-icon "$APPID" "$TITLE")
        if [ -z "$ICON" ]; then
            echo -e "${TITLE}\0info\x1f${ID}"
        else
            echo -e "${TITLE}\0icon\x1f${ICON}\x1finfo\x1f${ID}"
        fi  
    done <<< $(get-windows)
else
    # When an entry is selected, Rofi calls the script again with the selected
    # entry as an argument (in this case, the window title). All we care about
    # here is the ROFI_INFO variable which is set to the contents of the info
    # column of the selected entry (in this case, the sway window ID)
    swaymsg "[con_id=$ROFI_INFO]" focus > /dev/null
fi
