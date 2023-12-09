#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

BEGIN { delete positions }

(NR==1) { lp=split($1,path,"") }

/=/ {
    gsub(/[(),]/,"")
    step[$1]["L"]=$3
    step[$1]["R"]=$4
    if ($1 ~ /A$/)
        positions[$1] = $1
    if ($1 ~ /Z$/)
        finals[$1]=1
}

END {
    for (this in positions) {
        pos=1
        steps=0
        do {
            this=step[this][path[pos]]
            steps++
            if (this in finals) {
                key = i SUBSEP this SUBSEP pos
                if (key in ends) {
#                    print "Found period for " i " at location " this ", pos " pos ", start " ends[key] ", period " steps-ends[key]
                    if (steps != 2*ends[key]) { print "Error"; exit 1 }
                    break
                } else
                    ends[key] = steps
            }
            if(++pos>lp) pos=1
        } while (1)
    }
    l=asort(ends)
    for (i=2;i<=l;i++)
        ends[i]=lcm(ends[i-1],ends[i])
    print "Part 2: " ends[l]
}
