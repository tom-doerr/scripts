#!/bin/bash

# Function to process files
process_files() {
  #for filepath in "$1"/*; do
  for filepath in "$1"/* "$1"/.*; do
    [ -e "$filepath" ] || continue

    # check if . or ..
    filename=$(basename "$filepath")
    if [ "$filename" = "." ] || [ "$filename" = ".." ]; then
      continue
    fi

    # Get user and group IDs for the file
    user_id=$(stat -c "%u" "$filepath")
    group_id=$(stat -c "%g" "$filepath")

    # Change owner to tom if owner ID is 100999
    if [ "$user_id" -eq 100999 ]; then
      chown tom "$filepath"
    fi

    # Change group to tom if group ID is 100999
    if [ "$group_id" -eq 100999 ]; then
      chgrp tom "$filepath"
    fi

    # If directory, recurse into it
    if [ -d "$filepath" ]; then
      process_files "$filepath"
    fi
  done
}

# Start the script from the current directory
process_files "."

echo "Ownership and group changes complete."
