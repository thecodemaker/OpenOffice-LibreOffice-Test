#!/bin/bash

cd java

rm *.class
rm nohup.out

javac App.java

nohup java App 2>&1 &
#nohup java App 2>&1 &

#cd /vagrant_data
#less -h 20 nohup.out