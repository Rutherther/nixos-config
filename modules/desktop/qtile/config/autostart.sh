#!/usr/bin/env sh

systemctl start --user qtile-services.target

# Browser
firefox &

# Comms
discord &
element-desktop &

# aw-qt &
