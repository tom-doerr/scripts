#!/usr/bin/env python3

import os
from functools import wraps
import time

def cache_for_seconds(seconds):
    def decorator(func):
        cache = {}
        
        @wraps(func)
        def wrapper(*args, **kwargs):
            key = str((args, frozenset(kwargs.items())))
            
            # Check if cached and not expired
            if key in cache:
                result, timestamp = cache[key]
                if time.time() - timestamp < seconds:
                    return result
            
            # Calculate new result and cache it
            result = func(*args, **kwargs)
            cache[key] = (result, time.time())
            return result
            
        return wrapper
    return decorator
# Use home row keys for mapping
HOMEROW_CHARS = 'asdfghjk'

# num_start_indexing_file = "~/.task_id_mapper_start_num.txt"
num_start_indexing_file = os.path.expanduser("~/.task_id_mapper_start_num.txt")
if not os.path.exists(num_start_indexing_file):
    with open(num_start_indexing_file, 'w') as f:
        f.write("1000")

@cache_for_seconds(5)
def get_start_num():
    with open(num_start_indexing_file, 'r') as f:
        return int(f.read())

def check_if_start_num_needs_updating(num: int):
    if num + 3 > get_start_num():
        new_start_num = num + 10
        with open(num_start_indexing_file, 'w') as f:
            f.write(str(new_start_num))




def number_to_char_id(num_1: int) -> str:
    """Convert a numeric ID to a character-based ID using home row keys"""
    if num_1 <= 0:
        raise ValueError("ID must be positive")
    
    result = ""
    num = get_start_num() - num_1
    while num > 0:
        num -= 1  # Convert to 0-based for modulo
        result = HOMEROW_CHARS[num % len(HOMEROW_CHARS)] + result
        num //= len(HOMEROW_CHARS)

    check_if_start_num_needs_updating(num_1)
    return result

def char_id_to_number(char_id: str) -> int:
    """Convert a character-based ID back to numeric ID"""
    if not all(c in HOMEROW_CHARS for c in char_id):
        raise ValueError(f"Invalid characters in ID. Must only use: {HOMEROW_CHARS}")
    
    result = 0
    for c in char_id:
        result = result * len(HOMEROW_CHARS) + HOMEROW_CHARS.index(c) + 1

    result = get_start_num() - result
    return result

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2:
        print("Usage: task_id_mapper.py <char_id> or task_id_mapper.py <num_id>")
        sys.exit(1)

    # print("sys.argv[1].isdigit():", sys.argv[1].isdigit())
    if not sys.argv[1].isdigit():
        char_id = sys.argv[1]
        try:
            num_id = char_id_to_number(char_id)
            print(f"{num_id}")
        except ValueError as e:
            print(f"Error: {e}")
    else:
        num_id = int(sys.argv[1])
        try:
            char_id = number_to_char_id(num_id)
            print(f"{char_id}")
        except ValueError as e:
            print(f"Error: {e}")



