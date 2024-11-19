#!/usr/bin/env python3

import json
import sys

import os

# Set up debug logging
def debug_log(msg):
    print(f"DEBUG: {msg}", file=sys.stderr)

# Read the input task from stdin
debug_log("Reading input task...")
input_task = json.loads(sys.stdin.readline())
debug_log(f"Input task: {input_task}")

# Load project-to-tags mapping from config
config_path = '/home/tom/git/private/taskwarrior_project_tags.json'
debug_log(f"Looking for config file at: {config_path}")
try:
    with open(config_path, 'r') as f:
        config_content = f.read()
        debug_log(f"Raw config content: {config_content}")
        PROJECT_TAGS = json.load(f)
        debug_log(f"Parsed config: {PROJECT_TAGS}")
except FileNotFoundError:
    print(f"Warning: Config file not found at {config_path}", file=sys.stderr)
    PROJECT_TAGS = {}
except json.JSONDecodeError as e:
    print(f"Warning: Invalid JSON in config file {config_path}: {str(e)}", file=sys.stderr)
    PROJECT_TAGS = {}

# If the task has a project and it's in our mapping
if "project" in input_task:
    project = input_task["project"]
    debug_log(f"Task has project: {project}")
    
    if project in PROJECT_TAGS:
        debug_log(f"Found project in config, tags: {PROJECT_TAGS[project]}")
        
        # Initialize tags if not present
        if "tags" not in input_task:
            input_task["tags"] = []
            debug_log("Initialized empty tags list")
        
        # Add the mapped tags if they're not already present
        for tag in PROJECT_TAGS[project]:
            if tag not in input_task["tags"]:
                input_task["tags"].append(tag)
                debug_log(f"Added tag: {tag}")
    else:
        debug_log(f"Project {project} not found in config")
else:
    debug_log("Task has no project")

# Output the modified task
print(json.dumps(input_task))
