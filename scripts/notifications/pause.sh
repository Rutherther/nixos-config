#!/usr/bin/env bash

notify-send "Pausing notifications"
notify-send.py a --hint boolean:deadd-notification-center:true \
               string:type:pausePopups
sleep 3
dunstctl set-paused true
