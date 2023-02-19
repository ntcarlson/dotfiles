#!/usr/bin/env bash

# Applies Sway colors to an existing GTK theme

echo $0 $* > ~/foobar
if [ $# -ne 7 ]; then
    echo "Usage: $0 <bg0> <bg1> <bg2> <text_light> <text_dark> <accent> <urgent>"
    exit
fi

source_theme="/usr/share/themes/Nordic"
dest_theme="$HOME/.local/share/themes/Sway"

mkdir -p $dest_theme
cp -r $source_theme/* $dest_theme/

replace-var() {
    file="$1"
    name="$2"
    val="$3"

    sed --in-place "s/^\$$name:.*/\$$name: $val;/g" $dest_theme/$file 
}

replace-var "gtk-3.0/_colors.scss" "bg_color" "$1"
replace-var "gtk-3.0/_colors.scss" "base_color" "$2"
replace-var "gtk-3.0/_colors.scss" "text_color" "$4"
replace-var "gtk-3.0/_colors.scss" "fg_color" "$4"
replace-var "gtk-3.0/_colors.scss" "selected_fg_color" "$5"
replace-var "gtk-3.0/_colors.scss" "selected_bg_color" "$6"
sassc "$dest_theme/gtk-3.0/gtk.scss" "$dest_theme/gtk-3.0/gtk.css"

