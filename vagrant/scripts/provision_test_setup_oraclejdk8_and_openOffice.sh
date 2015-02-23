#!/bin/sh

sudo apt-get -y purge openjdk-8-jdk

sudo apt-get install -y software-properties-common python-software-properties

sudo add-apt-repository -y ppa:webupd8team/java

sudo apt-get -y update

JAVA_VERSION="oracle-java8-installer"

echo "[vagrant provisioning] Installing Java..."

sudo apt-get -y install oracle-java8-installer

export JAVA_HOME=/usr/lib/jvm/java-8-oracle

echo "[vagrant provisioning] Installing LibreOffice..."

sudo apt-add-repository ppa:libreoffice/libreoffice-4-2

sudo apt-get -y update

sudo apt-get install libreoffice

##### PROVISION CHECK #####

# Create .provision_check for the script to check on during a next vargant up.
echo "[vagrant provisioning] Creating .provision_check file..."
touch .provision_check