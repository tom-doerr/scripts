#!/bin/bash                                                   
                                                           
set -e  # Exit on error                                       
set -x  # Print commands as they are executed                 
                                                           
SOURCE_DIR="/mnt/8tb_hdd/syncthing"                           
ACCUMULATOR_DIR="/mnt/8tb_hdd/syncthing_accumulated"          
LOG_FILE="/mnt/8tb_hdd/syncthing_accumulator.log"             
                                                           
echo "Script starting..."                                     
echo "Checking directories..."                                
                                                           
# Check if source directory exists                            
if [ ! -d "$SOURCE_DIR" ]; then                               
 echo "ERROR: Source directory $SOURCE_DIR does not exist! 
 exit 1                                                    
fi                                                            
                                                           
# Create accumulator directory and set permissions            
echo "Setting up accumulator directory..."                    
mkdir -p "$ACCUMULATOR_DIR"                                   
chmod 755 "$ACCUMULATOR_DIR"                                  
                                                           
# Create log file directory if it doesn't exist               
echo "Setting up log file..."                                 
mkdir -p "$(dirname "$LOG_FILE")"                             
touch "$LOG_FILE"                                             
chmod 644 "$LOG_FILE"                                         
                                                           
# Log start time and directory sizes                          
echo "----------------------------------------"               
echo "----------------------------------------" >> "$LOG_FILE 
echo "$(date): Starting syncthing file accumulation"          
echo "$(date): Starting syncthing file accumulation" >>       
"$LOG_FILE"                                                   
                                                           
# Show directory sizes                                        
SOURCE_SIZE=$(du -sh "$SOURCE_DIR" | cut -f1)                 
ACCUM_SIZE=$(du -sh "$ACCUMULATOR_DIR" | cut -f1)             
echo "Source directory size: $SOURCE_SIZE"                    
echo "Source directory size: $SOURCE_SIZE" >> "$LOG_FILE"     
echo "Accumulator directory size before: $ACCUM_SIZE"         
echo "Accumulator directory size before: $ACCUM_SIZE" >>      
"$LOG_FILE"                                                   
                                                           
# Perform rsync with detailed logging                         
echo "Starting rsync operation..."                            
rsync -avu --ignore-existing --progress "$SOURCE_DIR/"        
"$ACCUMULATOR_DIR/" 2>&1 | tee -a "$LOG_FILE"                 
                                                           
# Log completion and final size                               
FINAL_SIZE=$(du -sh "$ACCUMULATOR_DIR" | cut -f1)             
echo "Accumulator directory size after: $FINAL_SIZE"          
echo "Accumulator directory size after: $FINAL_SIZE" >>       
"$LOG_FILE"                                                   
echo "$(date): Syncthing accumulation completed"              
echo "$(date): Syncthing accumulation completed" >> "$LOG_FIL 
echo "----------------------------------------"               
echo "----------------------------------------" >> "$LOG_FILE 

#!/bin/bash
set -x

# Directory paths
SOURCE_DIR="/mnt/8tb_hdd/syncthing"
ACCUMULATOR_DIR="/mnt/8tb_hdd/syncthing_accumulated"
LOG_FILE="/mnt/8tb_hdd/syncthing_accumulator.log"

echo "Script starting..."
echo "Checking directories..."

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Source directory does not exist: $SOURCE_DIR"
    exit 1
fi

# Create accumulator directory if it doesn't exist
mkdir -p "$ACCUMULATOR_DIR"

# Function to accumulate files
accumulate_files() {
    find "$SOURCE_DIR" -type f -print0 | while IFS= read -r -d '' file; do
        # Get relative path
        rel_path="${file#$SOURCE_DIR/}"
        # Create target directory
        target_dir="$ACCUMULATOR_DIR/$(dirname "$rel_path")"
        mkdir -p "$target_dir"
        # Copy file if it doesn't exist in target
        if [ ! -f "$ACCUMULATOR_DIR/$rel_path" ]; then
            cp "$file" "$ACCUMULATOR_DIR/$rel_path"
            echo "Copied: $rel_path" >> "$LOG_FILE"
        fi
    done
}

# Run the accumulation
accumulate_files

echo "Script completed."
