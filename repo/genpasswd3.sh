#!/bin/bash

# This script generates a random password.

# User can set the password length with -l add a special character with -s.
# Verbose mode can be enabled with -v

# Set default password length
LENGTH=48

usage(){
	echo "Usage: ${0} [-vs] [-l LENGTH]" >&2
	echo 'Generate a random password'
	echo ' -l LENGTH Specify a password length'
	echo ' -s Append a special character'
	echo ' -v Use Verbose mode'
	exit 1
}

log() {
	local MESSAGE="${@}"
	if [[ "${VERBOSE}" = true ]]
	then
		echo "${MESSAGE}"
	fi
}

while getopts vl:s OPTION
do
	case ${OPTION} in 
		v)
			VERBOSE='true'
			log 'Verbose mode on'
			;;
		l)
			LENGTH="${OPTARG}"
			;;
		s)
			USE_SPECIAL_CHARACTER='true'
			;;
		?)
			usage
			;;
	esac
done

echo "Number of args: ${#}"
echo "All args: ${@}"
echo "First arg: ${1}"
echo "Second arg: ${2}"
echo "Third args: ${3}" 

# Inspect OPTIND
#echo "OPTIND: ${OPTIND}"
# Remove the options while leaving the remaining arguemtsn
shift "$(( OPTIND - 1 ))"

echo "After the shift"
echo "All args: ${@}"
echo "First arg: ${1}"
echo "Second arg: ${2}"
echo "Third args: ${3}"


log 'Generating a password.'

PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c${LENGTH})

# Append special character if needed

if [[ "${USE_SPECIAL_CHARACTER}" = 'true' ]]
then
	log 'Selecting a random special character.'
	SPECIAL_CHARACTER=$(echo '!@#$%^&*()-=+' | fold -w1 | shuf | head -c1)
	PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
fi

log 'Done.'
log 'Here is the password:'

# Display the password
echo "${PASSWORD}"
exit 0
