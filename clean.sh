#!/bin/bash
set -euo pipefail

# ==================================================================
# ARTIFACTS
# ==================================================================

echo Remove unused homebrew artifacts
brew cleanup

echo Clean downloads folder
rm -rf "$HOME"/Downloads/*

