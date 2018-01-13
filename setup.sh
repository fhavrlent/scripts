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
  "node"
  "mas"
  "nvm"
  "tig"
  "yarn"
)
for homebrew_package in "${homebrew_packages[@]}"; do
  brew install "$homebrew_package"
done


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

Most importantly, my task list (Todoist) is the single source of truth linking to everything else. 

Most things are taken care of automatically with the set up script, but some manual items are needed:

- Install my ethernet adapter drivers from http://www.asix.com.tw/FrootAttach/driver/AX88179_178A_Macintosh_Driver_Installer_v2.9.0_20171011.zip
- Sync iTerm2 settings with `com.googlecode.iterm2.plist` dotfile
- Text Message Forwarding (on, from iPhone)
- Remove all dock icons
- Delete unused factory Applications
- Remove notification center widgets
- General
  - Highlight color (Nova cyan)
- Keyboard
  - For each keyboard
    - Modifier keys caps lock (escape)
  - Touch bar (app controls)
- Users
  - Add avatar
  - Login items (`RescueTime`)
- Audio & video
  - Video input: webcam camera
  - Audio input: webcam mic
  - Audio output: DAC
- Desktop & Screen Saver
  - Add desktop background
- Finder
  - Favorites (`trevordmiller` only)
  - Show all filename extensions (on)
  - Show warning before changing an extension (off)
  - Correct spelling automatically (off)
  - Remove items from the Trash after 30 days (on)
  - Keep folders on top when sorting by name (on)
- Face ID
  - Login (on)
  - Apple Pay (on)
- iCloud
  - Enable everything
- Notification Center
  - Do Not Disturb
    - Scheduled (on, from 10pm-6am)
    - When display is sleeping (on)
    - When mirroring to TVs and projectors (on)
    - Allow repeated calls (on)
    - Sort order (recents by app)
  - Turn off notifications for all apps that have email notifications
- Display
  - Night Shift
    - Scheduled (from sunset to sunrise)
    - Full warmth
- Sound
  - Alert sound (glass)
  - Alert volume (full)
- Sound
  - Show volume in menu bar (on)
- Todoist
  - Show in menu bar (off)
  - Show badge in dock icon (off)
- Calendar
  - Add "Personal" and "Work" accounts
  - Time to leave (on)
  - Show shared calendar messages in notification center (off)
- Chrome
  - Set as default browser
  - Add "personal", "work", and "flashcardbot" profiles, signed in to the related google account
    - Safe search (on, locked)
    - Extensions
      - Confirm install (1Password, Grammarly, Vimium, Adblock Plus, React DevTools, Apollo DevTools)
      - Vimium custom mappings
        - map <c-b> scrollFullPageUp
        - map <c-f> scrollFullPageDown
      - Adblock Plus settings
        - Allow some non-intrusive advertising (off)
        - Show 'Block Element' right-click menu item (off)
        - Show 'Adblock Plus' panel in the developer tools (off)
      - Hide icons in Chrome menu

EOF
