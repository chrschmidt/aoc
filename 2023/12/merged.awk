#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

function valid(start,run, pos,i,sum,upper) {
    if ((start,run) in cached) { hits++; return cached[start,run] }
    cached[start,run]=0

    for (pos=start;pos<start+sizes[run];pos++)
        if (line[pos]==".")
            return 0
    if (pos<=length(line) && line[pos]=="#")
        return 0
    pos++
    if (run==length(sizes)) {
        for (;pos<=length(line);pos++)
            if (line[pos]=="#")
                return 0
        cached[start,run]=1
        return 1
    }
    for (i=run+1;i<=length(sizes);i++) upper+=sizes[i]+1
    upper=length(line)-(upper-1)+1
    for (;pos<=upper;pos++)
        switch (line[pos]) {
        case "#": sum+=valid(pos,run+1)
            cached[start,run]=sum
            return sum
        case "?": sum+=valid(pos,run+1)
        }
    cached[start,run]=sum
    return sum
}        

function calc(i,upper,pos,sum) {
    for (i=1;i<=length(sizes);i++) upper+=sizes[i]+1
    upper=length(line)-(upper-1)+1
    for (pos=1;pos<=upper;pos++)
        switch (line[pos]) {
        case "#": return sum+valid(pos,1)
        case "?": sum+=valid(pos,1)
        }
    return sum
}

{
    split($1,line,"")
    split($2,sizes,/,/)
    t=calc()
    part1+=t
    delete cached

    hits=0
    split($1"?"$1"?"$1"?"$1"?"$1,line,"")
    split($2","$2","$2","$2","$2,sizes,/,/)
    t2=calc()
    part2+=t2
    delete cached
}

END {
    print "Part 1: " part1
    print "Part 2: " part2
}
