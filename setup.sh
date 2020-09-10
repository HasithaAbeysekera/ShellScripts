#!/bin/bash

# Setup file for testing cloning.
# Config
TESTDIRS='testdirs.txt'
TESTFILES='testfiles.txt'



for LINE in $(cat ${TESTDIRS})
do
	#echo "LINE: ${LINE}"
	mkdir ${LINE}
done


for LINE in $(cat ${TESTFILES})
do
	FILENAME=$(echo "${LINE}" | cut -d ":" -f1)
	TIME=$(echo "${LINE}" | cut -d ":" -f2 -s)
	#	
	MODTIME=$( date --date="-${TIME} days")

	echo "FILENAME: ${FILENAME}"
	echo "TIME: ${TIME}"
	#touch ${FILENAME}
	touch -d "${MODTIME}" ${FILENAME} 
	echo "FILE: ${FILE} created with time ${MODTIME}"
	echo

	#echo $( date --date="-${TIME} days")
done

touch vol03/passwd.txt

echo $'test123\npassword1\npassw0rd\nqwerty1234' >> vol03/passwd.txt 

exit 0
