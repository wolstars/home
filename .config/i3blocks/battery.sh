#!/usr/bin/env bash
BAT=$(acpi | grep -E "[01]?[0-9]?[0-9]"| cut -d " " -f 4)
BAT=${BAT%,}

acpi | grep -q "Charging" && echo "⚡$BAT" && echo "⚡$BAT" || (echo "🔋$BAT" && echo "🔋$BAT")

# Set urgent flag below 10% or use orange below 30%

[ ${BAT%?} -le 10 ] && exit 33
[ ${BAT%?} -le 30 ] && echo "#dbbc7f" && exit 0

echo "#a7c080"
exit 0
