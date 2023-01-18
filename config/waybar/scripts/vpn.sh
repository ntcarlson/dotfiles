#!/usr/bin/env bash

OPENVPN_CONF=co.us.protonvpn

message-box() {
    notify-send -i /usr/share/icons/Numix-Square/48/apps/qopenvpn.svg \
                -u low \
                -t 2000 \
                "OpenVPN" "$1"
}

vpn-status() {
    if vpn-is-connected; then
        vpn-server | awk -F. '{print $1}'
    else
        echo "No VPN"
    fi
}

vpn-connect() {
    message-box "Starting OpenVPN"
    sudo systemctl start openvpn-client@${OPENVPN_CONF}.service

    start=$(date +"%s")
    while true; do
        sleep 0.1
        entry="$(journalctl /usr/bin/openvpn -r --output=short-unix | grep -m 1 -e "Initialization Sequence Completed")"
        timestamp=$(awk -F. '{print $1}' <<< $entry)
        now=$(date +"%s")
        if (( timestamp > start )); then
            message-box "Connected to \n$(vpn-server)"
            kill -35 $(pgrep waybar)
            break
        fi
        if (( now > start + 30 )); then
            message-box "Connection timed out"
            sudo systemctl stop openvpn-client@${OPENVPN_CONF}.service
            break
        fi
    done
}

vpn-disconnect() {
    message-box "Disconnecting from \n$(vpn-server)"
    sudo systemctl stop openvpn-client@${OPENVPN_CONF}.service
    for pid in $(pgrep -f "bash $0"); do
        if [ ! $pid == $$ ]; then
            kill -9 $pid
        fi
    done
    kill -35 $(pgrep waybar)
}

vpn-is-connected() {
    local status="$(systemctl show openvpn-client@${OPENVPN_CONF}.service | awk -F= '/^StatusText=/ {print $2}')"
    local active="$(systemctl show openvpn-client@${OPENVPN_CONF}.service | awk -F= '/^ActiveState=/ {print $2}')"
    if [ "$status" == "Initialization Sequence Completed" ] && [ "$active" == "active" ]; then
        return 0
    else
        return 1
    fi
}

vpn-server() {
    journalctl /usr/bin/openvpn -r | grep -m 1 -Poe "([[:alnum:]]|-)*.protonvpn.(com|net)"
}

vpn-toggle() {
    if vpn-is-connected; then
        vpn-disconnect
    else
        vpn-connect
    fi
}

case "$1" in
    connect)    vpn-connect;;
    disconnect) vpn-disconnect;;
    toggle)     vpn-toggle;;
    status)     vpn-status;;
    *)          echo "Usage: $0 [connect|disconnect|toggle|status]"
esac
