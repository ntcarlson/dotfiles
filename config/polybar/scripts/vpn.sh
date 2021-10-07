#!/usr/bin/env bash

vpn-status() {
    SERVER=$(protonvpn-cli status | awk '/^Server:/ {print $2}')
    if [ -z "$SERVER" ]; then
        echo "No VPN"
    else
        echo "$SERVER"
    fi
}

vpn-connect() {
    notify-send -i none -u low -t 2000 "VPN Login Message" "Establishing VPN connection"
    protonvpn-cli connect --fastest
}

vpn-disconnect() {
    SERVER=$(vpn-status)
    notify-send -i none -u low -t 2000 "VPN Logout Message" "Disconnecting from $SERVER"
    protonvpn-cli disconnect
}

vpn-is-connected() {
    if [ "$(vpn-status)" == "No VPN" ]; then
        return 1
    else
        return 0
    fi
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
