#/usr/bin/env bash

APP_PATH=$HOME/.local/share/applications
ICON_PATH=$HOME/.local/share/Steam/appcache/librarycache
EXEC_STR="Exec=steam steam://rungameid/"

for shortcut in $APP_PATH/*.desktop; do
    appid=$(grep -e "^$EXEC_STR[[:digit:]]*" "$shortcut" | grep -o -e "[[:digit:]]*$")

    if [ ! -z $appid ]; then
        echo "Updating $(basename "$shortcut")"
        box_art="$ICON_PATH/${appid}_library_600x900.jpg"
        header="$ICON_PATH/${appid}_header.jpg"
        if [ ! -z $box_art ]; then
            file_data=$(file -F, $box_art | awk -F", " '{print $2}' )
            if [ "$file_data" == "JPEG image data" ] ; then
                sed -i "s:^Icon=.*$:Icon=$box_art:g" "$shortcut"
                sed -i "s:^Categories=.*:Categories=SteamLibrary;:g" "$shortcut"
            else
                echo "Could not update $shortcut: $box_art is invalid"
            fi
        else
            echo "Could not update $shortcut: file $box_art does not exist"
        fi
    fi
done
