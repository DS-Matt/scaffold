#!/bin/bash

cd ~/Code/Sites/Cronus

vagrant login

#creates the vagrant box virtual machine
vagrant up

#will be prompted to login to vagrant server

#SSH into Vagrant Zeus and set up DB stuff
vagrant ssh zues

#Once inside Zeus - run the following mysql commands
mysql -u root -p
# need to respond with password for mysql on the Vangrant box via scaffold.sh

#Create database as root user
CREATE DATABASE IF NOT EXISTS dsgi;

#Create user and give unlimited provileges on dsgi database
CREATE USER 'dsgi'@'localhost' IDENTIFIED BY 'Dsgi-01';
GRANT ALL PRIVILEGES ON dsgi.* TO 'dsgi'@'localhost';

#Quit mysql
echo '\q'

cd zeus

composer install

cd upload

bower install

npm install

open http://dev.diversified-systems.loc/

touch config.php
touch admin/config.php

mkdir -p image/{cache,catalog}
