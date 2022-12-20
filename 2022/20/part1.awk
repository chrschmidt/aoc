#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

{
    data[NR-1]["value"]=$1
    data[NR-1]["prev"]=NR-2
    data[NR-1]["next"]=NR
    if ($1==0)
        cstart=NR-1
}

function dump(i,e) {
    e=start
    for (i=0;i<NR;i++) {
        printf (i>0?", ":"") data[e]["value"]
        e=data[e]["next"]
    }
    print ""
}

function move(e, n,i,v) {
    n=e
    v=data[e]["value"]%(NR-1)
    if (!v)
        return
    if (v>0)
        for (i=0;i<v;i++)
            n=data[n]["next"]
    else
        for (i=0;i>=v;i--)
            n=data[n]["prev"]

    if (e==start)
        start=data[e]["next"]
    data[data[e]["prev"]]["next"]=data[e]["next"]
    data[data[e]["next"]]["prev"]=data[e]["prev"]
    data[e]["prev"]=n
    data[e]["next"]=data[n]["next"]
    data[n]["next"]=e
    data[data[e]["next"]]["prev"]=e
}

function calc(e,i,sum) {
    e=cstart
    for (i=1;i<=3000;i++) {
        e=data[e]["next"]
        if (!(i%1000))
            sum+=data[e]["value"]
    }
    return sum
}

END {
    start=0
    data[0]["prev"]=NR-1
    data[NR-1]["next"]=0
#    dump()
    for (e=0;e<NR;e++) {
        move(e)
#        printf "after " e "(" data[e]["value"] "): "
#        dump()
    }
    print "Part 1: " calc()
}
