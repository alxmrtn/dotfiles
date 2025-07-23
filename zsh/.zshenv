# shellcheck disable=SC2148

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

# shell behavior
export SHELL_SESSIONS_DISABLE=1
export __CF_USER_TEXT_ENCODING="0x1F5:0x0:0x0"

# brew
export HOMEBREW_BUNDLE_FILE="${CONFIG_ROOT}/brew/.brewfile"
export HOMEBREW_BREWFILE_CURSOR=1

# zoxide/z
export _ZO_DATA_DIR="${CONFIG_ROOT}/zsh/zoxide"
export _Z_DATA="${CONFIG_ROOT}/zsh/.z"

# hist
export HISTFILE="${CONFIG_ROOT}/zsh/.zsh_history"
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

# tool-specific configurations
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"

export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

export DOPPLER_CONFIG_DIR="$XDG_CONFIG_HOME/doppler"

export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

export KUBECONFIG="$XDG_CONFIG_HOME/kube/config"

export NODE_REPL_HISTORY="$XDG_CONFIG_HOME/nodejs/repl_history"
# export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/config"
# export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
# export NPM_CONFIG_LOGS_DIR="$XDG_CONFIG_HOME/npm/logs"

export PUPPETEER_CACHE_DIR="$XDG_CACHE_HOME/puppeteer"
export PUPPETEER_EXECUTABLE_PATH="$XDG_CACHE_HOME/puppeteer/chrome/linux-*/chrome"
export PUPPETEER_USER_DATA_DIR="$XDG_CONFIG_HOME/puppeteer/user-data"

export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'

export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
