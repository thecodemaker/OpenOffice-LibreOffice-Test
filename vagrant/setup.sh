#!/bin/sh

vagrant halt
vagrant destroy -y

vagrant init
vagrant up

#vagrant reload --provision