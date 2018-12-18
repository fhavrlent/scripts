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

You are blessed by Mac Doge
"

# ==================================================================
# ROOT
# ==================================================================

cd ~
mkdir -p repos

# ==================================================================
# SSH KEY
# ==================================================================

echo "Generating ssh keys, adding to ssh-agent..."
read -p 'Input email for ssh key: ' useremail

echo "Use default ssh file location, enter a passphrase: "
ssh-keygen -t rsa -b 4096 -C "$useremail"  # will prompt for password
eval "$(ssh-agent -s)"

# Now that sshconfig is synced add key to ssh-agent and
# store passphrase in keychain
ssh-add -K ~/.ssh/id_rsa

if [ -e ~/.ssh/config ]
then
    echo "ssh config already exists. Skipping adding osx specific settings... "
else
	echo "Writing osx specific settings to ssh config... "
   cat <<EOT >> ~/.ssh/config
	Host *
		AddKeysToAgent yes
		UseKeychain yes
		IdentityFile ~/.ssh/id_rsa
EOT
fi

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
	"rclone"
  "git"
  "mas"
  "tig"
  "yarn"
  "zsh-completions"
  "zsh" 
)

for homebrew_package in "${homebrew_packages[@]}"; do
  brew install "$homebrew_package"
done

echo "Installing NVM"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

echo "Installing Node"
. ~/.nvm/nvm.sh
. ~/.profile
. ~/.bashrc 
nvm install --lts 
nvm use --lts

echo "Upgrading npm"
npm install -g npm

# ==================================================================
# APPS 
# ==================================================================

echo "Installing Homebrew cask apps and fonts 🤔"

homebrew_cask_packages=(
  "docker"
  "firefox"
  "font-fira-code"
  "font-meslo-for-powerline"
  "google-chrome"
  "gpg-suite"
  "iterm2"
  "microsoft-teams"
  "notion"
  "postman"
  "scroll-reverser"
  "spotify"
  "timing"
  "virtualbox"
  "visual-studio-code"
  "vlc"
  "whatsapp"
  "caffeine"
)

for homebrew_cask_package in "${homebrew_cask_packages[@]}"; do
  brew cask install "$homebrew_cask_package"
done

brew cleanup

echo "Installing Mac App Store apps"

mac_app_store_apps=(
  "585829637" # Todoist
  "836505650" # Battery Monitor
  "931134707" # Wire
  "568494494" # Pocket
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

vscode_extensions=("Compulim.vscode-clock"
"capaj.vscode-exports-autocomplete"
"christian-kohler.path-intellisense"
"dbaeumer.vscode-eslint"
"eamodio.gitlens"
"EditorConfig.EditorConfig" 
"eg2.tslint"
"esbenp.prettier-vscode"
"kumar-harsh.graphql-for-vscode"
"ms-vsliveshare.vsliveshare"
"naumovs.color-highlight"
"octref.vetur"
"robertohuertasm.vscode-icons")

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
