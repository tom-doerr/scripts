#!/usr/bin/env python3
import json
import subprocess
import random

# Constant for Pareto distribution
PARETO_CONSTANT = 4
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
from task_id_mapper import number_to_char_id


def get_context_filter() -> str:
    """Get the filter for the current context from .taskrc"""
    try:
        # Get current context
        context = subprocess.check_output(['task', '_get', 'rc.context']).decode('utf-8').strip()
        if not context:
            return ''
            
        # Read .taskrc file
        with open(os.path.expanduser('~/.taskrc'), 'r') as f:
            for line in f:
                if line.startswith(f'context.{context}='):
                    return line.split('=', 1)[1].strip()
        return ''
    except Exception:
        return ''

def get_tasks(filter_cmd: List[str]) -> List[Dict]:
    """Get tasks from TaskWarrior using specified filter command"""
    # Get context filter
    context_filter = get_context_filter()
    
    # Build the base command
    base_cmd = ['task']
    
    # Add context filter if exists
    if context_filter:
        base_cmd.extend(context_filter.split())
    
    # Add the rest of the filters, skipping the initial 'task'
    base_cmd.extend(filter_cmd[1:])
    
    task_export = subprocess.check_output(base_cmd).decode('utf-8')
    return json.loads(task_export)

def sort_tasks_with_random(tasks: List[Dict], 
                         boost_chance: float = 0.20,
                         max_boost: float = 20.0,
                         preserve_tags: List[str] = ['next']) -> List[Dict]:
    """Sort tasks with random boosting, preserving certain tags at top"""
    # Separate active and preserved tag tasks
    active_tasks = [t for t in tasks if t.get('start')]
    preserved_tasks = [t for t in tasks if not t.get('start') and any(tag in t.get('tags', []) for tag in preserve_tags)]
    other_tasks = [t for t in tasks if not t.get('start') and not any(tag in t.get('tags', []) for tag in preserve_tags)]

    # Sort preserved tasks by urgency
    preserved_tasks.sort(key=lambda x: x.get('urgency', 0), reverse=True)

    # Add random boost to other tasks using a power law distribution (Pareto)
    other_tasks = [{**task, '_random_boost': random.paretovariate(PARETO_CONSTANT) * max_boost / PARETO_CONSTANT} for task in other_tasks]

    # Sort other tasks by urgency + random boost
    other_tasks.sort(key=lambda x: x.get('urgency', 0) + x['_random_boost'], reverse=True)
    
    return active_tasks + preserved_tasks + other_tasks

def create_task_table(tasks: List[Dict]) -> Table:
    """Create a rich table for tasks"""
    table = Table(box=box.SIMPLE)
    
    # Add columns
    table.add_column("ID", justify="right", style="cyan", no_wrap=True)
    table.add_column("Key", justify="center", style="yellow", no_wrap=True)
    table.add_column("Description", style="white")
    table.add_column("Project", style="blue")
    table.add_column("NPri", justify="right", style="white")
    table.add_column("Urg", justify="right", style="red")

    # Add rows
    for task in tasks:
        # Prepare values
        num_id = task.get('id', 0)
        char_id = number_to_char_id(num_id) if num_id else ''
        description = task.get('description', '')[:37] + '...' if len(task.get('description', '')) > 37 else task.get('description', '')
        project = task.get('project', '')[:12] + '...' if len(task.get('project', '')) > 12 else task.get('project', '')
        npriority = str(task.get('npriority', ''))
        urgency = f"{task.get('urgency', 0):.1f}"

        # Determine row style and text colors based on active status
        is_active = task.get('start')
        row_style = "on green" if is_active else None
        
        # For active tasks, everything is black
        if is_active:
            description = f"[black]{description}[/]"
            project_style = "[black]"
            npriority_style = "[black]"
            urgency_style = "[black]"
        # For inactive tasks, use normal colors
        else:
            if 'next' in task.get('tags', []):
                description = f"[yellow]{description}[/]"
            elif float(task.get('urgency', 0)) > 10:
                description = f"[bright_white]{description}[/]"
            else:
                description = f"[white]{description}[/]"
            project_style = "[blue]"
            npriority_style = "[white]"
            urgency_style = "[red]"

        # Add row with styled elements
        table.add_row(
            f"[black]{num_id}[/]" if is_active else str(num_id),
            f"[black]{char_id}[/]" if is_active else char_id,
            description,
            f"{project_style}{project}[/]" if project else "",
            f"{npriority_style}{npriority}[/]" if npriority else "",
            f"{urgency_style}{urgency}[/]",
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
    """Get the latest modification time of TaskWarrior data files and config"""
    data_dir = os.path.expanduser('~/.task')
    data_files = ['pending.data', 'completed.data', 'undo.data']
    config_file = os.path.expanduser('~/.taskrc')
    mtimes = []
    
    # Check data files
    for file in data_files:
        file_path = os.path.join(data_dir, file)
        if os.path.exists(file_path):
            mtimes.append(os.path.getmtime(file_path))
    
    # Check config file
    if os.path.exists(config_file):
        mtimes.append(os.path.getmtime(config_file))
    
    return max(mtimes) if mtimes else 0

def main():
    # Parse arguments
    parser = argparse.ArgumentParser(description='Display TaskWarrior tasks with randomization')
    parser.add_argument('--once', action='store_true', help='Show report once and exit')
    parser.add_argument('--interval', type=float, default=0.1,
                       help='Scan interval in seconds (default: 0.1)')
    parser.add_argument('filter_args', nargs='*', help='TaskWarrior filter arguments')
    args = parser.parse_args()

    # Use command line filters if provided, else use default context filter
    filter_cmd = args.filter_args if args.filter_args else [
        'status:Pending', '-BLOCKED',
        'and', '(-ing', 'or', '+self)',
        'and', '-bu', '-sm'
    ]

    if args.once:
        display_tasks(['task'] + filter_cmd + ['export'])
    else:
        last_mtime = 0
        
        while True:
            try:
                current_mtime = get_data_files_mtime()
                if current_mtime > last_mtime:
                    display_tasks(['task'] + filter_cmd + ['export'])
                    last_mtime = current_mtime
                time.sleep(args.interval)
            except KeyboardInterrupt:
                break

if __name__ == "__main__":
    main()
