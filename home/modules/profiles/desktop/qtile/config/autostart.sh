#!/usr/bin/env sh

systemctl start --user wm-services.target

# Browser
firefox &

# Comms
discord &
element-desktop &

# aw-qt &
