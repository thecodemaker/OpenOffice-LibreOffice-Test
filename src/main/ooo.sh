#!/bin/bash

OOO_HOME=/Applications/OpenOffice.org.app/Contents
USER_HOME=/tmp

_create_home() {
    port=$1
    home=${USER_HOME}/user/port${port}
    mkdir -p ${home}
    chmod -R 777 ${home}
    echo ${home}
}

_start_instances() {
    host=${OOO_HOST:-127.0.0.1}
    port=8100
    # Set user home
    HOME=$(_create_home ${port})
    export HOME
    # Start OOo
    echo "Starting Office on ${host}:${port} using home directory ${HOME}"
    sock="socket,host=${host},port=${port},tcpNoDelay=1;urp;StarOffice.ServiceManager"

    if [[ ${1} == Lib* ]]; then
        opts="--nologo --nofirststartwizard --nodefault --nocrashreport --norestart --nolockcheck --headless"
        nohup soffice --userid="${HOME}" --accept="${sock}" ${opts} > soffice_${port}.log 2>&1 &
    else
        opts="-nologo -nofirststartwizard -nodefault -nocrashreport -norestart -nolockcheck -headless"
        nohup soffice -userid="${HOME}" -accept="${sock}" ${opts} > soffice_${port}.log 2>&1 &
    fi
}

_start_instances $1
exit 0