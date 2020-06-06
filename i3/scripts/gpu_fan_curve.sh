#!/bin/bash

set_fan() {
    local fan_perc=$1
    echo "Target fan speed: $fan_perc%"
    nvidia-settings -a "[gpu:0]/GPUFanControlState=1" \
                    -a "[fan:0]/GPUTargetFanSpeed=$1"  &> /dev/null
}

while true; do 
    sleep 5
    temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
    echo -ne "Temperature: $temp C\t"
    if [ $temp -ge '78' ]; then
        set_fan 80
    elif [ $temp -ge '75' ]; then
        set_fan 70
    elif [ $temp -ge '70' ]; then
        set_fan 60
    elif [ $temp -ge '60' ]; then
        set_fan 45
    elif [ $temp -ge '50' ]; then
        set_fan 30
    else
        set_fan 10
    fi
done

