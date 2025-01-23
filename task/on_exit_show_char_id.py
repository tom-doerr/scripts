#!/usr/bin/env python3

import json
import sys
import os
from task_id_mapper import number_to_char_id, get_start_num


# Check if any arg contains the add command
if any(arg.startswith('command:add') for arg in sys.argv):
    print('inside if in hook')
    # Read all task JSON lines from stdin
    for line in sys.stdin:
        task = json.loads(line)
        print('parsed line')
        if 'id' in task:
            print('task has id')
            task_id = task['id']
            char_id = number_to_char_id(task_id)
            print(f"Created task with char ID: {char_id}", file=sys.stderr)
