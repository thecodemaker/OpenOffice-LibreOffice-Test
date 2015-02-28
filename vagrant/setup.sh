#!/bin/bash

LIBREOFFICE_VERSIONS=(\
#    '4.4.1.2' \
#    '4.3.6.2' \
#    '4.2.8.2' \
#    '4.1.6.2' \
#    '4.0.6.2' \
#    '3.6.7.2' \
    '3.5.7.2' \
#    '3.4.6.2' \
#    '3.3.4.1' \
    );

LIBREOFFICE_DEB_FILES=(\
#    'LibreOffice_4.4.1.2_Linux_x86_deb' \
#    'LibreOffice_4.3.6.2_Linux_x86_deb' \
#    'LibreOffice_4.2.8.2_Linux_x86_deb' \
#    'LibreOffice_4.1.6.2_Linux_x86_deb' \
#    'LibreOffice_4.0.6.2_Linux_x86_deb' \
#    'LibO_3.6.7.2_Linux_x86_install-deb_en-US' \
    'LibO_3.5.7rc2_Linux_x86_install-deb_en-US' \
#    'LibO_3.4.6rc2_Linux_x86_install-deb_en-US' \
#    'LibO_3.3.4_Linux_x86_install-deb_en-US' \
    );

for (( i=0; i<${#LIBREOFFICE_VERSIONS[@]}; i++)); do

    echo "Start setup for LibreOffice ${LIBREOFFICE_VERSIONS[$i]}";

    vagrant halt
    vagrant destroy --force

    vagrant init

    LIBREOFFICE_VERSION="${LIBREOFFICE_VERSIONS[$i]}" \
    LIBREOFFICE_DEB_FILE="${LIBREOFFICE_DEB_FILES[$i]}" \
    vagrant up

    sleep 10;

    vagrant ssh --command "cd /vagrant_data/; ./execute_test_soffice.sh;"
done

#vagrant reload --provision