#!/bin/bash

LIBREOFFICE_VERSION=${1%?};
echo "PARAM: LIBREOFFICE_VERSION=${LIBREOFFICE_VERSION}";

LIBREOFFICE_DEB_FILE=${2%?};
echo "PARAM: LIBREOFFICE_DEB_FILE=${LIBREOFFICE_DEB_FILE}";

LIBREOFFICE_HELPPACK_FILE=${3};
echo "PARAM: LIBREOFFICE_HELPPACK_FILE=${LIBREOFFICE_HELPPACK_FILE}";


CACHE_DIR='/var/cache/wget'
TMP_DIR='/tmp'

##### PROVISION #####

sudo apt-get -y purge openjdk-7-jdk
sudo apt-get -y purge libreoffice*

sudo apt-get -y update
sudo apt-get -y install software-properties-common python-software-properties


echo "[vagrant provisioning] Installing Java..."

wget -N -P ${CACHE_DIR} --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-linux-i586.tar.gz

mkdir /opt/jdk

tar -zxf ${CACHE_DIR}/jdk-7u75-linux-i586.tar.gz -C /opt/jdk

update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.7.0_75/bin/java 100

update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.7.0_75/bin/javac 100

update-alternatives --display java

update-alternatives --display javac

java -version


echo "[vagrant provisioning] Installing LibreOffice..."

wget -N -P ${CACHE_DIR} http://downloadarchive.documentfoundation.org/libreoffice/old/${LIBREOFFICE_VERSION}/deb/x86/${LIBREOFFICE_DEB_FILE}.tar.gz

tar -xvzf ${CACHE_DIR}/${LIBREOFFICE_DEB_FILE}.tar.gz -C ${TMP_DIR}

cd ${TMP_DIR}/${LIBREOFFICE_DEB_FILE}/DEBS

sudo dpkg -i *.deb

wget -N -P ${CACHE_DIR} http://downloadarchive.documentfoundation.org/libreoffice/old/${LIBREOFFICE_VERSION}/deb/x86/${LIBREOFFICE_HELPPACK_FILE}.tar.gz

tar -xvzf ${CACHE_DIR}/${LIBREOFFICE_HELPPACK_FILE}.tar.gz -C ${TMP_DIR}

cd ${TMP_DIR}/${LIBREOFFICE_HELPPACK_FILE}/DEBS

sudo dpkg -i *.deb

update-alternatives --install /usr/bin/soffice soffice /opt/libreoffice${LIBREOFFICE_VERSION::-4}/program/soffice 100

update-alternatives --display soffice

soffice --version

##### END PROVISION #####

##### PROVISION CHECK #####

# Create .provision_check for the script to check on during a next vargant up.
echo "[vagrant provisioning] Creating .provision_check file..."
touch .provision_check

##### END PROVISION CHECK #####