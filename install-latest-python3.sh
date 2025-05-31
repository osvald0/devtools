#!/bin/bash

# ------------------------------------------------------------------------------
#
# This script installs `pyenv` using Homebrew (if not already installed),
# sets up the required shell configuration in `~/.zshrc`, and installs
# the latest stable Python 3.x version using pyenv.
#
# Notes:
#   - Assumes you're using Zsh and have Homebrew installed.
#   - Safe to run multiple times; it checks for existing setup.
#
# ------------------------------------------------------------------------------

set -e

echo "Installing pyenv..."
brew install pyenv

echo "Adding pyenv config to ~/.zshrc..."
if ! grep -q 'pyenv init' ~/.zshrc; then
  {
    echo ''
    echo '# Pyenv setup'
    echo 'export PYENV_ROOT="$HOME/.pyenv"'
    echo 'command -v pyenv >/dev/null && eval "$(pyenv init -)"'
  } >>~/.zshrc
fi

echo "Reloading shell config..."
source ~/.zshrc

echo "Finding latest stable Python 3.x version..."
LATEST=$(pyenv install --list | grep -E '^\s*3\.[0-9]+\.[0-9]+$' | grep -v - | tail -1 | tr -d ' ')

echo "Installing Python $LATEST..."
pyenv install -s "$LATEST"
pyenv global "$LATEST"

echo "Python $(python --version) is ready to use!"
