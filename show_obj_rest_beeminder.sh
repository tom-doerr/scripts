#!/bin/bash

get_diff_times() {
    string1="$1"
    string2="$2"
    
    if [[ "$string1" == "days" || "$string2" == "days" ]]; then
        echo "N/A"
        return
    fi
    
    StartDate=$(date -u -d "$string1" +"%s")
    FinalDate=$(date -u -d "$string2" +"%s")
    
    if [[ -z "$StartDate" || -z "$FinalDate" ]]; then
        echo "Invalid"
        return
    fi
    
    if (( StartDate < FinalDate )); then
        date -u -d "@$((FinalDate - StartDate))" +"%H:%M:%S"
    else
        echo "-$(date -u -d "@$((StartDate - FinalDate))" +"%H:%M:%S")"
    fi
}



#obj_status_sorted="$(bm status | grep obj | sort)"


#get_diff_times 01:00:00 02:03:00

echo "----------------------------------------"
echo
time1=""
while read -r line; do
    if [[ $line =~ user ]]; then
        echo "$line"
        continue
    fi
    
    read goal time1 time2 value rest <<< $(echo "$line" | awk '{print $1, $2, $3, $4, $5, $6, $7, $8}')
    time1=${time1/+/}
    time2=${time2/+/}
    
    if [[ "$time1" == "✔" ]]; then
        printf "  - - - "
    else
        time_diff=$(get_diff_times "$time1" "$time2")
        printf "  %-8s %-6s %-6s " "$time_diff" "$time1" "$time2"
    fi
    printf "%-15s %s %s\n" "$goal" "$value" "$rest"
done < <(bm status 2>/dev/null | grep -E '(obj|main|ai)' | sort)
echo
echo "----------------------------------------"
bm status 2>/dev/null | grep -E '(obj|main|ai)'



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
