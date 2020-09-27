#!/bin/bash
set -euo pipefail

echo "
░░░░░░░░░▄░░░░░░░░░░░░░░▄
░░░░░░░░▌▒█░░░░░░░░░░░▄▀▒▌
░░░░░░░░▌▒▒█░░░░░░░░▄▀▒▒▒▐
░░░░░░░▐▄▀▒▒▀▀▀▀▄▄▄▀▒▒▒▒▒▐
░░░░░▄▄▀▒░▒▒▒▒▒▒▒▒▒█▒▒▄█▒▐
░░░▄▀▒▒▒░░░▒▒▒░░░▒▒▒▀██▀▒▌
░░▐▒▒▒▄▄▒▒▒▒░░░▒▒▒▒▒▒▒▀▄▒▒▌
░░▌░░▌█▀▒▒▒▒▒▄▀█▄▒▒▒▒▒▒▒█▒▐
░▐░░░▒▒▒▒▒▒▒▒▌██▀▒▒░░░▒▒▒▀▄▌
░▌░▒▄██▄▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▌
▌▒▀▐▄█▄█▌▄░▀▒▒░░░░░░░░░░▒▒▒▐
▐▒▒▐▀▐▀▒░▄▄▒▄▒▒▒▒▒▒░▒░▒░▒▒▒▒▌
▐▒▒▒▀▀▄▄▒▒▒▄▒▒▒▒▒▒▒▒░▒░▒░▒▒▐
░▌▒▒▒▒▒▒▀▀▀▒▒▒▒▒▒░▒░▒░▒░▒▒▒▌
░▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▒▄▒▒▐
░░▀▄▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▄▒▒▒▒▌
░░░░▀▄▒▒▒▒▒▒▒▒▒▒▄▄▄▀▒▒▒▒▄▀
░░░░░░▀▄▄▄▄▄▄▀▀▀▒▒▒▒▒▄▄▀
░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▀▀

You are blessed by Mac Doge!
"

# ==================================================================
# ROOT
# ==================================================================

cd ~
mkdir -p repos

# ==================================================================
# PACKAGES
# ==================================================================

echo "Installing Homebrew"
if test ! $(which brew)
then
	## Don't prompt for confirmation when installing homebrew
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
fi

brew upgrade
brew update

echo "Adding Homebrew taps"

homebrew_taps=(
	"caskroom/cask"
  "caskroom/fonts"
)

for homebrew_tap in "${homebrew_taps[@]}"; do
	brew tap "$homebrew_tap"
done

echo "Installing global Homebrew packages"

homebrew_packages=(
  "git"
  "mas"
  "thefuck"
  "tig"
  "yarn"
  "zsh-completions"
  "zsh"
)

for homebrew_package in "${homebrew_packages[@]}"; do
  brew install "$homebrew_package"
done

echo "Installing NVM"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.35.3/install.sh | bash

echo "Installing Node"
. ~/.nvm/nvm.sh
nvm install --lts 
nvm use --lts

echo "Upgrading npm"
npm install -g npm

# ==================================================================
# APPS 
# ==================================================================

echo "Installing Homebrew cask apps and fonts 🤔"

homebrew_cask_packages=(
  "adguard"
  "alfred"
  "appcleaner"
  "bartender"
  "calibre"
  "chromium"
  "discord"
  "docker"
  "evernote"
  "firefox-developer-edition"
  "font-fira-code"
  "gpg-suite"
  "iterm2"
  "karabiner-elements"
  "keybase"
  "notion"
  "openemu"
  "scroll-reverser"
  "signal"
  "slack"
  "sourcetree"
  "spotify"
  "steam"
  "tableplus"
  "tunnelblick"
  "visual-studio-code"
  "vlc"
  "whatsapp"
)

for homebrew_cask_package in "${homebrew_cask_packages[@]}"; do
  brew cask install "$homebrew_cask_package"
done

brew cleanup

echo "Installing Mac App Store apps"

mac_app_store_apps=(
  "1511185140" # MoneyWiz
  "1482490089" # Tampermonkey
  "1477385213" # Save to Pocket
  "1481669779" # Evernote Web Clipper
  "1055511498" # Day One
  "568494494" # Pocket
  "1449412482" # Reeder
  "732710998" # Enpass
)

for mac_app_store_app in "${mac_app_store_apps[@]}"; do
  mas install "$mac_app_store_app"
done

# ==================================================================
# VS Code
# ==================================================================

echo "Setting up VS Code"

cat << EOF >> ~/.bash_profile
# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
EOF

vscode_extensions=(
  "azemoh.one-monokai"
  "capaj.vscode-exports-autocomplete"
  "christian-kohler.path-intellisense"
  "Compulim.vscode-clock"
  "dbaeumer.vscode-eslint"
  "eamodio.gitlens"
  "EditorConfig.EditorConfig"
  "esbenp.prettier-vscode"
  "Gruntfuggly.todo-tree"
  "ms-vsliveshare.vsliveshare"
  "naumovs.color-highlight"
  "netcorext.uuid-generator"
  "redhat.vscode-yaml"
  "streetsidesoftware.code-spell-checker"
  "vscode-icons-team.vscode-icons"
  "waderyan.gitblame"
  "wix.vscode-import-cost"
)

for vscode_extension in "${vscode_extensions[@]}"; do
  code --install-extension "$vscode_extension"
done


# ==================================================================
# REPOS
# ==================================================================

cd ~/repos

echo "Cloning scripts"
git clone https://github.com/fhavrlent/scripts.git

echo "Cloning dotfiles"
git clone https://github.com/fhavrlent/dotfiles.git


# ==================================================================
# DOTFILES
# ==================================================================

cd ~/repos/dotfiles

echo "VS Code dotfiles"
rm -f ~/Library/Application\ Support/Code/User/settings.json
ln ./vscode.json ~/Library/Application\ Support/Code/User/settings.json

echo "ZSH dotfiles"
rm -f ~/.zshrc
ln ./.zshrc ~/.zshrc


# ==================================================================
# MACOS
# ==================================================================

osascript -e 'tell application "System Preferences" to quit'

echo "Save to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "Disable the “Are you sure you want to open this application?” dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "Configuring screenshots to save in Downloads"
defaults write com.apple.screencapture location ~/Downloads

echo "Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
defaults write com.apple.screencapture type -string "png"

echo "Avoid creating .DS_Store files on network or USB volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo "Minimize windows into their application’s icon"
defaults write com.apple.dock minimize-to-application -bool true

echo "Disable auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

echo "Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "Stop iTunes from responding to the keyboard media keys"
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

echo "Don’t show recent applications in Dock"
defaults write com.apple.dock show-recents -bool false

echo "Enable the automatic update check"
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

echo "Download newly available updates in background"
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

echo "Install System data files & security updates"
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# ==================================================================
# oh-my-zsh
# ==================================================================

echo "Setting up oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "zsh dotfiles"
rm -f ~/.zshrc
ln .zshrc ~/.zshrc
. ~/.zshrc

cd ~

echo "Install Cryptomator - https://cryptomator.org/"
echo "Install all favorites from Setapp"