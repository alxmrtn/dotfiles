source $CONFIG_ROOT/prompt/setup_prompt
autoload -Uz setup_prompt && prompt_purification_setup

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(mise activate zsh)"

source $CONFIG_ROOT/.aliases

. /opt/homebrew/etc/profile.d/z.sh
