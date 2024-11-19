#!/usr/bin/env python3

import json
import sys

# Read the input task from stdin
input_task = json.loads(sys.stdin.readline())

import os

# Load project-to-tags mapping from config
config_path = '/home/tom/git/private/taskwarrior_project_tags.json'
try:
    with open(config_path, 'r') as f:
        PROJECT_TAGS = json.load(f)
except FileNotFoundError:
    print(f"Warning: Config file not found at {config_path}", file=sys.stderr)
    PROJECT_TAGS = {}
except json.JSONDecodeError:
    print(f"Warning: Invalid JSON in config file {config_path}", file=sys.stderr)
    PROJECT_TAGS = {}

# If the task has a project and it's in our mapping
if "project" in input_task and input_task["project"] in PROJECT_TAGS:
    project = input_task["project"]
    
    # Initialize tags if not present
    if "tags" not in input_task:
        input_task["tags"] = []
    
    # Add the mapped tags if they're not already present
    for tag in PROJECT_TAGS[project]:
        if tag not in input_task["tags"]:
            input_task["tags"].append(tag)

# Output the modified task
print(json.dumps(input_task))
