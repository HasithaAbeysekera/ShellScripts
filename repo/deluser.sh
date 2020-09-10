#!/bin/bash

# This script deletes a user.

# run as root.
if [[ "${UID}" -ne 0 ]]
then
	echo "Please run with sudo or as root." >&2
	exit 1
fi

# assume the first arugment is user to delete.
USER="${1}"

# delete user
userdel ${USER}

# make sure user got deleted
if [[ "${?}" -ne 0 ]]
then
	echo "The account ${USER} was not deleted."
	exit 1
fi

# Dleteion successful message
echo "The account ${USER} was successfully deleted."

exit 0
