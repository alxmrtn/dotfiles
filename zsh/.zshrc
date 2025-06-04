source ${CONFIG_ROOT}/prompt/setup_prompt
autoload -Uz setup_prompt && prompt_purification_setup

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(${MISE_INSTALL_PATH} activate zsh)"
eval "$(zoxide init zsh)"

# hist
export LESSHISTFILE="${CONFIG_ROOT}/less/.lesshist"
export HISTFILE="${CONFIG_ROOT}/zsh/.zsh_history"

source ${HOME}/.aliases

# check for outdated packages once a day
source ${CONFIG_ROOT}/brew/remind_outdated.sh
