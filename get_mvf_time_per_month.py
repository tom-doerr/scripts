#!/usr/bin/env python3

import json
import subprocess
from collections import defaultdict
from datetime import datetime, timedelta

def get_timew_data():
    """Get all MVF time entries from timewarrior"""
    cmd = ['timew', 'export']
    result = subprocess.run(cmd, capture_output=True, text=True)
    return json.loads(result.stdout)

def is_break(tags):
    """Check if entry is a break"""
    return any('break' in tag.lower() for tag in tags)

def calculate_monthly_totals(entries):
    """Calculate total MVF time per month excluding breaks"""
    monthly_totals = defaultdict(timedelta)
    
    for entry in entries:
        if 'mvf' not in [tag.lower() for tag in entry.get('tags', [])]:
            continue
            
        if is_break(entry.get('tags', [])):
            continue
            
        start = datetime.fromisoformat(entry['start'].replace('Z', '+00:00'))
        end = datetime.fromisoformat(entry['end'].replace('Z', '+00:00')) if 'end' in entry else datetime.now(start.tzinfo)
        
        month_key = f"{start.year}-{start.month:02d}"
        duration = end - start
        monthly_totals[month_key] += duration

    return monthly_totals

def format_timedelta(td):
    """Format timedelta as HH:MM"""
    total_minutes = int(td.total_seconds() / 60)
    hours = total_minutes // 60
    minutes = total_minutes % 60
    return f"{hours:02d}:{minutes:02d}"

def main():
    entries = get_timew_data()
    monthly_totals = calculate_monthly_totals(entries)
    
    # Print results sorted by month
    for month in sorted(monthly_totals.keys()):
        duration = monthly_totals[month]
        print(f"{month}: {format_timedelta(duration)}")

if __name__ == '__main__':
    main()
