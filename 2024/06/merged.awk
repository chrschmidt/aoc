#!/usr/bin/env -S /bin/sh -c "exec awk -f ../../aoclib.awk -f ${_} input.txt"

{
    split($0,omap[FNR],"")
    if (!sx) {
        sx=index($0,"^")
        sy=FNR
    }
}

function step() {
    if (and(map[gy][gx],lshift(1,gdir))) return 1
    map[gy][gx]=or(map[gy][gx],lshift(1,gdir))
    switch (gdir) {
    case 0: nx=gx; ny=gy-1; break
    case 1: nx=gx+1; ny=gy; break
    case 2: nx=gx; ny=gy+1; break
    case 3: nx=gx-1; ny=gy
    }
    if (nx==0 || nx>mx || ny==0 || ny>my) return 0
    if (map[ny][nx]=="#") { gdir=(gdir+1)%4; return step() }
    gx=nx; gy=ny
    if (map[gy][gx]==".") {
        part1++
        map[gy][gx]=0
    }
    return 2
}

function init(x,y) {
    for (y=1;y<=my;y++)
        for (x=1;x<=mx;x++)
            map[y][x]=omap[y][x]
    gx=sx
    gy=sy
    gdir=0
    map[gy][gx]=0
}

function p2(x,y) {
    if (omap[y][x]!=".") return 0
    init()
    map[y][x]="#"
    do s=step(); while (s==2)
    return s
}
  
END {
    mx=length(omap[1])
    my=FNR
    init()
    part1=1
    while (step()) ;
    print "Part 1: " part1
    for (y=1;y<=my;y++) {
        for (x=1;x<=mx;x++)
            part2+=p2(x,y)
    print "Part 2: " part2
}
