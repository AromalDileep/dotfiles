#!/bin/bash
# Read battery capacity and status
capacity=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n1)
status=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -n1)

if [ -z "$capacity" ]; then
    echo "N/A"
    exit 0
fi

# Remove any trailing % or whitespace just in case
capacity=$(echo "$capacity" | tr -d '%[:space:]')

if [ "$status" = "Charging" ]; then
    echo "󰂄${capacity}%"
    exit 0
fi

# Discharging → select icon based on percentage
if   [ "$capacity" -ge 100 ]; then icon="󰁹"
elif [ "$capacity" -ge 90  ]; then icon="󰂂"
elif [ "$capacity" -ge 80  ]; then icon="󰂁"
elif [ "$capacity" -ge 70  ]; then icon="󰂀"
elif [ "$capacity" -ge 60  ]; then icon="󰁿"
elif [ "$capacity" -ge 50  ]; then icon="󰁾"
elif [ "$capacity" -ge 40  ]; then icon="󰁽"
elif [ "$capacity" -ge 30  ]; then icon="󰁼"
elif [ "$capacity" -ge 20  ]; then icon="󰁻"
else                               icon="󰁺"    # < 20%
fi

echo "${icon}${capacity}%"
