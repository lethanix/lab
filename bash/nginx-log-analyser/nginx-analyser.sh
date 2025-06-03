#!/bin/sh
#
# Script that analyse nginx access logs

# ****************************
# Verify input of the script
# ****************************
## Verify the number of arguments 
if [ $# -eq 0 ] && [ $# -lt 2 ]; then
    echo Missing argument: Log file is not provided $1 1>&2
    exit 1
elif [ $# -gt 1 ]; then
    echo 'Too many arguments (+1): ' "('$#') => '$@'" 1>&2
    exit 2
fi

## Verify if $1 argument is a file
if [ ! -f $1 ]; then
    echo Argument is not a file: $1 1>&2
    exit 3
else 
    echo Analysing file $1
fi

LOG=$1

######################################################
echo Top 5 IP addresses with the most requests:
awk '{print $1}' $LOG | sort | uniq -c | sort -nr | head -5 \
	| awk '{printf "%s - %d requests\n", $2, $1}'

######################################################
echo
echo Top 5 most requested paths:
grep -o '\w\s/.*\sHTTP' $LOG | awk '{print $2}' | sort | uniq -c | sort -nr | head -5 \
	| awk '{printf "%s - %d requests\n", $2, $1}'

######################################################
echo
echo Top 5 response status codes:
grep -E -o 'HTTP/1.1"[ ]*([0-9]{3})[ ]*' $LOG | awk '{print $2}' \
	| sort | uniq -c | sort -nr | head -5 \
	| awk '{printf "%d - %d requests\n", $2, $1}'

######################################################
echo
echo Top 5 user agents:
awk -F'"' '{print $6}' $LOG | sort | uniq -c | sort -nr | head -5 \
	| awk '{count=$1; $1=""; printf "%s - %d requests\n", $0, count}'

