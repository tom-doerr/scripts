#!/bin/bash

# Check if the first argument is a valid directory
if [ ! -d $1 ]; then
    echo "Not a valid directory"
    exit 1
fi

# Initialize the queue
queue=($1)

# Loop until all elements are deleted from the queue
while [ ${#queue[@]} -gt 0 ]; do

    # Pop the first element from the queue
    dir=${queue[0]}
    queue=("${queue[@]:1}")

    # List all files and directories in the popped directory
    for f in "$dir"/*; do
        if [ -d "$f" ]; then
            queue+=("$f")
        else
            echo "$f"
        fi
    done
done
