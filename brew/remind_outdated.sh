#!/bin/bash
last_reminder_file="${CONFIG_ROOT}/brew/last_upgrade_reminder.txt"

current_time=$(date +%s)
last_time=$(lcat "${last_reminder_file}" 2>/dev/null)

# Calculate the difference in seconds (24 hours = 86400 seconds)
time_diff=$((current_time - last_time))
twenty_four_hours=86400

# Check if last_reminder file exists or if more than 24 hours have passed
if [[ ! -f "${last_reminder_file}" ]] || [[ ${time_diff} -gt ${twenty_four_hours} ]]; then
    echo " Checking for outdated packages, run \`brew upgrade\` to upgrade..."
    brew outdated
    echo "${current_time}" > "${last_reminder_file}"
fi
