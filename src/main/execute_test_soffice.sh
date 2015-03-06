#!/bin/bash

cd ./resources

echo -e "\n---------------------------------------------------------------------------------------------------------------" >> test_results.txt
echo -e "$(date +"%H:%M:%S"):\t${1}" >> test_results.txt
echo -e "$(date +"%H:%M:%S"):\t${1}" >> execute_test_log.txt

NO_OF_DOCUMENTS=50;
NO_OF_EXECUTIONS=5;
FILENAMES=(\
    'hello' \
    'ODFAG' \
    );

for ((f=0; f<${#FILENAMES[@]}; f++)); do
    filename="${FILENAMES[$f]}";
    filesize=$(stat -c%s "input/${filename}.odt")

    declare -A durations;
    for execution in $(seq 1 $NO_OF_EXECUTIONS); do

        echo "Create the documents we want to use for testing."
        for i in $(seq 1 $NO_OF_DOCUMENTS); do
            cp input/${filename}.odt input/${filename}_$i.odt
        done

        echo "Create control file.";
        java -jar ../jodconverter-2.2.2/lib/jodconverter-cli-2.2.2.jar input/${filename}.odt result/${filename}.pdf 2>> execute_test_log.txt

        echo "Start document conversion."
        startTime=$(date +%s);

        converted_documents=0;
        for i in $(seq 1 $NO_OF_DOCUMENTS); do
           java -jar ../jodconverter-2.2.2/lib/jodconverter-cli-2.2.2.jar input/${filename}_$i.odt result/${filename}_$i.pdf 2>> execute_test_log.txt
           if [ -f result/${filename}.pdf ]; then
               converted_documents=$((converted_documents+1));
           fi
        done

        endTime=$(date +%s);
        duration=$((endTime-startTime));
        durations[$((execution-1))]=$duration;
        echo -e "$(date +"%H:%M:%S"):\tExecution:\t[${execution}]\tNO_OF_DOCUMENTS:\t[${converted_documents}]\tDocument size:\t[${filesize}]Kb\tTime:\t[${duration}]\tseconds." >> test_results.txt

        echo "Clean test data."
        for i in $(seq 1 $NO_OF_DOCUMENTS); do
            rm -f input/${filename}_${i}.odt result/${filename}*.pdf
        done
    done

    average=$(
       echo "${durations[*]}" | awk '{len=split($0, a, " ")}END{for(i in a) sum+=a[i]}END{print sum/len}'
    );
    standardDeviation=$(
        echo "${durations[*]}" | awk '{len=split($0, a, " ")}END{for(i in a) {sum+=a[i]; sumsq+=a[i]*a[i]}}END{print (sumsq/len-(sum/len)^2)^0.5}'
    )
    echo -e "$(date +"%H:%M:%S"):\tDocument size:\t[${filesize}]Kb\tAverage duration:\t[${average}]\tseconds\tStandard Deviation:\t${standardDeviation}\t%\n"  >> test_results.txt
done
echo "---------------------------------------------------------------------------------------------------------------" >> test_results.txt