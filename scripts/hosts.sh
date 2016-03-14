#!/bin/bash

# Hardlink Hosts file to backed up hosts file
rm /private/etc/hosts
ln $HOME/Code/Projects/dotBot/mackupBackup/hosts /private/etc/hosts
