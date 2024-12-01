#!/usr/bin/env python3
import json
import subprocess
import random
import os
import time
import argparse
import logging
from typing import List, Dict
from rich.console import Console
from rich.table import Table
from rich import box
import os.path
from datetime import datetime


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
    table.add_column("Est", justify="right", style="green")
    table.add_column("NPri", justify="right", style="yellow")
    table.add_column("Urg", justify="right", style="red")

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

        # Determine row style based on tags and urgency
        row_style = None
        if 'next' in task.get('tags', []):
            description = f"[yellow]{description}[/]"
        elif float(task.get('urgency', 0)) > 10:
            description = f"[bright_white]{description}[/]"
        else:
            description = f"[white]{description}[/]"

        # Add row with styled elements
        table.add_row(
            id,
            description,
            f"[blue]{project}[/]" if project else "",
            f"[magenta]{until}[/]" if until else "",
            f"[green]{estimate}[/]" if estimate else "",
            f"[yellow]{npriority}[/]" if npriority else "",
            f"[red]{urgency}[/]",
            style=row_style
        )

    return table

def display_tasks(filter_cmd):
    """Display tasks table"""
    # Get terminal size
    import shutil
    terminal_height = shutil.get_terminal_size().lines
    
    # Prepare the new output first
    tasks = get_tasks(filter_cmd)
    sorted_tasks = sort_tasks_with_random(tasks)
    table = create_task_table(sorted_tasks)
    
    # Create a string buffer to capture the output
    from io import StringIO
    from rich.console import Console
    
    # Create console with string buffer and force color
    string_io = StringIO()
    console = Console(file=string_io, force_terminal=True)
    
    # Render table to the string buffer
    console.print(table)
    output = string_io.getvalue()
    
    # Split output into lines and take only what fits in terminal
    lines = output.splitlines()
    truncated_output = '\n'.join(lines[:terminal_height-1])
    
    # Only clear screen and print when everything is ready
    os.system('clear')
    print(truncated_output)

def get_data_files_mtime():
    """Get the latest modification time of TaskWarrior data files"""
    data_dir = os.path.expanduser('~/.task')
    data_files = ['pending.data', 'completed.data', 'undo.data']
    mtimes = []
    
    for file in data_files:
        file_path = os.path.join(data_dir, file)
        if os.path.exists(file_path):
            mtimes.append(os.path.getmtime(file_path))
    
    return max(mtimes) if mtimes else 0

def main():
    # Parse arguments
    parser = argparse.ArgumentParser(description='Display TaskWarrior tasks with randomization')
    parser.add_argument('--once', action='store_true', help='Show report once and exit')
    parser.add_argument('--interval', type=float, default=0.1, 
                       help='Scan interval in seconds (default: 0.1)')
    args = parser.parse_args()

    # Default filter command - can be customized
    filter_cmd = [
        'task', 'status:Pending', '-BLOCKED',
        'and', '(-ing', 'or', '+self)',
        'and', '-bu', '-sm', '-scheduled_today_custom',
        'export'
    ]

    if args.once:
        display_tasks(filter_cmd)
    else:
        last_mtime = 0
        
        while True:
            try:
                current_mtime = get_data_files_mtime()
                if current_mtime > last_mtime:
                    display_tasks(filter_cmd)
                    last_mtime = current_mtime
                time.sleep(args.interval)
            except KeyboardInterrupt:
                break

if __name__ == "__main__":
    main()
