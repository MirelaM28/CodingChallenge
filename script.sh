#!/bin/bash

input_file=/root/logs.log

#Pretty formatting header
printf "%9s %12s %11s %11s %8s \n" "Task ID" "Start Time" "End Time" "Duration" "Alert"
printf "%9s %12s %12s %11s %8s \n" "---------" "------------" "------------" "-----------" "--------"


#Function to read file content and extract only lines containing tasks
retrieve_tasks_ids(){
  tasks=""
  while read -r line
  do
  	tasks+=$(echo "$line" | awk -F, '/task/{print $2" "'})
  done < $input_file

#To get the array made of the ids corresponding to the tasks
#uniq fails to remove duplicate ids if the lines are not adjacent
#sort -u will alter the order
  tasks_ids=($(echo "$tasks" | grep -o '[0-9]\+' | awk '!seen[$0]++'))

}

retrieve_tasks_ids

#Function that checks when a task starts and ends + calculate duration
#Tricky part is that some tasks ids are also part of other lines PIDs (for example 051)

start_end_tasks(){
  for id in ${tasks_ids[@]}
  do
  	start_task=$(awk -F, -v id="$id" '$2 ~ 'task' id && /START/{print $1}' $input_file)
	end_task=$(awk -F, -v id="$id" '$2 ~ 'task' id && /END/{print $1}' $input_file)
	start_seconds=$(date -d "$start_task" +%s)

#Will cause output to fail due to the fact that not all tasks end
#	end_seconds=$(date -d "$end_task" +%s)

        if [[ "$end_task" =~ [0-9]+ ]]
        then
                end_seconds=$( date -d "$end_task" +%s )
                difference=$(( $end_seconds - $start_seconds ))
                hours=$(( difference / 3600 ))
                minutes=$(( ( difference % 3600 ) / 60 ))
                seconds=$(( difference % 60 ))
        else
        	end_task="NOT ENDED"
        	hours=0
        	minutes=0
        	seconds=0

        fi

#Also included here the alert part
	message=""
        if [ $minutes -eq 5 ]
        then
                message="Warning"
        elif [ $minutes -eq 10 ]
        then
                message="Error"
        fi

#	echo "$id | $start_task | $end_task | $hours:$minutes:$seconds | $message " 
#For pretty formatting
	printf "%1s %7s %1s %10s %1s %10s %1s %8s %1s %7s %1s \n" "|" "$id" "|" "$start_task" "|" "$end_task" "|" "$hours:$minutes:$seconds" "|" "$message" "|"


  done

}
start_end_tasks

#Pretty format footer
printf "%58s \n" "----------------------------------------------------------"
