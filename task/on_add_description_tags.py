#!/usr/bin/env python3

import json
import sys
import os

# Read the input task from stdin
input_task = json.loads(sys.stdin.readline())

# Load description-to-tags mapping from multiple config files
config_paths = [
    '/home/tom/git/private/taskwarrior_project_tags.json',
    '/home/tom/git/private/tags.config.json'
]

TAG_CONFIGS = {}
for config_path in config_paths:
    try:
        with open(config_path, 'r') as f:
            TAG_CONFIGS.update(json.loads(f.read()))
    except FileNotFoundError:
        print(f"Warning: Config file not found at {config_path}", file=sys.stderr)
    except json.JSONDecodeError as e:
        print(f"Warning: Invalid JSON in {config_path}: {str(e)}", file=sys.stderr)

# Add tags based on exact description match
print('inside on_add_description_tags.py')
if "description" in input_task:
    print('description found')
    if "tags" not in input_task:
        input_task["tags"] = []
        
    description = input_task["description"]
    if description in TAG_CONFIGS:
        for tag in TAG_CONFIGS[description]:
            if tag not in input_task["tags"]:
                input_task["tags"].append(tag)

# Output the modified task
print(json.dumps(input_task))
