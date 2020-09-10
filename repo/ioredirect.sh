#!/bin/bash

# This script demonstrates I/O redirection.

# Redirect std out to a file
FILE="/tmp/data"
head -n1 /etc/passwd > ${FILE}

# Redirect stdin to a program
read LINE < ${FILE}
echo "Line contains: "${LINE}""

# Redirect std out to a file, appending to the file
echo "${RANDOM} ${RANDOM}" >> ${FILE}
echo "${RANDOM} ${RANDOM}" >> ${FILE}
echo
echo "Contents of ${FILE}:"
cat ${FILE}

# Redirect std in to a program, using FD 0
read LINE 0< ${FILE}
echo
echo "LINE contains: ${LINE}"

# Redirect std out to a file using FD 1, overwriting file
head -n3 /etc/passwd 1> ${FILE}
echo
echo "COntents of ${FILE}:"
cat ${FILE}

# Redirect std err to a file using FD 2.
ERRFILE="/tmp/data.err"
head -n3 /etc/passwd /fakefile 2> ${ERRFILE}

# Redirect std out and st err to a file.
head -n3 /etc/passwd /fakefile &> ${FILE}
echo
echo "Contents of ${FILE}:"
cat ${FILE}

# Redirect std out and std err thourgh a pipe
echo 
head -n3 /etc/passwd /fakefile |& cat -n

# Send output to STDERR
echo "This is stderr!" >&2

# Discard stdout
echo
echo "Discarding stdout:"
head -n3 /etc/passwd /fakefile > /dev/null

# Discard stderr
echo
echo "Discarding stderr:"
head -n3 /etc/passwd /fakefile 2> /dev/null

# discard both
echo
echo "Discarding both:"
head -n3 /etc/passwd /fakefile &> /dev/null

# Clean
rm ${FILE} ${ERRFILE} &> /dev/null

