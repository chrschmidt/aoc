#!/usr/bin/env -S /bin/sh -c "exec awk -f ../../aoclib.awk -f ${_} input.txt"

{
    split($0,a,"")
    for (x=1;x<=length($0);x++)
        switch (a[x]) {
        case "#": omap[FNR][x]=-1; break
        case "^": sx=x; sy=FNR
        case ".": omap[FNR][x]=0
        }
}

function mc(src,dst, x,y) {
    for (y=1;y<=my;y++)
        for (x=1;x<=mx;x++)
            dst[y][x]=src[y][x]
}

function solve() {
    do {
        if (and(map[gy][gx],gdir)) return 1
        map[gy][gx]=or(map[gy][gx],gdir)
        switch (gdir) {
        case 1: nx=gx; ny=gy-1; break
        case 2: nx=gx+1; ny=gy; break
        case 4: nx=gx; ny=gy+1; break
        case 8: nx=gx-1; ny=gy
        }
        if (nx==0 || nx>mx || ny==0 || ny>my) return 0
        if (map[ny][nx]==-1) gdir=gdir==8?1:2*gdir
        else {
            gx=nx; gy=ny
            if (map[gy][gx]==0)
                part1++
        }
    } while (1)
}

function init(x,y) {
    mc(omap,map)
    gx=sx
    gy=sy
    gdir=1
    map[gy][gx]=0
}

function p2(x,y) {
    if ((x==sx && y==sy) || map1[y][x]<=0) return 0 
    init()
    map[y][x]=-1
    return solve()
}
  
END {
    mx=length(omap[1])
    my=FNR
    init()
    part1=1
    solve()
    print "Part 1: " part1
    mc(map,map1)
    for (y=1;y<=my;y++)
        for (x=1;x<=mx;x++)
            part2+=p2(x,y)
    print "Part 2: " part2
}
