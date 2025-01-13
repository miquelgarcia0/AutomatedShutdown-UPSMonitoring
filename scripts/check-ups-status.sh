#!/bin/bash

# Define the threshold for low battery (in percentage)
LOW_BATTERY_THRESHOLD=20

# Log the time when the script is triggered (optional)
#echo "$(date): Script triggered due to LOWBATT" >> /home/nutups/shutdown.log

# Get the current battery charge
BATTERY_CHARGE=$(upsc UPSNAME battery.charge 2>/dev/null | grep -o '^[0-9]\+$')

# Check if the battery charge is below the threshold
if [ "$BATTERY_CHARGE" -le "$LOW_BATTERY_THRESHOLD" ]; then
    # Trigger the PowerCLI script using PowerShell
    pwsh /home/user/script_shutdown_esxi.ps1
fi
