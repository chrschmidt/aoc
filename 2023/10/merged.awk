#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

{
    wl=split($1,world[NR],"")
    if ((t=index($1,"S"))) {
        xs=t
        ys=NR
    }
}

function setxy(xn,yn) {
    x[found]=xn
    y[found++]=yn
    visited[xn,yn]=1
}

function viable(x,y) { return !(x SUBSEP y in visited) }

function dostep(i,xs,ys) {
    visited[xs,ys]=visited[x[i],y[i]]+1
    x[i]=xs; y[i]=ys
    return visited[xs,ys]
}

function sstep(i,x1,y1,x2,y2) {
    if (viable(x1,y1)) return dostep(i,x1,y1)
    else if (viable(x2,y2)) return dostep(i,x2,y2)
    else return 0
}

function step(i, xt,yt) {
    xt=x[i]; yt=y[i]
    switch (world[yt][xt]) {
    case "|": return sstep(i, xt,yt-1, xt,yt+1)
    case "-": return sstep(i, xt-1,yt, xt+1,yt)
    case "L": return sstep(i, xt,yt-1, xt+1,yt)
    case "J": return sstep(i, xt,yt-1, xt-1,yt)
    case "7": return sstep(i, xt-1,yt, xt,yt+1)
    case "F": return sstep(i, xt+1,yt, xt,yt+1)
    }
}    

END {
    found=0
    visited[xs,ys]=0
    if (world[ys-1][xs]~/[|7F]/) setxy(xs,ys-1)
    if (world[ys][xs+1]~/[-7J]/) setxy(xs+1,ys)
    if (world[ys+1][xs]~/[|LJ]/) setxy(xs,ys+1)
    if (world[ys][xs-1]~/[-LF]/) setxy(xs-1,ys)

    do { step(0) } while (step(1))
    print "Part 1: " visited[x[0],y[0]]

    for (yl=1;yl<=NR;yl++) {
        inside=0
        for (xl=1;xl<=wl;xl++) {
            if (viable(xl,yl)) part2+=inside
            else switch (world[yl][xl]) {
                case "|": inside=!inside; break
                case "F": open="F"; break
                case "L": open="L"; break
                case "7": if (open=="L") inside=!inside; break
                case "J": if (open=="F") inside=!inside; break
                }
        }
    }
    print "Part 2: " part2
}
