#! /bin/zsh
# shellcheck disable=SC2148,SC1071

if [[ "${COLIMA_START}" != "true" ]]; then
    return 0
fi

if ! command -v colima &>/dev/null; then
    return 0
fi

if ! colima status &>/dev/null; then
    pid=$( (colima start -c "${COLIMA_CORES}" -m "${COLIMA_MEM}" &>/dev/null & echo $!) )
    echo "==> starting colima in background (pid: ${pid})"
fi
