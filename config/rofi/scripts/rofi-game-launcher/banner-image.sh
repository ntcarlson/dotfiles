#!/usr/bin/env bash

# Generates a banner image for the given Steam appid with the given dimensions

# .bmp format was chosen since it appears to be the most performant format
# for ImageMagick to work with when generating the banner image
EXT="bmp"
CACHE_DIR="/tmp/rofi-game-launcher/"
BANNER="$CACHE_DIR/banner.$EXT"
TITLE="$CACHE_DIR/title.png"
STEAM_DIR="$HOME/.local/share/Steam/"
mkdir -p "$CACHE_DIR"

usage() {
    echo "Generate banner image to be used in the Rofi game menu"
    echo "Usage: $0 -a <APPID> -w <WIDTH> -h <HEIGHT> -b [<BLEND WIDTH>] [-f]"
    echo "  -b: Specify the width in pixels of the section on the edges used to extend the image. Default: 200"
    echo "  -f: Force generation of the banner image even if it exists in the cache"
    exit
}

update-banner() {
    local OPTIND=1
    local appid width height force
    local blend=200

    while getopts 'a:w:h:b:f' arg
    do
        case ${arg} in
            a) appid=${OPTARG};;
            w) width=${OPTARG};;
            h) height=${OPTARG};;
            b) blend=${OPTARG};;
            f) force=1;;
            *) usage;;
        esac
    done

    [ -z $appid ] && usage
    [ -z $width ] && usage
    [ -z $height ] && usage

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

    if [ ! -f $out ] || [ ! -z $force ]; then
        # Banner image is generated by taking the hero image used by Steam
        # (typically 1920x620) and stretching and blurring the horizontal
        # edges to reach the desired width. The variable blend determines the
        # how much of the edges are used in this operation.
        local gradient=$CACHE_DIR/gradient.$EXT
        local left=$CACHE_DIR/left.$EXT
        local right=$CACHE_DIR/right.$EXT
        local center=$CACHE_DIR/center.$EXT


        convert $src -resize ${width}x${height} $center

        # Generate gradient image used for blending the side extensions into
        # the center image and for fading the side images
        magick -size ${height}x${blend} gradient: -rotate 90 $gradient

        local center_width=$(identify -format "%W" $center)
        local side_width=$(( (width - center_width + 1)/2 + blend ))
        local side_blend=$(( side_width/2 ))

        # Generate left extension
        convert $center -crop ${blend}x${height}+0+0 \
            -resize ${side_width}x${height}\! -blur 0x12 \
            -gravity east \( $gradient -rotate 180 \) \
            -compose copyopacity -composite \
            -gravity west \( $gradient -resize ${side_blend}x${height}\! \) \
            -compose copyopacity -composite \
            $left

        # Generate right extension
        convert $center -gravity east -crop ${blend}x${height}+0+0 \
            -resize ${side_width}x${height}\! -blur 0x12 \
            -gravity west $gradient \
            -compose copyopacity -composite \
            -gravity east \( $gradient -rotate 180 -resize ${side_blend}x${height}\! \) \
            -compose copyopacity -composite \
            $right

        # Blend the banner together
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

update-banner $@
