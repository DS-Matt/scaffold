#!/bin/bash

###########################
# This script installs the dotfiles and runs all other system configuration scripts
# @author Adam Eivy with contributions by Matthew Sambrook
###########################

##TODO: Wrap this in a prompt if the user has a mackup backup (if not then do this)

# include my library helpers for colorized echo and require_brew, etc
source ./lib.sh

# make a backup directory for overwritten dotfiles
if [[ ! -e ~/.dotfiles_backup ]]; then
    mkdir ~/.dotfiles_backup
fi

bot "Hi. I'm DotBot. I am going to make your OSX system better."

fullname=`osascript -e "long user name of (system info)"`

if [[ -n "$fullname" ]];then
  lastname=$(echo $fullname | awk '{print $2}');
  firstname=$(echo $fullname | awk '{print $1}');
fi

# me=`dscl . -read /Users/$(whoami)`

if [[ -z $lastname ]]; then
  lastname=`dscl . -read /Users/$(whoami) | grep LastName | sed "s/LastName: //"`
fi
if [[ -z $firstname ]]; then
  firstname=`dscl . -read /Users/$(whoami) | grep FirstName | sed "s/FirstName: //"`
fi
email=`dscl . -read /Users/$(whoami)  | grep EMailAddress | sed "s/EMailAddress: //"`

if [[ ! "$firstname" ]];then
  response='n'
else
  echo -e "I see that your full name is $COL_YELLOW$firstname $lastname$COL_RESET"
  read -r -p "Is this correct? [Y|n] " response
fi

if [[ $response =~ ^(no|n|N) ]];then
  read -r -p "What is your first name? " firstname
  read -r -p "What is your last name? " lastname
fi
fullname="$firstname $lastname"

bot "Great $fullname, no we will install some apps!"

./scripts/packages.sh

bot "Everything is intstalled, now creating symlinks for mackup backup of dotfiles."

symlinkifne .mackup.cfg

./scripts/osx.sh
./scripts/repos.sh
sudo ./scripts/hosts.sh

bot "Woot! All done."
