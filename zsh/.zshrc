source $CONFIG_ROOT/prompt/setup_prompt
autoload -Uz setup_prompt && prompt_purification_setup

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"

source $CONFIG_ROOT/zsh/.aliases
