#!/usr/bin/env -S awk -F: -f ${_} -- input.txt
(FNR < NR) { exit }

function abs(a) { return a < 0 ? -a : a }

BEGIN {
    lowcost = 1000000
    legal[2]; legal[3]; legal[5]; legal[7]; legal[9]; legal[11]; legal[12]
}

{ cavedepth = FNR - 3; for (x=1; x<=length($1); x++) board[x,FNR] = substr($1, x, 1) }

function findamphis(x, y, i, coords, type, cave) {
    for (y=3; y<=2+cavedepth; y++)
        for (x=4; x<=10; x+=2) {
            amphic[board[x,y]]++
            amphis[board[x,y],amphic[board[x,y]]] = x SUBSEP y
        }
    do {
        deleted = 0
        for (i in amphis) {
            type = substr(i, 1, 1)
            cave = 4 + 2 * (strtonum("0x" type)-10)
            split(amphis[i], coords, SUBSEP)
            if (coords[1] != cave) continue
            if (coords[2] == 2+cavedepth || board[cave,coords[2]+1] == "X") {
                board[amphis[i]] = "X"
                amphis[i] = "X"
                solved++
                deleted = 1
            }
        }
    } while (deleted)
    asorti(amphis, amphilist)
}

function iscached(mapstring, x, y) {
    for (x=2; x<=12; x++) mapstring = mapstring board[x,2]
    for (x=4; x<=10; x+=2)
        for (y=1; y<=cavedepth; y++)
            mapstring = mapstring board[x,2+y]
    if (mapstring in cache && cache[mapstring] <= cost) return 1
    cache[mapstring] = cost
    return 0
}

function trymove(amphi, type, typeval, pos, coords, x, y,  i, oldcost) {
    if (coords[1] > x) { for (i=x+1; i<coords[1]; i++) if (board[i,2] != ".") return }
    else               { for (i=coords[1]+1; i<x; i++) if (board[i,2] != ".") return }

    oldcost = cost
    cost += 10^typeval * (coords[2]-2 + y-2 + abs(x-coords[1]))
    if (y > 2) {
        board[pos] = "."
        board[x,y] = "X"
        amphis[amphi] = "X"
        solved++
    } else {
        board[pos] = "."
        board[x,y] = type
        amphis[amphi] = x SUBSEP y
    }
    if (length(amphis) == solved) { if (cost < lowcost) lowcost = cost }
    else if (!iscached()) move()
    if (y > 2) solved--
    amphis[amphi] = pos
    board[x,y] = "."
    board[pos] = substr(amphi, 1, 1)
    cost = oldcost
}

function move(a, i, j, type, typeval, cavex, pos, coords, y) {
    if (cost > lowcost) return
    for (a=1; a<=4*cavedepth; a++) {
        i = amphilist[a]
        pos = amphis[i]
        if (pos == "X")
            continue
        split(pos, coords, SUBSEP)
        if (coords[2] > 3 && board[coords[1], coords[2]-1] != ".")
            continue
        type = substr(i, 1, 1)
        typeval = strtonum("0x" type) - 10
        cavex = 4+2*typeval
        if (board[cavex,3] == ".") {
            for (y=4; y<=2+cavedepth; y++)
                if (board[cavex,y] != ".")
                    break
            if (board[cavex,y] == "X" || board[cavex,y] == "#")
                trymove(i, type, typeval, pos, coords, cavex, y-1)
        }
        if (coords[2] != 2) {
            for (j in legal)
                if (board[j,2] == ".")
                    trymove(i, type, typeval, pos, coords, int(j), 2)
        }
    }
}

END {
    for (y=5; y>=4; y--)
        for (x=1; x<=13; x++)
            if ((x,y) in board) board[x,y+2] = board[x,y]
    for (x=1; x<=11; x++) {
        board[x,4] = substr("  #D#C#B#A#", x, 1)
        board[x,5] = substr("  #D#B#A#C#", x, 1)
    }
    cavedepth += 2
    findamphis()
    move()
    print "Part 2: " lowcost
}
