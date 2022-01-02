#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

{
    xlen = length($1); ylen = FNR
    for (i=1; i<=length($1); i++)
        if (substr($1, i, 1) != ".")
            board[i-1,FNR-1] = substr($1, i, 1)
}

function step(snail, moved, coords, newboard) {
    for (snail in board)
        if (board[snail] == ">") {
            split(snail, coords, SUBSEP)
            newcoords = (coords[1]+1)%xlen SUBSEP coords[2]
            if (newcoords in board) newboard[snail]     = ">"
            else { moved = 1;       newboard[newcoords] = ">" }
        } else {
            newboard[snail] = "v"
        }
    delete board
    for (snail in newboard)
        if (newboard[snail] == "v") {
            split(snail, coords, SUBSEP)
            newcoords = coords[1] SUBSEP (coords[2]+1)%ylen
            if (newcoords in newboard) board[snail]     = "v"
            else { moved = 1;          board[newcoords] = "v" }
        } else {
            board[snail] = ">"
        }
    return moved
}

END {
    do { steps++ } while (step())
    print "Part 1: " steps
}
