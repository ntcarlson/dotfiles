#!/bin/sh

# Startup script to be run with autologin

[ -f /etc/profile ] && . /etc/profile

export MOZ_USE_XINPUT2=1
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export GDK_BACKEND=wayland
export XDG_CURRENT_DESKTOP=sway

exec sway
