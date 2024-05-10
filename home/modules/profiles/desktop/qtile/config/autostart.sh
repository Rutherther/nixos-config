#!/usr/bin/env sh

dbus-update-activation-environment --systemd DISPLAY XDG_CURRENT_DESKTOP

# systemctl start --user wm-services.target
systemctl start --user xorg-wm-services.target

# Browser
firefox &

# Comms
discord &
element-desktop &

# aw-qt &
