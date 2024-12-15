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

