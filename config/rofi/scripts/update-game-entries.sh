#!/usr/bin/env bash

# Generates .desktop entries for all installed Steam games with box art for
# the icons to be used with a specifically configured Rofi launcher

SCRIPT_DIR=$(dirname $(realpath $0))

STEAM_ROOT=$HOME/.local/share/Steam
APP_PATH=$HOME/.local/share/applications/steam

# Fetch all Steam library folders.
steam-libraries() {
    echo "$STEAM_ROOT"

    # Additional library folders are recorded in libraryfolders.vdf
    libraryfolders=$STEAM_ROOT/steamapps/libraryfolders.vdf
    if [ -e "$libraryfolders" ]; then
        awk -F\" '/^[[:space:]]*"[[:digit:]]+"/ {print $4}' "$libraryfolders"
    fi
}

# Generate the contents of a .desktop file for a Steam game.
# Expects appid, title, and box art file to be given as arguments
desktop-entry() {
cat <<EOF
[Desktop Entry]
Name=$2
Exec=$SCRIPT_DIR/game-splash-menu.sh $1
Icon=$3
Terminal=false
Type=Application
Categories=SteamLibrary;
EOF
}

update-game-entries() {
    mkdir -p "$APP_PATH"
    for library in $(steam-libraries); do
        # All installed Steam games correspond with an appmanifest_<appid>.acf file
        for manifest in "$library"/steamapps/appmanifest_*.acf; do
            appid=$(basename "$manifest" | grep -oe "[[:digit:]]*")
            title=$(awk -F\" '/"name"/ {print $4}' "$manifest" | tr -d "™®/")
            boxart=$STEAM_ROOT/appcache/librarycache/${appid}_library_600x900.jpg
            entry=$APP_PATH/${title}.desktop

            # Filter out non-game entries (e.g. Proton versions or soundtracks) by
            # checking for boxart and other criteria
            if [ ! -f "$boxart" ]; then
                echo "Skipping $title"
                continue
            fi
            if echo "$title" | grep -qe "Soundtrack"; then
                echo "Skipping $title"
                continue
            fi
            echo "Generating $entry..."
            desktop-entry "$appid" "$title" "$boxart" > "$entry"
        done
    done
}
