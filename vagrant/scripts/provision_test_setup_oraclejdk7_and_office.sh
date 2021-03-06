#!/bin/bash

OFFICE_VERSION=${1%?};
echo "PARAM: OFFICE_VERSION=${OFFICE_VERSION}";

OFFICE_DEB_FILE=${2};
echo "PARAM: OFFICE_DEB_FILE=${OFFICE_DEB_FILE}";

CACHE_DIR='/var/cache/wget'
TMP_DIR='/tmp'

##### PROVISION #####

sudo apt-get -y purge openjdk-7-jdk
sudo apt-get -y purge libreoffice* openoffice*

sudo apt-get -y update
sudo apt-get -y install software-properties-common python-software-properties unzip


echo "[vagrant provisioning] Installing Java..."

wget -N -P ${CACHE_DIR} --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-linux-i586.tar.gz

mkdir /opt/jdk

tar -zxf ${CACHE_DIR}/jdk-7u75-linux-i586.tar.gz -C /opt/jdk

update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.7.0_75/bin/java 100

update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.7.0_75/bin/javac 100

update-alternatives --display java

update-alternatives --display javac

java -version


echo "[vagrant provisioning] Installing Office..."

sudo apt-get install -y libxrandr2 libxinerama1 libcups2 libfontconfig libglu1 libsm6

if [[ ${OFFICE_DEB_FILE} == Lib* ]]; then
    wget -N -P ${CACHE_DIR} http://downloadarchive.documentfoundation.org/libreoffice/old/${OFFICE_VERSION}/deb/x86/${OFFICE_DEB_FILE}.tar.gz
else
    wget -N -P ${CACHE_DIR} http://sourceforge.net/projects/openofficeorg.mirror/files/${OFFICE_VERSION}/binaries/en-US/${OFFICE_DEB_FILE}.tar.gz
fi

tar -xvzf ${CACHE_DIR}/${OFFICE_DEB_FILE}.tar.gz -C ${TMP_DIR}

if [[ ${OFFICE_DEB_FILE} == Lib* ]]; then
    cd ${TMP_DIR}/${OFFICE_DEB_FILE:0:3}*/DEBS
else
    cd ${TMP_DIR}/en*/DEBS
fi

sudo dpkg -i *.deb


if [[ ${OFFICE_DEB_FILE} == Lib* ]]; then
    office_instance='libreoffice';
else
    office_instance='openoffice';
fi
update-alternatives --install /usr/bin/soffice soffice /opt/${office_instance}${OFFICE_VERSION::-4}/program/soffice 100
update-alternatives --install /usr/bin/soffice.bin soffice.bin /opt/${office_instance}${OFFICE_VERSION::-4}/program/soffice.bin 100

update-alternatives --display soffice
update-alternatives --display soffice.bin

#soffice.bin --version

echo "[vagrant provisioning] Copying jodconverter..."

wget -N -P ${CACHE_DIR} wget http://sourceforge.net/projects/jodconverter/files/JODConverter/2.2.2/jodconverter-2.2.2.zip

unzip -o ${CACHE_DIR}/jodconverter-2.2.2.zip -d /vagrant_data/

##### END PROVISION #####

##### PROVISION CHECK #####

# Create .provision_check for the script to check on during a next vargant up.
echo "[vagrant provisioning] Creating .provision_check file..."
touch .provision_check

##### END PROVISION CHECK #####