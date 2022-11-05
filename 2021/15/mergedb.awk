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

function chkup(x, y, val,  old) {
    if ((x,y) in visited)
        return
    if ((x,y) in allcandidates) {
        old = allcandidates[x,y]
        if (old <= val)
            return
        delete candidates[old][x,y]
        if (length(candidates[old]) == 0)
            delete candidates[old]
    }
    candidates[val][x,y] = 1
    allcandidates[x,y] = val
}

function getcand(low, c) {
    low = 10 * maxx * maxy
    for (c in candidates)
        if (length(candidates[c]) && int(c) < low)
            low = int(c)
    for (c in candidates[low]) {
        delete candidates[low][c]
        if (length(candidates[low]) == 0)
            delete candidates[low]
        visited[c] = 1
        return c
    }
}

function solve(part) {
    chkup(1, 1, 0)
    do {
        pos = getcand()
        low = allcandidates[pos]
        split(pos, coords, SUBSEP)
        x = coords[1]; y = coords[2]
        if (x == maxx && y == maxy)
            break
        if (x<maxx) chkup(x+1, y, low+riskmap[y][x+1])
        if (y<maxy) chkup(x, y+1, low+riskmap[y+1][x])
        if (x>1)    chkup(x-1, y, low+riskmap[y][x-1])
        if (y>1)    chkup(x, y-1, low+riskmap[y-1][x])
    } while (1)
    print "Part " part ": " allcandidates[maxx,maxy]
    delete candidates
    delete allcandidates
    delete visited
}    

END {
    solve(1)
    expand()
    solve(2)
}
