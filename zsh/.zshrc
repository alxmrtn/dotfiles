# /etc/zshrc resets HISTFILE, HISTSIZE, and SAVEHIST after .zshenv.
export HISTFILE="${CONFIG_ROOT}/zsh/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# shuck: source=../prompt/setup_prompt.zsh
source "${CONFIG_ROOT}/prompt/setup_prompt.zsh"
prompt_purification_setup

# shuck: source=../scripts/brew_shellenv.zsh
source "${CONFIG_ROOT}/scripts/brew_shellenv.zsh"
eval "$(${MISE_INSTALL_PATH} activate zsh)"
eval "$(zoxide init zsh)"
# fzf prints its init script on stdout.
# shuck: disable=C002
source <(fzf --zsh)

# shuck: source=../scripts/agent_shell.zsh
source "${CONFIG_ROOT}/scripts/agent_shell.zsh"
if ! is_agent_shell; then
  # shuck: source=../scripts/colima_startup.zsh
  source "${CONFIG_ROOT}/scripts/colima_startup.zsh"
  # shuck: source=../scripts/brew_remind_outdated.zsh
  source "${CONFIG_ROOT}/scripts/brew_remind_outdated.zsh"

  # shuck: source=.aliases
  source "${HOME}/.aliases"
fi

# 1Password generates this file outside the repo.
if [[ -r "${CONFIG_ROOT}/op/plugins.sh" ]]; then
  # shuck: disable=C003
  source "${CONFIG_ROOT}/op/plugins.sh"
fi
