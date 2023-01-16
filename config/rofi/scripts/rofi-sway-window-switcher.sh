#!/usr/bin/env bash

# Array to associate icons with appids.
# Will fall back to a search if not specified here.
declare -A icon_by_appid=(
    [firefox]="firefox"
    [kitty]="kitty"
    [thunar]="org.xfce.thunar"
    [org.jellyfin.jellyfinmediaplayer]="com.github.iwalton3.jellyfin-media-player"
)

# Array to associate icons with window names.
# Will fall back to a search if not specified here.
declare -A icon_by_name=(
    [Mozilla Firefox]="firefox"
    [GVIM]="gvim"
)

# Gets a list of windows in a tab separated table containing Sway window id,
# application name, window title, and focused status. Each line of the output
# is in a format that can be eval'd to set variables holding these values.
get-windows() {
    swaymsg -t get_tree | \
        jq -r 'recurse(.nodes[]?, .floating_nodes[]?)
                | select(.type=="con" or .type=="floating_con")
                | select(.name!=null)
                | "id=" + (.id|tostring)
                + " appid=\"" + .app_id + "\""
                + " title=\"" + .name + "\""
                + " focused=" + (.focused|tostring)'
}

# Try to match an application name or window name to a .desktop file in
# /usr/share/applications and grab the corresponding icon
get-icon() {
    local icon

    # The ideal way to get application icon is from the appid
    local appid="$1"

    # Some applications don't set the appid field. In these cases, we can try
    # to guess the application assuming it follows the titling convention
    # where the application name is added as a suffix to the title separated
    # by a -. For example,
    #    Getting Started - Code - OSS
    #    [No name] - GVim
    local title="$2"
    local appname="${title##*- }"

    # Check if the icon is already listed in one of the arrays
    if [ -n "$appid" ] && [ -n "${icon_by_appid[$appid]}" ]; then
        echo "${icon_by_appid[$appid]}"
        return
    elif [ -n "$appname" ] && [ -n "${icon_by_name[$appname]}" ]; then
        echo "${icon_by_name[$appname]}"
        return
    fi

    # Fallback to searching for the icon first using the appid . . .
    icon="$(icon-search "$(tr -d "-" <<< "$appid")")"
    if [ -n "$icon" ]; then
        icon_by_appid[$appid]="$icon"
        echo "$icon"
        return
    fi

    # . . . and then using the name extracted from the title
    icon="$(icon-search "$appname")"
    if [ -n "$icon" ]; then
        icon_by_name[$appname]="$icon"
        echo "$icon"
        return
    fi
}

# Find an application icon by trying to match a .desktop file (which will
# specify the appropriate icon)
icon-search() {
    local search="$1"
    local app

    if [ -z "$search" ]; then
        return
    fi

    app="$(desktop-entries | fzf -i -f "$search" | head -n 1)"
    if [ -n "$app" ]; then
        grep -m 1 -Poe '(?<=Icon=).*' "$app"
    fi
}


# Get list of desktop entries to search
desktop-entries() {
    find {~/.local/share/applications,/usr/share/applications} -name "*.desktop"
}


# Produces the list of windows for Rofi to render
window-list() {
    local icon
    local i=0
    get-windows | while read -r window; do
        # Set the id, appid, title, and focused variables
        eval "$window"

        icon=$(get-icon "$appid" "$title")
        if [ -z "$icon" ]; then
            echo -e "${title}\0info\x1f${id}"
        else
            echo -e "${title}\0icon\x1f${icon}\x1finfo\x1f${id}"
        fi

        if [ "$focused" == "true" ]; then
            echo -e "\0active\x1f$i"
        fi
        i=$((i + 1))
    done
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
