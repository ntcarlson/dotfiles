#!/usr/bin/env bash

# Applies Sway colors to an existing GTK theme

if [ $# -ne 7 ]; then
    echo "Usage: $0 <bg0> <bg1> <bg2> <text_light> <text_dark> <accent> <urgent>"
    exit
fi

source_theme="/usr/share/themes/Nordic"
dest_theme="$HOME/.local/share/themes/Sway"
colors="$dest_theme/gtk-3.0/_colors.scss"

replace-var() {
    file="$1"
    name="$2"
    val="$3"

    sed --in-place "s/^\$$name:.*/\$$name: $val;/g" $file
}

replace-vars() {
    file="$1"
    replace-var "$file" "bg_color"          "$2"
    replace-var "$file" "base_color"        "$3"
    replace-var "$file" "text_color"        "$5"
    replace-var "$file" "fg_color"          "$5"
    replace-var "$file" "selected_fg_color" "$6"
    replace-var "$file" "selected_bg_color" "$7"
}

if [ -f "$colors" ]; then
    # Check if theme needs to be regenerated
    cp "$source_theme/gtk-3.0/_colors.scss" "${colors}.tmp"
    replace-vars "${colors}.tmp" "$@"
    if ! diff "${colors}.tmp" "$colors"; then
        mv "${colors}.tmp" "$colors"
        sassc "$dest_theme/gtk-3.0/gtk.scss" "$dest_theme/gtk-3.0/gtk.css"
    fi
else
    mkdir -p $dest_theme/gtk-3.0
    cp -r $source_theme/* $dest_theme/
    replace-vars "$colors" "$@"
    sassc "$dest_theme/gtk-3.0/gtk.scss" "$dest_theme/gtk-3.0/gtk.css"
fi
