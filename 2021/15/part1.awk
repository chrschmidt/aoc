#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

BEGIN { INF=1000000; SUBSEP="," }

{ riskmap[++maxy][1]; maxx = split($1, riskmap[maxy], "") }


function chkup(x, y, val) {
    if ((x,y) in points && points[x,y] > val)
        points[x,y] = val
}

END {
    for (x=1; x<=maxx; x++)
        for (y=1; y<=maxy; y++)
            points[x,y] = INF
    points[1,1] = 0

    do {
        low = INF
        for (p in points)
            if (points[p] < low) {
                low = points[p]
                pos = p
            }
        split(pos, coords, SUBSEP)
        x = coords[1]; y = coords[2]
        if (x == maxx && y == maxy)
            break
        chkup(x+1, y, points[x,y]+riskmap[y][x+1])
        chkup(x, y+1, points[x,y]+riskmap[y+1][x])
        chkup(x-1, y, points[x,y]+riskmap[y][x-1])
        chkup(x, y-1, points[x,y]+riskmap[y-1][x])
        delete points[pos]
    } while (1)
    print "Part 1: " points[maxx,maxy] 
}
