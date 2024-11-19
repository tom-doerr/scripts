#!/usr/bin/env python3

import json
import sys

# Read the input task from stdin
input_task = json.loads(sys.stdin.readline())

# Define project-to-tags mapping
PROJECT_TAGS = {
    "work": ["office", "professional"],
    "home": ["personal", "house"],
    "study": ["learning", "education"],
    # Add more project-to-tags mappings as needed
}

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
