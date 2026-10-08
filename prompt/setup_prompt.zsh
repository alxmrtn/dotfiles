# Purification
# modified by Alexander Martin
# https://github.com/alxmrtn/dotfiles

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
  local has_ahead=false has_behind=false
  local branch_status_enabled=true
  local line x y header_rest tracking

  [[ "$GIT_DISABLE_PROMPT_BRANCH_STATUS" == "true" ]] && branch_status_enabled=false

  # Always get fresh git status
  INDEX=$(command git status --porcelain -b 2> /dev/null)
  [[ -z "$INDEX" ]] && return

  STATUS=""
  BRANCH=""

  # Parse git status output line by line for efficiency
  while IFS= read -r line; do
    case "$line" in
      \#\#\ *)
        # Branch name stops at the upstream (...). Ahead/behind live only in
        # the trailing [ahead N, behind M] bracket, so a branch named
        # fix/behind-proxy is not treated as behind.
        header_rest="${line#\#\# }"
        BRANCH="${header_rest%%...*}"
        BRANCH="${BRANCH%% \[*}"
        if [[ "$header_rest" == *'['*']'* ]]; then
          tracking="${header_rest##*\[}"
          tracking="${tracking%%\]*}"
          [[ "$tracking" == *ahead* ]] && has_ahead=true
          [[ "$tracking" == *behind* ]] && has_behind=true
        fi
        ;;
      *)
        # Porcelain is "XY PATH". Check both characters so combined states
        # (MM, RM, MD) keep both flags. Conflict pairs are unmerged only.
        x="${line[1]}"
        y="${line[2]}"
        case "${x}${y}" in
          AA|DD|AU|UA|DU|UD|UU)
            has_unmerged=true
            continue
            ;;
        esac
        case "$x" in
          \?) has_untracked=true ;;
          A|M|T) has_added=true ;;
          R|C) has_renamed=true ;;
          D) has_deleted=true ;;
        esac
        case "$y" in
          \?) has_untracked=true ;;
          M|T) has_modified=true ;;
          D) has_deleted=true ;;
        esac
        ;;
    esac
  done <<< "$INDEX"

  # % is a prompt escape. Branch names can contain it.
  BRANCH="${BRANCH//\%/%%}"

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

prompt_purification_setup() {
  # Set theme variables (unchanged)
  ZSH_THEME_GIT_PROMPT_PREFIX="%F{black}λ%f"
  ZSH_THEME_GIT_PROMPT_SUFFIX=""

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
