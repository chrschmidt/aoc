#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

{
    forest[NR][0]
    fw=split($1,forest[NR],"")
}

function check(tx, ty,  nv) {
    if (nv=forest[y][x]<=forest[ty][tx])
        inv++
    return !nv
}

function score() {
    inv=0
    for (sl=1;check(x-sl,y)&&(x-sl)>1;sl++) ;
    for (sr=1;check(x+sr,y)&&(x+sr)<fw;sr++) ;
    for (st=1;check(x,y-st)&&(y-st)>1;st++) ;
    for (sb=1;check(x,y+sb)&&(y+sb)<NR;sb++) ;
    scores[x,y]=sl*sr*st*sb
    if (inv != 4)
        visible[x,y]
}

END {
    for (y=2; y<NR; y++)
        for (x=2; x<fw; x++)
            score()
    asort(scores)
    print "Part 1: " length(visible)+2*(NR+fw)-4
    print "Part 2: " scores[length(scores)]
}
