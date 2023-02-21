#!/bin/sh

# Startup script to be run with autologin

[ -f /etc/profile ] && . /etc/profile

export MOZ_USE_XINPUT2=1
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export GDK_BACKEND=wayland
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway

if lsmod | grep -q "^nvidia"; then
    # Apply some Nvidia-specific workarounds
    export WLR_NO_HARDWARE_CURSORS=1
    export WLR_RENDERER=vulkan

    export GBM_BACKEND=nvidia-drm
    export __GL_GSYNC_ALLOWED=0
    export __GL_VRR_ALLOWED=0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia

    exec sway --unsupported-gpu -D noscanout
else
    exec sway
fi

