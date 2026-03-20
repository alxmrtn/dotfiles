# shellcheck disable=SC2148,SC1091
source "${CONFIG_ROOT}/prompt/setup_prompt.sh"
autoload -Uz setup_prompt.sh && prompt_purification_setup

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(${MISE_INSTALL_PATH} activate zsh)"
eval "$(zoxide init zsh)"

# hist, it doesn't take in the .zshenv file for whatever reason
export LESSHISTFILE="${CONFIG_ROOT}/less/.lesshist"
export HISTFILE="${CONFIG_ROOT}/zsh/.zsh_history"

# aliases
source "${HOME}/.aliases"

# startup scripts
source "${CONFIG_ROOT}/scripts/colima_startup.sh"
source "${CONFIG_ROOT}/scripts/brew_remind_outdated.sh"

# load 1password plugins [aws]
source "${CONFIG_ROOT}/op/plugins.sh"
