#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

function valid(start,run, pos,i,sum,upper) {
    pos=start
    if (run) {
        if ((start,run) in cached)
            return cached[start,run]
        cached[start,run]=0
        for (;pos<start+sizes[run];pos++)
            if (line[pos]==".")
                return 0
        if (pos<=length(line) && line[pos++]=="#")
            return 0
        if (run==length(sizes)) {
            for (;pos<=length(line);pos++)
                if (line[pos]=="#")
                    return 0
            cached[start,run]=1
            return 1
        }
    }
    for (i=run+1;i<=length(sizes);i++) upper+=sizes[i]+1
    upper=length(line)-(upper-1)+1
    for (;pos<=upper;pos++) {
        if (line[pos]==".") continue
        sum+=valid(pos,run+1)
        if (line[pos]=="#") break
    }
    cached[start,run]=sum
    return sum
}        

function calc(condition,groups) {
    delete cached
    split(condition,line,"")
    split(groups,sizes,/,/)
    return valid(1,0)
}

{
    part1+=calc($1,$2)
    part2+=calc($1"?"$1"?"$1"?"$1"?"$1, $2","$2","$2","$2","$2)
}

END {
    print "Part 1: " part1
    print "Part 2: " part2
}
