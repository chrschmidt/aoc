#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

{ seats[NR][0]; split($0, seats[NR], "") }

function adjacent(x, y,  xi, yi, adj) {
    for (yi=y-1; yi<=y+1; yi++)
        for (xi=x-1; xi<=x+1; xi++)
            if ((xi != x || yi != y) && seats[yi][xi] == "#")
                adj++
    return adj
}

function round1(x, y, changes, occupied) {
    for (y=1; y<=rows; y++)
        for (x=1; x<=columns; x++)
            if (seats[y][x] == "L" && adjacent(x, y) == 0) { changes = 1; new[y][x] = "#" }
            else if (seats[y][x] == "#" && adjacent(x, y) >= 4) { changes = 1; new[y][x] = "L" }
            else { if (seats[y][x] == "#") occupied++; new[y][x] = seats[y][x] }
    for (y=1; y<=rows; y++)
        for (x=1; x<=columns; x++)
            seats[y][x] = new[y][x]
    if (changes) return 0
    else return occupied
}

function visibleinc(x, y, xinc, yinc) {
    do {
        x+=xinc; y+=yinc
        if (seats[y][x] == "#") return 1
        if (seats[y][x] == "L") return 0
    } while (x>0 && x<=columns && y>0 && y<=rows)
    return 0
}

function visible(x, y,  xi, yi, vis) {
    vis = visibleinc(x,y,0,-1) + visibleinc(x,y,0,1) + visibleinc(x,y,-1,0) + visibleinc(x,y,1,0)
    vis += visibleinc(x,y,-1,-1) + visibleinc(x,y,-1,1) + visibleinc(x,y,1,-1) + visibleinc(x,y,1,1)
    return vis
}

function round2(x, y, changes, occupied) {
    for (y=1; y<=rows; y++)
        for (x=1; x<=columns; x++)
            if (seats[y][x] == "L" && visible(x, y) == 0) { changes = 1; new[y][x] = "#" }
            else if (seats[y][x] == "#" && visible(x, y) >= 5) { changes = 1; new[y][x] = "L" }
            else { if (seats[y][x] == "#") occupied++; new[y][x] = seats[y][x] }
    for (y=1; y<=rows; y++)
        for (x=1; x<=columns; x++)
            seats[y][x] = new[y][x]
    if (changes) return 0
    else return occupied
}

END {
    rows = NR-1
    columns = length(seats[1])
    do { occupied = round1() } while (!occupied)
    print "Part 1: " occupied
    for (y=1; y<=rows; y++)
        for (x=1; x<=columns; x++)
            if (seats[y][x] == "#") seats[y][x] = "L"
    do { occupied = round2() } while (!occupied)
    print "Part 2: " occupied
}
