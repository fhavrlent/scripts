#!/bin/bash
set -euo pipefail


# ==================================================================
# ROOT
# ==================================================================

cd ~
mkdir repos


# ==================================================================
# SHELL SCRIPTS
# ==================================================================

#echo "Cloning shell scripts"
#cd ~/repos
#git clone https://github.com/trevordmiller/shell-scripts.git
#cd ~


# ==================================================================
# DOTFILES
# ==================================================================

#echo "Cloning dotfiles"
#cd ~/repos
#git clone https://github.com/trevordmiller/dotfiles.git
#cd dotfiles
#./index
#cd ~


# ==================================================================
# PACKAGES
# ==================================================================

echo "Installing Homebrew"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Installing Homebrew packages"

homebrew_packages=(
  "git"
  "mas"
  "yarn"
  "nvm"
  "tig"
)
for homebrew_package in "${homebrew_packages[@]}"; do
  brew install "$homebrew_package"
done

echo "Installing Node"
nvm install node
nvm use node


echo "Upgrading npm"
npm install npm@latest -g


# ==================================================================
# APPS 
# ==================================================================

echo "Installing Homebrew cask apps and fonts"

brew tap caskroom/cask
brew tap caskroom/fonts

homebrew_cask_packages=(
  "iterm2"
  "google-chrome"
  "firefox"
  "slack"
  "skype"
  "visual-studio-code"
  "macpass"
  "tunnelblick"
  "sequel-pro"
  "postman"
  "filezilla"
  "whatsapp"
  "font-meslo-for-powerline"
)
for homebrew_cask_package in "${homebrew_cask_packages[@]}"; do
  brew cask install "$homebrew_cask_package"
done

echo "Installing Mac App Store apps"

mac_app_store_apps=(
  "585829637" # Todoist
  "1055511498" # Day One
  "715768417" # MS Remote Desktop
  "747648890" # Telegram
  "402592703" # Timeout
  "497799835" # XCode
  "836505650" # Battery Monitor
  "931134707" # Wire
  "568494494" # Pocket
)
for mac_app_store_app in "${mac_app_store_apps[@]}"; do
  mas install "$mac_app_store_app"
done

# ==================================================================
# VS Code
# ==================================================================

cat << EOF >> ~/.bash_profile
# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
EOF

vscode_extensions=("Compulim.vscode-clock"
"EditorConfig.EditorConfig"
"burkeholland.simple-react-snippets"
"capaj.vscode-exports-autocomplete"
"christian-kohler.path-intellisense"
"dbaeumer.vscode-eslint"
"dzannotti.vscode-babel-coloring"
"emmanuelbeziat.vscode-great-icons"
"esbenp.prettier-vscode"
"felixfbecker.php-intellisense"
"kokororin.vscode-phpfmt"
"naumovs.color-highlight"
"robinbentley.sass-indented"
"xabikos.JavaScriptSnippets")

for vscode_extension in "${vscode_extensions[@]}"; do
  code --install-extension "$vscode_extension"
done

cp ./vscode.json ~/Library/Application\ Support/Code/User/settings.json

# ==================================================================
# iTerm
# ==================================================================
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp ./.zshrc ~/.zshrc
source ~/.zshrc

# ==================================================================
# MACOS
# ==================================================================

# HIDDEN FILES

echo "Configuring hidden files to show"
defaults write com.apple.finder AppleShowAllFiles YES
killall Finder


# SCREENSHOTS

echo "Configuring screenshots to save in Downloads"
defaults write com.apple.screencapture location ~/Downloads
killall SystemUIServer

# CHROME

echo "Configuring incognito mode"
defaults write com.google.chrome IncognitoModeAvailability -integer 1


# ==================================================================
# MANUAL
# ==================================================================

cat << EOF

Stuff to do will go here
EOF
