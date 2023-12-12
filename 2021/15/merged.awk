#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

{ riskmap[++maxy][1]; maxx = split($1, riskmap[maxy], "") }

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

function chkup(x, y, val) {
    if ((x,y) in visited)
        return
    if (!(x,y) in candidates || candidates[x,y] > val)
        candidates[x,y] = val
}

function solve(part) {
    candidates[1,1] = 0
    do {
        low = 10 * maxx * maxy
        for (p in candidates)
            if (candidates[p] < low) {
                low = candidates[p]
                pos = p
            }
        split(pos, coords, SUBSEP)
        x = coords[1]; y = coords[2]
        if (x == maxx && y == maxy)
            break
        if (x<maxx) chkup(x+1, y, low+riskmap[y][x+1])
        if (y<maxy) chkup(x, y+1, low+riskmap[y+1][x])
        if (x>1)    chkup(x-1, y, low+riskmap[y][x-1])
        if (y>1)    chkup(x, y-1, low+riskmap[y-1][x])
        visited[pos] = 1
        delete candidates[pos]
    } while (1)
    print "Part " part ": " candidates[maxx,maxy]
    delete candidates
    delete visited
}

END {
    solve(1)
    expand()
    solve(2)
}
