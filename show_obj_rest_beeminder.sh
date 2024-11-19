#!/bin/bash

get_diff_times() {
    string1="$1"
    string2="$2"
    
    echo "DEBUG: get_diff_times input: '$string1' '$string2'" >&2
    
    # Check if either input is "day" or "days"
    if [[ "$string1" == "day" || "$string1" == "days" || "$string2" == "day" || "$string2" == "days" ]]; then
        echo "DEBUG: Found day/days input" >&2
        echo "N/A"
        return
    fi
    
    echo "DEBUG: Converting '$string1' to seconds" >&2
    StartDate=$(date -u -d "$string1" +"%s")
    echo "DEBUG: Converting '$string2' to seconds" >&2
    FinalDate=$(date -u -d "$string2" +"%s")
    
    echo "DEBUG: StartDate=$StartDate, FinalDate=$FinalDate" >&2
    if (( StartDate < FinalDate )); then
        date -u -d "0 $FinalDate sec - $StartDate sec" +"%H:%M:%S"
    else
        echo "-"$(date -u -d "0 $StartDate sec - $FinalDate sec" +"%H:%M:%S")
    fi
}



#obj_status_sorted="$(bm status | grep obj | sort)"


#get_diff_times 01:00:00 02:03:00

echo
time1=""
# Get all goals and filter for those with time format (not days)
# Get the raw status output first
status_output=$(bm status 2>/dev/null)

# Debug: Show raw status output
echo "=== RAW STATUS OUTPUT ==="
echo "$status_output"
echo "=== END RAW STATUS ==="

# Create a filtered version that only includes goals due within 24 hours
filtered_output=$(echo "$status_output" | awk '
    BEGIN { print "=== PROCESSING LINES ===" }
    {
        # Print debug info for each line
        print "DEBUG: Processing line: " $0
        
        if ($0 ~ /in [0-9]+:[0-9]+$/) {
            print "DEBUG: Found HH:MM format"
            print
        } else if ($0 ~ /in [0-9]+ days?$/) {
            days = $(NF-1)
            print "DEBUG: Found days format: " days " days"
            if (days <= 1) {
                print
            }
        }
    }
')

echo "=== FILTERED OUTPUT ==="
echo "$filtered_output"
echo "=== END FILTERED ==="

echo "=== PROCESSING LOOP START ==="
# Process the filtered output (only lines with actual goals)
filtered_for_processing=$(echo "$filtered_output" | grep -v '^===' | grep -v '^DEBUG:' | grep -v '^-\+$' | sort | awk '{print "  "$2" "$NF" "$1}')
echo "DEBUG: Filtered for processing:"
echo "$filtered_for_processing"
echo "=== END FILTERED FOR PROCESSING ==="

for word in $filtered_for_processing
do
    echo "DEBUG: Processing word: '$word'"
    if [[ $word =~ user ]]
    then
        echo "DEBUG: Found username: $word"
        echo $word
        continue
    fi
    word=${word/+/}
    echo "DEBUG: After removing +: '$word'"
    
    if [[ $time1 == "" ]]; then
        echo "DEBUG: Setting time1='$word'"
        time1="$word"
    else
        echo "DEBUG: Processing time pair: time1='$time1' word='$word'"
        if [[ $time1 == "✔" ]]; then
            echo "DEBUG: Found checkmark"
            printf "  - - - "
        elif [[ $time1 == "day" || $time1 == "days" || $word == "day" || $word == "days" ]]; then
            echo "DEBUG: Found day/days"
            printf "  N/A  $time1  $word  "
        elif [[ $time1 =~ ^[0-9:]+$ ]] && [[ $word =~ ^[0-9:]+$ ]]; then
            echo "DEBUG: Found time format, calculating difference"
            time_diff=$(get_diff_times "$time1:00" "$word:00")
            echo "DEBUG: time_diff='$time_diff'"
            printf "  ${time_diff::-3}  $time1  $word  "
        else
            echo "DEBUG: No valid time format found"
            printf "  - - - "
        fi
        unset time1
    fi
done
# Print the filtered status with headers
echo "-----------------------------------------------------------------"
echo "$filtered_output" | grep -v "date: invalid date" | grep -v '^===' | grep -v '^DEBUG:'
echo "-----------------------------------------------------------------"



#for line in "$obj_status_sorted"
#do
#    echo $line
#done
#
#
#
#for line in  $(bm status | grep obj | sort | awk '{print "  "$2" "$NF" "$1}')                                                                                                                                                                                                    
#do                                                                                                                                                                                                                                                                               
#    echo $line                                                                                                                                                                                                                                                                   
#done                                                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                                                                  
#get_diff_times $(echo $obj_status_sorted | awk)                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                                  
#echo                                                                                                                                                                                                                                                                             
#echo "$(bm status | grep obj | sort | awk '{print "  "$2" "$NF" "$1}')                                                                                                                                                                                                           
#$(bm status)"   
