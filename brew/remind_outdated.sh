#!/bin/bash
LAST_REMINDER_FILE="${CONFIG_ROOT}/brew/last_upgrade_reminder.txt"

CURRENT_TIME=$(date +%s)
LAST_TIME=$(lcat "$LAST_REMINDER_FILE" 2>/dev/null)

# Calculate the difference in seconds (24 hours = 86400 seconds)
TIME_DIFF=$((CURRENT_TIME - LAST_TIME))
TWENTY_FOUR_HOURS=86400

# Check if last_reminder file exists or if more than 24 hours have passed
if [[ ! -f "$LAST_REMINDER_FILE" ]] || [[ $TIME_DIFF -gt $TWENTY_FOUR_HOURS ]]; then
    echo " Checking for outdated packages, run \`brew upgrade\` to upgrade..."
    brew outdated
    echo "$CURRENT_TIME" > "$LAST_REMINDER_FILE"
fi
