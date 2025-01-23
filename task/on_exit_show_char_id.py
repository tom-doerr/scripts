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
    # Read all task JSON lines from stdin
    for line in sys.stdin:
        task = json.loads(line)
        # if 'id' in task:
        if 'uuid' in task:
            # Get stable UUID and convert to task ID
            task_uuid = task['uuid']
            try:
                task_id = int(subprocess.check_output(f"task _get {task_uuid}.id", shell=True).decode().strip())
                char_id = number_to_char_id(task_id)
                print(f"Char ID: {char_id}", file=sys.stderr)
            except (subprocess.CalledProcessError, ValueError) as e:
                print(f"Error getting task ID: {e}", file=sys.stderr)
