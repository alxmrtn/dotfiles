#! /bin/zsh

if [[ "${TERM_PROGRAM}" != "WarpTerminal" ]]; then
  return 0
fi

() {
  local last_reminder_file="${CONFIG_ROOT}/brew/last_upgrade_reminder.txt"
  local current_time last_time time_diff
  local twenty_four_hours=86400

  current_time=$(date +%s)
  last_time=$(/bin/cat "${last_reminder_file}" 2>/dev/null)
  last_time=${last_time:-0}
  time_diff=$((current_time - last_time))

  # A missing file reads as 0, so the age check covers that case.
  if [[ ${time_diff} -gt ${twenty_four_hours} ]]; then
    echo "==> checking for outdated packages, run \`brew upgrade\` to upgrade..."
    brew outdated
    echo "${current_time}" > "${last_reminder_file}"
  fi
}
