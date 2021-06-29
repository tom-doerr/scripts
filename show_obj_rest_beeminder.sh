#!/bin/bash

get_diff_times() {
    string1="$1"
    string2="$2"
    StartDate=$(date -u -d "$string1" +"%s")
    FinalDate=$(date -u -d "$string2" +"%s")
    date -u -d "0 $FinalDate sec - $StartDate sec" +"%H:%M:%S"
}



#obj_status_sorted="$(bm status | grep obj | sort)"


#get_diff_times 01:00:00 02:03:00

echo
time1=""
for word in  $(bm status | grep obj | sort | awk '{print "  "$2" "$NF" "$1}') 
do
    if [[ $word =~ user ]]
    then
        echo $word
        continue
    fi
    word=${word/+/}
    if [[ $time1 == "" ]]
    then
        #echo set
        time1="$word"
    else
        #echo calc
        time_diff=$(get_diff_times "$time1:00" "$word:00")
        printf "  ${time_diff::-3}  $time1  $word  "
        unset time1
    fi
done
bm status



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
