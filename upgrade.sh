#!/bin/bash
set -euo pipefail

. ~/.nvm/nvm.sh


# ==================================================================
# PACKAGES
# ==================================================================

# HOMEBREW

echo "Upgrading global Homebrew packages"
brew update
brew upgrade

echo "Upgrading Node"
nvm install --lts
nvm use --lts

echo "Upgrading npm"
npm install -g npm

# ==================================================================
# MAC APP STORE
# ==================================================================

echo "Upgrading Mac App Store apps"
mas upgrade

# ==================================================================
# MACOS
# ==================================================================

echo "Upgrading macOS"
sudo softwareupdate -ia
