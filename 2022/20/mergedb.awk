#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

{
    value[NR-1]=$1
    nextp[NR-1]=NR
    prevp[NR-1]=NR-2
    if ($1==0)
        cstart=NR-1
}

function move(e, n,i,v) {
    n=e
    v=value[e]%(NR-1)
    if (!v)
        return
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

function calc(e,i,sum) {
    e=cstart
    for (i=1;i<=3000;i++) {
        e=nextp[e]
        if (!(i%1000))
            sum+=value[e]
    }
    return sum
}

END {
    prevp[0]=NR-1
    nextp[NR-1]=0
    for (e=0;e<NR;e++)
        move(e)
    print "Part 1: " calc()

    for (i=0;i<NR;i++) {
        value[i]*=811589153
        nextp[i]=i+1
        prevp[i]=i-1
    }
    prevp[0]=NR-1
    nextp[NR-1]=0
    for (l=0;l<10;l++)
        for (e=0;e<NR;e++)
            move(e)
    print "Part 2: " calc()
}
