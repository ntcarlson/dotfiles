#!/bin/bash

ICON="$1"

case "$(echo -e "Cancel\nConfirm" | rofi -dmenu -theme confirmation_dialog -mesg "$ICON" )" in
    "Cancel")  exit 1;;
    "Confirm") exit 0;;
esac

exit 1
