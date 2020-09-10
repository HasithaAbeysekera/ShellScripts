#!/bin/bash

# Demonstrate use of shift and while loops

# Display first 3 paramters.
echo "Param 1: ${1}"
echo "Param 2: ${2}"
echo "Param 3: ${3}"
echo

# Use while loop through all parameters
while [[ "${#}" -gt 0 ]]
do
  echo "Number of params: "${#}""
  echo "Param 1: "${1}""
  echo "Param 2: "${2}""
  echo "Param 3: "${3}""
echo
shift
done
