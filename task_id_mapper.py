#!/usr/bin/env python3

# Use home row keys for mapping
HOMEROW_CHARS = 'asdfghjk'

def number_to_char_id(num: int) -> str:
    """Convert a numeric ID to a character-based ID using home row keys"""
    if num <= 0:
        raise ValueError("ID must be positive")
    
    result = ""
    while num > 0:
        num -= 1  # Convert to 0-based for modulo
        result = HOMEROW_CHARS[num % len(HOMEROW_CHARS)] + result
        num //= len(HOMEROW_CHARS)
    return result

def char_id_to_number(char_id: str) -> int:
    """Convert a character-based ID back to numeric ID"""
    if not all(c in HOMEROW_CHARS for c in char_id):
        raise ValueError(f"Invalid characters in ID. Must only use: {HOMEROW_CHARS}")
    
    result = 0
    for c in char_id:
        result = result * len(HOMEROW_CHARS) + HOMEROW_CHARS.index(c) + 1
    return result
