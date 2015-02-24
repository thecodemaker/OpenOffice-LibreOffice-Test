#!/bin/sh

sudo apt-get -y purge openjdk-7-jdk

sudo apt-get -y purge libreoffice*

sudo apt-get -y update

sudo apt-get -y install software-properties-common python-software-properties
sudo add-apt-repository -y ppa:webupd8team/java

sudo apt-get -y update

JAVA_VERSION="oracle-java7-installer"

echo "[vagrant provisioning] Installing Java..."

echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections

sudo apt-get -y install oracle-java7-installer

export JAVA_HOME=/usr/lib/jvm/java-7-oracle

echo "[vagrant provisioning] Installing LibreOffice..."

sudo add-apt-repository -y ppa:libreoffice/libreoffice-4-4

sudo apt-get -y update

sudo apt-get -y install libreoffice

##### PROVISION CHECK #####

# Create .provision_check for the script to check on during a next vargant up.
echo "[vagrant provisioning] Creating .provision_check file..."
touch .provision_check
