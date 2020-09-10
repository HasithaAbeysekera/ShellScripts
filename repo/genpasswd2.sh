#!/bin/bash

# A script to generate a random password for each user specificied on the command line

# Display what the user typed on the command line.
echo "You executed this command: ${0}"

# Make sure at least one arugment is supplied.
NUMBER_OF_PARAMETERS="${#}"

if [[ "${NUMBER_OF_PARAMETERS}" -lt 1 ]]
then
  echo "Correct usage: ..."
  exit 1
fi

# Generate and display a password for each parameter
for USERNAME in "${@}"
do
  PASSWORD=$(date +%s%N | sha256sum | head -c48)
  echo "${USERNAME}: ${PASSWORD}"
done


