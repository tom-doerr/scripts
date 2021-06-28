#!/bin/bash

echo
echo "$(bm status | grep obj | sort | awk '{print "  "$2" "$NF" "$1}')
$(bm status)"
