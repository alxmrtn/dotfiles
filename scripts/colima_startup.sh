#! /bin/zsh
# shellcheck disable=SC2148,SC1071

if [[ "${COLIMA_START}" != "true" ]]; then
    return 0
fi

if ! command -v colima &>/dev/null; then
    return 0
fi

setopt NO_MONITOR
(
    if ! colima status &>/dev/null; then
        colima start -c "${COLIMA_CORES}" -m "${COLIMA_MEM}" &>/dev/null
    fi
) &>/dev/null &
disown
setopt MONITOR
