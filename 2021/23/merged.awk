#!/usr/bin/env -S awk -F: -f ${_} -- input.txt
(FNR < NR) { exit }

function abs(a) { return a < 0 ? -a : a }

BEGIN { legal[2]; legal[3]; legal[5]; legal[7]; legal[9]; legal[11]; legal[12] }

{ cavedepth = FNR - 3; for (x=1; x<=length($1); x++) board[x,FNR] = substr($1, x, 1) }

function findamphis(x, y, i, coords, type, cave) {
    for (y=2+cavedepth; y>=3; y--)
        for (x=4; x<=10; x+=2) {
            board[x,y] = strtonum("0x" board[x,y])-10
            cave = 4 + 2 * board[x,y]
            if (x == cave && board[x,y+1] == "#")  board[x,y] = "#"
            else amphis[board[x,y],++amphic[board[x,y]]] = x SUBSEP y
        }
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

function trymove(amphi, type, pos, coords, x, y,  i, oldcost) {
    if (coords[1] > x) { for (i=x+1; i<coords[1]; i++) if (board[i,2] != ".") return }
    else               { for (i=coords[1]+1; i<x; i++) if (board[i,2] != ".") return }

    oldcost = cost
    cost += 10^type * (coords[2]-2 + y-2 + abs(x-coords[1]))
    if (y > 2) {
        board[pos] = "."
        board[x,y] = "#"
        amphis[amphi] = "#"
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

function move(a, i, j, type, cavex, pos, coords, y) {
    if (cost > lowcost) return
    for (a in amphilist) {
        i = amphilist[a]
        pos = amphis[i]
        if (pos == "#")
            continue
        split(pos, coords, SUBSEP)
        if (coords[2] > 3 && board[coords[1], coords[2]-1] != ".")
            continue
        type = substr(i, 1, 1)
        cavex = 4 + 2*type
        if (board[cavex,3] == ".") {
            for (y=4; y<=2+cavedepth; y++)
                if (board[cavex,y] != ".")
                    break
            if (board[cavex,y] == "#")
                trymove(i, type, pos, coords, cavex, y-1)
        }
        if (coords[2] != 2)
            for (j in legal)
                if (board[j,2] == ".")
                    trymove(i, type, pos, coords, int(j), 2)
    }
}

END {
    for (b in board) backup[b] = board[b]

    lowcost = 1000000
    findamphis()
    move()
    print "Part 1: " lowcost

    lowcost = 1000000
    delete amphis
    for (b in backup) board[b] = backup[b]
    for (x=1; x<=13; x++) {
        board[x,6] = board[x,4]
        board[x,7] = board[x,5]
        board[x,4] = substr("  #D#C#B#A#", x, 1)
        board[x,5] = substr("  #D#B#A#C#", x, 1)
    }
    cavedepth += 2
    findamphis()
    move()
    print "Part 2: " lowcost
}
