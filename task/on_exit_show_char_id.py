#!/usr/bin/env python3

import json
import sys
from task_id_mapper import number_to_char_id

# Read the task from stdin
input_task = json.loads(sys.stdin.readline())

# Only show char ID for new tasks (add command) 
if "id" in input_task and any(arg.endswith('add') for arg in sys.argv):
    char_id = number_to_char_id(input_task["id"])
    print(f"Created task with char ID: {char_id}", file=sys.stderr)

# Pass through the original task data unmodified
print(json.dumps(input_task))
