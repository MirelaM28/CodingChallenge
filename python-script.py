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


print(retrieve_tasks_ids(input_file))

