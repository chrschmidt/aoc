#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

{
    data[NR-1]["value"]=811589153*$1
    data[NR-1]["prev"]=NR-2
    data[NR-1]["next"]=NR
    if ($1==0)
        cstart=NR-1
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
    data[0]["prev"]=NR-1
    data[NR-1]["next"]=0
    for (l=0;l<10;l++)
        for (e=0;e<NR;e++)
            move(e)
    print "Part 2: " calc()
}
