#!/usr/bin/env python3

import json
import sys

import os

# Read the input task from stdin
input_task = json.loads(sys.stdin.readline())

# Load project-to-tags mapping from config
config_path = '/home/tom/git/private/taskwarrior_project_tags.json'
try:
    with open(config_path, 'r') as f:
        config_content = f.read()
        PROJECT_TAGS = json.loads(config_content)
except FileNotFoundError:
    print(f"Warning: Config file not found at {config_path}", file=sys.stderr)
    PROJECT_TAGS = {}
except json.JSONDecodeError as e:
    print(f"Warning: Invalid JSON in config file {config_path}: {str(e)}", file=sys.stderr)
    PROJECT_TAGS = {}

# If the task has a project and it's in our mapping
if "project" in input_task:
    projects = input_task["project"].split('.')
    for project in projects:
        if project in PROJECT_TAGS:
            # Initialize tags if not present
            if "tags" not in input_task:
                input_task["tags"] = []
            
            # Add the mapped tags if they're not already present
            for tag in PROJECT_TAGS[project]:
                if tag not in input_task["tags"]:
                    input_task["tags"].append(tag)

# Output the modified task
print(json.dumps(input_task))
