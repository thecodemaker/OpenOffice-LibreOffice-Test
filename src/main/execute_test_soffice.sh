#!/bin/bash

NO_OF_EXECUTIONS=2;

N=100;

cd ./resources

echo "$(date +"%H:%M:%S"): $(soffice.bin --version)" >> test_results.txt

echo "Create the documents we want to use for testing."
for i in $(seq 1 $N); do
    cp input/hello.odt input/hello_$i.odt
done

echo "Create control file.";
soffice.bin \
    --headless \
    --nocrashreport \
    --nodefault \
    --nofirststartwizard \
    --nolockcheck \
    --nologo \
    --norestore \
    --invisible \
    --convert-to pdf \
    --outdir "result/" input/hello.odt
if [ ! -f result/hello.pdf ]; then
    echo "$(date +"%H:%M:%S"): Document conversion failed." >> test_results.txt
fi

echo "Start document conversion."
startTime=$(date +%s);
for i in $(seq 1 $N); do

   soffice.bin \
    --headless \
    --nocrashreport \
    --nodefault \
    --nofirststartwizard \
    --nolockcheck \
    --nologo \
    --norestore \
    --invisible \
    --convert-to pdf \
     --outdir "result/" input/hello_$i.odt
done
endTime=$(date +%s);
duration=$((endTime-startTime));
echo "$(date +"%H:%M:%S"): Time required for converting ${N} documents: ${duration}" >> test_results.txt

echo "Clean test data."
for i in $(seq 1 $N); do
    rm -f input/hello_$i.odt result/hello*.pdf
done