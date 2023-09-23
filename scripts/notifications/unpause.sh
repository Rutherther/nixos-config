#!/usr/bin/env bash

dunstctl set-paused false
notify-send.py a --hint boolean:deadd-notification-center:true \
               string:type:unpausePopups
notify-send "Unpaused notifications"
