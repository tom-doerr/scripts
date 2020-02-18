#!/bin/zsh

source ~/.zshrc

get_time_h_day() {
    hms_to_hours $(timew su $1 | tail -2 | head -1 | { read first rest; echo $first; })
}

currently_tracking_video() {
    tw_output=$(timew)
    tracking_line=$(printf "$tw_output" | awk 'NR==1')  
    [[ $tracking_line == *" video"* ]] 
}

to_much_video() {
    h_prof=$(get_time_h_day prof)
    h_video=$(get_time_h_day video)
    h_video_2=$((($h_video - 0.25) * 4))
    (( $(echo "$h_video_2 > $h_prof" | bc -l) ))
}

while true
do
    if currently_tracking_video
    then
        if to_much_video
        then
            h_prof=$(get_time_h_day prof)
            h_prof_rounded=$(printf "%.2f\n" $h_prof)
            h_video=$(get_time_h_day video)
            h_video_rounded=$(printf "%.2f\n" $h_video)
            echo "Spent too much time watching videos ($h_video_rounded) vs working on prof tasks ($h_prof_rounded)" | telegram-send --stdin
        fi

    fi
    sleep 10
done
