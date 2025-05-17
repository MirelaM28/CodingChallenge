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
  tasks_ids=($(echo "$tasks" | grep -o '[0-9]\+' | uniq))

}

retrieve_tasks_ids


echo "${tasks_ids[@]}"
