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
    if (( $time_without_leading_zero > $START_TIME )) && (( $time_without_leading_zero < $END_TIME ))
    then
        timew_output_prof=$(timew su $(date --date "15 minutes ago" +%H%M) - tomorrow prof | tail -2 | head -1)
        timew_output_schlafen=$(timew su $(date --date "15 minutes ago" +%H%M) - tomorrow schlafen | tail -2 | head -1)

        if [[ $timew_output_prof == *$NO_DATA_TEXT* ]] && [[ $timew_output_schlafen == *$NO_DATA_TEXT* ]]
        then
            telegram-send "$TELEGRAM_MESSAGE_TO_SEND"
            sleep $SLEEP_TIME_BETWEEN_MESSAGES
        fi
    fi
    sleep $SLEEP_BETWEEN_CHECKS
done


