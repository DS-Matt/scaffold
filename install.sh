#!/usr/bin/env bash

echo 'Installing Scaffold - be prepared to be Amazed!'

#create directory structure
if [ ! -d "$HOME/'Drive - Personal'" ]; then
  mkdir $HOME/'Drive - Personal'
fi
if [ ! -d "$HOME/'Drive - Work'" ]; then
  mkdir $HOME/'Drive - Work'
fi
if [ ! -d "$HOME/'Code'" ]; then
  mkdir -p $HOME/Code/{Sites,Snippets,Projects}
fi

# make a backup directory for overwritten dotfiles
if [[ ! -e ~/.dotfiles_backup ]]; then
    mkdir ~/.dotfiles_backup
fi

#Set dir variable to projects folder
dir="$HOME/Code/Projects"

xcode-select --install

cd $dir
git clone --recursive git://github.com/DS-MATT/scaffold.git
cd scaffold
git remote set-url origin https://github.com/DS-MATT/scaffold.git
