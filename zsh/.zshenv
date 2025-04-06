# config root
export XDG_CONFIG_HOME="${HOME}/.config"
export CONFIG_ROOT=$XDG_CONFIG_HOME

# brew
export HOMEBREW_BUNDLE_FILE="${CONFIG_ROOT}/brew/.brewfile"

# zsh
export ZDOTDIR="${CONFIG_ROOT}/zsh"
export ZSH_SESSIONS_DIR="${CONFIG_ROOT}/zsh/.zsh_sessions"

# zoxide/z
export _ZO_DATA_DIR="${ZDOTDIR}/zoxide"
export _Z_DATA="${ZDOTDIR}/.z"

# hist
export LESSHISTFILE="${CONFIG_ROOT}/less/.lesshist"
export HISTFILE="${CONFIG_ROOT}/zsh/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

# editor
export VIMINIT="source ${CONFIG_ROOT}/vim/vimrc"
export EDITOR="code"

# git
export GIT_CONFIG_GLOBAL="${CONFIG_ROOT}/gh/.gitconfig"

# themes
export BAT_THEME="ansi"
