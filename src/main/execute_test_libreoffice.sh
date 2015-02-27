#!/bin/bash

N=100;
echo "$(date +"%H:%M:%S"): $(libreoffice --version)" >> test_results.txt

cd ./resources

#echo "Create the documents we want to use for testing."
for i in $(seq 1 $N); do
    cp input/hello.odt input/hello_$i.odt
done

libreoffice --headless --invisible --convert-to pdf --outdir "result/" input/hello.odt &>/dev/null
[[ $? != 0 ]] && echo "$(date +"%H:%M:%S"): Document conversion failed." >> test_results.txt

echo "$(date +"%H:%M:%S"): Start document conversion."
startTime=$(date +%s);
for i in $(seq 1 $N); do
    libreoffice --headless --invisible --convert-to pdf --outdir "result/" input/hello_$i.odt &>/dev/null
done
endTime=$(date +%s);
duration=$((endTime-startTime));
echo "$(date +"%H:%M:%S"): Time required for converting ${N} documents: ${duration}" >> test_results.txt

#echo "Clean test data."
for i in $(seq 1 $N); do
    rm -f input/hello_$i.odt result/hello*.pdf
done