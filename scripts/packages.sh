#!/bin/bash

# include my library helpers for colorized echo and require_brew, etc
# Get path the Git repo
GIT_ROOT=`git rev-parse --show-toplevel`

# Load the search functions
source $GIT_ROOT/lib/lib.sh

###############################################################################
bot "Installing Homebrew"
###############################################################################
running "checking homebrew install"
brew_bin=$(which brew) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
	action "installing homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    if [[ $? != 0 ]]; then
    	error "unable to install homebrew, script $0 abort!"
    	exit -1
	fi
fi
ok

running "checking brew-cask install"
output=$(brew tap | grep cask)
if [[ $? != 0 ]]; then
	action "installing brew-cask"
	require_brew caskroom/cask/brew-cask
fi
ok

###############################################################################
bot "Installing Oh-My-ZSH"
###############################################################################
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

###############################################################################
bot "Install command-line tools using Homebrew..."
###############################################################################
# Make sure we’re using the latest Homebrew
running "updating homebrew"
brew update
ok

bot "before installing brew packages, we can upgrade any outdated packages."
read -r -p "run brew upgrade? [y|N] " response
if [[ $response =~ ^(y|yes|Y) ]];then
    # Upgrade any already-installed formulae
    action "upgrade brew packages..."
    brew upgrade
    ok "brews updated..."
else
    ok "skipped brew package upgrades.";
fi

bot "installing homebrew command-line tools"

# dos2unix converts windows newlines to unix newlines
require_brew dos2unix

# skip those GUI clients, git command-line all the way
require_brew git

# yes, yes, use git-flow, please :)
require_brew git-flow

# Install GNU `sed`, overwriting the built-in `sed`
# so we can do "sed -i 's/foo/bar/' file" instead of "sed -i '' 's/foo/bar/' file"
require_brew gnu-sed --default-names

# better, more recent grep
require_brew homebrew/dupes/grep

require_brew imagemagick
require_brew imagesnap

# jq is a JSON grep
require_brew jq

require_brew node --without-npm

#fix for installing NPM globally but not using sudo

mkdir "${HOME}/.npm-packages"
echo NPM_PACKAGES="${HOME}/.npm-packages" >> ${HOME}/.zshrc
echo prefix=${HOME}/.npm-packages >> ${HOME}/.npmrc
curl -L https://www.npmjs.org/install.sh | sh
echo NODE_PATH=\"\$NPM_PACKAGES/lib/node_modules:\$NODE_PATH\" >> ${HOME}/.zshrc
echo PATH=\"\$NPM_PACKAGES/bin:\$PATH\" >> ${HOME}/.zshrc
source ~/.zshrc

require_brew tree

# Install wget with IRI support
require_brew wget --enable-iri

require_brew autojump

require_brew unrar

require_brew mackup

require_brew hub

###############################################################################
bot "NPM Globals..."
###############################################################################

require_npm bower
require_npm bower-check-updates

require_npm grunt
require_npm gulp

require_npm eslint

require_npm prettyjson

###############################################################################
# Native Apps (via brew cask)                                                 #
###############################################################################
bot "installing GUI tools via homebrew casks..."
brew tap caskroom/versions > /dev/null 2>&1

# cloud storage
require_cask google-drive #choosing google drive over Insync because work comps only get work cloud storage
#require_cask amazon-cloud-drive
#require_cask box-sync
#require_cask dropbox
#require_cask evernote

# communication
#require_cask adium
require_cask slack
require_cask skype

# tools
require_cask spotify
require_cask camtasia
require_cask alfred
require_cask appcleaner
require_cask dashlane
require_cask cord
#require_cask todoist  -- Not supported by Homebrew Cask
require_cask google-photos-backup
require_cask microsoft-office
require_cask moom
require_cask forklift
require_cask flash-player
require_cask the-unarchiver

#Adobe Apps
require_cask adobe-creative-cloud
require_cask adobe-photoshop-cc
require_cask adobe-illustrator-cc
require_cask adobe-indesign-cc

# development browsers
require_cask firefox
require_cask google-chrome
require_cask opera

#Fluid App - allows you to create app icons for webpages
require_cask fluid

### Development tools + IDEs
require_cask iterm2
require_cask phpstorm
require_cask android-studio
require_cask visual-studio-code
require_cask android-studio
require_cask sequel-pro
require_cask dash
require_cask livereload
## Git Clients
require_cask sourcetree
require_cask tower
require_cask github-desktop
require_cask diffmerge
require_cask kaleidoscope
## virtual machines
require_cask virtualbox
# vagrant for running dev environments using docker images
require_cask vagrant # # | grep Caskroom | sed "s/.*'\(.*\)'.*/open \1\/Vagrant.pkg/g" | sh

require_cask atom

 require_apm atom-beautify
 require_apm atom-pair
 require_apm dash
 require_apm docblockr
 require_apm editor-stats
 require_apm emmet
 require_apm file-icons
 require_apm git-history
 require_apm highlight-selected
 require_apm image-view
 require_apm language-jade
 require_apm linter
 require_apm markdown-preview
 require_apm merge-conflicts
 require_apm npm-install
 require_apm pretty-json
 require_apm script
 require_apm term
 require_apm zentabs

# link with alfred
require_cask alfred link

bot "Alright, cleaning up homebrew cache..."
# Remove outdated versions from the cellar
brew cleanup > /dev/null 2>&1
bot "All clean"


###############################################################################
bot "Installing Composer..."
###############################################################################
#install Composer globally
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
