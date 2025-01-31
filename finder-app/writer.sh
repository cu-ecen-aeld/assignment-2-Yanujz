#!/bin/bash

# Check if the correct number of arguments is provided
if [ $# -ne 2 ]; then
    echo "Error: Invalid number of arguments"
    echo "Usage: $0 <file_path> <write_string>"
    exit 1
fi

writefile=$1
writestr=$2

directory=$(dirname "$writefile")

# Create directory if it does not exist
if [ ! -d "$directory" ]; then
    mkdir -p "$directory" || { echo "Error: Failed to create directory '$directory'"; exit 1; }
fi

# Write string to file
echo "$writestr" > "$writefile" || { echo "Error: Failed to write to file '$writefile'"; exit 1; }

echo "Successfully wrote to '$writefile'"
