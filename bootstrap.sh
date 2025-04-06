#! /bin/zsh

cp .zshrc "${HOME}/.zshrc"
cp .zshenv "${HOME}/.zshenv"

local config_root="${HOME}/.config"
mkdir -p $config_root

cp .aliases $config_root/.aliases

declare -a folders=("brew" "gh" "prompt")
for f in "${folders[@]}"; do
    [ ! -d "${config_root}/${f}" ] && cp -R $f "${config_root}/${f}"
done

mkdir -p "${HOME}/.warp/themes"
cp warp/almartin.yaml "${HOME}/.warp/themes/almartin.yaml"

cp git/.gitconfig "${HOME}/.gitconfig"

if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew bundle