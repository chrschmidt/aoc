#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

(NR==1) { lp=split($1,path,"") }

/=/ {
    gsub(/[(),]/,"")
    step[$1]["L"]=$3
    step[$1]["R"]=$4
    if ($1 ~ /A$/)
        positions[$1] = $1
}

END {
    pos=1
    curpos="AAA"
    while(curpos != "ZZZ") {
        curpos=step[curpos][path[pos]]
        steps1++
        if(++pos>lp) pos=1
    }
    print "Part 1: " steps1

    for (curpos in positions) {
        pos=1
        steps=0
        while (!(curpos in ends)) {
            curpos=step[curpos][path[pos]]
            steps++
            if (curpos ~ /Z$/)
                ends[curpos] = steps
            if(++pos>lp) pos=1
        } 
    }
    l=asort(ends)
    for (i=2;i<=l;i++)
        ends[i]=lcm(ends[i-1],ends[i])
    print "Part 2: " ends[l]
}
