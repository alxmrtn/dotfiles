#! /bin/zsh

set -e  # Exit on error

# Parse command line arguments
no_install=false
git_commit_email=""
for arg in "$@"; do
  case "$arg" in
    --no-install)
      no_install=true
      ;;
    --git-commit-email=*)
      git_commit_email="${arg#--git-commit-email=}"
      ;;
    *)
      echo "❌ Unknown argument: ${arg}" >&2
      echo "Usage: ./bootstrap.zsh [--no-install] [--git-commit-email=<email>]" >&2
      exit 1
      ;;
  esac
done

# mise install reads the mise.toml in the working directory.
script_dir="${0:A:h}"
cd "${script_dir}"

# shuck: source=zsh/.zshenv
source "${script_dir}/zsh/.zshenv"

echo "⚙️ Setting up dotfiles..."

# Create necessary directories
echo "📁 Creating config directories..."
mkdir -p "${XDG_CONFIG_HOME}/zsh"
mkdir -p "${HOME}/.warp/themes"
mkdir -p "${XDG_STATE_HOME}/vim"
mkdir -p "${XDG_STATE_HOME}/less"
mkdir -p "${XDG_STATE_HOME}/python"
mkdir -p "${XDG_CONFIG_HOME}/npm"
mkdir -p "${XDG_CONFIG_HOME}/mise/config"

# Create symlinks
echo "🔗 Creating symlinks..."
ln -sfF "${script_dir}/zsh/.zshenv" "${HOME}/.zshenv"
ln -sfF "${script_dir}/zsh/.aliases" "${HOME}/.aliases"
ln -sfF "${script_dir}/zsh/.zshrc" "${HOME}/.zshrc"

# App specific symlinks that don't respect the XDG_CONFIG_HOME variable

# Warp
ln -sfF "${script_dir}/warp/almartin.yaml" "${HOME}/.warp/themes/almartin.yaml"

# Global mise config only. ~/.config/mise also holds installs and caches.
# Not mise/config.toml: mise loads that path as a project config.
ln -sfF "${script_dir}/mise/global.toml" "${XDG_CONFIG_HOME}/mise/config/config.toml"

# Link config folders
folders=("brew" "git" "prompt" "vim" "glow" "cursor" "aws" "docker" "tombi" "scripts" "python")
for folder in "${folders[@]}"; do
  if [[ -d "${script_dir}/${folder}" ]]; then
    ln -sfF "${script_dir}/${folder}" "${XDG_CONFIG_HOME}/${folder}"
  else
    echo "  Warning: ${folder} directory not found, skipping..."
  fi
done

# Relative to .git/config, so the filters apply without GIT_CONFIG_GLOBAL.
if ! git config --local --get-all include.path 2>/dev/null | grep -Fqx '../git/filters.gitconfig'; then
  git config --local --add include.path ../git/filters.gitconfig
fi

# Set up shell history. HISTFILE is assigned in .zshrc, after /etc/zshrc.
echo "📜 Setting up shell history..."
histfile="${XDG_CONFIG_HOME}/zsh/.zsh_history"
mkdir -p "${histfile:h}"
if [[ -f "${HOME}/.zsh_history" ]]; then
  echo "📜 Appending ${HOME}/.zsh_history to ${histfile}..."
  cat "${HOME}/.zsh_history" >> "${histfile}"
  rm "${HOME}/.zsh_history"
elif [[ ! -f "${histfile}" ]]; then
  echo "📜 Creating new history file at ${histfile}..."
  touch "${histfile}"
fi

# Write git commit email if provided
if [[ -n "$git_commit_email" ]]; then
  echo "📧 Setting git commit email..."
  git config --global user.email "${git_commit_email}"
fi

# Install Homebrew if not present
if ! command -v "/opt/homebrew/bin/brew" &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "🍺 Homebrew already installed"
fi

echo "🍺 Caching brew shellenv..."
/opt/homebrew/bin/brew shellenv > "${XDG_CONFIG_HOME}/brew/.shellenv_cache"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install mise if not present
if ! command -v "${MISE_INSTALL_PATH}" &>/dev/null; then
  echo "🔧 Installing mise..."
  curl -fsSL https://mise.run | sh
else
  echo "🔧 mise already installed"
fi

# Move an existing ~/.npmrc once. Never overwrite the destination.
echo "🔧 Setting up npm config..."
npmrc_dest="${XDG_CONFIG_HOME}/npm/npmrc"
if [[ -f "${HOME}/.npmrc" && ! -e "${npmrc_dest}" ]]; then
  echo "🔧 Moving ${HOME}/.npmrc to ${npmrc_dest}..."
  mv "${HOME}/.npmrc" "${npmrc_dest}"
fi

# .zshrc sources tools that brew bundle installs, so a fresh machine would
# abort under set -e. Invoke brew and mise directly instead.
# Install packages and tools
if [[ "$no_install" == false ]]; then
  echo "📦 Installing packages..."
  if command -v brew &>/dev/null; then
    brew bundle
  else
    echo "❌ Error: brew command not found after installation"
    exit 1
  fi

  if [[ -x "${MISE_INSTALL_PATH}" ]]; then
    "${MISE_INSTALL_PATH}" install
  else
    echo "❌ Error: mise command not found after installation"
    exit 1
  fi

  if command -v cursor &>/dev/null; then
    extensions_file="${XDG_CONFIG_HOME}/cursor/extensions.txt"

    if [[ -f "$extensions_file" ]]; then
      install_cmd=(cursor)
      while IFS= read -r extension; do
        # Skip empty lines and comments
        if [[ -n "$extension" && ! "$extension" =~ ^[[:space:]]*# ]]; then
          install_cmd+=(--install-extension "$extension")
        fi
      done < "$extensions_file"
      install_cmd+=(--force)
      "${install_cmd[@]}"
    else
      echo "❌ Error: extensions file not found at $extensions_file"
      exit 1
    fi
  else
    echo "❌ Error: cursor command not found after installation"
    exit 1
  fi
else
  echo "⏭ Skipping package installation (--no-install flag used)"
fi

echo "🎉 Bootstrap complete!"
