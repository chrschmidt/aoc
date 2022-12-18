#!/usr/bin/env -S /bin/sh -c "exec awk -v line=2000000 -f ${_} input.txt"

function abs(a) { return a<0?-a:a }
function inrange(min,max,val) { return val>=min && val <=max }
function dist(x1,y1,x2,y2) { return abs(x1-x2)+abs(y1-y2) }

{
    patsplit($0,a,"-?[0-9]+")
    if (a[4]==line)
        map[a[4]]="B"
    md=dist(a[1],a[2],a[3],a[4])
    if (inrange(a[2]-md,a[2]+md,line)) {
        for (x=a[1]-md;x<=a[1]+md;x++)
            if (dist(a[1],a[2],x,line)<=md)
                if (!(x in map))
                    map[x]="#"
    }
}

END {
    for (x in map)
        if (map[x]!="B")
            np++
    print "Part 1: " np
}
