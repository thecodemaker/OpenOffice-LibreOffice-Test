#!/bin/bash

cd ./resources

echo -e "$(date +"%H:%M:%S"):\t$(soffice.bin --version)" >> test_results.txt

NO_OF_DOCUMENTS=100;
NO_OF_EXECUTIONS=10;
for execution in $(seq 1 $NO_OF_EXECUTIONS); do

    echo "Create the documents we want to use for testing."
    for i in $(seq 1 $NO_OF_DOCUMENTS); do
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
        --outdir "result" input/hello.odt

    if [ ! -e result/hello.pdf ]; then
        echo "$(date +"%H:%M:%S"): Document conversion failed." >> test_results.txt
        exit 1;
    fi

    echo "Start document conversion."
    startTime=$(date +%s);
    for i in $(seq 1 $NO_OF_DOCUMENTS); do

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
         --outdir "result" input/hello_$i.odt
    done
    endTime=$(date +%s);
    duration=$((endTime-startTime));
    echo -e "$(date +"%H:%M:%S"): Execution:\t[${execution}]\tNO_OF_DOCUMENTS:\t[${NO_OF_DOCUMENTS}]\tTime:\t[${duration}]\tseconds." >> test_results.txt

    echo "Clean test data."
    for i in $(seq 1 $NO_OF_DOCUMENTS); do
        rm -f input/hello_$i.odt result/hello*.pdf
    done

done