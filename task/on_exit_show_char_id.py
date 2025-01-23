#!/usr/bin/env python3

import json
import sys
import os
from task_id_mapper import number_to_char_id, get_start_num

# Only show char ID for add commands 
if len(sys.argv) > 1 and sys.argv[1] == 'add':
    # Get task ID from stdout output
    stdout_file = os.environ.get('TASK_STDOUT')
    if stdout_file and os.path.exists(stdout_file):
        with open(stdout_file, 'r') as f:
            for line in f:
                if 'Created task' in line:
                    task_id = int(line.split()[-1].strip('.'))
                    break
            else:  # No matching line found
                sys.exit(0)
        char_id = number_to_char_id(task_id)
        print(f"Created task with char ID: {char_id} (from numeric ID: {task_id})", file=sys.stderr)
        print(f"Current start number: {get_start_num()}", file=sys.stderr)
