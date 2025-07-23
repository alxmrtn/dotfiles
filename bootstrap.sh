#! /bin/zsh
# shellcheck disable=SC1091,SC1071

set -e  # Exit on error

# Parse command line arguments
no_install=false
git_commit_email=""
for arg in "$@"; do
  if [[ "$arg" == "--no-install" ]]; then
    no_install=true
  fi

  if [[ "$arg" == --git-commit-email=* ]]; then
    git_commit_email="${arg#--git-commit-email=}"
  fi
done

# Configuration
config_root="${HOME}/.config"
script_dir="${PWD}"

echo "⚙️ Setting up dotfiles..."

# Create necessary directories
echo "📁 Creating config directories..."
mkdir -p "$config_root/zsh"
mkdir -p "${HOME}/.warp/themes"

# Create symlinks
echo "🔗 Creating symlinks..."
ln -sfF "${script_dir}/zsh/.zshenv" "${HOME}/.zshenv"
ln -sfF "${script_dir}/zsh/.aliases" "${HOME}/.aliases"
ln -sfF "${script_dir}/zsh/.zshrc" "${HOME}/.zshrc"

# App specific symlinks that don't respect the XDG_CONFIG_HOME variable

# Warp
ln -sfF "${script_dir}/warp/almartin.yaml" "${HOME}/.warp/themes/almartin.yaml"

# TODO: Figure out how to sync cursor settings like installed extensions, etc.

# Link config folders
folders=("brew" "git" "prompt" "vim" "glow" "cursor")
for folder in "${folders[@]}"; do
  if [[ -d "${script_dir}/${folder}" ]]; then
    ln -sfF "${script_dir}/${folder}" "${config_root}/${folder}"
  else
    echo "  Warning: ${folder} directory not found, skipping..."
  fi
done

# Source environment
echo "🔄 Loading environment..."
source "${HOME}/.zshenv"

# Copy existing history if it exists
echo "📜 Setting up shell history..."
if [[ -f ~/.zsh_history ]]; then
    echo "📜 Moving existing history to ${HISTFILE}..."
    mv ~/.zsh_history "${HISTFILE}"
elif [[ ! -f "${HISTFILE}" ]]; then
    echo "📜 Creating new history file at ${HISTFILE}..."
    touch "${HISTFILE}"
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

# Install mise if not present
if ! command -v "${MISE_INSTALL_PATH}" &>/dev/null; then
  echo "🔧 Installing mise..."
  curl -fsSL https://mise.run | sh
else
  echo "🔧 mise already installed"
fi

# Final setup
echo "🔄 Reloading shell configuration..."
source "${HOME}/.zshrc"

# Install packages and tools
if [[ "$no_install" == false ]]; then
  echo "📦 Installing packages..."
  if command -v brew &>/dev/null; then
    brew bundle
  else
    echo "❌ Error: brew command not found after installation"
    exit 1
  fi

  if command -v mise &>/dev/null; then
    mise install
  else
    echo "❌ Error: mise command not found after installation"
    exit 1
  fi

  if command -v cursor &>/dev/null; then
    extensions_file="${config_root}/cursor/extensions.txt"

    if [[ -f "$extensions_file" ]]; then
      # Build command with multiple --install-extension flags
      install_cmd="cursor"
      while IFS= read -r extension; do
        # Skip empty lines and comments
        if [[ -n "$extension" && ! "$extension" =~ ^[[:space:]]*# ]]; then
          install_cmd+=" --install-extension $extension"
        fi
      done < "$extensions_file"
      install_cmd+=" --force"
      eval "$install_cmd"
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
