#!/bin/bash

get_diff_times() {
    string1="$1"
    string2="$2"
    
    # Check if either input is "day" or "days"
    if [[ "$string1" == "day" || "$string1" == "days" || "$string2" == "day" || "$string2" == "days" ]]; then
        echo "N/A"
        return
    fi
    
    StartDate=$(date -u -d "$string1" +"%s")
    FinalDate=$(date -u -d "$string2" +"%s")
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
# Filter and format, excluding the separator lines
for word in $(echo "$status_output" | grep -v '^-\+$' | grep -v -E ' day[s]* ' | sort | awk '{print "  "$2" "$NF" "$1}')
do
    if [[ $word =~ user ]]
    then
        echo $word
        continue
    fi
    word=${word/+/}
    # Skip if word is just dashes (separator line)
    if [[ "$word" =~ ^-+$ ]]; then
        continue
    fi
    
    if [[ $time1 == "" ]]; then
        time1="$word"
    else
        if [[ $time1 == "✔" ]]; then
            printf "  - - - "
        elif [[ $time1 == "day" || $time1 == "days" || $word == "day" || $word == "days" ]]; then
            printf "  N/A  $time1  $word  "
        elif [[ $time1 =~ ^[0-9:]+$ ]] && [[ $word =~ ^[0-9:]+$ ]]; then
            time_diff=$(get_diff_times "$time1:00" "$word:00")
            printf "  ${time_diff::-3}  $time1  $word  "
        else
            printf "  - - - "
        fi
        unset time1
    fi
done
# Print the original status output but filter out any error messages
echo "$status_output" | grep -v "date: invalid date"



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
