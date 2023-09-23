#!/usr/bin/env bash

dunstctl close-all
notify-send.py a --hint boolean:deadd-notification-center:true \
               string:type:clearPopups
