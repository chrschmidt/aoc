#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

{
    split($1,world[NR],"")
    if ((t=index($1,"S"))) {
        xp=t
        yp=NR
    }
}

function sstep(x1,y1,x2,y2) {
    if (!(x1,y1) in pipe)      { xp=x1; yp=y1 }
    else if (!(x2,y2) in pipe) { xp=x2; yp=y2 }
    else return 0
    return 1
}

function step() {
    switch (world[yp][xp]) {
    case "|": return sstep(xp,yp-1, xp,yp+1)
    case "-": return sstep(xp-1,yp, xp+1,yp)
    case "L": return sstep(xp,yp-1, xp+1,yp)
    case "J": return sstep(xp,yp-1, xp-1,yp)
    case "7": return sstep(xp-1,yp, xp,yp+1)
    case "F": return sstep(xp+1,yp, xp,yp+1)
    }
}

END {
    pipe[xp,yp]
    if (world[yp-1][xp]~/[|7F]/)      yp--
    else if (world[yp][xp+1]~/[-7J]/) xp++
    else if (world[yp+1][xp]~/[|LJ]/) yp++
    else if (world[yp][xp-1]~/[-LF]/) xp--
    pipe[xp,yp]
    for (steps=2;step();steps++) pipe[xp,yp]
    print "Part 1: " steps/2

    for (yl in world)
        for (xl in world[yl])
            if (!(xl,yl) in pipe) part2+=inside
            else switch (c=world[yl][xl]) {
                case "|": inside=!inside; break
                case "F":
                case "L": open=c; break
                case "7": if (open=="L") inside=!inside; break
                case "J": if (open=="F") inside=!inside; break
                }
    print "Part 2: " part2
}
