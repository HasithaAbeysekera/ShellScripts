#!/bin/bash

# This script allows for local Linux accounts to be disabled, deleted and optionally archived.

ARCHIVE_DIR='/archive'

# Usage and exit
usage(){
	echo "Usage "${0}" [-dra] USER [USERN] " >&2
	echo "Delete, disable and optionally archive account"
	echo "	-d Delete account instead of disable"
	echo "	-r Remove home directory"
	echo "	-a ARCHIVE_DIR Create archive in ARCHIVE_DIR"
	exit 1
}

# Make sure the script is being executed with superuser privelages
if [[ "${UID}" -ne 0 ]]
then
	echo "You require root privileges"
	exit 1
fi

# Parse the options
while getopts dar OPTION
do
	case ${OPTION} in
		d)
			echo "Deleting account"
			DELETE_USER='true';;
		r)
			echo "Removing home directory"
			REMOVE_OPTION='-r'
			;;
		a)
			echo "Creating archive"
			ARCHIVE_DIR="true"
			;;
		?)
			usage
			;;
	esac
done

# remove the options while leaving the remaining arguments
shift "$(( OPTIND - 1 ))"

# If user doesn't supple at least one argument, display usage
if [[ "${#}" -lt 1 ]]
then
	usage
fi

# Loop through all the usernames supplied as arguments
for USERNAME in "${@}"
do
	echo "Processing user: ${USERNAME}"

	# check UID is at least 1000
	USERID=$(id -u {$USERNAME})
	if [[ "${USERID}" -lt 1000 ]]
	then
		echo "Cannot remove account ${USERNAME} as it is <1000." >&2
		exit 1
	fi

	# Create archive is requested
	if [[ ${ARCHIVE} = 'true' ]]
	then
		# check ARCHIVE_DIR exists
		if [[ ! -d "${ARCHIVE_DIR}" ]]
		then
			echo "creating archive dir"
			mkdir -p ${ARCHIVE_DIR}
			if [[ "${?}" -ne 0 ]]
			then
				echo "Error creating directory" >&2
				exit 1
			fi
		fi
		
		# Archive home directory and move it into ARCHIVE_DIR
		HOME_DIR="/home/${USERNAME}"
		ARCHIVE_FILE="${ARCHIVE_DIR}/${USERNAME}.tgz"
		if [[ -d "${HOME_DIR}" ]]
		then
			echo "archiving ${HOME_DIR} to ${ARCHIVE_FILE}"
			tar -zcf ${ARCHIVE_FILE} ${HOME_DIR} &> /dev/null
			if [[ "${?}" -ne 0 ]]
			then 
				echo "Could not create archive file} "
				exit 1
			fi
		else
			echo "${HOME_DIR} does not exist or is not a idrectory." >&2
			exit 1
		fi
	fi
	
	if [[ "${DELETE_USER}" = 'true' ]]
	then
		#delete user
		userdel ${REMOVE_OPTION} ${USERNAM}

		#check userdel succeeded
		if [[ "${?}" -ne 0 ]]
		then 
			echo "The Account ${USERNAME} was NOT deleted." >&2
			exit 1
		fi
		echo "The account {$USERNAME} was deleted."
	else
		chage -E 0 ${USERNAME}
		if [[ "${?}" -ne 0 ]]
		then 
			echo "The Account ${USERNAME} was NOT disabled." >&2
			exit 1
		fi
		echo "The account {$USERNAME} was disabled."
	fi
done

exit 0
