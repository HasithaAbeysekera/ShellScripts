#!/bin/bash

# This script creates an account on the local system
# You will be prompted for the account name and password


# Ask for the user name
read -p 'Enter the username to create: ' USERNAME

# Ask for the real name
read -p 'Enter the name of the person who owns this account: ' COMMENT

# Ask for the password
read -p 'Enter password to use: ' PASSWORD

# Create user
useradd -c "${COMMENT}" -m ${USERNAME}

# Set password
echo ${PASSWORD} | passwd --stdin ${USERNAME}

# Force password change on first login
passwd -e ${USERNAME}



