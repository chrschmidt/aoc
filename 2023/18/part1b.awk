#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

BEGIN { lagoon[0][0]="S"; x=0; y=0; last="S"; PROCINFO["sorted_in"]="@ind_num_asc" }

{
#    printf $0
    dx=dy=0
    switch ($1) {
    case "R":
        if (last=="U") lagoon[y][x]="F"
        else if (last=="D") lagoon[y][x]="L"
        else if (last!="S") { print "ERROR: " last "->" $1; exit }
        dx=1
        break
    case "L":
        if (last=="U") lagoon[y][x]="7"
        else if (last=="D") lagoon[y][x]="J"
        else if (last!="S") { print "ERROR: " last "->" $1; exit }
        dx=-1
        break
    case "U":
        if (last=="R") lagoon[y][x]="J"
        else if (last=="L") lagoon[y][x]="L"
        dy=-1
        break
    case "D":
        if (last=="R") lagoon[y][x]="7"
        else if (last=="L") lagoon[y][x]="F"
        dy=1
    }
    if (dy) {
        do {
            y+=dy
            lagoon[y][x]="|"
            $2--
        } while ($2)
    } else {
        do {
            x+=dx
            lagoon[y][x]="-"
            $2--
        } while ($2)
    }
    last=$1
}

function start() {
    if (1 in lagoon[0] && lagoon[0][1]~/[-7J]/) c0=1
    if (1 in lagoon && 0 in lagoon[1] && lagoon[1][0]~/[|LJ]/) c1=1
    if (-1 in lagoon[0] && lagoon[0][-1]~/[-LF]/) c2=1
    if (-1 in lagoon && 0 in lagoon[-1] && lagoon[-1][0]~/[|/F]/) c3=1
    if      (c0&&c1&&!c2&&!c3) lagoon[0][0]="F"
    else if (c0&&!c1&&c2&&!c3) lagoon[0][0]="-"
    else if (c0&&!c1&&!c2&&c3) lagoon[0][0]="L"
    else if (!c0&&c1&&c2&&!c3) lagoon[0][0]="7"
    else if (!c0&&c1&&!c2&&c3) lagoon[0][0]="|"
    else if (!c0&&!c1&&c2&&c3) lagoon[0][0]="J"
    else printf "ERROR: %d,%d,%d,%d\n", c0, c1, c2, c3
}
        

function space(x,y,a,v,open) {
    for (y in lagoon) {
#        printf "%5d (%3d):", y, length(lagoon[y])
        for (x in lagoon[y]) {
#            printf " %c@%5d", lagoon[y][x], x
            switch (c=lagoon[y][x]) {
            case "|":
            case "F":
            case "L":
                if (inside) {
#                    printf "A: " x-xclose
                    v+=x-xclose-1
                }
                if (c=="|") {
                    inside=!inside
                    xclose=x
                } else {
                    open=c
                }
                break
            case "7": if (open=="L") inside=!inside; xclose=x; break
            case "J": if (open=="F") inside=!inside; xclose=x; break
            }
            v++
        }
        if (inside) {
            print "ERROR: line " y " ended inside"
            exit
        }
#        printf " Total: %d\n", v
    }
    return v
}

END {
    start()
    print "Part 1: " space()
#    print "Part 1: " length(energized)
#    print "Part 2: " part2
}
