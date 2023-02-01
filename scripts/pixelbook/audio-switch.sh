#!/usr/bin/env bash

INTERNAL_SINK="alsa_output.platform-kbl_r5514_5663_max.HiFi__hw_kblr55145663max_0__sink"
INTERNAL_SOURCE="alsa_input.platform-kbl_r5514_5663_max.HiFi__hw_kblr55145663max_4__source"

EXTERNAL_SINK="alsa_output.platform-kbl_r5514_5663_max.HiFi__hw_kblr55145663max_2__sink"
EXTERNAL_SOURCE="alsa_input.platform-kbl_r5514_5663_max.HiFi__hw_kblr55145663max_1__source"

case "$1" in
    "speakers")
        pactl set-default-sink $INTERNAL_SINK
        pactl set-default-source $INTERNAL_SOURCE
        ;;
    "headphones")
        pactl set-default-sink $EXTERNAL_SINK
        pactl set-default-source $EXTERNAL_SOURCE
        ;;
    "swap")
        CURRENT_SINK="$(pactl info | awk '/^Default Sink:/ {print $3}')"
        if [ "$CURRENT_SINK" == "$INTERNAL_SINK" ]; then
            $0 headphones
        else
            $0 speakers
        fi
        ;;
    *)
        echo "Usage: $0 (speakers|headphones|swap)"
esac
