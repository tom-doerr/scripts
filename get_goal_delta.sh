#!/bin/bash

# This script sums up the time spent on a certain tag using timewarrior and 
# substracts a goal value.
# The goal value is the number of days in the interval times a certain number
# of hours per day.


# Get the tag
tag=$1

# Get the time interval
startdate=$2

num_hours_per_day=$3

# Calculate the value goal based on the number of days since stardate and some daily amount.
# Get the current date.
currentdate=$(date +%Y-%m-%d)

# Get the number of days since startdate.
days=$(echo $(($(date -d "$currentdate" "+%s") - $(date -d "$startdate" "+%s"))) | awk '{print int($1/86400)}')

# Get the number of hours per day.
hours=$(echo $num_hours_per_day | bc)

# Calculate the goal value.
goal=$(echo "$days * $hours" | bc)

# Get the current time
currentdate=$(date +%Y-%m-%d)
enddate=$currentdate

# Get the time sum
sum=$(timew summary $startdate - "$enddate" $tag | tail -n2)

# Strip empty lines and space from sum.
sum=$(echo $sum | sed -e 's/^[ \t]*//')

# Convert the sum in HH:MM::SS format to hours.
sum=$(echo $sum | cut -d' ' -f6 | sed -e 's/:/ /g')
sum=$(echo $sum | awk '{print ($1*3600 + $2*60 + $3)/3600}')

# Substitute sum comma by a decimal point.
sum=$(echo $sum | sed -e 's/,/./')


# Calculate the result
result=$(echo "$sum - $goal" | bc)

# Round result to an integer value.
# This also works for negative numbers
result=$(echo "($result+0.5)/1" | bc)

# Print the time delta.
echo "You have spent $sum hours on $tag."

# Print the goal.
echo "You need to spend $goal hours on $tag."

# Print the difference between tag and goal.
echo "You have to work $(echo "$goal - $sum" | bc) more hours on $tag."

echo

# Print the result
if [ $result -lt 0 ]; then
	echo "You have spent too much time on $tag. You need to work more!"
elif [ $result -eq 0 ]; then
	echo "You have spent the perfect amount of time on $tag."
else
	echo "You have spent enough time on $tag."
fi


