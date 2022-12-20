#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

{
    value[NR-1]=$1
    if ($1==0)
        cstart=NR-1
}

function move(c, sum) {
    for (i=0;i<NR;i++) {
        nextp[i]=i==NR-1?0:i+1
        prevp[i]=i?i-1:NR-1
    }
    for (l=0;l<c;l++)
        for (e=0;e<NR;e++) {
            n=e
            v=value[e]%(NR-1)
            if (!v)
                continue
            if (v<0)
                v+=(NR-1)
            for (i=0;i<v;i++)
                n=nextp[n]
            nextp[prevp[e]]=nextp[e]
            prevp[nextp[e]]=prevp[e]
            prevp[e]=n
            nextp[e]=nextp[n]
            nextp[n]=e
            prevp[nextp[e]]=e
        }
    e=cstart
    for (i=1;i<=3000;i++) {
        e=nextp[e]
        if (!(i%1000))
            sum+=value[e]
    }
    return sum
}

END {
    print "Part 1: " move(1)

    for (i=0;i<NR;i++)
        value[i]*=811589153
    print "Part 2: " move(10)
}
