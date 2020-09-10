#!/bin/bash

# Generates a list of passwords

# A random number as a password.
PASSWORD="${RANDOM}"
echo "${PASSWORD}"

# 3 numbers together
PASSWORD="${RANDOM}${RANDOM}${RANDOM}"
echo "${PASSWORD}"

# Use current date/time as basis
PASSWORD=$(date +%s)
echo "${PASSWORD}"

# Use nanoseconds for extra randomisation
PASSWORD=$(date +%s%N)
echo "${PASSWORD}"

# Using checksums
PASSWORD=$(date +%s%N | sha256sum | head -c32)
echo "${PASSWORD}"

# Improving it
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c48)
echo "${PASSWORD}"

# Append a special character to the password.
SPECIAL=$(echo '!@#$%^&*()_+' | fold -w1 | shuf | head -c1)
echo "${PASSWORD}${SPECIAL}"

