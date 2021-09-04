#!/bin/bash


unalias_function_or_alias() {
  local name=$1
  local type=$(type $name)
  if [[ $type =~ "function" ]]; then
    unset -f $name
  elif [[ $type =~ "alias" ]]; then
    unalias $name
  fi
}


for i in {1..10} d w m y q
do
    unalias_function_or_alias $i
    source <(echo "$i(){wait_task $i}")
done


wait_task() {
    command=$@
    if [[ $command == "" ]]
    then
        bucket_item_done
    elif [[ $command =~ '^[0-9].*' ]]
    then
        first_task_id=$(get_first_task 'review_bucket_items')
        if [[ $command =~ '^[0-9]*$' ]]
        then
            time_unit="d"
        else
            time_unit=""
        fi
        task $first_task_id mod wait:$command"$time_unit"
    elif [[ $command =~ '^(d|w|m|y|q)$' ]]
    then
        first_task_id=$(get_first_task 'review_bucket_items')
        task $first_task_id mod wait:1"$command"
    fi
}
