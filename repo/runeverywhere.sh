#!/bin/bash

# This script when executed will run a command across all server machines in the local network

SERVER_FILE='/vagrant/servers'
#SUDO=""
SSH_OPTIONS='ssh -o ConnectTimeout=2'


usage(){
	echo "./run-everywhere.sh [-nsv] [-f FILE] COMMAND"
	echo "Executes COMMAND as a single command on every server."
	echo "	-f FILE  Use FILE for the list of servers. Default: '${SERVER_FILE}'  "
	echo "	-n       Dry run mode.  Display the COMMAND that would have beenexecuted and exit."
	echo "	-s       Execute the COMMAND using sudo on the remote server."
	echo "	-v       Verbose mode. Displays the server name before executing COMMAND."
	exit 1
}


# Check script isn't executed with superuser privileges
if [[ "${UID}" -eq 0 ]]
then
	echo "Do not execute this script as root. Please use -s for root privileges instead" >&2
	usage
fi

# For Verbose option
log() {
	local MESSAGE="${@}"
	if [[ "${VERBOSE}" = true ]]
	then
		echo "${MESSAGE}"
	fi
}

# 
#if [[ $(echo ${@} | cut -c -4) -eq 'sudo' ]]
#then
#	echo "Error, sudo privileges can only be used via -s"
#	exit 1
#fi

while getopts nf:sv OPTION
do
	case ${OPTION} in 
		n)
			DRY='true'
			;;
		f)
			SERVER_FILE="${OPTARG}"
			log SERVER_FILE is "${SERVER_FILE}"
			;;
		s)
			SUDO='sudo'
			;;
		v)
			VERBOSE='true'
			log 'Verbose mode on'
			;;	
		?)
			usage
			;;
	esac
done

shift "$(( OPTIND - 1 ))"

COMMAND="${@}"
#echo "After the shift"
#echo "All args: ${@}"
#echo "First arg: ${1}"
#echo "Second arg: ${2}"
#echo "Third args: ${3}"

if [[ "${#}" -lt 1 ]]
then
	echo "Error: Please supply a command"
	exit 1
fi


if [[ ! -e ${SERVER_FILE} ]]
then
	echo "Cannot open ${SERVER_FILE}" >&2
	exit 1
fi


# Create exit status to update if problem occurs
EXIT_STATUS='0'


for SERVER in $(cat ${SERVER_FILE})
do
	if [[ "${DRY}" = 'true' ]]
	then
		#DRY RUN
		echo "DRY RUN: ${SSH_OPTIONS} ${SERVER} ${SUDO} ${COMMAND}"
	else
		log "From ${SERVER}"
		#sping -c 1 ${SERVER}
		${SSH_OPTIONS} ${SERVER} ${SUDO} ${COMMAND}
		SSH_EXIT_STATUS="${?}"

		if [[ "${SSH_EXIT_STATUS}" -ne 0 ]]
		then
			EXIT_STATUS="${SSH_EXIT_STATUS}"
			echo "Execution failed on server '${SERVER}'" >&2
		fi
	fi
done

exit ${EXIT_STATUS}