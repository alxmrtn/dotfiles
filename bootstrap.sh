#! /bin/zsh
local no_install=false

for arg in "$@"; do
  if [ "$arg" = "--no-install" ]; then
    no_install=true
  fi
done

local config_root="${HOME}/.config"
mkdir -p $config_root

cp zsh/.zshenv "${HOME}/.zshenv"
cp zsh/.aliases $config_root/zsh/.aliases
cp zsh/.zshrc $config_root/zsh/.zshrc

declare -a folders=("brew" "gh" "prompt" "vim")
for f in "${folders[@]}"; do
  rsync -a "$f/" "${config_root}/${f}/"
done

mkdir -p "${HOME}/.warp/themes"
cp warp/almartin.yaml "${HOME}/.warp/themes/almartin.yaml"

if ! command -v /opt/homebrew/bin/brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

source "${HOME}/.zshenv"
source "${ZDOTDIR}/.zshrc"

if ! $no_install; then
  brew bundle
else
  echo "skipping: brew bundle"
fi
