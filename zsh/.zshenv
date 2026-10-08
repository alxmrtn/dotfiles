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
export HOMEBREW_NO_ENV_HINTS=1

# zoxide
export _ZO_DATA_DIR="${CONFIG_ROOT}/zsh/zoxide"

# editor
# --wait so git commit and git rebase -i block until the file is closed.
export EDITOR="cursor --wait"

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

export LESSHISTFILE="${XDG_STATE_HOME}/less/history"

export NODE_REPL_HISTORY="$XDG_CONFIG_HOME/nodejs/repl_history"

export NPM_CONFIG_CACHE="${XDG_CACHE_HOME}/npm"
export NPM_CONFIG_LOGS_DIR="${XDG_CONFIG_HOME}/npm/logs"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"

export PUPPETEER_CACHE_DIR="$XDG_CACHE_HOME/puppeteer"
export PUPPETEER_USER_DATA_DIR="$XDG_CONFIG_HOME/puppeteer/user-data"

export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonstartup.py"
export PYTHON_HISTORY="${XDG_STATE_HOME}/python/history"

# Vim expands $MYVIMRC and $XDG_CONFIG_HOME; the shell must not.
# shuck: disable=C005
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'

export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"

# colima
export COLIMA_START=true
export COLIMA_CORES=4
export COLIMA_MEM=8
