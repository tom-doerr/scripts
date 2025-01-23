#!/bin/bash

# Define paths
HOOKS_DIR="$HOME/.task/hooks"
SCRIPTS_DIR="$HOME/git/scripts/task"

# Create hooks directory if it doesn't exist
mkdir -p "$HOOKS_DIR"

# Function to create symlink with error checking
create_hook_symlink() {
    local source="$1"
    local hook_name="$2"
    local target="$HOOKS_DIR/$hook_name"
    
    if [ -L "$target" ]; then
        echo "Hook $hook_name already exists, skipping..."
        return
    fi
    
    if ln -s "$source" "$target"; then
        echo "Successfully created hook: $hook_name"
        chmod +x "$target"
    else
        echo "Failed to create hook: $hook_name"
        exit 1
    fi
}

# Set up project tags hook
create_hook_symlink "$SCRIPTS_DIR/on_add_project_tags.py" "on-add.project_tags"

# Set up char ID display hook (on-exit)
create_hook_symlink "$SCRIPTS_DIR/on_exit_show_char_id.py" "on-exit.char_id"

echo "Taskwarrior hooks setup complete!"
