#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

{
    patsplit($1,n,"[0-9]+")
    if ((n[1]<=n[3] && n[2]>=n[4]) || (n[1]>=n[3] && n[2]<=n[4])) sum1++
    if ((n[1]<=n[3] && n[2]>=n[3]) || (n[3]<=n[1] && n[4]>=n[1])) sum2++
}

END {
    print "Part 1: " sum1
    print "Part 2: " sum2
}
