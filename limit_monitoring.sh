#!/usr/bin/zsh -i


#!/usr/bin/zsh -i                                        

while true                                            
do                                                             
    # task +ACTIVE
    if [ -n "$(task +ACTIVE)" ]; then
        echo "You have active tasks"
    else
        echo "You have no active tasks"
        sleep 10
        continue
    fi
    task_limit_seconds=$(current_task_limit_seconds)
    active_time_seconds=$(current_active_time_seconds)                          
    # check if numbers
    if [[ $task_limit_seconds -gt 0 && $active_time_seconds -gt 0 ]]    
    then                                                                       
        if [ $active_time_seconds -gt $task_limit_seconds ]                   
        then                                                        
            echo "Time limit exceeded"                     
            at break        
        else
            echo "Within time limit"
        fi                                                     
    fi                                                  
    sleep 10                                                                  
done                                                       

#while true
#do
    #task_limit_seconds=$(current_task_limit_seconds)
    #active_time_secons=$(current_active_time_seconds)
    ## check if numbers
    #if [[ $task_limit_seconds -gt 0 && $active_time_secons -gt 0 ]]
    #then
        #if [ $active_time_seconds -gt $task_limit_seconds ]
        #then
            #echo "Time limit exceeded"
            #at break
        #fi
    #fi
    #sleep 10
#done
