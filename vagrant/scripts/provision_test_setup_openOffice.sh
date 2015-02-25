#!/bin/sh

sudo apt-get -y purge openoffice*

sudo apt-get -y install software-properties-common python-software-properties

echo "[vagrant provisioning] Installing OpenOffice..."

sudo add-apt-repository ppa:upubuntu-com/office

sudo apt-get -y update

sudo apt-get -y install openoffice

##### PROVISION CHECK #####

# Create .provision_check for the script to check on during a next vargant up.
echo "[vagrant provisioning] Creating .provision_check file..."
touch .provision_check
