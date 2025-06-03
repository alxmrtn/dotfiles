#!/usr/bin/env zsh

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

echo "🔧 Setting up dotfiles..."

# Create necessary directories
echo "📁 Creating config directories..."
mkdir -p "$config_root/zsh"
mkdir -p "${HOME}/.warp/themes"

# Create symlinks
echo "🔗 Creating symlinks..."
ln -sfF "${script_dir}/zsh/.zshenv" "${HOME}/.zshenv"
ln -sfF "${script_dir}/zsh/.aliases" "${HOME}/.aliases"
ln -sfF "${script_dir}/zsh/.zshrc" "${HOME}/.zshrc"

ln -sfF "${script_dir}/glow/almartin.json" "${config_root}/glow/almartin.json"
ln -sfF "${script_dir}/warp/almartin.yaml" "${HOME}/.warp/themes/almartin.yaml"

# Link config folders
folders=("brew" "git" "prompt" "vim")
for folder in "${folders[@]}"; do
  if [[ -d "${script_dir}/${folder}" ]]; then
    ln -sfF "${script_dir}/${folder}" "${config_root}/${folder}"
  else
    echo "⚠️  Warning: ${folder} directory not found, skipping..."
  fi
done

# Source environment
echo "🔄 Loading environment..."
source "${HOME}/.zshenv"

# Copy existing history if it exists
echo "📜 Setting up shell history..."
if [[ -f ~/.zsh_history ]]; then
    echo "📋 Moving existing history to ${HISTFILE}..."
    mv ~/.zsh_history "${HISTFILE}"
elif [[ ! -f "${HISTFILE}" ]]; then
    echo "📝 Creating new history file at ${HISTFILE}..."
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
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | sh
else
  echo "✅ Homebrew already installed"
fi

# Install mise if not present
if ! command -v "${MISE_INSTALL_PATH}" &>/dev/null; then
  echo "⚙️  Installing mise..."
  curl -fsSL https://mise.run | sh
else
  echo "✅ mise already installed"
fi

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
else
  echo "⏭️  Skipping package installation (--no-install flag used)"
fi

# Final setup
echo "🔄 Reloading shell configuration..."
source "${HOME}/.zshrc"

echo "✨ Bootstrap complete!"
