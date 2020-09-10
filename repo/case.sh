#!/bin/bash

# This script demonstrate the case statement

case "${1}" in
  start)
    echo 'Starting'
    ;;
  stop)
    ;;
  status | state | --state | --status)
    echo 'Status:'
    ;;
  *)
    echo 'Supply a valid option.' >&2
    exit 1
    ;;
esac



