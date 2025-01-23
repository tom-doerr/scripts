#!/usr/bin/env python3

import json
import sys
import os
from task_id_mapper import number_to_char_id, get_start_num


if len(sys.argv) > 2 and sys.argv[2] == 'add':
    # Read the task JSON from stdin
    task = json.load(sys.stdin)
    
    if 'id' in task:
        task_id = task['id']
        char_id = number_to_char_id(task_id)
        print(f"Created task with char ID: {char_id}", file=sys.stderr)
