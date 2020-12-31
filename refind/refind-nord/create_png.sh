#!/usr/bin/env bash

SCRIPT_DIR=$(dirname $(realpath $0))
SVG_DIR=$SCRIPT_DIR/svg
PNG_DIR=$SCRIPT_DIR/icons

mkdir -p $PNG_DIR

for svg in $SVG_DIR/*.svg; do
    icon=$(basename $svg .svg)

    inkscape --export-area-page \
             --export-overwrite \
             --export-dpi=96 \
             --export-filename=$PNG_DIR/$icon.png \
             $SVG_DIR/$icon.svg > /dev/null
done
