# config root
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${XDG_CONFIG_HOME}/local/share"
export XDG_STATE_HOME="${XDG_CONFIG_HOME}/local/state"
export XDG_CACHE_HOME="${XDG_CONFIG_HOME}/cache"

export CONFIG_ROOT=$XDG_CONFIG_HOME

export MISE_ROOT="${CONFIG_ROOT}/mise"
export MISE_INSTALL_PATH="${MISE_ROOT}/mise"
export MISE_CONFIG_DIR="${MISE_ROOT}/config"
export MISE_CACHE_DIR="${MISE_ROOT}/cache"
export MISE_STATE_DIR="${MISE_ROOT}/state"
export MISE_DATA_DIR="${MISE_ROOT}/data"

# brew
export HOMEBREW_BUNDLE_FILE="${CONFIG_ROOT}/brew/.brewfile"

# zoxide/z
export _ZO_DATA_DIR="${CONFIG_ROOT}/zsh/zoxide"
export _Z_DATA="${CONFIG_ROOT}/zsh/.z"

# hist
export HISTSIZE=10000
export SAVEHIST=10000

# editor
export VIMINIT="source ${CONFIG_ROOT}/vim/vimrc"
export EDITOR="cursor"

# git
export GIT_CONFIG_GLOBAL="${CONFIG_ROOT}/git/.gitconfig"
export GIT_DISABLE_PROMPT_BRANCH_STATUS=false

# themes
export BAT_THEME="ansi"
