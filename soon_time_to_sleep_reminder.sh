#!/bin/bash

FILE_LOCATION='/home/tom/telegram_reminders/soon_time_to_sleep'
SECONDS_BEFORE_SCHLAFEN_TO_REMIND=$(( 2 * 3600 ))
MAX_SECONDS_TIME_OF_DAY=$(( 7 * 3600 ))

echo "SECONDS_BEFORE_SCHLAFEN_TO_REMIND: " "$SECONDS_BEFORE_SCHLAFEN_TO_REMIND"
echo "MAX_SECONDS_TIME_OF_DAY: " "$MAX_SECONDS_TIME_OF_DAY"

get_time_in_seconds() {
    echo $@ | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }'
}

get_num_lines_file() {
    wc -l $FILE_LOCATION |
        awk '{print $1}'
}


while true
do
    relevant_date=$(date --date "7 hours ago" +%Y-%m-%d)
    last_schlafen_start=$(timew su "$relevant_date"T00:00:00 - "$relevant_date"T07:00:00 schlafen | 
        tail -n4 |
        head -n1 |
        awk '{print $(NF - 3)}')
    echo "last_schlafen_start: " "$last_schlafen_start"
    schlafen_start_seconds=$(get_time_in_seconds $last_schlafen_start)
    echo "schlafen_start_seconds: " "$schlafen_start_seconds"
    current_time=$(date +%H:%M:%S)
    echo "current_time: " "$current_time"
    current_time_seconds=$(get_time_in_seconds $current_time)
    echo "current_time_seconds: " "$current_time_seconds"
    time_difference_seconds=$(( schlafen_start_seconds - current_time_seconds ))
    echo "time_difference_seconds: " "$time_difference_seconds"



    num_lines_old=$(get_num_lines_file)
    if (( current_time_seconds < MAX_SECONDS_TIME_OF_DAY )) && (( time_difference_seconds < SECONDS_BEFORE_SCHLAFEN_TO_REMIND )) && [[ ! $(timew) =~ "schlafen" ]] && [[ ! $(timew) =~ "bettzeit" ]] 
    then
        while true
        do
            num_lines=$(get_num_lines_file)
            echo "num_lines_old: " "$num_lines_old"
            echo "num_lines: " "$num_lines"
            if (( num_lines - num_lines_old > 0 ))
            then
                echo 'Acknowledged alarm, starting to sleep.'
                sleep $SECONDS_BEFORE_SCHLAFEN_TO_REMIND
                break
            fi
            telegram-send "Time to get ready for bed. Last time started sleeping: $last_schlafen_start."
            num_lines_old=$num_lines
            sleep 20
        done
    fi
    sleep 60
done
