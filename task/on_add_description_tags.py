#!/usr/bin/env python3

import json
import sys
import os

# Read the input task from stdin
input_task = json.loads(sys.stdin.readline())

# Load description-to-tags mapping from config
config_path = '/home/tom/git/private/taskwarrior_project_tags.json'
try:
    with open(config_path, 'r') as f:
        PROJECT_TAGS = json.loads(f.read())
except FileNotFoundError:
    print(f"Warning: Config file not found at {config_path}", file=sys.stderr)
    PROJECT_TAGS = {}
except json.JSONDecodeError as e:
    print(f"Warning: Invalid JSON in config file {config_path}: {str(e)}", file=sys.stderr)
    PROJECT_TAGS = {}

# Add tags based on exact description match
if "description" in input_task:
    if "tags" not in input_task:
        input_task["tags"] = []
        
    description = input_task["description"]
    if description in PROJECT_TAGS:
        for tag in PROJECT_TAGS[description]:
            if tag not in input_task["tags"]:
                input_task["tags"].append(tag)

# Output the modified task
print(json.dumps(input_task))
