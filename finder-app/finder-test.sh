#!/bin/sh
# Tester script for assignment 1 and assignment 2
# Author: Siddhant Jajoo

set -e
set -u

NUMFILES=10
WRITESTR=AELD_IS_FUN
WRITEDIR=/tmp/aeld-data
username=$(cat conf/username.txt)

if [ $# -lt 3 ]
then
    echo "Using default value ${WRITESTR} for string to write"
    if [ $# -lt 1 ]
    then
        echo "Using default value ${NUMFILES} for number of files to write"
    else
        NUMFILES=$1
    fi  
else
    NUMFILES=$1
    WRITESTR=$2
    WRITEDIR=/tmp/aeld-data/$3
fi

MATCHSTR="The number of files are ${NUMFILES} and the number of matching lines are ${NUMFILES}"

echo "Writing ${NUMFILES} files containing string ${WRITESTR} to ${WRITEDIR}"

# Check if WRITEDIR exists, remove it before creating it again
if [ -d "$WRITEDIR" ]; then
    rm -rf "$WRITEDIR"
fi

# create WRITEDIR if not exists (only if not assignment1)
assignment=`cat ../conf/assignment.txt`

if [ $assignment != 'assignment1' ]
then
    mkdir -p "$WRITEDIR"

    if [ -d "$WRITEDIR" ]
    then
        echo "$WRITEDIR created"
    else
        echo "Failed to create $WRITEDIR"
        exit 1
    fi
fi

# Clean and compile the writer application
echo "Removing the old writer utility and compiling as a native application"
make clean

# Compile with or without cross-compilation
if [ -z ${CROSS_COMPILE+x} ]; then
    make
else
    make CROSS_COMPILE=aarch64-none-linux-gnu-
fi

if [ $? -eq 0 ]; then
    # Save the result of the 'file' command to fileresult.txt
    mkdir -p assignments/assignment2
    file ./writer > assignments/assignment2/fileresult.txt
else
    echo "Make failed. Exiting."
    exit 1
fi

# Write the files
for i in $( seq 1 $NUMFILES)
do
    ./writer "$WRITEDIR/${username}$i.txt" "$WRITESTR"
done

# Call the finder.sh script and capture the output
OUTPUTSTRING=$(./finder.sh "$WRITEDIR" "$WRITESTR")

# remove temporary directories
rm -rf /tmp/aeld-data

set +e
echo ${OUTPUTSTRING} | grep "${MATCHSTR}"
if [ $? -eq 0 ]; then
    echo "success"
    exit 0
else
    echo "failed: expected ${MATCHSTR} in ${OUTPUTSTRING} but instead found"
    exit 1
fi
