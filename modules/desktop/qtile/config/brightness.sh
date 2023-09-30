#!/usr/bin/env sh

function send_notification() {
    brightness=$(printf "%.0f\n" $(brillo -G))
    dunstify -a "brightness" -u low -r 9991 -h int:value:"$brightness" -i "brightness-$1" "Brightness: $brightness %"
}

case $1 in
    up)
        brillo -A 5 -q
        ;;
    down)
        brillo -U 5 -q -c 2
        ;;
esac

send_notification $1
