#!/bin/sh

vagrant halt
vagrant destroy

vagrant init
vagrant up

#vagrant reload --provision