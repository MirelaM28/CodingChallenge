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


echo "${tasks_ids[@]}"
