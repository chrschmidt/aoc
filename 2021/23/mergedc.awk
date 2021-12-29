#!/usr/bin/env -S awk -F: -f ${_} -- input.txt
(FNR < NR) { exit }

function abs(a) { return a < 0 ? -a : a }
function min(a, b) { return a < b ? a : b }

BEGIN { legal[0]=2; legal[1]=3; legal[2]=5; legal[3]=7; legal[4]=9; legal[5]=11; legal[6]=12 }

{ cavedepth = FNR - 1; for (x=1; x<=length($1); x++) board[x,FNR] = substr($1, x, 1) }

function findamphis(x, y, i, coords, type, cave, amphic) {
    for (y=cavedepth; y>=3; y--)
        for (x=4; x<=10; x+=2) {
            board[x,y] = strtonum("0x" board[x,y])-10 # rename amphi types so 10^type is their cost per step
            cave = 4 + 2 * board[x,y]
            if (x == cave && board[x,y+1] == "#") board[x,y] = "#"
            else amphis[board[x,y],++amphic[board[x,y]]] = x SUBSEP y
        }
    asorti(amphis, amphilist)
}

function getmapstring(mapstring, x, y) {
    for (x=2; x<=12; x++) mapstring = mapstring board[x,2]
    for (x=4; x<=10; x+=2)
        for (y=3; y<=cavedepth; y++)
            mapstring = mapstring board[x,y]
    return mapstring
}

function calcmove(amphi, type, pos, coords, x, y,  stepcost, mapstring) {
    board[pos] = "."
    if (y > 2) {
        board[x,y] = "#"
        amphis[amphi] = "#"
        solved++
    } else {
        board[x,y] = type
        amphis[amphi] = x SUBSEP y
    }
    stepcost = 10^type * (coords[2] + y - 4 + abs(x-coords[1]))
    if (length(amphis) != solved) {
        mapstring = getmapstring()
        if (!(mapstring in cache))
            cache[mapstring] = move()
        stepcost += cache[mapstring]
    }
    if (y > 2) solved--
    amphis[amphi] = pos
    board[x,y] = "."
    board[pos] = type
    return stepcost
}

function checkmove(sx, ex,  x) {
    if (sx > ex) { for (x=ex+1; x<sx; x++) if (board[x,2] != ".") return 0 }
    else         { for (x=sx+1; x<ex; x++) if (board[x,2] != ".") return 0 }
    return 1
}

function move(a, i, j, type, cavex, pos, coords, x, y, minmove) {
    minmove = 100000
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
        if (coords[2] == 2) { # in hallway - check if the target cave can be entered
            if (board[cavex,3] == ".") {
                for (y=4; y<=cavedepth; y++)
                    if (board[cavex,y] != ".")
                        break
                if (board[cavex,y] == "#" && checkmove(coords[1], cavex))
                    minmove = min(minmove, calcmove(i, type, pos, coords, cavex, y-1))
            }
        } else { # leave the cave into the hallway.
                 # do not directly enter a cave, as this is covered in two steps anyway due to exhaustive search
            x = coords[1]/2
            for (j=x-1; j>=0; j--) # move left in hallway, stop at first amphi
                if (board[legal[j],2] == ".") minmove = min(minmove, calcmove(i, type, pos, coords, legal[j], 2))
                else break
            for (j=x; j<=6; j++) # move right in hallway, stop at first amphi
                if (board[legal[j],2] == ".") minmove = min(minmove, calcmove(i, type, pos, coords, legal[j], 2))
                else break
        }
    }
    return minmove
}

END {
    for (b in board) backup[b] = board[b]

    findamphis()
    print "Part 1: " move()

    for (b in backup) board[b] = backup[b]
    for (x=1; x<=13; x++) {
        board[x,6] = board[x,4]
        board[x,7] = board[x,5]
        board[x,4] = substr("  #D#C#B#A#", x, 1)
        board[x,5] = substr("  #D#B#A#C#", x, 1)
    }
    cavedepth += 2
    findamphis()
    print "Part 2: " move()
}
