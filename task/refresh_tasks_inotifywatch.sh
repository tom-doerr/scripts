#! /bin/bash

clear
task

# Frueher mit '-m' Option fuer Monitor Mode und dafuer ohne aeussere while-Schleife
# inotifywait -r -q -m -e close_write ~/Nextcloud/sonstiges/task/backlog.data ~/git/dotfiles/taskrc |

while true; do 
    inotifywait -r -q -e close_write ~/Nextcloud/sonstiges/task/backlog.data ~/git/dotfiles/taskrc |
    while read -r filename event; do
        clear
        task # or "./$filename"
    done
done
