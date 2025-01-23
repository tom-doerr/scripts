#!/usr/bin/env python3

import json
import sys
import os
from task_id_mapper import number_to_char_id, get_start_num

# Only show char ID for add commands 
if len(sys.argv) > 1 and sys.argv[1] == 'add':
    # Read the task JSON from stdin
    tasks = [json.loads(line) for line in sys.stdin]
    
    # Check if we have any added tasks
    for task in tasks:
        if 'id' in task:
            task_id = task['id']
            char_id = number_to_char_id(task_id)
            print(f"Created task with char ID: {char_id} (from numeric ID: {task_id})", file=sys.stderr)
            print(f"Current start number: {get_start_num()}", file=sys.stderr)
