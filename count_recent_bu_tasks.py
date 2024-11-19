#!/usr/bin/env python3
import json
import subprocess
from datetime import datetime, timedelta

def get_recent_bu_edits():
    # Get all pending bu tasks in JSON format
    cmd = ['task', 'all', '+bu', 'export']
    result = subprocess.run(cmd, capture_output=True, text=True)
    
    if not result.stdout.strip():
        return []
        
    try:
        tasks = json.loads(result.stdout)
    except json.JSONDecodeError:
        print("Error: Could not parse taskwarrior output")
        return []
    
    # Get current time and 3 hours ago
    now = datetime.now()
    three_hours_ago = now - timedelta(hours=3)
    
    # Filter tasks modified in last 3 hours
    recent_tasks = []
    for task in tasks:
        if 'modified' in task:
            mod_time = datetime.fromtimestamp(task['modified'])
            if mod_time > three_hours_ago:
                recent_tasks.append(task)
    
    return recent_tasks

if __name__ == '__main__':
    recent = get_recent_bu_edits()
    print(f"Number of bu tasks edited in last 3 hours: {len(recent)}")
    if recent:
        print("\nRecently edited tasks:")
        for task in recent:
            mod_time = datetime.fromtimestamp(task['modified'])
            print(f"- {task['description']} (modified: {mod_time.strftime('%H:%M')})")
