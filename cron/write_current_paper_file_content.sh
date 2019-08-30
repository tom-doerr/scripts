#!/bin/bash

file_list=$(find ~/git/offset_paper/ | grep -E '\.tex|\.bib')

output_file=~/uni/bachelorarbeit/offset_paper_files_content_5am
echo "" > $output_file
for e in $file_list
do
    cat "$e" >> $output_file
done


