#!/bin/bash
set -euo pipefail

# ==================================================================
# ARTIFACTS
# ==================================================================

echo Remove unused homebrew artifacts
brew cleanup
brew cleanup
brew prune

echo Remove .DS_Store files
find "$HOME" -name '.DS_Store' -delete

echo Clean downloads folder
rm -rf "$HOME"/Downloads/*

