#!/usr/bin/env python3
import json
import subprocess
import random
import os
import time
import argparse
from typing import List, Dict
from rich.console import Console
from rich.table import Table
from rich import box
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

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

def create_task_table(tasks: List[Dict]) -> Table:
    """Create a rich table for tasks"""
    table = Table(box=box.SIMPLE)
    
    # Add columns
    table.add_column("ID", justify="right", style="cyan", no_wrap=True)
    table.add_column("Description", style="white")
    table.add_column("Project", style="blue")
    table.add_column("Until", style="magenta")
    table.add_column("Est", justify="right")
    table.add_column("NPri", justify="right")
    table.add_column("Urg", justify="right")

    # Add rows
    for task in tasks:
        # Prepare values
        id = str(task.get('id', ''))
        description = task.get('description', '')[:37] + '...' if len(task.get('description', '')) > 37 else task.get('description', '')
        project = task.get('project', '')[:12] + '...' if len(task.get('project', '')) > 12 else task.get('project', '')
        until = task.get('until', '')[:10] if task.get('until') else ''
        estimate = str(task.get('estimate', ''))
        npriority = str(task.get('npriority', ''))
        urgency = f"{task.get('urgency', 0):.1f}"

        # Color only description yellow for 'next' tagged tasks
        description_style = "yellow" if 'next' in task.get('tags', []) else "white"
        
        table.add_row(
            id, 
            f"[{description_style}]{description}[/]", 
            project, 
            until, 
            estimate, 
            npriority, 
            urgency,
            style=None  # No overall row style
        )

    return table

class TaskWarriorHandler(FileSystemEventHandler):
    def __init__(self, filter_cmd):
        self.filter_cmd = filter_cmd
        self.console = Console()

    def display_tasks(self):
        # Clear screen
        os.system('clear')
        
        tasks = get_tasks(self.filter_cmd)
        sorted_tasks = sort_tasks_with_random(tasks)
        table = create_task_table(sorted_tasks)
        self.console.print(table)

    def on_modified(self, event):
        if event.src_path.endswith('pending.data'):
            self.display_tasks()

def display_once(filter_cmd):
    """Display tasks once without watching for changes"""
    console = Console()
    tasks = get_tasks(filter_cmd)
    sorted_tasks = sort_tasks_with_random(tasks)
    table = create_task_table(sorted_tasks)
    console.print(table)

def main():
    # Parse arguments
    parser = argparse.ArgumentParser(description='Display TaskWarrior tasks with randomization')
    parser.add_argument('--once', action='store_true', help='Show report once and exit')
    args = parser.parse_args()

    # Default filter command - can be customized
    filter_cmd = [
        'task', 'status:Pending', '-BLOCKED',
        'and', '(-ing', 'or', '+self)',
        'and', '-bu', '-sm', '-scheduled_today_custom',
        'export'
    ]

    if args.once:
        display_once(filter_cmd)
    else:
        # Get TaskWarrior data directory
        data_dir = os.path.expanduser('~/.task')
        
        # Set up watchdog
        event_handler = TaskWarriorHandler(filter_cmd)
        observer = Observer()
        observer.schedule(event_handler, data_dir, recursive=False)
        observer.start()

        # Display initial tasks
        event_handler.display_tasks()

        try:
            while True:
                time.sleep(1)
        except KeyboardInterrupt:
            observer.stop()
        observer.join()

if __name__ == "__main__":
    main()
