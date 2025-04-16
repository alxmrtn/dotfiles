# config root
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${XDG_CONFIG_HOME}/local/share"
export XDG_STATE_HOME="${XDG_CONFIG_HOME}/local/state"
export XDG_CACHE_HOME="${XDG_CONFIG_HOME}/cache"

export CONFIG_ROOT=$XDG_CONFIG_HOME

# brew
export HOMEBREW_BUNDLE_FILE="${CONFIG_ROOT}/brew/.brewfile"

# zsh
export ZDOTDIR="${CONFIG_ROOT}/zsh"

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
export GIT_DISABLE_PROMPT_BRANCH_STATUS=true

# azure
export AZURE_CONFIG_DIR="${CONFIG_ROOT}/azure"
export DOTNET_CLI_HOME="${CONFIG_ROOT}/dotnet"
export NUGET_PACKAGES="${CONFIG_ROOT}/nuget/packages"
export ASPNETCORE_APPDATA_PATH="${CONFIG_ROOT}/aspnet"

# java/maven/gradle
export JAVA_TOOL_OPTIONS="-Djava.io.tmpdir=${XDG_CACHE_HOME}/java -Dazure.config.dir=${AZURE_CONFIG_DIR}"
export MAVEN_USER_HOME="${CONFIG_ROOT}/maven"
export M2_HOME="${MAVEN_USER_HOME}/m2"
export MAVEN_OPTS="-Dmaven.repo.local=${M2_HOME}"
export GRADLE_USER_HOME="${CONFIG_ROOT}/gradle"

# themes
export BAT_THEME="ansi"
