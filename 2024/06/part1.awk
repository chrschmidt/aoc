#!/usr/bin/env -S /bin/sh -c "exec awk -f ../../aoclib.awk -f ${_} input.txt"

BEGIN {
}

{
    split($0,map[FNR],"")
    if (!gx) {
        gx=index($0,"^")
        gy=FNR
    }
}

function step() {
    switch (gdir) {
    case 0: nx=gx; ny=gy-1; break
    case 1: nx=gx+1; ny=gy; break
    case 2: nx=gx; ny=gy+1; break
    case 3: nx=gx-1; ny=gy
    }
    if (nx==0 || nx>mx || ny==0 || ny>my) return 0
    if (map[ny][nx]=="#") { gdir=(gdir+1)%4; return step() }
    gx=nx; gy=ny
    if (map[gy][gx]!="^") {
        part1++
        map[gy][gx]="^"
    }
    return 1
}

END {
    mx=length(map[1])
    my=FNR
    part1=1
    while (step()) ;
        
    print "Part 1: " part1
    print "Part 2: " part2
}
