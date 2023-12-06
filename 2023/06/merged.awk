#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

/^Time/  { for (i=2;i<=NF;i++) times[i-2]=$i; $1=""; realtime=int(gensub(/[[:blank:]]+/, "", "g")) }
/^Distance/  { for (i=2;i<=NF;i++) dists[i-2]=$i; $1=""; realdist=int(gensub(/[[:blank:]]+/, "", "g")) }

function calc(t,d, c,w) {
    for (c=1;c<t;c++)
        if ((t-c)*c>d)
            w++
    return w
}

END {
    part1=1
    for (t in times)
        part1*=calc(times[t],dists[t])
    print "Part 1: " part1
    print "Part 2: " calc(realtime,realdist)
}
