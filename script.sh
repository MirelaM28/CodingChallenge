#!/bin/bash

input_file=/root/logs.log

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

#Task to retrieve when a task starts and ends + calculate duration
#Tricky part is that some tasks ids are also part of other lines PIDs (for example 051)

start_end_tasks(){
  for id in ${tasks_ids[@]}
  do
  	start_task=$(awk -F, -v id="$id" '$2 ~ 'task' id && /START/{print $1}' $input_file)
	end_task=$(awk -F, -v id="$id" '$2 ~ 'task' id && /END/{print $1}' $input_file)

	start_seconds=$(date -d "$start_task" +%s)
	end_seconds=$(date -d "$end_task" +%s)
	
	difference=$(( $end_seconds - $start_seconds ))
	hours=$(( difference / 3600 ))
	minutes=$(( ( difference % 3600 ) / 60 ))
	seconds=$(( difference % 60 ))

	echo "$id | $start_task | $end_task | $hours:$minutes:$seconds " 

  done

}

start_end_tasks
