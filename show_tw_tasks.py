#!/usr/bin/env python3
import json
import subprocess
import random
from typing import List, Dict

def get_tasks(filter_cmd: List[str]) -> List[Dict]:
    """Get tasks from TaskWarrior using specified filter command"""
    task_export = subprocess.check_output(filter_cmd).decode('utf-8')
    return json.loads(task_export)

def sort_tasks_with_random(tasks: List[Dict], 
                         boost_chance: float = 0.20,
                         max_boost: float = 20.0,
                         preserve_tags: List[str] = ['next']) -> List[Dict]:
    """Sort tasks with random boosting, preserving certain tags at top"""
    # Separate preserved tag tasks
    preserved_tasks = [t for t in tasks if any(tag in t.get('tags', []) for tag in preserve_tags)]
    other_tasks = [t for t in tasks if not any(tag in t.get('tags', []) for tag in preserve_tags)]

    # Add random boost to other tasks
    for task in other_tasks:
        if random.random() < boost_chance:
            task['_random_boost'] = random.uniform(0, max_boost)
        else:
            task['_random_boost'] = 0

    # Sort other tasks by urgency + random boost
    other_tasks.sort(key=lambda x: x.get('urgency', 0) + x['_random_boost'], reverse=True)
    
    return preserved_tasks + other_tasks

def main():
    # Default filter command - can be customized
    filter_cmd = [
        'task', 'status:Pending', '-BLOCKED',
        'and', '(-ing', 'or', '+self)',
        'and', '-bu', '-sm', '-scheduled_today_custom',
        'export'
    ]
    
    tasks = get_tasks(filter_cmd)
    sorted_tasks = sort_tasks_with_random(tasks)

    # Print header
    print(f"{'ID':<4} {'Description':<40} {'Project':<15} {'Until':<12} {'Est':<6} {'NPri':<4} {'Urg':<5}")
    print("-" * 86)

    # Print tasks
    for task in sorted_tasks:
        id = task.get('id', '')
        description = task.get('description', '')[:37] + '...' if len(task.get('description', '')) > 37 else task.get('description', '')
        project = task.get('project', '')[:12] + '...' if len(task.get('project', '')) > 12 else task.get('project', '')
        until = task.get('until', '')[:10] if task.get('until') else ''
        estimate = task.get('estimate', '')
        npriority = task.get('npriority', '')
        urgency = f"{task.get('urgency', 0):.1f}"
        
        print(f"{id:<4} {description:<40} {project:<15} {until:<12} {estimate:<6} {npriority:<4} {urgency:<5}")

if __name__ == "__main__":
    main()
