# CodingChallenge
Step1: read the file logs.log and extract only the lines which contain tasks
Output:

[root@fedora-vm CodingChallenge]# ./script.sh
032 796 515 051 386 188 996 188 996 268 182 946 074 173 538 173 538 946 811 697 051 515 697 294 074 626 536 626 706 460 268 794 064 8116 294 521 080 678 521 920 080 794 678 773 920 333 746 374 936 004 064 672 746 016 460 531 936 374 182 672

Step2: changed the way duplicates are removed (since tasks ids appear twice - at START & END)
Output:
[root@fedora-vm CodingChallenge]# ./script.sh
032 796 515 051 386 188 996 268 182 946 074 173 538 811 697 294 626 536 706 460 794 064 004 521 080 678 920 773 333 746 374 936 672 016 531
