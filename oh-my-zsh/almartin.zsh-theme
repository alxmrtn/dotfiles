local ret_status="%(?:%{$fg_bold[green]%}%B»%b :%{$fg_bold[red]%}%B»%b %s)"

function venv_info() {
  [[ -n $VIRTUAL_ENV ]] && echo "%{$fg[green]%}\ue73c%{$reset_color%} "
}

PROMPT='$(venv_info)$USER :: %2~ $(git_prompt_info)${ret_status}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[black]%}λ%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}*%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=" "
