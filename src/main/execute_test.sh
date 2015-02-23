#!/bin/bash

N=10;

cd ./resources

#echo "Create the documents we want to use for testing."
for i in $(seq 1 $N); do
    cp input/hello.odt input/hello_$i.odt
done

#echo "Convert documents."
startTime=$(date +%s);
for i in $(seq 1 $N); do
    libreoffice --headless --invisible --convert-to pdf --outdir "result/" input/hello_$i.odt &>/dev/null
done
endTime=$(date +%s);
duration=$((endTime-startTime));
echo "Time required for the operation: ${duration}";

#echo "Clean test data."
for i in $(seq 1 $N); do
    rm -f input/hello_$i.odt result/hello_$i.pdf
done