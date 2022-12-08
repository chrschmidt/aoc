#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

function check(tx,ty) {
    if (forest[y][x] <= forest[ty][tx]) {
        inv++
        return 0
    }
    return 1
}

{
    forest[NR][0]
    split($1,forest[NR],"")
}

function score(l, sl, sr, st, sb) {
    inv=0
    for (l=x-1;l;l--) {
        sl++
        if (!check(l,y))
            break
    }
    for (l=x+1;l<=length(forest[1]);l++) {
        sr++
        if (!check(l,y))
            break
    }
    for (l=y-1;l;l--) {
        st++
        if (!check(x,l))
            break
    }
    for (l=y+1;l<=length(forest);l++) {
        sb++
        if (!check(x,l))
            break
    }
    scores[x,y]=sl*sr*st*sb
    if (inv != 4)
        visible[x,y]=1
}

END {
    for (y=2; y<length(forest); y++)
        for (x=2; x<length(forest[1]); x++)
            score()

    asort(scores)
    print "Part 1: " length(visible)+2*(length(forest)+length(forest[1]))-4
    print "Part 2: " scores[length(scores)]
}
