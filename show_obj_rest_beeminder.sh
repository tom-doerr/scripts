#!/bin/bash

echo "----------------------------------------"
echo
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
        time_diff=$(date -u -d @$(($(date -d "$time2" +%s) - $(date -d "$time1" +%s))) +%H:%M:%S)
        printf "  %-8s %-6s %-6s " "$time_diff" "$time1" "$time2"
    fi
    printf "%-15s %s %s\n" "$goal" "$value" "$rest"
done < <(bm status 2>/dev/null | grep -E '(obj|main|ai)' | sort)
echo
echo "----------------------------------------"
