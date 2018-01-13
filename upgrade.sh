#!/bin/bash
set -euo pipefail


# ==================================================================
# PACKAGES
# ==================================================================

# HOMEBREW

echo "Upgrading Homebrew packages"
brew update
brew upgrade

echo "Upgrading npm"
npm install npm@latest -g

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
