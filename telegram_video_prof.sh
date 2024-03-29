#!/bin/zsh

source ~/.zshrc

currently_tracking_tag() {
    tag="$1"
    tw_output=$(timew)
    tracking_line=$(printf "$tw_output" | awk 'NR==1')  
    [[ $tracking_line =~ " $tag" ]] 
}

too_much_video() {
    too_much_tag_time "video"
}

too_much_break() {
    too_much_tag_time "break"
}

too_much_tag_time() {
    tag="$1"
    [[ $tag == "video" ]] && tag_command="vtime"
    [[ $tag == "break" ]] && tag_command="btime"
    remaining_time=$($tag_command)
    (( $(echo "$remaining_time < 0" | bc -l) ))
}

while true
do
    if too_much_video && currently_tracking_tag "video"
    then
        h_prof=$(get_time_h_day prof)
        h_prof_rounded=$(printf "%.2f\n" $h_prof)
        h_video=$(get_time_h_day video)
        h_video_rounded=$(printf "%.2f\n" $h_video)
        echo "Spent too much time watching videos ($h_video_rounded) vs working on prof tasks ($h_prof_rounded)" | telegram-send --stdin
    fi
    if too_much_break && currently_tracking_tag "break"
    then
        echo "Too much break time!" | telegram-send --stdin
    fi
    sleep 10
done
