#! /bin/zsh

# The cache is gitignored and must exist before zoxide and fzf are looked up.
# Delete it to pick up a changed `brew shellenv`.
shellenv_cache="${CONFIG_ROOT}/brew/.shellenv_cache"

if [[ ! -s "${shellenv_cache}" && -x /opt/homebrew/bin/brew ]]; then
    /opt/homebrew/bin/brew shellenv > "${shellenv_cache}"
fi

if [[ -s "${shellenv_cache}" ]]; then
    # shuck: disable=C002
    source "${shellenv_cache}"
fi
