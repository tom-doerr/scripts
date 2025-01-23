#!/usr/bin/env python3

import json
import sys
from task_id_mapper import number_to_char_id

# Only show char ID for add commands
if any(arg.endswith('add') for arg in sys.argv):
    # Get the last added task ID from log
    result = os.popen('task newest limit:1 id').read()
    if result.strip().isdigit():
        task_id = int(result.strip())
        char_id = number_to_char_id(task_id)
        print(f"Created task with char ID: {char_id}", file=sys.stderr)
