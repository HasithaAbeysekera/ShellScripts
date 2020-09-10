#!/bin/bash

log() {
	# This functions sends a message to syslog and to std output is VERBOSE if true
	local MESSAGE="${@}"
	if [[ "${VERBOSE}" = 'true' ]]
	then
		echo "${MESSAGE}"
	fi
	logger -t demo10.sh "${MESSAGE}"
}

backup_file(){
	# This function creates a backup for a file. Return non-zero status on error
	local FILE="${1}"

	# Make sure file exists
	if [[ -f "${FILE}" ]]
	then
		local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
		log "Backing up ${FILE} to ${BACKUP_FILE}."
	
		# Exit status of the function will be exit status of the cp command	
		cp -p ${FILE} ${BACKUP_FILE}
	else
		# File doesn't exist, so return non-zero
		return 1
	fi
}


readonly VERBOSE='true'
log 'Hello!'
log 'This is fun!'

backup_file demo5.sh

# Made a decision based on the exit status of the function
if [[ "${?}" -eq '0' ]]
then 
	log 'File backup succeeded!'
else
	log 'File backup failed'
	exit 1
fi

