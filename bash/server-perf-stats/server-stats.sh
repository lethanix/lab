#!/bin/sh
#
# Script that analyse server performance stats

# Total CPU usage
## Get one sample from `vmstat`
## Remove the header with `tail`
## Calculate 100 minus the idle percentage (the 15th field)
echo "*******************************"
echo Total CPU usage
echo $(vmstat | tail -n 1 | awk '{print "CPU: " 100-$15"%"}')

# Total memory usage (Free vs Used including percentage)
## Remove the headers with `tail` and select the Mem row with `head`
## Calculate the percentage and print it with `awk`
echo "*******************************"
echo Total memory usage
free -m | tail -n +2 | head -1 | awk '{f = $4*100/$2; u = $3*100/$2; printf "Free: %dMb (%3.2f%)\nUsed: %dMb (%3.2f%)\n", $4, f, $3, u }'

# Total disk usage (Free vs Used including percentage)
echo "*******************************"
echo Total disk usage
df -h / | tail -n 1 | awk '{f = $4*100/$2; u = $3*100/$2; printf "Free: %s (%3.2f%)\nUsed: %s (%3.2f%)\n", $4, f, $3, u}'

# Top 5 processes by CPU usage
## Provide the first five results with `head`
echo "*******************************"
echo Top 5 processed by CPU usage
ps ax k -%cpu o pid,%cpu | head -6 | awk '{printf "%-7s%5s\n", $1, $2}'

# Top 5 processes by memory usage
## Provide the first five results with `head`
echo "*******************************"
echo Top 5 processed by Memory usage
ps ax k -%mem o pid,%mem | head -6 | awk '{printf "%-7s%5s\n", $1,$2}'

