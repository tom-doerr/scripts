#!/usr/bin/env python3

import json
import sys
import os
import subprocess

# Add scripts directory to path for module resolution
sys.path.insert(0, os.path.expanduser("~/git/scripts"))
from task_id_mapper import number_to_char_id, get_start_num


# Check if any arg contains the add command
if any(arg.startswith('command:add') for arg in sys.argv):
    # Read and validate input
    input_data = sys.stdin.read()
    if not input_data.strip():
        sys.exit(0)
        
    try:
        task = json.loads(input_data)
        if 'uuid' not in task:
            sys.exit(0)
            
        task_uuid = task['uuid']
        
        # Try to get ID from JSON first
        task_id = task.get('id')
        if not task_id:  # Fallback to UUID lookup
            result = subprocess.check_output(
                f"task _get {task_uuid}.id", 
                shell=True, 
                stderr=subprocess.DEVNULL
            ).decode().strip()
            
            if not result.isdigit():
                raise ValueError("Invalid task ID response")
                
            task_id = int(result)
            
        char_id = number_to_char_id(task_id)
        print(f"Char ID: {char_id}", file=sys.stderr)
        
    except Exception as e:
        print(f"Error processing task: {e}", file=sys.stderr)
        sys.exit(0)
