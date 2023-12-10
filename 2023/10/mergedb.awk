#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

{
    split($1,world[NR],"")
    if ((t=index($1,"S"))) {
        xs=t
        ys=NR
    }
}

function setxy(xn,yn) {
    x[steps]=xn
    y[steps++]=yn
    pipe[xn,yn]
}

function sstep(i,x1,y1,x2,y2) {
    if (!(x1,y1) in pipe)      { x[i]=x1; y[i]=y1 }
    else if (!(x2,y2) in pipe) { x[i]=x2; y[i]=y2 }
    else return 0
    pipe[x[i],y[i]]
    return 1
}

function step(i) {
    switch (world[y[i]][x[i]]) {
    case "|": return sstep(i, x[i],y[i]-1, x[i],y[i]+1)
    case "-": return sstep(i, x[i]-1,y[i], x[i]+1,y[i])
    case "L": return sstep(i, x[i],y[i]-1, x[i]+1,y[i])
    case "J": return sstep(i, x[i],y[i]-1, x[i]-1,y[i])
    case "7": return sstep(i, x[i]-1,y[i], x[i],y[i]+1)
    case "F": return sstep(i, x[i]+1,y[i], x[i],y[i]+1)
    }
}    

END {
    steps=0
    pipe[xs,ys]
    if (world[ys-1][xs]~/[|7F]/) setxy(xs,ys-1)
    if (world[ys][xs+1]~/[-7J]/) setxy(xs+1,ys)
    if (world[ys+1][xs]~/[|LJ]/) setxy(xs,ys+1)
    if (world[ys][xs-1]~/[-LF]/) setxy(xs-1,ys)
    
    do { steps+=step(0) } while (step(1))
    print "Part 1: " steps-1

    for (yl in world)
        for (xl in world[yl]) {
            if (!(xl,yl) in pipe) part2+=inside
            else switch (c=world[yl][xl]) {
                case "|": inside=!inside; break
                case "F":
                case "L": open=c; break
                case "7": if (open=="L") inside=!inside; break
                case "J": if (open=="F") inside=!inside; break
                }
        }
    print "Part 2: " part2
}
