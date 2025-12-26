#!/bin/bash
capacity=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null)
status=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null)

if [ -z "$capacity" ]; then
    echo "N/A"
elif [ "$status" = "Charging" ]; then
    echo "⚡${capacity}%"
else
    echo "🔋${capacity}%"
fi
