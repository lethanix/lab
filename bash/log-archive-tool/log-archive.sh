#!/bin/sh
#
# Script to compress and store logs in a new directory

# Name of the output folder 
OUTPUT="archout"

# ****************************
# Verify input of the script
# ****************************
## Verify the number of arguments 
if [ $# -eq 0 ] && [ $# -lt 2 ]; then
    echo Missing argument: Directory is not provided $1 1>&2
    exit 1
elif [ $# -gt 1 ]; then
    echo 'Too many arguments (+1): ' "('$#') => '$@'" 1>&2
    exit 2
fi


## Verify if $1 argument is a directory
if [ ! -d $1 ]; then
    echo Argument is not a directory: $1 1>&2
    exit 3
else 
    echo Archiving directory $1
fi


# ****************************
# Verify output of the script
# ****************************
## Find the output folder in the current directory
## If not found, create it
OUTPUT_FOUND=$(find . -maxdepth 1 -type d -name $OUTPUT) 
if [ -n "$OUTPUT_FOUND" ]; then
    echo Output folder located $OUTPUT_FOUND
else 
    echo "Creating output folder '$OUTPUT'"
    mkdir $OUTPUT
fi

# ******************************
# Compress & save the directory
# ******************************
## Get the date and time 
DATE=$(date -u +%Y%m%d_%H%M%S%Z)
LOCATION="$OUTPUT/logs_archive_$DATE"
tar czf "$LOCATION.tar.gz" $1

## Display location of archive
echo Directory archived at: $LOCATION
