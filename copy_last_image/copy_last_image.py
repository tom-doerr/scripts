#!/usr/bin/env python3

import os
import glob
from pathlib import Path
import subprocess
import json

CACHE_FILE = Path.home() / ".cache" / "last_copied_image.json"

def load_last_copied():
    if not CACHE_FILE.exists():
        return None, 0
    try:
        with open(CACHE_FILE) as f:
            data = json.load(f)
            return data.get("path"), data.get("mtime", 0)
    except:
        return None, 0

def save_last_copied(path, mtime):
    CACHE_FILE.parent.mkdir(parents=True, exist_ok=True)
    with open(CACHE_FILE, "w") as f:
        json.dump({"path": path, "mtime": mtime}, f)

def get_last_downloaded_image():
    downloads_dir = str(Path.home() / "Downloads")
    image_extensions = ["*.png", "*.jpg", "*.jpeg", "*.gif"]
    
    newest_image = None
    newest_mtime = 0
    
    for ext in image_extensions:
        pattern = os.path.join(downloads_dir, ext)
        try:
            # Use iglob for memory efficiency
            for img_path in glob.iglob(pattern):
                mtime = os.path.getmtime(img_path)
                if mtime > newest_mtime:
                    newest_image = img_path
                    newest_mtime = mtime
        except:
            continue
    
    if not newest_image:
        return None, 0
        
    return newest_image, newest_mtime

def copy_to_clipboard(image_path):
    try:
        subprocess.run(["xclip", "-selection", "clipboard", "-t", "image/png", "-i", image_path], 
                      check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        return True
    except:
        return False

if __name__ == "__main__":
    last_path, last_mtime = load_last_copied()
    newest_path, newest_mtime = get_last_downloaded_image()
    
    if not newest_path:
        exit(0)
    
    if newest_mtime <= last_mtime:
        exit(0)
        
    if copy_to_clipboard(newest_path):
        save_last_copied(newest_path, newest_mtime)
