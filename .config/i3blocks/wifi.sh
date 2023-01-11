#!/usr/bin/env bash

COLOR_HIGH=#a7c080
COLOR_LOW=#FF0000
COLOR_DOWN=#e67e80

INTERFACE=wlp58s0

# If the wifi interface exists but no connection is active, "down" shall be displayed.
if [[ "$(cat /sys/class/net/$INTERFACE/operstate)" = 'down' ]]; then
    echo "down"
    echo "down"
    echo $COLOR_DOWN
    exit
fi

SSID=$(iw dev wlp58s0 link | grep 'SSID' | cut -d " " -f 2)

SIGNAL=$(iw dev wlp58s0 link | grep -Eo '[-][0-9]{1,2}')

[ "$SIGNAL" -le -100 ] && QUALITY=0 || QUALITY=$((100$SIGNAL))

echo "$QUALITY% $SSID" # full text
echo "$QUALITY% $SSID" # short text

# color

if [[ $QUALITY -le 20 ]]; then
    echo $COLOR_LOW
else
	echo $COLOR_HIGH
fi
