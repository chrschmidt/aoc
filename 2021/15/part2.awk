#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

BEGIN { INF=1000000; SUBSEP="," }

{ riskmap[++maxy][1]; maxx = split($1, riskmap[maxy], "") }

function chkup(x, y, val) {
    if (!(x,y) in points)
        return
    if (!(x,y) in candidates || candidates[x,y] > val)
        candidates[x,y] = val
}

function limit(x) { return x > 9 ? x - 9 : x }

function expand() {
    for (ex=0; ex<=4; ex++)
        for (ey=0; ey<=4; ey++)
            for (x=1; x<=maxx; x++)
                for (y=1; y<=maxy; y++)
                    riskmap[y+maxy*ey][x+maxx*ex] = limit(riskmap[y][x] + ex + ey)
    maxx *= 5
    maxy *= 5
}

END {
    expand()
    for (x=1; x<=maxx; x++)
        for (y=1; y<=maxy; y++)
            points[x,y] = 1
    candidates[1,1] = 0

    do {
        low = INF
        for (p in candidates)
            if (candidates[p] < low) {
                low = candidates[p]
                pos = p
            }
        split(pos, coords, SUBSEP)
        x = coords[1]; y = coords[2]
        if (x == maxx && y == maxy)
            break
        chkup(x+1, y, candidates[x,y]+riskmap[y][x+1])
        chkup(x, y+1, candidates[x,y]+riskmap[y+1][x])
        chkup(x-1, y, candidates[x,y]+riskmap[y][x-1])
        chkup(x, y-1, candidates[x,y]+riskmap[y-1][x])
        delete points[pos]
        delete candidates[pos]
    } while (1)
    print "Part 2: " candidates[maxx,maxy]
}
