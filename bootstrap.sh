#! /bin/zsh
cp zsh/.zshrc "${HOME}/.zshrc"
cp zsh/.zshenv "${HOME}/.zshenv"

local config_root="${HOME}/.config"
mkdir -p $config_root

cp zsh/.aliases $config_root/.aliases

declare -a folders=("brew" "gh" "prompt")
for f in "${folders[@]}"; do
  rsync -a "$f/" "${config_root}/${f}/"
done

mkdir -p "${HOME}/.warp/themes"
cp warp/almartin.yaml "${HOME}/.warp/themes/almartin.yaml"

cp git/.gitconfig "${HOME}/.gitconfig"

if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

source "${HOME}/.zshenv"
source "${HOME}/.zshrc"

brew bundle
