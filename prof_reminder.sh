#!/bin/bash

START_TIME=1000
END_TIME=1800
TELEGRAM_MESSAGE_TO_SEND='prof_reminder: Break lasts for more than 15mins'
SLEEP_TIME_BETWEEN_MESSAGES=60
SLEEP_BETWEEN_CHECKS=10
NO_DATA_TEXT="No filtered data found in the range"



while true
do
    time_with_leading_zero=$(date --date 'now' +%H%M)
    time_without_leading_zero=${time_with_leading_zero#0}
    time_without_leading_zeros=${time_without_leading_zero#0}
    time_without_leading_zeros=${time_without_leading_zeros#0}
    if [[ $(date +%u) != "7" ]] && (( $time_without_leading_zeros > $START_TIME )) && (( $time_without_leading_zeros < $END_TIME ))
    then
        send_reminder=true
        for e in {prof,schlafen,morgens,buch,psy,friseur,fitness}
        do
            timew_output=$(timew su $(date --date "15 minutes ago" +%H%M) - tomorrow $e | tail -2 | head -1)
            if [[ $timew_output != *$NO_DATA_TEXT* ]]
            then
                send_reminder=false
            fi
        done

        if $send_reminder
        then
            telegram-send "$TELEGRAM_MESSAGE_TO_SEND"
            sleep $SLEEP_TIME_BETWEEN_MESSAGES
        fi
    fi
    sleep $SLEEP_BETWEEN_CHECKS
done


