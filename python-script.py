#!/usr/bin/env python

import re
import csv
from datetime import datetime

input_file='/root/logs.log'

#Function used for reading file lines and retrieve unique task ids
#The word that follows 'task' in each line (id) is stored in a set (choosed due to the fact that it won't contain any duplicates)
def retrieve_tasks_ids(input_file):
   tasks=""
   with open(input_file, 'r') as file:
       for line in file:
           tasks += str(line)
           if 'task' in line:
               tasks_ids=list(set(re.findall(r'(?<=task )(\w+)',tasks)))
   return tasks_ids

def start_end_tasks(input_file, task_ids):
    results=[]
    with open(input_file, 'r') as file:
        lines=file.readlines()
        for task_id in task_ids:
            start_task=None
            end_task=None
            for line in lines:
                if f'task {task_id}' in line:
                    if 'START' in line and start_task is None:
                        start_task=line.split(',')
                    elif 'END' in line:
                        end_task=line.split(',')

#Added the calculation of tasks

            if start_task:
                start_seconds=int(datetime.strptime(start_task[0], "%H:%M:%S").timestamp())

            if end_task:
                end_seconds=int(datetime.strptime(end_task[0], "%H:%M:%S").timestamp())
                difference=end_seconds-start_seconds
                hours=difference//3600
                minutes=(difference % 3600) // 60
                seconds=difference % 60
            else:
                end_task=["NOT ENDED"]
                hours=0
                minutes=0
                seconds=0

#Keeped only the first element of start_task & end_task strings since the first value reflects the time 
            results.append((task_id,start_task[0],end_task[0],f"{hours}:{minutes}:{seconds}"))

        return results

output_first_function=retrieve_tasks_ids(input_file)
print(start_end_tasks(input_file,output_first_function))

