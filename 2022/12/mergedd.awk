#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -v X=1 input.txt"

BEGIN { for (i=97; i<=122; i++) chars[sprintf("%c", i)]=i-97 }

{
    split($1,a,"")
    for (x in a)
        if (a[x] in chars) map[x,NR]=chars[a[x]]
        else if (a[x]=="S") { s=x SUBSEP NR; map[s]=0 }
        else if (a[x]=="E") { e=x SUBSEP NR; map[e]=25 }
}

function try(x,y,l,s) {
    if (!(x,y) in map || (x,y) in wave || map[x,y]-l > 1) return 0
    wave[x,y]=s+1
    front[x,y]
    return 1
}

function expand(curstep, res) {
    res=0
    for (pos in front) {
        delete front[pos]
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
            delete front
            wave[start]=0
            front[start]=0
            for (steps=0; expand(steps) && !(e in wave); steps++) ;
            if (e in wave)
                results[start]=wave[e]
            else
                for (w in wave)
                    delete map[w]
        }
    print "Part 1: " results[s]
    asort(results)
    print "Part 2: " results[1]
}
