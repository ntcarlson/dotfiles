#/usr/bin/env bash

# Generates .desktop entries for all installed Steam games with box art for
# the icons to be used with a specifically configured Rofi launcher

STEAM_ROOT=$HOME/.local/share/Steam
APP_PATH=$HOME/.local/share/applications/steam

# Fetch all Steam library folders.
steam_libraries() {
    echo $STEAM_ROOT

    # Additional library folders are recorded in libraryfolders.vdf
    libraryfolders=$STEAM_ROOT/steamapps/libraryfolders.vdf
    if [ -e $libraryfolders ]; then
        awk -F\" '/^[[:space:]]*"[[:digit:]]+"/ {print $4}' $libraryfolders
    fi
}

# Generate the contents of a .desktop file for a Steam game.
# Expects appid, title, and box art file to be given as arguments
desktop_entry() {
cat <<EOF
[Desktop Entry]
Name=$2
Exec=steam steam://rungameid/$1
Icon=$3
Terminal=false
Type=Application
Categories=SteamLibrary;
EOF
}


mkdir -p $APP_PATH
for library in $(steam_libraries); do
    # All installed Steam games correspond with an appmanifest_<appid>.acf file
    for manifest in $library/steamapps/appmanifest_*.acf; do
        appid=$(basename $manifest | grep -oe "[[:digit:]]*")
        title=$(awk -F\" '/"name"/ {print $4}' $manifest | tr -d "™®")
        boxart=$STEAM_ROOT/appcache/librarycache/${appid}_library_600x900.jpg
        entry=$APP_PATH/${title}.desktop

        # Check that the box art exists.
        # This filters out non-game entries like Proton versions
        if [ -f $boxart ]; then
            echo "Generating $entry..."
            desktop_entry $appid "$title" $boxart > $entry
        fi
    done
done
