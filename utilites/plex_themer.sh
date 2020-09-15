#!/usr/bin/env bash

# Find all CSS files associated with plex
css_files=$(pacman -Ql plex-media-server | grep -e ".css$" | awk '{print $2}')

color_bg=$(xrdb -query | awk -F\# '/^*background:/ {print $2}')
color_menu=$(xrdb -query | awk -F\# '/^*background_alt:/ {print $2}')
color_accent=$(xrdb -query | awk -F\# '/^*primary:/ {print $2}')

# Toolbar color
old[0]="1f2326"
new[0]="$color_menu"

# Background color
old[1]="3f4245"
new[1]="$color_bg"

# Accent colors
old[2]="cc7b19"
new[2]="$color_accent"
old[3]="e5a00d"
new[3]="$color_accent"

# Construct sed replacement string
sed_str=""
for i in ${!old[*]}; do
    sed_str+="s/${old[$i]}/${new[$i]}/g;"
done

for css_file in $css_files; do
    cp $css_file $css_file.bak
    sed "$sed_str" $css_file.bak > $css_file
done

# Remove grainy background
bg_grain=$(pacman -Ql plex-media-server | grep -e "backgrounds/noise.*png$" | awk '{print $2}')
mv $bg_grain $bg_grain.bak
touch $bg_grain

# Remove gradient effect on background
bg_gradient=$(pacman -Ql plex-media-server | grep -e "backgrounds/preset-light.*png$" | awk '{print $2}')
mv $bg_gradient $bg_gradient.bak
touch $bg_gradient
bg_gradient=$(pacman -Ql plex-media-server | grep -e "backgrounds/preset-dark.*png$" | awk '{print $2}')
mv $bg_gradient $bg_gradient.bak
touch $bg_gradient
