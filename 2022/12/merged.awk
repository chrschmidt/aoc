#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -v X=1 input.txt"

BEGIN { for (i=97; i<=122; i++) chars[sprintf("%c", i)]=i-97 }

{
    split($1,a,"")
    for (x in a)
        if (a[x] in chars) map[x,NR]=chars[a[x]]
        else if (a[x]=="S") { map[x,NR]=0; sx=x; sy=NR }
        else if (a[x]=="E") { map[x,NR]=25; ex=x; ey=NR }
}

function try(x,y,l,s) {
    if (!(x,y) in map) return 0
    if ((x,y) in wave) return 0
    if (map[x,y]-l > 1) return 0
    wave[x,y]=s+1
    return 1
}

function expand(curstep, res) {
    res=0
    for (pos in wave)
        if (wave[pos]==curstep) {
            split(pos,coords,SUBSEP)
            res+=try(coords[1]+1,coords[2],map[pos],curstep)
            res+=try(coords[1]-1,coords[2],map[pos],curstep)
            res+=try(coords[1],coords[2]+1,map[pos],curstep)
            res+=try(coords[1],coords[2]-1,map[pos],curstep)
        }
    return res
}

END {
    for (start in map)
        if (map[start]==0) {
            delete wave
            wave[start]=0
            for (steps=0; expand(steps); steps++) ;
            if ((ex,ey) in wave)
                results[start]=wave[ex,ey]
        }
    print "Part 1: " results[sx,sy]
    asort(results)
    print "Part 2: " results[1]
}
