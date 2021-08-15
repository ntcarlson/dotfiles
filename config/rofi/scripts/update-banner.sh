#!/usr/bin/env bash

# Generates a hero image for the given Steam appid with the given dimensions

EXT=tiff
CACHE_DIR=/tmp/rofi-game-launcher/
BANNER=$CACHE_DIR/banner.$EXT
TITLE=$CACHE_DIR/title.png
STEAM_DIR=~/.local/share/Steam/
mkdir -p $CACHE_DIR


update-banner() {
    local OPTIND=1
    local appid width height
    local blend=200

    while getopts 'a:w:h:' arg
    do
        case ${arg} in
            a) appid=${OPTARG};;
            w) width=${OPTARG};;
            h) height=${OPTARG};;
            *) return 1 # illegal option
        esac
    done

    local src=$STEAM_DIR/appcache/librarycache/${appid}_library_hero.jpg
    local title=$STEAM_DIR/appcache/librarycache/${appid}_logo.*
    local out=$CACHE_DIR/$appid/${width}x${height}.$EXT
    mkdir -p $CACHE_DIR/$appid

    if [ -f $BANNER ]; then
        rm $BANNER
    fi
    if [ -f $TITLE ]; then
        rm $TITLE
    fi

    if [ ! -f $out ]; then
        local gradient=$CACHE_DIR/gradient.tiff
        local left=$CACHE_DIR/left.tiff
        local right=$CACHE_DIR/right.tiff
        local center=$CACHE_DIR/center.tiff


        convert $src -resize ${width}x${height} $center
        magick -size ${height}x${blend} gradient: -rotate 90 $gradient

        local center_width=$(identify -format "%W" $center)
        local side_width=$(( (width - center_width + 1)/2 + blend ))
        local side_blend=$(( side_width/2 ))

        convert $center -crop ${blend}x${height}+0+0 \
            -resize ${side_width}x${height}\! -blur 0x12 \
            -gravity east \( $gradient -rotate 180 \) \
            -compose copyopacity -composite \
            -gravity west \( $gradient -resize ${side_blend}x${height}\! \) \
            -compose copyopacity -composite \
            $left

        convert $center -gravity east -crop ${blend}x${height}+0+0 \
            -resize ${side_width}x${height}\! -blur 0x12 \
            -gravity west $gradient \
            -compose copyopacity -composite \
            -gravity east \( $gradient -rotate 180 -resize ${side_blend}x${height}\! \) \
            -compose copyopacity -composite \
            $right

        convert \
            \( $center -background none -gravity center -extent ${width}x${height} \) \
            \( $left   -background none -gravity west   -extent ${width}x${height} \) \
            -compose over -composite \
            \( $right  -background none -gravity east   -extent ${width}x${height} \) \
            -compose over -composite \
            $out
        fi
        ln -s $out $BANNER
        
        if [ -f $title ]; then
            ln -s $title $TITLE
        fi
}

