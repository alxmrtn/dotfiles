# shellcheck disable=SC2148

# Purification
# modified by Alexander Martin
# https://github.com/alxmrtn/dotfiles/prompt/

# Based on:

# Purification
# by Matthieu Cneude
# https://github.com/Phantas0s/purification

# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)

# Combined git status and branch info function (no persistent cache)
prompt_git_info_combined() {
  local INDEX STATUS BRANCH
  local has_untracked=false has_added=false has_modified=false has_renamed=false
  local has_deleted=false has_stashed=false has_unmerged=false
  local has_ahead=false has_behind=false has_diverged=false
  local branch_status_enabled=true

  [[ "$GIT_DISABLE_PROMPT_BRANCH_STATUS" == "true" ]] && branch_status_enabled=false

  # Always get fresh git status
  INDEX=$(command git status --porcelain -b 2> /dev/null)
  [[ -z "$INDEX" ]] && return

  STATUS=""
  BRANCH=""

  # Parse git status output line by line for efficiency
  # shellcheck disable=SC2222,SC2221
  while IFS= read -r line; do
    case "$line" in
      \#\#\ *) 
        # Extract branch name from the first line
        BRANCH="${line#\#\# }"
        BRANCH="${BRANCH%%...*}"  # Remove tracking branch info
        [[ "$line" == *"ahead"* ]] && has_ahead=true
        [[ "$line" == *"behind"* ]] && has_behind=true
        [[ "$line" == *"diverged"* ]] && has_diverged=true
        ;;
      \?\?*) has_untracked=true ;;
      A\ *|M\ *|MM*) has_added=true ;;
      \ M*|AM*|MM*|\ T*) has_modified=true ;;
      R\ *) has_renamed=true ;;
      \ D*|D\ *|AD*) has_deleted=true ;;
      UU*) has_unmerged=true ;;
    esac
  done <<< "$INDEX"

  # Check for stashed changes (only if branch status checking is enabled)
  if $branch_status_enabled && command git rev-parse --verify refs/stash >/dev/null 2>&1; then
    has_stashed=true
  fi

  # Build status string based on findings
  $has_untracked && STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED $STATUS"
  $has_added && STATUS="$ZSH_THEME_GIT_PROMPT_ADDED $STATUS"
  $has_modified && STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED $STATUS"
  $has_renamed && STATUS="$ZSH_THEME_GIT_PROMPT_RENAMED $STATUS"
  $has_deleted && STATUS="$ZSH_THEME_GIT_PROMPT_DELETED $STATUS"

  # Branch status indicators (only if enabled)
  if $branch_status_enabled; then
    $has_stashed && STATUS="$ZSH_THEME_GIT_PROMPT_STASHED $STATUS"
    $has_unmerged && STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED $STATUS"
    $has_ahead && STATUS="$ZSH_THEME_GIT_PROMPT_AHEAD $STATUS"
    $has_behind && STATUS="$ZSH_THEME_GIT_PROMPT_BEHIND $STATUS"
    $has_diverged && STATUS="$ZSH_THEME_GIT_PROMPT_DIVERGED $STATUS"
  fi

  # Build the complete git info string
  local git_info=""
  if [[ -n "$BRANCH" ]]; then
    git_info="$ZSH_THEME_GIT_PROMPT_PREFIX%F{white}$BRANCH%f$ZSH_THEME_GIT_PROMPT_SUFFIX"
    if [[ -n "$STATUS" ]]; then
      git_info="$git_info [ $STATUS]"
    fi
  fi

  echo "$git_info"
}

prompt_venv_info() {
  [[ -n $VIRTUAL_ENV ]] && echo "%F{green}\ue606%f "
}

prompt_ret_status() {
  echo "%(?:%F{green}»%f :%F{red}»%f )"
}

# shellcheck disable=SC2034,SC2016
prompt_purification_setup() {
  # Set theme variables (unchanged)
  ZSH_THEME_GIT_PROMPT_PREFIX="%F{black}λ%f"
  ZSH_THEME_GIT_PROMPT_SUFFIX=""
  ZSH_THEME_GIT_PROMPT_DIRTY=""
  ZSH_THEME_GIT_PROMPT_CLEAN=""

  # if you can't see the symbols, install a nerd font
  ZSH_THEME_GIT_PROMPT_ADDED="%F{green}+%f"
  ZSH_THEME_GIT_PROMPT_MODIFIED="%F{blue}%f"
  ZSH_THEME_GIT_PROMPT_DELETED="%F{red}x%f"
  ZSH_THEME_GIT_PROMPT_RENAMED="%F{magenta}➜%f"
  ZSH_THEME_GIT_PROMPT_UNMERGED="%F{yellow}═%f"
  ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{white}%f"
  ZSH_THEME_GIT_PROMPT_STASHED="%B%F{red}%f%b"
  ZSH_THEME_GIT_PROMPT_BEHIND="%B%F{red}%f%b"
  ZSH_THEME_GIT_PROMPT_AHEAD="%B%F{green}%f%b"

  setopt prompt_subst
  
  # Simplified prompt setup using the combined function
  RPROMPT='$(prompt_git_info_combined)'
  PROMPT='$(prompt_venv_info)$USER :: %2~ %B$(prompt_ret_status)%b'
}
