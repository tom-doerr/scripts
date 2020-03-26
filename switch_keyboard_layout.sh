#!/bin/bash -i

layout=$(setxkbmap -query | grep layout | awk '{print $2}') 
if [[ $layout == 'us' ]]                                    
then                                                        
        setxkbmap -layout de                                
else                                                        
        setxkbmap -layout us                                
        kb                                                  
fi                      
